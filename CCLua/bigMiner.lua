--big miner
chest_slot = 1
coal_slot = 2
bucket_slot = 3
supnum = 3
--MOVE FUNCTIONSv
function isin(item,list)
	for _,i in pair(list) do
		if i == item then
			return true
		end
	end
	return false
end

function dig()
	if slowtest then 
		print("dig")
		sleep(.5)
	end
	while true do
		if turtle.getItemCount(16) ~= 0 then
			dump_stuff()
		end
		if turtle.dig() then break
		else turtle.attack()end
		--check if inventory is full and dump
		
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
		while true do
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
		while true do
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
		while true do
			if turtle.forward() then 
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
		while true do
			turnL(2)
			if turtle.forward() then 
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
		while true do
			if turtle.up() then  
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
	dnum = 0
	if slowtest then 
		print("goDn")
		sleep(.5)
	end
	turtle.select(coal_slot)
	while num>0 do
		catch_bottom = 0
		while true do
			if turtle.down() then 
				dnum = dnum+1
				break
			else 
				refuel() 
				turtle.select(coal_slot) 
				turtle.digDown() 
				turtle.attackDown()
				catch_bottom = catch_bottom + 1
				
				if catch_bottom > 10 then
					print("bottom")
					return dnum
				end
			end
        end
		num=num-1
	end
	return dnum
end

function refuel()
	lava_refuel()
	coal_refuel()
end

function lava_refuel()
	if slowtest then 
		print("lava_refuel")
		sleep(.5)
	end
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

function dump_stuff()
	print("dump_stuff")
	turtle.select(chest_slot)
	place()
	for i=supnum+1,16 do
		turtle.select(i)
		turtle.drop()
	end
	turtle.select(chest_slot)
	dig()
end

function mine_row()
	--print("mine_row")
	for i = 0,size - 2 do
		dig()
		goFd(1)
		turtle.digUp()
		turtle.digDown()
	end
end

function row_turn(even)
	--print("row_turn")
	if even then
		turnR(1)
		goFd(1)
		turnR(1)
	else 
		turnL(1)
		goFd(1)
		turnL(1)
	end
	turtle.digUp()
	turtle.digDown()
end

function mine_layer(size)
	print("mine_layer")
	for i = 0,size - 1 do
		mine_row(size)
		if i ~=size - 1 then
			row_turn(i % 2 == 0)
		end
	end
	turnR(1)
	goFd(size-1)
	turnR(1)
end

function mine_chunk(mdepth,size)
	print("mine_chunk")
	depth = 0
	while true do
		nd = goDn(3)
		if nd > 0 then
			depth = depth + nd
		else --bottom
			break
		end
		if depth < mdepth then
			mine_layer(size)
		else
			break
		end
		
	end
	goUp(depth)
end
	
function next_chunk(cnum,size)
	dirs = {0,1,2,2,3,3,0,0,0,1,1,1,2,2,2,2,3,3,3,3,0,0,0,0} --1 indexed
	turnR(dirs[cnum])
	goFd(size)
	turnL(dirs[cnum])
end
	
function back_to_start(size)
	turnL(1)
	goFd((size)*2)
	turnR(1)
	goFd(size)
end

--MAIN FUNCTION

for i = 1,25 do
	nn = 120
	size = 16 --has to be even >=4
	mine_chunk(nn,size)
	next_chunk(i,size)
end
back_to_start(size)