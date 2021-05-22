# python minecraft server manager
import datetime
import discord
import time
import subprocess
import urllib.request
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
def turnOn():
	serverProc = subprocess.Popen(["ServerStart.bat"],stdin = subprocess.PIPE,universal_newlines = True)
	return serverProc
def turnOff(serverProc):
	if not serverProc:
		return
	serverProc.communicate("/stop")
	time.sleep(10)
	serverProc.terminate()
# copy backups to nas
	
# discord ip bot

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
	runNormal()