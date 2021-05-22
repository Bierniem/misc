# python server manager
import datetime
import discord
import time
import subprocess
import urllib.request
import shutil
import zipfile
from multiprocessing import Process,Queue
import pickle
# timed up and down
#will break if something blocks for an hour...
#day hour on,day hour off
#wednesday 22utc = 4mdt 6 hours, Saturday 16utc = 10mdt 7 hours
#On = [[1,23],[2,1]]
#Off = [[2,0],[2,2]]
On = [[2,16],[5,0]]
Off = [[3,0],[6,0]]
state = False

def flatten(arrin):
	return [val for sl in arrin for val in sl]


class process_thing:

	def __init__(self):
		self.state = False
		self.serverProc = False
		self.players = []
		self.q =Queue()
		self.stdioProc = Process(target = self.streamer)

	def turnOn(self):
		print ('trying')
		serverLoc = 'C:\\Users\\Ben\\Desktop\\minecraft server\\1.12\\forge install'
		serverFunc = serverLoc+'\\startServer.bat'
		#serverProc = subprocess.Popen(["C:\\Users\\Ben\\Desktop\\LunaMultiplayer-Release\\LMPServer\\Server.exe"],stdin = subprocess.PIPE,universal_newlines = True, creationflags = subprocess.CREATE_NEW_CONSOLE)
		self.serverProc = subprocess.Popen([serverFunc],cwd = serverLoc, stdin = subprocess.PIPE,universal_newlines = True)
		#self.serverProc = subprocess.Popen([serverFunc],cwd = serverLoc, stdout = subprocess.PIPE, stdin = subprocess.PIPE,universal_newlines = True)
		self.state = True
		print ('server up')
		self.stdioProc.start()
		
	def turnOff(self):
		if not self.state:
			return
		self.serverProc.communicate("/stop")
		time.sleep(10)
		self.serverProc.terminate()
		self.state = False
		self.stdioProc.join()
		
	def streamer(self):
		for line in iter(serverProc.stdout.readline,''):
			self.q.put(line)
			
	def readPlayers(self):
	#this function is blocking right now... readline is supposed to
	#I could thread the readline function seperately to handle this
		now = datetime.datetime.today()	
		while not self.q.empty():
			line = self.q.get()
			print (line)
			if 'joined the game' in line:
				words = line.split(' ')
				players.append(words[3])
				pickleLog(words[3],1)
				
			if 'left the game' in line:
				words = line.split(' ')
				try:
					players.remove(self.players.index(words[3]))
				except ValueError:
					continue
				pickleLog(words[3],0)
				
			fid = open('players.txt','w')
			writeline = '\n'.join(players)+ '\nupdate: '+str(now.hour)+':'+str(now.minute)+'\n'
			print(writeline)
			fid.write(writeline)
			fid.close()
		
	def pickleLog(player,inout):
		fid = open('playerPickle.pkl','rw')
		playerPick = pickle.load(fid)
		if player not in playerPick.keys():
			playerPick[player] = []
		playerPick[player].append([inout,time.time()])
		
		
# copy backups to nas
# discord ip bot
def runAlwaysUp(backup_hour,backup_minute = 0):
	#runs almost all the time but, ocasionally stops to do a backup...
	proc = process_thing()
	while True:
		#proc.readPlayers()
		now = datetime.datetime.today()	
		#print(now.hour,now.minute,proc.state)
		if (now.hour == backup_hour and now.minute == backup_minute):
			if proc.state:
				print('bringing server down')
				fid = open('status.txt','w')
				fid.write('server Backing up and restarting')
				fid.close()
				proc.turnOff()
				fileName = 'C:\\Users\\Ben\\Desktop\\minecraft server\\1.12\\forge install\\world'
				backupName = 'C:\\Users\\Ben\\Desktop\\minecraft server\\1.12\\forge install\\worldBackups\\world_'+now.day+'-'+now.month+'-'+now.year
				#shutil.copytree(fileName,backupName)
				zipfile.ZipFile.write(fileName,backupName)
				
		else:		
			fid = open('status.txt','w')
			writeline = 'Server On\nupdate: '+str(now.hour)+':'+str(now.minute)+'\n'
			fid.write(writeline)
			fid.close()
			if not proc.state:
				print('bringing server up')
				proc.turnOn()
		time.sleep(5)
	print ('no')
	
def runNormal(onNow = False):
	serverProc = False
	state = False
	while True:
		now = datetime.datetime.today()
		print(now.weekday(),now.hour)
		if onNow:
			print ('maybe on')
			if not state:
				print('turning on')
				status = 'Server On/busy starting'
				fid = open('status.txt','w')
				fid.write(status)
				fid.close()
				serverProc = turnOn()
				state = True
		for i in range(len(On)):
			if (now.weekday() == On[i][0]) and (now.hour == On[i][1]):
				print ('maybe on')
				if not state:
					print('turning on')
					status = 'Server On/busy starting'
					fid = open('status.txt','w')
					fid.write(status)
					fid.close()
					serverProc = turnOn()
					state = True
		for i in range(len(Off)):
			if (now.weekday() == Off[i][0]) and (now.hour == Off[i][1]):
				print('maybe off')
				if state:
					fid = open('status.txt','w')
					fid.write(status)
					fid.close()
					print('turning off')
					turnOff(serverProc)
					state = False
		if not state:
			#print(now.hour)
			for i in range(len(On)):
				minDays = [(On[i][0] - now.weekday())%7 for i in range(len(On)) ]
			minDay = min(minDays)
			mindex = minDays.index(minDay)
			minHour = (On[mindex][1] - now.hour)
			print(minDay,minHour,mindex)
			tton = 24 * minDay + minHour
			status = 'Server Off, turning on in '+str(tton)+' hours'
			fid = open('status.txt','w')
			fid.write(status)
			fid.close()
		time.sleep(10)
		
def test():
	serverProc = turnOn()
	time.sleep(600)
	turnOff(serverProc)
	
if __name__=='__main__':
	runAlwaysUp(12,25)
	
	'''
	server = ServerManager()
	server.runAlwaysUp()
	'''