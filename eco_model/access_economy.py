#agent based
"""
foxes
eat chickens
make more foxes
travel towards chickens
have limited lifespan
die without chickens

chickens
make more chickens
travel towards chickens
travel away from foxes
have limited lifepan
die with foxes
"""

import numpy as np

class Agent():
    def __init__(self,location:int,world:World):
        self.age = 0
        self.hunger = 0
        self.sight = 0
        self.visibility = 0
        self.speed = 0
        self.speedP = 0
        self.speedI = 0
        self.speedD = 0
        self.sex = 0
        self.location = location
        self.world = world

    def see(self,):
        return
    def turn(self,):
        return
    def move(self,):
        self.desiredSpeed = 
        self.speed = 
        self.speedMod = pid()
        return

class World():
    def __init__(self,dimensions):
        #create world
        self.locations = [[] for i in range(np.prod(dimensions))] #record things at each location


class Fox():
    def __init__(self,location):
        self.age = 0
        self.hunger = 0
        self.sight = 2
        self.speed = 1
        self.sex = np.random.randn(1)
        self.location = location

    def _mate(self):



def update(a:Agent):


