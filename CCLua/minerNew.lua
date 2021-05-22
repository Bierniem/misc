--new miner 2020!!!
not_ores = {"minecraft:dirt",
"minecraft:cobblestone",
"minecraft:stone",
--"minecraft:obsidian",
"minecraft:sand",
"minecraft:gravel",
"minecraft:grass",
"minecraft:netherrack",
--"minecraft:netherbrick",
--"minecraft:stonebrick",
--"minecraft:soul_sand",
"minecraft:bedrock",
"minecraft:lava",
"minecraft:water",
"minecraft:magma",
--"minecraft:wood",
--"minecraft:planks",
"chisel:marble",
"chisel:marble2",
"chisel:limestone",
"chisel:limestone2",
"minecraft:sandstone",
"minecraft:basalt",
"chisel:basalt",
"chisel:brownstone",
"tconstruct:slime_grass",
"tconstruct:slime_congealed",
--"minecraft:planks",
"minecraft:red_sandstone",
"minecraft:snow",
"minecraft:snow_layer",
"minecraft:ice",
"buildcraftenergy:fluid_block_oil_heat_0",
"buildcraftenergy:fluid_block_oil_heat_1",
"ic2:te",
"enderstorage:ender_storage",
"computercraft:turtle",
"nuclearcraft:rtg_americium",
}

no_safe_dig = {"ic2:te",
"enderstorage:ender_storage",
"computercraft:turtle",
"nuclearcraft:rtg_americium",
}

anchor_block = {"ic2:te",
}

--containers
	--facing direction
	--movements
direction = 0 --NESW modulo 4
moves = {} --a list of directions of travel in which movement is completed meant for vein mining 
pos = {0,0,0} --xy position in chunk modulo 15 z depth from start
--print("here ",pos)
imoves = {2,3,0,1,5,4}
qturn = {0,1,2,-1,0}
pos_mod = {1,1,-1,-1}
compass_dirs = {"north","east","south","west"}
compass_0 = ""
tnum = 1
cnum = 0
bore_points = {{4,4},{4,11},{11,4},{11,11},{7,7}}
ready_to_step = {true,false,false,false,false}

chest_slot=1
loader_slot=2
rtg_slot=3
--pellet_slot=
compass_slot=4
bucket_slot=5
coal_slot=6
resource_slot = coal_slot
--state_writer()
--race_writer()
tkeep = 0
tlast = 0

function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, tonumber(match));
    end
    return result;
end

function state_writer()
	pfile = fs.open("state","w")
	if pfile then
		pfile.writeLine(direction)
		--print("write direction ",direction)
		pfile.writeLine(pos[1] .. "," .. pos[2] .. "," .. pos[3])
		pfile.writeLine(tnum)
		pfile.writeLine(cnum)
		--print("write pos ",pos[1] .. "," .. pos[2] .. "," .. pos[3])
		pfile.close()
	else
		print("unable to write state")
	end
end
	
function race_writer(values)
	--print("linewriter")
	pfile =fs.open("racefile","w")
	if pfile then
		pfile.writeLine(values)
		pfile.close()
	else
		print("unable to write race")
	end
end
	
function state_reader()
	pfile = fs.open("state","r")
	if pfile then
		direction = tonumber(pfile.readLine())
		--print("read direction ",direction)
		poss = pfile.readLine()
		pos = split(poss,",")
		tnum = tonumber(pfile.readLine())
		cnum = tonumber(pfile.readLine())
		--print("read pos ",pos[1] .. "," .. pos[2] .. "," .. pos[3])
	end
end

function race_reader()
	pfile = fs.open("racefile","r")
	if pfile then
		race = pfile.readLine()
		failure_append("read race raw")
		failure_append(race)
		if #race == 0 then
			--empty racefile == no race condition
			return false
		end
		races = split(race,",")
		--print("races[1] ",races[1])
		--print("read race ",races[1]..","..races[2])
		return races
	end
end

function step_reader()
	if tnum == 1 then
		pfile = fs.open("stepping","r")
		if pfile then
			while true do
				line = pfile.readLine() 
				if not line then
					return
				end
				if #line == 1 then
					--insert values into the ready_to_step list
					ready_to_step[tonumber(line)] = true
				end
			end
		end
	end
end

function step_reset()
	pfile = fs.delete("stepping")
	ready_to_step = {true,false,false,false,false}
end

function full_stop(msg)
	--do not restart on reboot
	--save failure message
	pfile = fs.open("failure","a")
	if pfile then
		pfile.writeLine(msg)
		pfile.close()
	end
	start_file = fs.open("startup","w")
	if start_file then
		start_file.write("os.loadAPI(\"miner\")\n")
		start_file.write("miner.tx_help()")
		start_file.close()
	end
	os.reboot()
end
	
function tx_help()
	--blocks until it recieves a response
	--tx 
	rednet.open("right")
	while true do
		rednet.broadcast(os.getComputerID(),"help_me")
		--wait for ack from lead
		sleep(5)
	end
end
	
function failure_append(msg)
	pfile = fs.open("failure","a")
	if pfile then
		pfile.writeLine(msg)
		pfile.close()
	end
end
	
function refuel()
	lava_refuel()
	coal_refuel()
end

function lava_refuel()
	if turtle.getFuelLevel()<10000 then
		b,d = turtle.inspect()
		if d.name == "minecraft:lava" and d.metadata == 0 then
			turtle.select(bucket_slot)
			turtle.place()
			turtle.refuel()
		end
	end
end

function coal_refuel()
	if turtle.getFuelLevel()<10 then
		turtle.select(coal_slot) 
		turtle.refuel(1)
	end
end
	
function chunk_safety()
	--check heading and pos to determine chunk_safety
	if (pos[2] == 0 and direction == 2) then
		return false
	elseif (pos[2] == 15 and direction == 0) then
		return false
	elseif (pos[1] == 0 and direction == 3) then 
		return false
	elseif (pos[1] == 15 and direction == 1) then
		return false
	else
		return true
	end
end
	
function moves_controller(dir)
	--move undoes the last move
	--print("mvbegin")
	--for i=1,#moves do
		--print (i," ",moves[i])
	--end
	if imoves[dir+1] == moves[#moves] then
		table.remove(moves,#moves)
	else
		moves[#moves + 1] = dir
	end
	--print("mvend")
	--for i=1,#moves do
		--print (i," ",moves[i])
	--end
end
	
--Base actions
	--move
function move_to(newpos)
	--move to new pos in chunk
	--X
	unsticker = 0 --progressively move up until no longer stuck
	while not (pos[1] == newpos[1] and pos[2] == newpos[2] and pos[3]==newpos[3]) do --try until success
		if newpos[1] > pos[1] then
			turn(1 - direction)
			mmove(0,newpos[1] - pos[1])
		elseif newpos[1] < pos[1] then
			turn(3 - direction)
			mmove(0,pos[1] - newpos[1])
		end
		
		--Y
		if newpos[2] > pos[2] then
			turn(0 - direction)
			mmove(0,newpos[2] - pos[2])
		elseif newpos[2] < pos[2] then
			turn(2 - direction)
			mmove(0,pos[2] - newpos[2])
		end
		
		--Z
		if newpos[3] > pos[3] then
			mmove(4,newpos[3]-pos[3])
		elseif newpos[3] < pos[3] then
			mmove(5,pos[3] - newpos[3])
		elseif unsticker == 2 then --only every other so it doesn't prevent the while from succeeding
			mmove(4,5)
		elseif unsticker == 4 then
			mmove(4,5)
		elseif unsticker>5 then
			unsticker = 0
		end
		unsticker = unsticker+1
	end
end

function mmove(dir,amt)
	for i = 1,amt do
		if not move(dir) then
			return false
		end
	end
	return true
end


function move(dir)
	--fwd
	if dir == 0 then
		for i = 1,20 do
			race_writer("0,0")
			if not turtle.forward() then
				fs.delete("racefile")
				refuel()
				dig(0,resource_slot,true)
				turtle.attack()
				if turtle.detect() then
					return false
				end
			else 
				posind = ((direction + 1) % 2) + 1--1 indexed
				pos[posind] = (pos[posind] + pos_mod[direction + 1]) % 16--update position in chunk
				moves_controller(direction) -- update moves list
				state_writer()
				fs.delete("racefile")
				refuel()
				if turtle.getItemCount(16) > 0 then
					dump_stuff()
				end
				sleep(.1)
				return true
			end
		end
	elseif dir == 4 then--up
		for i = 1,20 do
			race_writer("0,4")
			if not turtle.up() then	
				fs.delete("racefile")
				refuel()
				dig(4,resource_slot,true)
				turtle.attackUp()
				if turtle.detectUp() then
					return false
				end
			else
				pos[3] = pos[3] + 1
				moves_controller(4)
				state_writer()
				fs.delete("racefile")
				refuel()
				if turtle.getItemCount(16) > 0 then
					dump_stuff()
				end
				sleep(.1)
				return true
			end
		end
		--down
	elseif dir == 5 then
		for i = 1,20 do
			race_writer("0,5")
			if not turtle.down() then
				fs.delete("racefile")
				refuel()
				dig(5,resource_slot,true)
				turtle.attackDown()
				if turtle.detectDown() then
					return false
				end
			else
				pos[3] = pos[3] - 1
				moves_controller(5)
				state_writer()
				fs.delete("racefile")
				refuel()
				if turtle.getItemCount(16) > 0 then
					dump_stuff()
				end
				sleep(.1)
				return true
			end
		end
	else
		print("invalid argument to function move")
	end
	return false
end
	--place
function place(dir,slot)
	--fwd
	if dir == 0 then
		for i = 1,10 do
			turtle.select(slot)
			if not turtle.place() then
				dig(0,resource_slot,true)
				turtle.attack()
				if turtle.detect() then
					return false
				end
			else
				return true
			end
		end
	--up
	elseif dir == 4 then
		for i = 1,10 do
			turtle.select(slot)
			if not turtle.placeUp() then
				dig(dir,resource_slot,true)
				turtle.attackUp()
				if turtle.detectUp() then
					return false
				end
			else
				return true
			end
		end
	--down
	elseif dir == 5 then
		for i = 1,10 do
			turtle.select(slot)
			if not turtle.placeDown() then
				dig(dir,resource_slot,true)
				turtle.attackDown()
				if turtle.detectDown() then
					return false
				end
			else
				return true
			end
		end
	else
		print("invalid argument to function place")
	end
end
	
	--turn
function turn(t)
	--minimize turning
	t = t % 4
	if t == 3 then
		t = -1
	end
	--left
	if t < 0 then
		for i = t,-1 do
			turtle.turnLeft()
			direction = (direction - 1) % 4
			refuel()
			sleep(.1)
		end
	--right
	elseif t > 0 then
		for i = 1,t do
			turtle.turnRight()
			direction = (direction + 1) % 4
			refuel()
			sleep(.1)
		end
	end
end

function isOre(dir,c_list)
	--fwd
	dbool = false
	ddata = false
	if dir == 0 then
		if turtle.detect() then
			dbool,ddata = turtle.inspect()
		end
	elseif dir == 4 then
		if turtle.detectUp() then
			dbool,ddata = turtle.inspectUp()
		end
	elseif dir == 5 then
		if turtle.detectDown() then
			dbool,ddata = turtle.inspectDown()
		end
	else
		print("invalid argument to function isOre")
	end
	
	if dbool then
		for _,item in pairs(c_list) do
			if ddata.name == item then
				--if the item is in the list return true
				return true
			end
		end
		--if the item is not in the list return false
	end
	return false
end
		
function dump_stuff()
	race_writer("2,0")
	for pdir = 0,3 do
		if pdir<4 then
			turn(pdir-direction)
			if place(0,chest_slot) then
				for i=resource_slot+1,16 do
					turtle.select(i)
					turtle.drop()
				end
				dig(0,chest_slot,false)
				fs.delete("racefile")
				return true
			end
		--else -- don't do up and down because it will complicate recovery
		--	if place(pdir,chest_slot) then
		--		for i=resource_slot+1,16 do
		--			turtle.select(i)
		--			turtle.drop()
		--		end
		--		dig(pdir,chest_slot,false)
		--		fs.delete("racefile")
		--		return true
		--	end
		end	
	end
	return false
end
		
function dig(dir,slot,safe)
	turtle.select(slot)
	if safe then
		if isOre(dir,no_safe_dig) then
			--do not dig
			return false
		end
	end
	if dir == 0 then
		turtle.dig()
	elseif dir == 4 then
		turtle.digUp()
	elseif dir == 5 then
		turtle.digDown()
	else
		print("invalid argument to function dig")
	end
	return true
end

function mine_out()
	--undo last move regardless of current heading
	if #moves == 0 then
		return
	end
	lmove = moves[#moves]
	if lmove == 0 then
		turn(2 - direction)
		mmove(0,1)
	elseif lmove == 1 then
		turn(3 - direction)
		mmove(0,1)
	elseif lmove == 2 then 
		turn(0 - direction)
		mmove(0,1)
	elseif lmove ==3 then
		turn(1 - direction)
		mmove(0,1)
	elseif lmove == 4 then
		mmove(5,1)
	elseif lmove == 5 then
		mmove(4,1)
	end
end

function mine_nr()
	sdepth = 1
	moves = {}
	while sdepth > 0 do
		if mine_nr_sub() then
			sdepth = sdepth + 1
		else 
			sdepth = sdepth - 1
		end
	end
end

function mine_nr_sub() --not recursive miner
	for i = 0,3 do
		if turtle.detect() then
			if not isOre(0,not_ores) then
				if chunk_safety() then
					if mmove(0,1) then
						return true
					end
				end
			end
		end
		turn(1)
	end
	if turtle.detectUp() then
		if not isOre(4,not_ores) then
			if chunk_safety() then
				if mmove(4,1) then
					return true
				end
			end
		end
	end
	if turtle.detectDown() then
		if not isOre(5,not_ores) then
			if chunk_safety() then
				if mmove(5,1) then
					return true
				end
			end
		end
	end
	if #moves > 0 then
		--print("#moves ",#moves , moves[#moves])
		mine_out()
	end
	return false
end

function clear_moves()
	moves = {}
end

function bore(x,y,z)
	depth = 0
	move_to({x,y,0})
	print("bore @ " ,x,",",y)
	while mmove(5,1) do
		depth = depth + 1
		moves = {}	--empty moves
		mine_nr() --not so recursive vein mining
		move_to({x,y,pos[3]}) --re-center in case it somehow doesn't
		if depth > z then
			break
		end
	end
	print("return to surface", depth)
	move_to({x,y,0})
end

function build_loader(lnum)
	lpos = {{8,0,0},{7,1,0},{8,14,0},{7,15,0}}
	ldirs = {2,2,0,0}
	move_to(lpos[lnum])
	turn(ldirs[lnum] - direction)
	move_to({pos[1],pos[2],1})
	place(0,rtg_slot)
	move_to({pos[1],pos[2],0})
	place(0,loader_slot)
end

function destroy_loader(lnum)
	lpos = {{8,0,0},{7,1,0},{8,14,0},{7,15,0}}
	ldirs = {2,2,0,0}
	move_to(lpos[lnum])
	turn(ldirs[lnum] - direction)
	dig(0,loader_slot,false)
	move_to({pos[1],pos[2],1})
	dig(0,rtg_slot,false)
end

function find_loader(lnum)
	lpos = {{8,0,0},{7,1,0},{8,14,0},{7,15,0}}
	ldirs = {2,2,0,0}
	move_to(lpos[lnum])
	turn(ldirs[lnum] - direction)
	
	if isOre(0,no_safe_dig) then -- found loader
		return true
	else
		move_to({pos[1],pos[2],1})
		if isOre(0,no_safe_dig) then --found lonely rtg_americium
			dig(0,rtg_slot,false)
		end
	end
	return false
end

function restart_step()
	pfile = fs.open("in_step","r")
	if not pfile then
		chunk_step(1)
		return
	end
	pfile.close()
	if find_loader(1) then
		chunk_step(5)
		return
	elseif find_loader(2) then
		if not find_loader(3) then
			chunk_step(1)
			return 
		else
			chunk_step(2)
			return
		end
	elseif find_loader(3) then
		if not find_loader(4) then
			chunk_step(3)
			return
		else
			chunk_step(4)
			return
		end
	end
end
			
function chunk_step(p)
	group_step()--will block until group is ready
	--only the lead turtle moves the loader
	if tnum <= 1 then
		pfile = fs.open("in_step","w")
		if pfile then
			pfile.write("")
			pfile.close()
		end

		--place loader at new edge of current chunk pos == {7,15}
		if p<2 then
			build_loader(3)--------------------------------------------
		end
		--remove loader from old edge of current chunk
		if p<3 then
			destroy_loader(2)-------------------------------------------
		end
		--place loader at edge of new chunk
		if p<4 then
			send_step() -- move others into next chunk before loading it to act as a lock
			build_loader(4)-------------------------------------------
		end
		if p<5 then
			move_to({pos[1],15,3}) --go over the loader
			turn(0-direction)
			--enter new chunk
			mmove(0,5)
			
		end	
		--remove loader at new edge of old chunk
		destroy_loader(1)-------------------------------------------
		fs.delete("in_step")
		step_reset()
	end
end
	
function recovery_startup()
	
	step_reader()
	state_reader() -- get saved state
	printStats()
	dir_recovery()
	failure_append(pos)
	races = race_reader() --get possible races
	--return to surface --this will break if the turtle is directly above or below the loader...
	if turtle.getItemCount(chest_slot) == 0 then
		dig(0, chest_slot, false)
	end
	if not races then
	--if racefile is empty, dir and pos are accurate
		failure_append("no race condition on restart")
		move_to({pos[1],pos[2],0})
		
		restart_step()
		main_run()
	elseif races[1] == 0 then
	--if racefile includes "move" dir is accurate but pos is not
		if races[2] == 0 then
			failure_append("xy race condition on restart")
			move_to({pos[1],pos[2],0})
			if pos_recovery_xy() then
				restart_step()
				main_run()
			else
				print("failed xy_recovery")
				full_stop("failed xy_recovery")
			end
		else 
			failure_append("z race condition on restart")
			if pos_recovery_z() then
				restart_step()
				main_run()
			else
				print("failed z_recovery")
				full_stop("failed z_recovery")
			end
		end
	else
		print("invalid races file, waiting for manual recovery")
		failure_append("failed to recover due to invalid races file")
		full_stop()
	end
end

function pos_recovery_xy()
	--solve xy postion ambiguity by navigating to the anchor
	cposes = {{6,2,0},{7,2,0},{8,2,0},{6,1,0},{7,1,0},{8,1,0}}
	for _,pose in pairs(cposes) do
		move_to(pose)
		turn(2 - direction)
		if isOre(0,anchor_block) then
			pos = {7,1,0}
			print("success xy recovery")
			return true
		end
	end
	cposes = {{6,13,0},{7,13,0},{8,13,0},{6,14,0},{7,14,0},{8,14,0}}
	for _,pose in pairs(cposes) do
		move_to(pose)
		turn(0 - direction)
		if isOre(0,anchor_block) then
			pos = {8,14,0}
			print("success xy recovery")
			return true
		end
	end
	cposes = {{8,0,0},{7,0,0},{6,0,0}}
	for _,pose in pairs(cposes) do
		move_to(pose)
		turn(2 - direction)
		if isOre(0,anchor_block) then
			pos = {7,1,0}
			print("success xy recovery")
			return true
		end
	end
	cposes = {{8,15,0},{7,15,0},{6,15,0}}
	for _,pose in pairs(cposes) do
		move_to(pose)
		turn(0 - direction)
		if isOre(0,anchor_block) then
			pos = {8,14,0}
			print("success xy recovery")
			return true
		end
	end
	print("failure xy recovery")
	return false
end

function pos_recovery_z()
	move_to({pos[1],pos[2],-2})
	move_to({7,0,-2})
	for i = 1,3 do
		if isOre(4,anchor_block) then
			pos = {7,0,-1}
			print("success z recovery")
			return true
		else 
			mmove(4,1)
		end
	end
	move_to({pos[1],pos[2],-2})
	move_to({8,15,-2})
	for i = 1,3 do
		if isOre(4,anchor_block) then
			pos = {8,15,-1}
			print("success z recovery")
			return true
		else 
			mmove(4,1)
		end
	end
	print("failure z recovery")
	return false
end

function dir_set()
	--correspond compass direction with direction value
	turn(0-direction)
	place(4,compass_slot)
	b,d = turtle.inspectUp()
	dig(4,compass_slot,false)
	for i,dir in pairs(compass_dirs) do
		if d.state.facing == dir then
			compass_0 = i
			c_file = fs.open("compass_0","w")
			if c_file then
				c_file.writeLine(compass_0)
			end
		end
	end
end

function dir_recovery(rdir)
	--get original compass heading
	c_file = fs.open("compass_0","r")
	if c_file then
		compass_0 = tonumber(c_file.readLine())
	end
	--use another turtle as a compass
	place(4,compass_slot)
	b,d = turtle.inspectUp()
	dig(4,compass_slot,false)
	for i,dir in pairs(compass_dirs) do
		if d.state.facing == dir then
			direction = (i - compass_0)%4
		end
	end
end

function main_run()
	while true do
		if tnum == 0 then
			for bnum = 1,#bore_points do
				bore(bore_points[bnum][1],bore_points[bnum][2],1000)
			end
		else
			bore(bore_points[tnum][1],bore_points[tnum][2],1000)
			--bore(7,7) --boring close to the center of the chunk is safer
		end
		chunk_step(0)
	end
end

function test_recovery_xy(mode)
	race_writer("0,0")
	if mode == 0 then
		print("mode 0")
		sleep(5)
		os.reboot()
	end
	if not turtle.forward() then
		fs.delete("racefile")
		dig(0,resource_slot,true)
		turtle.attack()
		if turtle.detect() then
			return false
		end
	else 
		posind = ((direction + 1) % 2) + 1--1 indexed
		pos[posind] = (pos[posind] + pos_mod[direction + 1]) % 16--update position in chunk
		moves_controller(direction) -- update moves list
		if mode == 1 then
			print("mode 1")
			sleep(5)
			os.reboot()
		end
		state_writer()
		if mode == 2 then
			print("mode 2")
			sleep(5)
			os.reboot()
		end
		fs.delete("racefile")
		refuel()
		return true
	end
end

function test_recovery_z(mode)
	race_writer("0,4")
	if mode == 0 then
		print("mode 0")
		sleep(5)
		os.reboot()
	end
	if not turtle.up() then	
		fs.delete("racefile")
		dig(4,resource_slot,true)
		turtle.attackUp()
		if turtle.detectUp() then
			return false
		end
	else
		pos[3] = pos[3] + 1
		moves_controller(4)
		if mode == 1 then
			print("mode 1")
			sleep(5)
			os.reboot()
		end
		state_writer()
		if mode == 2 then
			print("mode 2")
			sleep(5)
			os.reboot()
		end
		fs.delete("racefile")		
		refuel()
		return true
	end
end

function test_recovery_dir(mode)
	race_writer("1,-1")
	if mode == 0 then
		print("mode 0")
		sleep(5)
		os.reboot()
	end
	turtle.turnLeft()
	if mode == 1 then
		print("mode 1")
		sleep(5)
		os.reboot()
	end
	state_writer()
	if mode == 2 then
		print("mode 2")
		sleep(5)
		os.reboot()
	end	
	fs.delete("racefile")
	direction = (direction - 1) % 4
	refuel()
end

function test_recovery(kind,mode,x,y,z)
	--write test reboot startup
	kind = tonumber(kind)
	mode = tonumber(mode)
	x = tonumber(x)
	y = tonumber(y) 
	z = tonumber(z)
	start_file = fs.open("startup","w")
	if start_file then
		start_file.write("os.loadAPI(\"miner\")\n")
		start_file.write("miner.test_recovery_startup()")
		start_file.close()
	else
		print("failed to create startup file")
	end
	move_to({x,y,z})
	if kind == 0 then
		print("testing xy recovery")
		test_recovery_xy(mode)
	elseif kind == 1 then
		print("testing z recovery")
		test_recovery_z(mode)
	elseif kind == 2 then
		print("testing dir recovery")
		test_recovery_dir(mode)
	else
		print("invalid test_recovery kind ",kind)
	end
	move_to({0,0,0})
	turn(0-direction)
end

function setState(x,y,dir)
	pos[1] = x
	pos[2] = y
	direction = dir
end

function qstart()
	print("ready to start, enter tnum")
	tnum = tonumber(io.read())
	--set startup to recovery
	dir_set()
	start_file = fs.open("startup","w")
	if start_file then
		start_file.write("os.loadAPI(\"miner\")\n")
		start_file.write("miner.recovery_startup()")
		start_file.close()
	else
		print("failed to create startup file")
		return
	end
	if tnum <= 1 then
		build_loader(2) --setup initial chunk loader
	end
	main_run()
end

function tx_stepping()
	--blocks until it recieves a response
	--tx 
	rednet.open("right")
	while true do
		rednet.broadcast(tnum,"stepping")
		--wait for ack from lead
		if rednet.receive("step",5+tnum/5) then
			return
		end
	end
end

function rx_stepping()
	--rx
	rednet.open("right")
	sender,msg,protocol = rednet.receive("stepping",5)
	if sender then
		--record to file
		print("sender:",sender,", tnum:",msg ,", me:",os.getComputerID())
		pfile = fs.open("stepping","a")
		if pfile then
			pfile.writeLine(msg)
		end
		pfile.close()
		--set ready list
		if tonumber(msg) then
			if (tonumber(sender) > os.getComputerID() and tonumber(sender) < os.getComputerID() + 5) then--turtles must be placed sequentially
				ready_to_step[tonumber(msg)] = true
			end
		end
		--tx ack
		--rednet.send(sender,"ack","step")
	end
end

function send_step()
	rednet.open("right")
	while true do
		--reply until no step requests received, long timeout so that no one gets left behind
		sender,msg,protocol = rednet.receive("stepping",8)
		if sender then
			rednet.send(sender,"ack","step")
		else
			rednet.broadcast(tnum,"stepping")
			return
		end		
	end
end 

function group_step()
	--if not lead turtle 
	if tnum > 1 then
		--move into pos(tnum-1,0,0) in new chunk
		move_to({tnum-1,15,0})
		turn(0-direction)
		tx_stepping()--blocks until it receives a response
		mmove(0,5)
	elseif tnum == 1 then
	--if lead turtle
		--wait for all to set stepping
		safety_timer = 0
		while not (ready_to_step[2] and ready_to_step[3] and ready_to_step[4] and ready_to_step[5]) do
			rx_stepping()
		end
	end
	cnum = cnum + 1
end
	
function printStats()
	print("pos ",pos[1],pos[2],pos[3])
	print("dir ",direction)
	print("moves ",#moves)
end

function getInd(a,b)
	for i = 1,#b do
		if b[i] == a then
			return i
		end
	end
	return false
end

function monitor()
	rednet.open("left")
	slist = {}
	tlist = {}
	tklist = {}
	while true do
		sender,_,_ = rednet.receive("stepping",5)
		if sender then
			term.clear()
			i_sender = getInd(sender,slist)
			if i_sender then
				tlist[i_sender]=os.time()
				tklist[i_sender] = 0
			else
				slist[#slist + 1] = sender
				tlist[#tlist + 1] = os.time()
				tklist[#tklist + 1] = 0
			end
		else
			rednet.broadcast("keepalive","1")
		end
		for iss = 1,#slist do
			tsince,tklist[iss] = time_since(tlist[iss],tklist[iss])
			term.setCursorPos(1,iss)
			term.write(slist[iss])
			term.write(" : ")
			term.write(tsince)
		end
	end
end

function time_since(stime,tkeep)
	tsince = os.time()-stime + tkeep
	if tsince < tlast then
		tkeep = tkeep + 24
		tsince = os.time()-stime + tkeep
	end
	return tsince,tkeep
end
--test_recovery on whole table again, 
	--see if {0,0,0} causes weirdness again with kind 0 mode 1
--