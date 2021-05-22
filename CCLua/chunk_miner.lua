--simple fast chunk remover miner
--recursive miner
supnum=3 --supplies 
forbidnum=0 --slots to forbid items
deep=0
memoryguardnum=40
memoryguard=0
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
	local pfile =fs.open(file,"w")
	if pfile then
		for _, sLine in ipairs(writetable) do
			pfile.writeLine(sLine)
		end
		pfile.close()
	end
end
function lineadder(file,newdat)
	local addtable=linereader(file)
	table.insert(addtable,newdat)
	linewriter(file,addtable)
end
		
--MOVE FUNCTIONSv
function dig()
	while true do
		queuechurn()
		if turtle.dig() then break
		else turtle.attack()end
	end
end
function place()
	while true do
		queuechurn()
		if turtle.place() then break
		else turtle.dig() turtle.attack()end
	end
end
function placeUp()
	while true do
		queuechurn()
		if turtle.placeUp() then break
		else turtle.digUp() turtle.attackUp() end
	end
end
function turnL(num)
	turtle.select(1)
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
	turtle.select(1)
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
	turtle.select(1)
	while num>0 do
		--print("Fd")
		lineadder("recoverystats","Fd")
		queuechurn()
		while true do
			queuechurn()
			turtle.select(3)
			if turtle.compare() then print("anchor") return 1
			elseif turtle.forward() then break
			else refuel() turtle.select(1) turtle.dig() turtle.attack()
			end
                end
                num=num-1
        end
end
function goBk(num)
	turtle.select(1)
	while num>0 do
		--print("Bk")
		lineadder("recoverystats","Bk")
		queuechurn()
		while true do
			queuechurn()
			turtle.select(3)
			turnL(2)
			if turtle.compare() then turnL(2) print("anchor") return 1
			elseif turtle.forward() then turnL(2) break
			else refuel() turtle.select(1) turtle.dig() turtle.attack() turnL(2)	
			end
		end
		num=num-1
	end
end
function goUp(num)
	turtle.select(1)
	while num>0 do
		lineadder("recoverystats","Up")
		queuechurn()
		while true do
			queuechurn()
			turtle.select(3)
			if turtle.compareUp() then print("anchor")return 1
			elseif turtle.Up() then break
			else refuel() turtle.select(1) turtle.digUp() turtle.attackUp()
			end
                end
                num=num-1
        end
end
function goDn(num)
	turtle.select(1)
	while num>0 do
		lineadder("recoverystats","Dn") 
		queuechurn()
		while true do
			queuechurn()
			turtle.select(3)
			if turtle.compareDown() then print("anchor") return 1
			elseif turtle.down() then break
			else refuel() turtle.select(1) turtle.digDown() turtle.attackDown()
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
		turtle.select(3)
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
		turtle.select(3)
		if flagcheck then
			for i=0,linenum do
				table.remove(rtf2table)
			end
		end
	end
	sleep(3)
	turtle.select(3)
	if turtle.compare() then return end
	print("goback")
	linenum=0
	while(linenum<=#rtftable) do
		queuechurn()
		movefd(rtftable[linenum])
		linenum=linenum+1
	end
	sleep(3)
	print("shorttable")
	table.remove(rtftable)
	linenum=#rtftable
	while(linenum>0)do
		queuechurn()
		moverv(rtftable[linenum])
		linenum=linenum-1
	end
	turtle.select(3)
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
	local pfile=fs.open("recoveryjob","w")
	pfile.write("refuel")
	pfile.close()
	if turtle.getFuelLevel()<1000 then
		 print("moar coal!") turtle.select(1) turtle.refuel(turtle.getItemCount(1)-1)
	end
	if turtle.getFuelLevel()<1000 then print("need more fuel") exit() end
end
function chunkstep(p)
	print("chunkstep")
	local pfile=fs.open("recoveryjob","w")
	pfile.write("chunkstep")
	pfile.close()
	if (p=="" or p==NULL) then p="1" end
	local pfile=fs.open("recoverystats","w")
	while (p~="7") do
		queuechurn()
		print(p)
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
			turtle.select(3)
			place()
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
			turtle.select(3)
			dig()
			turnL(2)
			goFd(6)
			turtle.select(3)
			place()
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
			turtle.select(3)
			dig()
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
			turtle.select(3)
			place()
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
			dig()
			turnL(2)
			goFd(6)
			local pfile11=fs.open("recoverystats","w")
			pfile11.write()
			pfile11.close()
			p="7"
		end
	end
end

function bore()
	print("bore")
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
	end
end

function gotosurf()
	print("gotosurf")
	local pfile=fs.open("recoveryjob","w")
	pfile.write("gotosurf")
	pfile.close()
	goUp(deep)
end

function dump()
	turnL(2)
	print("dump")
	local pfile=fs.open("recoveryjob","w")
	pfile.write("dump")
	pfile.close()
	turtle.select(2)
	place()
	for i=1+supnum,forbidnum+supnum do
		turtle.select(i)
		dumpcount=turtle.getItemCount(i)-1
		if dumpcount>0 then turtle.drop(dumpcount) end
	end
		for i=forbidnum+supnum+1,16 do
		turtle.select(i)
		turtle.drop()
	end
	turtle.select(2)
	dig()
	turnL(2)
end

function dump_exclude(exclude)
	print("dump_exclude")
	local pfile=fs.open("recoveryjob","w")
	pfile.write("dump_exclude")
	pfile.close()
	turtle.select(2) --chest needs to be in slot 2
	place()
		for i=exclude+1,16 do
		turtle.select(i)
		turtle.drop()
	end
	turtle.select(2)
	dig()
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

function compareFd()
	if turtle.detect() and memoryguard<memoryguardnum then ore=1
		for i=1+supnum,forbidnum+supnum do
			turtle.select(i)
			if turtle.compare() then ore=0 end
		end
		if ore==1 then mineFd() end
	end
end

function compareUp()
	if turtle.detectUp() and memoryguard<memoryguardnum then ore=1
		for i=1+supnum,forbidnum+supnum do
			turtle.select(i)
			if turtle.compareUp() then ore=0 end
		end
		if ore==1 then mineUp() end
	end
end

function compareDn()
	if turtle.detectDown() and memoryguard<memoryguardnum then ore=1
		for i=1+supnum,forbidnum+supnum do
			turtle.select(i)
			if turtle.compareDown() then ore=0 end
		end
		if ore==1 then mineDn() end
	end
end

function scan(first)
	print("scan")
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
	print("insert coal, enderchest, 3chunkloaders 1stone, 1dirt, 1gravel, 1cobble \n make sure I'm placed with my left and back to a chunk border facing in mining direction \n enter 1 to begin program")
	startcode=io.read()
	startcode=tonumber(startcode)
	if startcode~=1 then print("try again!") exit() end
	local prmode=fs.open("recoverymode","w")
	prmode.write("restart")
	prmode.close()
	mainfunc()
		
end
--MAIN FUNCTION
function mainfunc()
		--go down then mine all blocks in a 16x16x3 layer
		goDn(2)

		deep = deep + 2
		for j = 0, 16 do
			for i = 0, 16 do
				dig()
				goFd(1)
				digUp()
				digDown()
			end
			--turn around for the next row
			if j < 15 then --don't do the turn on the last column
				if j%2 == 0 then
					turnL(1)
					goFd(1)
					turnL(1)
				end
				if j%2 == 1 then
					turnR(1)
					goFd(1)
					turnR(1)
				end
			end
			--dump inventory & refuel if necessary
			goFd(1)
			goBk(1)--make sure to clear the space for the chest
			dump_exclude(2)
			refuel()
		end
		--go back to the starting column
		turnL(1)
		goFd(15)
		--try to go down, if at the bottom... go up
		digDown()
		if turtle.detectDown()==false do
			goDn(1)
			deep=deep+1
			turtle.digDown()
		else --done go back up		
		goUp(deep)
		exit()
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
	if recoveryjob=="dump" then rtf() dump() 
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