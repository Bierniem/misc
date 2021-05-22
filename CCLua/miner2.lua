deep=0
dist=0
dist2=0

function goup()
	while true do
		if turtle.up() then break
		else turtle.digUp() end
	end
end
function godn()
	while true do
		if turtle.down() then break
		else turtle.digDown() end
	end
end
function gofd()
	while true do
		if turtle.forward() then break
		else turtle.dig() end
	end
end
function gobk()
	while true do
		if turtle.back() then break
		else sleep(1) 
			turtle.turnLeft()
			turtle.turnLeft()
			gofd()
			turtle.turnLeft()
			turtle.turnLeft()
		end
	end
end
function refuel()
	while turtle.getFuelLevel()<500+dist+dist2 do
		turtle.select(1)
		turtle.refuel(1)
	end
end
function bore()
	deep=0
	while turtle.detectDown()==false do
		godn()
		deep=deep+1
		turtle.select(1)
		turtle.digDown()
		for i=1,4 do
			compare1()
			turtle.turnLeft()
		end
	end
	gofd()
	gofd()
	gofd()
	dist=dist+3
end
function up()
	print(deep)
	for i=1,deep do 
		turtle.digUp()
		goup()
		for i=1,4 do
			compare1()
			turtle.turnLeft()
		end
 
	end

end
function dump()
	turtle.turnLeft()
	turtle.turnLeft()
	for i=1,dist do
		gofd()
	end
	if dir==0 then turtle.turnLeft() end
	if dir==1 then turtle.turnRight() end
	for i=1,dist2 do
		gofd()
	end
	if dir==0 then turtle.turnRight() end
	if dir==1 then turtle.turnLeft() end
	for i=2,4 do
		turtle.select(i)
		turtle.drop(turtle.getItemCount(i)-1)
	end
	for i=5,16 do
		turtle.select(i)
		turtle.drop()
	end
	turtle.turnLeft()
	turtle.turnLeft()
end
function next()
	while turtle.detectUp()==true do sleep(10) end
	if dir==0 then turtle.turnLeft() end
	if dir==1 then turtle.turnRight() end
	for i=1,dist2 do
		gofd()
	end
	if dir==0 then turtle.turnRight() end
	if dir==1 then turtle.turnLeft() end
	turtle.select(1)
	dist=dist+3
	for i=1,dist do
		turtle.dig()
		gofd()
	end
end
function compare1()
	ore=1
	if turtle.detect()==true then
		for i=2,4 do
			turtle.select(i)
			if turtle.compare()==true then ore=0 end
		end
		if ore==1 then turtle.select(1) mine() end
	end
end
function compare2()
	ore=1
	if turtle.detect()==true then
		for i=2,4 do
			turtle.select(i)
			if turtle.compare()==true then ore=0 end
		end
		if ore==1 then turtle.select(1) mine2() end
	end
end
function compare3()
	ore=1
	if turtle.detect()==true then
		for i=2,4 do
			turtle.select(i)
			if turtle.compare()==true then ore=0 end
		end
		if ore==1 then turtle.select(1) turtle.dig() end
	end
end	
function compupdn()
	ore=1
	if turtle.detectUp()==true then
		for i=2,4 do
			turtle.select(i)
			if turtle.compareUp()==true then ore=0 end
		end
		if ore==1 then turtle.select(1) turtle.digUp() end
	end
	if turtle.detectDown()==true then
		for i=2,4 do
			turtle.select(i)
			if turtle.compareDown()==true then ore=0 end
		end
		if ore==1 then turtle.select(1) turtle.digDown() end
	end
end
function mine()
	turtle.dig()
	gofd()
	compare3()
	turtle.turnRight()
	compare2()
	turtle.turnLeft()
	turtle.turnLeft()
	compare2()
	turtle.turnRight()
	gobk()
end
function mine2()
	turtle.dig()
	gofd()
	compupdn()
	compare3()
	gobk()
end
--main--
print("dir? 0=L 1=R")
dir=io.read()
dir=tonumber(dir)
if dir==0 then print("Left") 
elseif dir==1 then print("Right") 
else print("not valid dir") exit() end
while (dist2<67) do

while (dist<67) do
print("refuel")
refuel()
print("next")
next()
print("bore")
turtle.select(1)
turtle.digDown()
bore()
print("up")
up()
print("dump")
dump()
end
dist=0
dist2=dist2+3
end