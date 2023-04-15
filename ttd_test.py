#mess around with some ideas that i might want to try to implement as a mod to openttd or somethin
#make a sort of generalized demand based economy model
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FixedLocator,FormatStrFormatter
import matplotlib
import time


"""
make a list of locations
make a list of connections
"""

class Node:
    def __init__(self,location:list):
        """ 
        consumers/producers of things
        """
        self.demand = {} #contains map of demand for various items
        self.location = location
    
    def update_demand(self):
        """
        update the demand map
        """
        for product in self.demand.keys():
            self.demand[product] = 0

class Product:
    def __init__(self,halfLife,sdFunc,txSpeed,txCost):
        """
        things that are demanded
        args:
            halfLife: the halflife of the item in storage/transit( 10 ** halflife)
            sdFunc: the function that defines the price from supply and demand
        """
        self.halfLife = halfLife
        self.sdFunc = sdFunc
        self.txSpeed = txSpeed
        self.txCost = txCost
    
    def sd_func(self,supply,demand):
        return self.sdFunc(supply,demand)
    

class ProductPoint:
    """
    contains one product info for a single point
    """
    def __init__(self,location:list,product:Product,passability):
        self.product = product
        self.location = location
        self.supplyTxSpeed = passability*self.product.txSpeed
        self.demandTxSpeed = passability*self.product.txSpeed
        self.supplyTxCost = passability*self.product.txCost
        self.demandTxCost = passability*self.product.txCost
        self.demand = 0
        self.supply = 0
        self.consumption = 0
        self.production = 0
        self.price = self.product.sd_func(self.supply,self.demand)
        self.supplyFlows = 0
        self.demandFlows = 0

class Connection:
    def __init__(self,product:ProductPoint,Kp,Ti,Td,source,sink,e,ie,de,bias,minVal):
        self.bias = bias
        self.min = minVal
        self.product = product
        self.source = source
        self.sink = sink
        self.e = e
        self.ie = ie
        self.de = de
        self.Kp = Kp
        self.Ti = Ti 
        self.Td = Td

    def pid(self,):
        return self.Kp*(self.e + 1 / self.Ti * self.ie + self.Td * self.de)

    def update(self,):
        self.e[-self.n+1:] += self.source.supply - self.sink.supply - self.bias 
        self.ie = sum(self.e)
        self.de = self.e[-1] - self.e[-2]

class TerrainMap:
    def __init__(self,size:list,Product):
        """
        the play area
        args:
            size is the integer dimensions of the area
        """
        #passabilty = perlin(size)
        self.size = size
        self.terrainMap=[ProductPoint([i,j],product=Product,passability=1) for i in range(size[0]) for j in range(size[1])]
        self.compute_connections()

    def compute_connections(self,):
        self.connections = []
        for pp in self.terrainMap:
            neighbors = [[-1,0],[1,0],[0,-1],[0,1]]
            neighbors = [[pp.location[0]+n[0],pp.location[1]+n[1]] for n in neighbors if  self.size[0]>pp.location[0]+n[0]>0 and self.size[1]>pp.location[1]+n[1]>0]
            neighbors = [self.terrainMap[self.compute_index(i[0],i[1])] for i in neighbors]
            self.connections += [Connection(pp.location,i.location,0,0,0) for i in neighbors]
            

    def compute_index(self,i,j):
        return self.size[0]*i + j

    def compute_flow(self,):
        """
        compute the flow of the product into neighboring product points
        """
        #supply flows from lower price to higher price
        #demand flows from higher price to lower price
        #if the price+-txcost is equal there is no flow
        for pp in self.terrainMap:
            neighbors = [[-1,0],[1,0],[0,-1],[0,1]]
            neighbors = [[pp.location[0]+n[0],pp.location[1]+n[1]] for n in neighbors if  self.size[0]>pp.location[0]+n[0]>0 and self.size[1]>pp.location[1]+n[1]>0]
            neighbors = [self.terrainMap[self.compute_index(i[0],i[1])] for i in neighbors]
            pd = [n.price-pp.price for n in neighbors]
            #print(pd)
            sFlows = [(p+pp.supplyTxCost)*pp.supplyTxSpeed for p in pd]
            dFlows = [(p+pp.demandTxCost)*pp.demandTxSpeed for p in pd]
            sMag = np.sum(sFlows)
            dMag = np.sum(dFlows)
            if sMag > 0 and pp.supply > 0:
                #print(sFlows)
                sFlowsUnit = [pp.supply*i for i in sFlows]
                pp.supply -=np.sum(sFlowsUnit)
                #pp.supplyFlows -= np.sum(sFlowsUnit)
                #print(pp.location,pp.supply,sFlowsUnit)
                for ni,n in enumerate(neighbors):
                    #print(sFlows)
                    #n.supplyFlows += sFlowsUnit[ni]
                    n.supply +=sFlowsUnit[ni]
            if dMag > 0:
                dFlowsUnit = [pp.demand*i/dMag for i in dFlows]
                pp.demandFlows -= np.sum(sFlows)
                #add outgoing flows to neigbors
                for ni,n in enumerate(neighbors):
                    n.demandFlows += dFlowsUnit[ni]
            #subtract the sum of all outgoing flow
            
    def compute_flow_pid(self,):
        """
        compute the flow using a pid
        """
        for pp in self.terrainMap:
            neighbors = [[-1,0],[1,0],[0,-1],[0,1]]
            neighbors = [[pp.location[0]+n[0],pp.location[1]+n[1]] for n in neighbors if  self.size[0]>pp.location[0]+n[0]>0 and self.size[1]>pp.location[1]+n[1]>0]
            neighbors = [self.terrainMap[self.compute_index(i[0],i[1])] for i in neighbors]
            pd = [n.price-pp.price for n in neighbors]
            #print(pd)

            sFlows = [(p+pp.supplyTxCost)*pp.supplyTxSpeed for p in pd]
            dFlows = [(p+pp.demandTxCost)*pp.demandTxSpeed for p in pd]
            sMag = np.sum(sFlows)
            dMag = np.sum(dFlows)
            if sMag > 0 and pp.supply > 0:
                #print(sFlows)
                sFlowsUnit = [pp.supply*i for i in sFlows]
                pp.supply -=np.sum(sFlowsUnit)
                #pp.supplyFlows -= np.sum(sFlowsUnit)
                #print(pp.location,pp.supply,sFlowsUnit)
                for ni,n in enumerate(neighbors):
                    #print(sFlows)
                    #n.supplyFlows += sFlowsUnit[ni]
                    n.supply +=sFlowsUnit[ni]
            if dMag > 0:
                dFlowsUnit = [pp.demand*i/dMag for i in dFlows]
                pp.demandFlows -= np.sum(sFlows)
                #add outgoing flows to neigbors
                for ni,n in enumerate(neighbors):
                    n.demandFlows += dFlowsUnit[ni]
            #subtract the sum of all outgoing flow


    def update_pid(self,cn):
        cn
    
    def update(self,):
        """
        sum all flows and update the supply, demand, and price
        """
        for pp in self.terrainMap:
            #print(pp.location,pp.supplyFlows)
            pp.supply += pp.supplyFlows
            pp.supplyFlows = 0
            #pp.demand += pp.demandFlows
            #pp.demandFlows = 0
            pp.price = pp.product.sd_func(pp.supply,pp.demand)
            pp.supply = pp.supply-pp.consumption+pp.production
            #pp.demand += pp.consumption


def wtsum(s,d):
    return d-s
class plot3dAnim(object):
    def __init__(self,size):
        self.fig = plt.figure()
        self.ax = self.fig.add_subplot(111,projection = '3d')
        self.ax.set_zlim3d(-100,100)
        self.X,self.Y = np.meshgrid(range(size[0]),range(size[1]))
        self.ax.w_zaxis.set_major_locator(LinearLocator(10))
        self.ax.w_zaxis.set_major_formatter(FormatStrFormatter('%.03f'))

        heightR = np.zeros(self.X.shape)
        self.surf = self.ax.plot_surface(self.X,self.Y,heightR)
        

    def drawSurf(self, heightR):
        self.surf.remove()
        self.surf = self.ax.plot_surface(self.X,self.Y,heightR)
        plt.draw()
        time.sleep(1)


if __name__ == '__main__':
    matplotlib.interactive(True)
    p_water = Product(False,wtsum,1,0)
    tm = TerrainMap([10,10],p_water)
    print(np.shape(tm.terrainMap))
    tm.terrainMap[tm.compute_index(2,2)].production = 1
    tm.terrainMap[tm.compute_index(5,5)].consumption = 0
    fig = plt.figure()
    ax = fig.add_subplot(111,projection = '3d')
    X,Y = np.meshgrid(range(tm.size[0]),range(tm.size[1]))
    for i in range(10):
        tm.compute_flow()
        tm.update()
        p = np.array([pp.supply for pp in tm.terrainMap])
        print(np.sum(p))
        d = [pp.demand for pp in tm.terrainMap]
        pr = np.array([pp.price for pp in tm.terrainMap])
        #if i%10==0:
        ax.plot_surface(X,Y,p.reshape(tm.size[0],tm.size[1]))
        plt.draw()
        plt.pause(.01)
        ax.cla()
    tm.terrainMap[tm.compute_index(2,2)].production = 0 #turn off production
    for i in range(100):
        tm.compute_flow()
        tm.update()
        p = np.array([pp.supply for pp in tm.terrainMap])
        print(np.sum(p))
        d = [pp.demand for pp in tm.terrainMap]
        pr = np.array([pp.price for pp in tm.terrainMap])
        #if i%1==0:
        ax.plot_surface(X,Y,p.reshape(tm.size[0],tm.size[1]))
        plt.draw()
        plt.pause(.1)
        ax.cla()
