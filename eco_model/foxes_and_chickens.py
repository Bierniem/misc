import matplotlib.pyplot as plt
import matplotlib
from matplotlib import animation, rc
from matplotlib.ticker import LinearLocator, FixedLocator,FormatStrFormatter
import numpy as np


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
            priceDif = points[0].chickens.price - points[1].price
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

class Thing():
    def __init__(self):
        self.supply = 0
        self.demand = 0
        self.price = 0

class Point():
    def __init__(self):
        self.chickens = Thing()
        self.foxes = Thing()
    
def pid(p,i,d,e,ti,td):
    ret = p*e[0] + i*sum(e[:ti])/ti + d*(e[0]-e[td])/td
    return ret


def update(p:Point):
    starve = p.foxes.supply - p.chickens.supply
    p.chickens.supply = max(0,p.chickens.supply-p.foxes.supply)
    if starve > 0:
        p.foxes.supply -= starve
    if p.foxes.supply>2:
        p.foxes.supply += .1

    if p.chickens.supply>2:
        p.chickens.supply += 1

    p.chickens.demand = -p.foxes.supply
    p.chickens.demand += p.chickens.supply
    p.foxes.demand = p.chickens.supply




def foxes_and_chickens_system():
    """
    foxes
    eat chickens
    make more foxes
    travel towards chickens
    #have limited lifespan
    die without chickens

    chickens
    make more chickens
    travel towards chickens
    travel away from foxes
    #have limited lifepan
    die with foxes
    """



    matplotlib.interactive(True)


    t2d = Terrain2D([50,50])


    fig = plt.figure()
    ax = fig.add_subplot(111,projection = '3d')
    X,Y = np.meshgrid(range(t2d.dim[0]),range(t2d.dim[1]))
    
    t2d.points[0].chickens.supply = 5
    #t2d.points[100].supply = supplymax
    for i in range(500):
        #t2d.points[0].supply+=t2d.points[49].supply
        #t2d.points[50*25+25].supply = 0
        t2d.calc_delta()

        chickens = np.array([i.chickens.supply for i in t2d.points])
        foxes = np.array([i.foxes.supply for i in t2d.points])

        ax.plot_surface(X,Y,chickens.reshape(t2d.dim[0],t2d.dim[1]))
        #ax.set_zlim(0,plotmax)
        plt.draw()
        plt.pause(.01)
        ax.cla()


if __name__=='__main__':
    foxes_and_chickens_system()