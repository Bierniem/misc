--recursive miner
supnum=8 --supply count
--forbidnum=5 --stone, cobblestone, gravel, sand, dirt, grass replace with inspect and block ids
not_ores = {"minecraft:dirt",
"minecraft:cobblestone",
"minecraft:stone",
"minecraft:obsidian",
"minecraft:sand",
"minecraft:gravel",
"minecraft:grass",
"minecraft:netherrack",
"minecraft:netherbrick",
"minecraft:stonebrick",
"minecraft:soul_sand",
"minecraft:bedrock",
"minecraft:lava",
"minecraft:water",
"minecraft:magma",
"minecraft:wood",
"minecraft:planks",
"minecraft:clay",
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
"minecraft:planks",
"minecraft:red_sandstone"}
deep=0 --depth
memoryguardnum=20
memoryguard=0
slowtest = false


--tank_slot = 1
--pipe_slot = 2
--dynamo_slot = 3
--wire_slot = 4
rtg_slot = 1
pellet_slot = 2
chunkloader_slot = 3
chest_slot = 4
bucket_slot = 5
coal_slot = 6

function exit()
	print("bye")
	sleep(10)
	error()
end
function queuechurn()
	--os.queueEvent("nullEvent")
	--os.pullEvent()
	sleep(.05)
end
--create files
function initfiles()
	print("initfiles")
	if not fs.exists("recoveryjob") then
		local frjob=fs.open("recoveryjob","w")
		frjob.write()
		frjob.close()
	end
	if not fs.exists("recoverystats") then
		local frstats=fs.open("recoverystats","w")
		frstats.write()
		frstats.close()
	end
	if not fs.exists("chunkpoint") then
		local pcpoint=fs.open("chunkpoint","w")
		pcpoint.write()
		pcpoint.close()
	end
	if not fs.exists("recoverymode") then
		local prmode=fs.open("recoverymode","w")
		prmode.write()
		prmode.close()
	end
end
--recovery file use functions
function movefd(code)
	if code=="R" then turnR(1) 
	elseif code=="L" then turnL(1)
	elseif code=="Bk" then goBk(1) 
	elseif code=="Fd" then goFd(1) 
	elseif code=="Dn" then goDn(1) 
	elseif code=="Up" then goUp(1)
	elseif code==NULL then 
	else print("unlisted movefdcode")print(code) exit() end
end
function moverv(code)
	if code=="L" then turnR(1)
	elseif code=="R" then turnL(1)
	elseif code=="Fd" then goBk(1)
	elseif code=="Bk" then goFd(1) 
	elseif code=="Up" then goDn(1) 
	elseif code=="Dn" then goUp(1)
	elseif code==NULL then
	else print("unlisted movervcode")print(code) exit() end
end
	
--file interaction functions
function linereader(file)
	--print("linereader")
	local pfile=fs.open(file,"r")
	if pfile then
		local readtable={}
		local sLine=pfile.readLine()
		while sLine do
			table.insert(readtable,sLine)
			sLine=pfile.readLine()
		end
		pfile.close()
		return readtable
	end
end
function linewriter(file,writetable)
	--print("linewriter")
	local pfile =fs.open(file,"w")
	if pfile then
		for _, sLine in ipairs(writetable) do
			pfile.writeLine(sLine)
		end
		pfile.close()
	end
end
function lineadder(file,newdat)
	--print("lineaddr")
	local addtable=linereader(file)
	table.insert(addtable,newdat)
	linewriter(file,addtable)
end
		
--MOVE FUNCTIONSv
function dig()
	if slowtest then 
		print("dig")
		sleep(.5)
	end
	while true do
		queuechurn()
		if turtle.dig() then break
		else turtle.attack()end
		--check if inventory is full and dump
		if turtle.getItemCount(16) ~= 0 then
			dump_stuff()
		end
		if not turtle.detect() then
			break
		end
	end
end

function place()
	if slowtest then 
		print("place")
		sleep(.5)
	end
	while true do
		queuechurn()
		if turtle.place() then break
		else turtle.dig() turtle.attack()end
	end
end

function placeUp()
	if slowtest then 
		print("placeUp")
		sleep(.5)
	end
	while true do
		queuechurn()
		if turtle.placeUp() then break
		else turtle.digUp() turtle.attackUp() end
	end
end

function turnL(num)
	if slowtest then 
		print("turnL")
		sleep(.5)
	end
	turtle.select(coal_slot)
	while num>0 do
	--print("L")
	lineadder("recoverystats","L")
	queuechurn()
		while true do
			queuechurn()
			if turtle.turnLeft() then break
			else refuel() turtle.dig() end
		end
	num=num-1
	end
end

function turnR(num)
	if slowtest then 
		print("turnR")
		sleep(.5)
	end
	turtle.select(coal_slot)
	while num>0 do
	--print("R")
	lineadder("recoverystats","R")
	queuechurn()
		while true do
			queuechurn()
			if turtle.turnRight() then break
			else refuel() turtle.dig() end
		end
	num=num-1
	end
end

function goFd(num)
	if slowtest then 
		print("goFd")
		sleep(.5)
	end
	turtle.select(coal_slot)
	while num>0 do
		--print("Fd")
		lineadder("recoverystats","Fd")
		queuechurn()
		while true do
			queuechurn()
			turtle.select(tank_slot)
			if turtle.compare() and turtle.getItemCount() ~= 0 then 
				print("anchor") 
				return 1
			elseif turtle.forward() then 
				break
			else 
				refuel() 
				turtle.select(coal_slot) 
				turtle.dig() 
				turtle.attack()
			end
                end
                num=num-1
        end
end

function goBk(num)
	if slowtest then 
		print("goBk")
		sleep(.5)
	end
	turtle.select(coal_slot)
	while num>0 do
		--print("Bk")
		lineadder("recoverystats","Bk")
		queuechurn()
		while true do
			queuechurn()
			turnL(2)
			turtle.select(tank_slot)
			if turtle.compare() and turtle.getItemCount() ~= 0 then 
				turnL(2) print("anchor") 
				return 1
			elseif turtle.forward() then 
				turnL(2) 
				break
			else 
				refuel() 
				turtle.select(coal_slot) 
				turtle.dig() 
				turtle.attack() 
				turnL(2)	
			end
		end
		num=num-1
	end
end

function goUp(num)
	if slowtest then 
		print("goUp")
		sleep(.5)
	end
	turtle.select(coal_slot)
	while num>0 do
		lineadder("recoverystats","Up")
		queuechurn()
		while true do
			queuechurn()
			turtle.select(tank_slot)
			if turtle.compareUp() and turtle.getItemCount() ~= 0 then 
				print("anchor")
				return 1
			elseif turtle.up() then  
				break
			else 
				refuel() 
				turtle.select(coal_slot) 
				turtle.digUp() 
				turtle.attackUp()
			end
		end
		num=num-1
	end
end

function goDn(num)
	if slowtest then 
		print("goDn")
		sleep(.5)
	end
	turtle.select(coal_slot)
	while num>0 do
		catch_bottom = 0
		lineadder("recoverystats","Dn") 
		queuechurn()
		while true do
			queuechurn()
			turtle.select(tank_slot)
			if turtle.compareDown() and turtle.getItemCount() ~= 0 then 
				print("anchor") 
				return 1
			elseif turtle.down() then 
				break
			else 
				refuel() 
				turtle.select(coal_slot) 
				turtle.digDown() 
				turtle.attackDown()
				catch_bottom = catch_bottom + 1
				if catch_bottom > 10 then
					print("bottom")
					break
				end
			end
        end
		num=num-1
	end
end

--recovery code
function rtf()
	print("rtf")
	rtftable=linereader("recoverystats")
	if #rtftable==0 then print("no table")
		turtle.select(tank_slot)
		print("here")
		if turtle.compare() then print("here") return
		else distress()
		end
	end
	print("longtable")
	linenum=#rtftable
	while(linenum>0)do
		queuechurn()
		flagcheck=moverv(rtftable[linenum])
		linenum=linenum-1
		turtle.select(tank_slot)
		if flagcheck then
			for i=0,linenum do
				table.remove(rtf2table)
			end
		end
	end
	sleep(.5)
	turtle.select(tank_slot)
	if turtle.compare() then return end
	print("goback")
	linenum=0
	while(linenum<=#rtftable) do
		queuechurn()
		movefd(rtftable[linenum])
		linenum=linenum+1
	end
	sleep(.5)
	print("shorttable")
	table.remove(rtftable)
	linenum=#rtftable
	while(linenum>0)do
		queuechurn()
		moverv(rtftable[linenum])
		linenum=linenum-1
	end
	turtle.select(tank_slot)
	if turtle.compare() then return end
	distress()
end


function distress()
	print("lost")
	exit()
	goUp(100)
end
	
	
--JOBS
function refuel()
	lava_refuel()
	coal_refuel()
end

function lava_refuel()
	if slowtest then 
		print("lava_refuel")
		sleep(.5)
	end
	local pfile=fs.open("recoveryjob","w")
	pfile.write("refuel")
	pfile.close()
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
	if slowtest then 
		print("coal_refuel")
		sleep(.5)
	end
	local pfile=fs.open("recoveryjob","w")
	pfile.write("refuel")
	pfile.close()
	if turtle.getFuelLevel()<10 then
		turtle.select(coal_slot) 
		turtle.refuel(1)
	end
end

function d_p_choose(i,pd)
	if slowtest then 
		print("d_p_choose")
		sleep(.5)
	end
	if not i then
		dig()
	elseif i then
		place()
	end
end

function chunk_stack(i,pd)
	if slowtest then 
		print("chunk_stack")
		sleep(.5)
	end
	--pickup or place the whole stack of chunk loading equipment
	turtle.select(rtg_slot)
	if i and pd then --predump
		turtle.drop()
	end
	turtle.select(pellet_slot)
	if i and pd then --predump
		turtle.drop()
	end
	turtle.select(rtg_slot)
	d_p_choose(i) -- place or pick rtg
	
	turtle.select(pellet_slot)
	if i and pd then --predump
		turtle.drop()
	end
	if i then
		turtle.drop(1) -- insert the rtg pellet
	
	
	goUp(1)
	turtle.select(pipe_slot)
	if i and pd then --predump
		turtle.drop()
	end
	d_p_choose(i)
	goUp(1)
	turtle.select(dynamo_slot)
	if i and pd then --predump
		turtle.drop()
	end
	d_p_choose(i)
	goUp(1)
	turtle.select(wire_slot)
	if i and pd then --predump
		turtle.drop()
	end
	d_p_choose(i)
	goUp(1)
	turtle.select(chunkloader_slot)
	if i and pd then --predump
		turtle.drop()
	end
	d_p_choose(i)
	goDn(4)
	sleep(5) --make sure the chunk loader is active
end

function chunkstep(p)
	if slowtest then 
		print("chunkstep")
		sleep(.5)
	end
	local pfile=fs.open("recoveryjob","w")
	pfile.write("chunkstep")
	pfile.close()
	if (p=="" or p==NULL) then p="1" end
	local pfile=fs.open("recoverystats","w")
	while (p~="7") do
		queuechurn()
		if slowtest then 
			print(p)
			sleep(.5)
		end
		if p=="1" then
			pfile.write()
			pfile.close()
			goBk(1)	
			turnR(1)
			goFd(1)
			turnL(1)
			goFd(9)
			turnL(1)
			goFd(1)
			chunk_stack(true,false)--put a chunk loader at the edge of the current chunk
			--now should have no chunk loader items in inventory
			local pfile1=fs.open("recoverystats","w")
			pfile1.write()
			pfile1.close()
			local pfile2=fs.open("chunkpoint","w")
			pfile2.write("2")
			pfile2.close()
			p="2"
		elseif p=="2" then
			goBk(1)
			turnL(1)
			goFd(6)
			turnR(1)
			goFd(1)
			turnL(1)
			--should have no chunk loader items in inventory predump items
			chunk_stack(false,true)--pick up the old chunk loader
			--should have one chunk loader in inventory
			turnL(2)
			goFd(6)
			chunk_stack(true,false)--place the chunk loader in the next chunk 
			--should have no chunk loader items in inventory
			local pfile3=fs.open("recoverystats","w")
			pfile3.write()
			pfile3.close()
			local pfile4=fs.open("chunkpoint","w")
			pfile4.write("3")
			pfile4.close()
			p="3"
		elseif p=="3" then
			goBk(1)
			turnR(1)
			goFd(1)
			turnL(1)
			goFd(3)
			turnL(1)
			goFd(1)
			turnL(1)
			local pfile5=fs.open("recoverystats","w")
			pfile5.write()
			pfile5.close()
			local pfile6=fs.open("chunkpoint","w")
			pfile6.write("4")
			pfile6.close()
			p="4"
		elseif p=="4" then
			goBk(1)
			turnR(1)
			goFd(1)
			turnL(1)
			goFd(2)
			--should have no chunk loader in inventory
			chunk_stack(false,true)--pick up the chunk loader in the previous chunk
			--should have one chunk loader in inventory
			turnR(2)
			goFd(1)
			turnR(1)
			goFd(1)
			turnR(1)
			local pfile7=fs.open("recoverystats","w")
			pfile7.write()
			pfile7.close()
			local pfile8=fs.open("chunkpoint","w")
			pfile8.write("5")
			pfile8.close()
			p="5"
		elseif p=="5" then
			turnL(2)
			goFd(6)
			chunk_stack(true) --???
			local pfile9=fs.open("recoverystats","w")
			pfile9.write()
			pfile9.close()
			local pfile10=fs.open("chunkpoint","w")
			pfile10.write("6")
			pfile10.close()
			p="6"
		elseif p=="6" then
			turnL(2)
			goFd(6)
			chunk_stack(false)--???
			turnL(2)
			goFd(6)
			local pfile11=fs.open("recoverystats","w")
			pfile11.write()
			pfile11.close()
			p="7"
		end
	end
end

function bore(max_depth)
	if slowtest then 
		print("bore")
		sleep(.5)
	end
	local pfile=fs.open("recoveryjob","w")
	pfile.write("bore")
	pfile.close()
	turtle.digDown()
	deep=0
	while turtle.detectDown()==false do
		goDn(1)
		deep=deep+1
		turtle.digDown()
		scan(0)
		if deep > max_depth then
			return
		end
	end
end

function gotosurf()
	if slowtest then 
		print("gotosurf")
		sleep(.5)
	end
	local pfile=fs.open("recoveryjob","w")
	pfile.write("gotosurf")
	pfile.close()
	goUp(deep)
end

function dump_stuff()
	turnL(2)
	if slowtest then 
		print("dump_stuff")
		sleep(.5)
	end
	local pfile=fs.open("recoveryjob","w")
	pfile.write("dump")
	pfile.close()
	turtle.select(chest_slot)
	place()
	for i=supnum+1,16 do
		turtle.select(i)
		turtle.drop()
	end
	turtle.select(chest_slot)
	dig()
	turnL(2)
end


--mining code	

function mineFd()
	memoryguard=memoryguard+1
	goFd(1)
	scan(1)
	goBk(1)
	memoryguard=memoryguard-1
end
function mineUp()
	memoryguard=memoryguard+1
	goUp(1)
	scan(1)
	goDn(1)
	memoryguard=memoryguard-1
end
function mineDn()
	memoryguard=memoryguard+1
	goDn(1)
	scan(1)
	goUp(1)
	memoryguard=memoryguard-1
end

function checkOre(data_name)
	if slowtest then 
		print("checkOre")
		sleep(.5)
	end
	for _,item in pairs(not_ores) do
		if data_name == item then
			return false
		end
	end
	return true
end

function compareFd()
	if slowtest then 
		print("compareFd")
		sleep(.5)
	end
	if turtle.detect() and memoryguard<memoryguardnum then
		b,d = turtle.inspect()
		ore = checkOre(d.name)
		if ore then 
			mineFd() 
		else
			dig()--make a wider bore and get more netherrack
		end
		
	end
end

function compareUp()
	if slowtest then 
		print("compareUp")
		sleep(.5)
	end
	if turtle.detectUp() and memoryguard<memoryguardnum then
		b,d = turtle.inspectUp()
		ore = checkOre(d.name)
		if ore then mineUp() end
	end
end

function compareDn()
	if slowtest then 
		print("compareDn")
		sleep(.5)
	end
	if turtle.detectDown() and memoryguard<memoryguardnum then
		b,d = turtle.inspectDown()
		ore = checkOre(d.name)
		end
		if ore then mineDn() 
	end
end


function scan(first)
	if slowtest then 
		print("scan")
		sleep(.5)
	end
	for scanrot=1,4 do
		compareFd()
		turnL(1)
	end
	if first~=0 then
		compareUp()
		compareDn()
	end
end
--User start INIT
function userinit()
	--tank_slot = 1
	--pipe_slot = 2
	--dynamo_slot = 3
	--wire_slot = 4
	--chunkloader_slot = 5
	--chest_slot = 6
	--bucket_slot = 7
	print ("insert rtg(2), rtg pellet(3), chunk loader(2), ender_chest(1), bucket(1), coal \nmake sure I'm placed with my left and back to a chunk border facing in mining direction \n enter 1 to begin program 2 to start test")
	--print("insert coal, enderchest, 3chunkloaders 1stone, 1dirt, 1gravel, 1cobble \n make sure I'm placed with my left and back to a chunk border facing in mining direction \n enter 1 to begin program")
	startcode=io.read()
	startcode=tonumber(startcode)
	--if startcode==1 then print("try again!") exit() end
	if startcode == 1 then
		local prmode=fs.open("recoverymode","w")
		prmode.write("restart")
		prmode.close()
		turnR(1)
		goFd(7)
		turnL(1)
		goFd(7)
		chunk_stack(true,false) --place chunk stack at the center of chunk
		mainfunc(1000)
	elseif startcode == 2 then --test mode
		local prmode=fs.open("recoverymode","w")
		prmode.write("restart")
		prmode.close()
		turnR(1)
		goFd(7)
		turnL(1)
		goFd(7)
		chunk_stack(true,false) --place chunk stack at the center of chunk
		mainfunc(10)
	else -- do not start
		exit()
	end
end
--MAIN FUNCTION
function mainfunc(max_depth)
	while true do
		chunkstep()
		dump_stuff()
		bore(max_depth)
		gotosurf()
	end
end
--stuffs
initfiles()
local prmode=fs.open("recoverymode","r")
rmode=prmode.readAll()
prmode.close()
if rmode=="restart" then --recovery
	print(rmode)
	local pfile=fs.open("recoveryjob","r")
	recoveryjob=pfile.readAll()
	pfile.close()
	print("recoveryjob")
	print(recoveryjob)
	if recoveryjob=="dump" then rtf() dump_stuff() 
	elseif recoveryjob=="chunkstep" then 
		local chunkpoint=fs.open("chunkpoint","r")
		point=chunkpoint.readAll()
		chunkpoint.close()
		rtf()
		chunkstep(point)
		mainfunc()
	else rtf() mainfunc() end
else --user start
	print("userstartmode")	
	print(rmode)
	userinit()
	
end