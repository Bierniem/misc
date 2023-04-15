#new pid fluid model
from typing import TypedDict
import matplotlib.pyplot as plt
import matplotlib
from matplotlib import animation, rc
from matplotlib.ticker import LinearLocator, FixedLocator,FormatStrFormatter
import numpy as np
import time


class Terrain2D():
    def __init__(self,dim:list):
        """dim is [x,y], eg dim = [3,2] the points are arranged [[0,1,2],[3,4,5]]"""
        self.dim = dim
        self.points = [Point() for i in range(np.prod(dim))]
        self.coords = [[i,j] for i in range(dim[0]) for j in range(dim[1])]
        #print(self.coords)
        self.connections = [Connection(i,j) for i in range(len(self.points)) for j in range(len(self.points)) if self.is_neighbor(i,j)]
        #self.connections = [Connection(i,j) for i in range(len(self.points)) for j in range(len(self.points)) if j-i == 1 or j-i == dim[0]]
        #print(self.connections)
        self.randomizer = list(range(len(self.connections)))
        #np.random.shuffle(self.randomizer)

    def is_neighbor(self,i,j):
        a = (self.coords[i][0]-self.coords[j][0] == 1 and self.coords[i][1] == self.coords[j][1])
        b = (self.coords[i][1]-self.coords[j][1] == 1 and self.coords[i][0]==self.coords[j][0])
        return a or b

    def calc_delta(self,):
        #np.random.shuffle(self.randomizer)
        for n in self.randomizer:
            c = self.connections[n]
            points = [self.points[c.i], self.points[c.j]]
            #for p in points:
            #    self.update(p)
            priceDif = points[0].price - points[1].price
            if priceDif != 0:
                c.e = [priceDif] + c.e[:-1]
                c.supplyControl = pid(.1,.2,0,c.e,10,5)

                supplyMoveA = np.abs(c.supplyControl)
                supplyMoveB = (min(supplyMoveA,np.abs(points[int(c.supplyControl>=0)].supply)))
                supplyMove = np.sign(c.supplyControl)*supplyMoveB
                #print(supplyMoveA,supplyMoveB,supplyMove)

                c.demandControl = -pid(.1,.3,.1,c.e,10,5)
                demandMoveA = np.abs(c.demandControl)
                demandMoveB = (min(demandMoveA,np.abs(points[int(c.demandControl>=0)].demand)))
                demandMove = np.sign(c.demandControl)*demandMoveB
                #print(demandMoveA,demandMoveB,demandMove)

                points[0].supply += supplyMove
                points[1].supply -= supplyMove
                points[0].demand += demandMove
                points[1].demand -= demandMove
                
    def update(self,p):
        p.price = liquidSD(p)

    def update_all(self):
        for p in self.points:
            self.update(p)
    #def calc_moves(self,):
    #    for c in self.connections:

        


class Connection():
    def __init__(self,i,j):
        self.i = i
        self.j = j
        self.e = [0 for i in range(10)]

class Point():
    def __init__(self):
        self.supply = 0
        self.demand = 0
        self.price = 0
    
def pid(p,i,d,e,ti,td):
    ret = p*e[0] + i*sum(e[:ti])/ti + d*(e[0]-e[td])/td
    return ret

def liquidSD(p:Point):
    #for a liquid the price is analogous to the inverse surface level
    return -p.supply + p.demand
    #return p.demand
    #return(-p.supply)

def test_pid():
    plt.figure()
    js = [.01,.02,.05,.1,.2,.5]
    for j in js:
        sp = 10
        cv = 0
        e = [0 for i in range(20)]
        cvs = []
        for i in range(100):
            cvs+=[cv]
            e = [sp-cv] + e[:-1]
            cv+=pid(j,.1,.1,e,10,10)
        plt.plot(cvs)
    plt.legend(js)   
    plt.title('p')
    
    plt.figure()
    js = [.01,.02,.05,.1,.2,.5]
    for j in js:
        sp = 10
        cv = 0
        e = [0 for i in range(20)]
        cvs = []
        for i in range(100):
            cvs+=[cv]
            e = [sp-cv] + e[:-1]
            cv+=pid(.1,j,.1,e,10,10)
        plt.plot(cvs)
    plt.legend(js)   
    plt.title('i')

    plt.figure()
    js = [.01,.02,.05,.1,.2,.5]
    for j in js:
        sp = 10
        cv = 0
        e = [0 for i in range(20)]
        cvs = []
        for i in range(100):
            cvs+=[cv]
            e = [sp-cv] + e[:-1]
            cv+=pid(.1,.1,j,e,10,10)
        plt.plot(cvs)
    plt.legend(js)   
    plt.title('d')
    
    plt.show()

def plot_fluid_test():
    matplotlib.interactive(True)
    t2d = Terrain2D([20,20])
    fig = plt.figure()
    ax = fig.add_subplot(131,projection = '3d')
    ax2 = fig.add_subplot(132,projection = '3d')
    ax3 = fig.add_subplot(133,projection = '3d')
    X,Y = np.meshgrid(range(t2d.dim[0]),range(t2d.dim[1]))
    supplymax = np.prod(t2d.dim) **2
    plotmax = np.prod(t2d.dim)*2
    t2d.points[0].supply = supplymax/10
    t2d.points[-1].demand = supplymax/20
    for i in range(200):
        #t2d.points[0].supply+=t2d.points[49].supply
        #t2d.points[50*25+25].supply = 0
        #t2d.update()
        p = np.array([i.price for i in t2d.points])
        s = np.array([i.supply for i in t2d.points])
        d = np.array([i.demand for i in t2d.points])
        t2d.update_all()
        t2d.calc_delta()
        
        ax.plot_surface(X,Y,s.reshape(t2d.dim[0],t2d.dim[1]))
        ax2.plot_surface(X,Y,p.reshape(t2d.dim[0],t2d.dim[1]))
        ax3.plot_surface(X,Y,d.reshape(t2d.dim[0],t2d.dim[1]))
        ax.set_zlim(0,plotmax)
        ax2.set_zlim(0,plotmax)
        ax3.set_zlim(0,plotmax)
        plt.draw()
        plt.pause(.01)
        #plt.pause(.01)
        ax.cla()
        ax2.cla()
        ax3.cla()



if __name__ == '__main__':
    plot_fluid_test()
    #test_pid()
