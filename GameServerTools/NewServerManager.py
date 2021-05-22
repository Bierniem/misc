#new server manager
import subprocess as sp
import multiprocessing as mp
from datetime import datetime as dt
import os
import time
import shutil
import pickle


def pushTime(time):
	push = '00' + str(time)
	push = [push[i] for i in range(len(push)-2,len(push))]
	return ''.join(push)
	
class serverWrap:
	
	def __init__(self,serverloc,serverexe,q):
		self.serverloc = serverloc
		self.serverexe = serverexe
		self.q = q

	def run(self,):
		with sp.Popen([self.serverexe],cwd = self.serverloc, stdout = sp.PIPE, stdin = sp.PIPE, universal_newlines = True) as remoteProcess:
			print('server process up\n')
			while True:
				#print('here')
				msg = remoteProcess.stdout.readline()
				#print('msg',msg)
				try:
					self.q.put(msg)
				except:
					print('pipe error, closing')
					remoteProcess.communicate("/stop")
					time.sleep(10)
					while remoteProcess.poll():
						remoteProcess.terminate()
						time.sleep(1)
					return
				#print('put')
				'''if stop.value:
					print('terminating server process\n')
					remoteProcess.communicate("/stop")
					time.sleep(10)
					while remoteProcess.poll():
						remoteProcess.terminate()
						time.sleep(1)
					return'''
		
class serverManage:
	
	def __init__(self,backup,backupdir,q):
		self.backup = backup
		self.backupdir = backupdir
		self.q = q
		self.players = []
		self.didbackup = True
		
	def makeBackup(self,):
		timestring = dt.today().strftime("%m-%d-%Y_%H-%M")
		shutil.copytree(self.backup,os.path.join(self.backupdir,timestring))
		
	def pickleLog(self, player,inout):
		try:
			playerPick = pickle.load(open('.\playerPickle.pkl','rb'))
		except FileNotFoundError:
			playerPick = {}
		if player not in playerPick.keys():
			playerPick[player] = []
		playerPick[player].append([inout,time.time()])
		pickle.dump(playerPick,open('.\playerPickle.pkl','wb'))
	
	def logUsers(self,):
		while not self.q.empty():
			with open('status.txt','w') as fid:
				writeline = 'last server checkin: '+pushTime(dt.today().hour)+':'+pushTime(dt.today().minute)+'\n'
				fid.write(writeline)
			now = dt.today()	
			line = self.q.get()
			#print ('got ',line)
			if 'joined the game' in line:
				words = line.split(' ')
				wordn = words.index('joined')
				self.players.append(words[wordn-1])
				self.pickleLog(words[wordn-1],1)
				print (words[wordn-1:wordn+3])
			if 'left the game' in line:
				words = line.split(' ')
				wordn = words.index('left')
				print(words[wordn-1:wordn+3])
				self.pickleLog(words[wordn-1],0)
				try:	
					self.players.remove(words[wordn-1])
				except ValueError:
					print('failed to remove player ', words[wordn-1], ' from ', self.players)
				print(words[wordn-1:wordn+3])
				self.pickleLog(words[wordn-1],0)
				
			writeline = '\n'.join(self.players)+ '\nupdate: '+pushTime(now.hour)+':'+pushTime(now.minute)+'\n'
			with open('.\players.txt','w') as fid:
				#print(writeline)
				fid.write(writeline)
			
if __name__ == '__main__':
    os.chdir('C:\\Users\\biern\\Desktop\\Python')
    didbk = True
    q = mp.Queue()
    serverWrapper = serverWrap('C:\\Users\\biern\\Desktop\\minecraft server\\1.12\\forge install','C:\\Users\\biern\\Desktop\\minecraft server\\1.12\\forge install\\startServer.bat',q)
    #serverWrapper = serverWrap('C:\\Users\\Ben\\Desktop\\Python','C:\\Users\\Ben\\Desktop\\Python\\startdummyserver.bat',q)
    #serverManager = serverManage('C:\\Users\\Ben\\Desktop\\Python','C:\\Users\\Ben\\Desktop\\Python2',q)
    serverManager = serverManage('C:\\Users\\biern\\Desktop\\minecraft server\\1.12\\forge install\\world','D:\\serverBackups',q)
    serverProc = mp.Process(target = serverWrapper.run)
    serverProc.start()
    serverManager.pickleLog('server',1)
    while True:
        time.sleep(5)
        serverManager.logUsers()
        if (dt.today().hour == 4 and not didbk):
            serverManager.makeBackup()
            didbk = True
        elif (dt.today().hour != 4):
            didbk = False
            