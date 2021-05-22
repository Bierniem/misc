#player plotter
import pickle
from matplotlib import pyplot as plt

time_div = 1

#load player pickle
players = pickle.load(open('playerPickle.pkl','rb'))
#correct multi logins and other posssible wierdness

#force logout on server starts
start_list = [players['server'][i][1] - time_div for i in range(len(players['server']))]
for player in players.keys():
    for i in start_list:
        players[player].append([0,i])
        
#set times to integers
for player in players.keys():
    for i in range(len(players[player])):
       players[player][i][1] = int(players[player][i][1]/time_div)*time_div
       print(player,players[player][i][1])
       
#get timescale
mintime = min([players[player][i][1] for player in players.keys() for i in range(len(players[player]))])
mintime = int(mintime/time_div)*time_div
maxtime = max([players[player][i][1] for player in players.keys() for i in range(len(players[player]))])
maxtime = int(maxtime/time_div)*time_div
timerange = range(mintime,maxtime,time_div)
print('got times',mintime,maxtime)

#plot players over time
playerplt = {} #player(key), time(key), state
plt.figure()
for player in players.keys():
    pltlist = []
    for i in range(len(players[player])):
        playerplt[player]={}
        playerplt[player][players[player][i][1]] = players[player][i][0]
    lastval = 0
    for i in timerange:
        if i in playerplt[player].keys():
            print('here')
            lastval = playerplt[player][i]
        pltlist.append(lastval)
    plt.plot(timerange,pltlist)
    
plt.show()
#get stats max players most played etc