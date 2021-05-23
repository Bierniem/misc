import discord
import urllib.request
import certifi
import numpy as np
import pickle
import time
import asyncio
import requests
import re
import os

#os.chdir('C:\\Users\\biern\\Desktop\\Python')

#load or instantiate dictionaries
try:
	dayVotes = pickle.unpickle('.\pickles\dayVotes.pkl')
except:
	dayVotes = {'filename':'.\pickles\dayVotes.pkl'}
try:
	hourVotes = pickle.unpickle('.\pickles\hourVotes.pkl')
except:
	hourVotes = {'filename':'.\pickles\hourVotes.pkl'}


def run_client(client, *args, **kwargs):
    loop = asyncio.get_event_loop()
    while True:
        try:
            loop.run_until_complete(client.start(*args, **kwargs))
        except Exception as e:
            print("Error", e)  # or use proper logging
        print("Waiting until restart")
        time.sleep(600)

def getMyExtIp():
    try:
        res = requests.get("http://whatismyip.org")
        myIp = re.compile('(\d{1,3}\.){3}\d{1,3}').search(res.text).group()
        if myIp != "":
            return myIp
    except:
        pass
    return "n/a"

def getIp():
    external_ip = urllib.request.urlopen('https://ident.me').read().decode('utf8')
    return external_ip
	
def vote(dict,d0,d1,name):
    #sort d0,d1
    darry = np.array(d0,d1)
    #add to dictionary
    dict[name] = darry
    #save to file
    pickle.dump(dict,dict['filename'])
    #tally votes
    votes = []
    for key in dict.keys():
        if key != 'filename':
            votes.append(dict[key][0])
            votes.append(dict[key][1])
    histbins = set(votes)
    histbins.append(np.max(histbins)+1)
    hist = np.histogram(votes,histbins)
    return hist
	
	
	
client = discord.Client()
	
@client.event
async def on_message(message):
    print('message')
    channel = message.channel
    if message.author == client.user:
        return
    if message.content.startswith('!ip'):
        print('getting ip')
        ip = getMyExtIp()
        msg = 'the server is at:  ' + str(ip).format(message)
        await channel.send(msg)
        time.sleep(1)
    if message.content.startswith('!up'):
        print('getting status')
        #ip = getMyExtIp()
        fid = open('.\status.txt','r')
        status = fid.read()
        fid.close()
        msg = status
        print(status)
        await channel.send(msg)
        time.sleep(1)
        
    if message.content.startswith('!who'):
        print('getting players')
        #ip = getMyExtIp()
        fid = open('.\players.txt','r')
        status = fid.read()
        fid.close()
        msg = status
        print(status)
        await channel.send(msg)
        time.sleep(1)
    #elif message.content.startswith('!voteDay'):
    #	print('voteDay')
    #	hist = vote(dayVotes,)
        
@client.event
async def on_ready():
    print('logged in')

print('starting')
time.sleep(10)
print('here')
while(True):
    time.sleep(1)
    print ('here2')
    with open('token.pkl','rb') as tkf:
        token = pickle.load(tkf)
    try:
        run_client(client,token)
        #client.run('musicwebsiteemail@gmail.com','Aa19726033')
        print('nerr')
    except Exception as e:
        print('err',e)
        #client.close()
        exit()
