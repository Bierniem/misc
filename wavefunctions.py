import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.ticker import LinearLocator
import numpy as np
import time
import sys
import copy


class Sudoku:
    def __init__(self, field=np.zeros([9,9], dtype = int)):
        #make sudoku field
        self.field = field
        self.probs = np.ones([9,9,9], dtype = bool)
        self.probs_z_ind = np.zeros([9,9,9],dtype = int)
        self.resets = []
        for x,y,z in np.ndindex(self.probs.shape):
            self.probs_z_ind[x,y,z] = z+1
        self.lastIndex = None
        self.compute_probs()
        return

    def reset(self,):
        self.field = np.zeros([9,9], dtype = int)
        self.probs = np.ones([9,9,9], dtype = bool)
        self.resets = []

    def row_rule(self,index:tuple):
        #implement row rule
        kernel = np.zeros([9,9,9], dtype = bool)
        for x,y,z in np.ndindex(kernel.shape):
            kernel[x,y,z] = 0 if (z == self.field[index]-1 and x == index[0]) else 1
        return kernel

    def column_rule(self,index:tuple):
        #implement column rule
        kernel = np.zeros([9,9,9], dtype = bool)
        for x,y,z in np.ndindex(kernel.shape):
            kernel[x,y,z] = 0 if (z == self.field[index]-1 and y == index[1]) else 1
        return kernel

    def square_rule(self,index:tuple):
        #implement square rule
        kernel = np.zeros([9,9,9], dtype = bool)
        square = [i//3*3 for i in index]
        for x,y,z in np.ndindex(kernel.shape):
            kernel[x,y,z] = 0 if (z == self.field[index]-1 and x//3*3 == square[0] and y//3*3 == square[1]) else 1
        return kernel

    def increment_probs(self,index:tuple):
        #like compute probs but only do the computations for the field element at index
        if self.field[index] != 0:
            self.probs &= self.row_rule(index)
            self.probs &= self.column_rule(index)
            self.probs &= self.square_rule(index)
        return

    def compute_probs(self,):
        for x,y in np.ndindex(self.field.shape):
            if self.field[(x,y)] != 0:
                self.probs &= self.row_rule((x,y))
                self.probs &= self.column_rule((x,y))
                self.probs &= self.square_rule((x,y))
        return

    def step(self,):
        if not isinstance(self.lastIndex,(type(None))): #set lastIndex to None to skip the increment probs
            self.increment_probs(self.lastIndex)
            #self.compute_probs()
        if np.sum(self.field != 0) == 81:
            #print('done')
            return 0
        threshprobs = np.sum(self.probs,axis=2) #sum the probablities along the z axis
        threshprobs = threshprobs * (self.field == 0) #only include elements that have not been set
        #find min of threshprobs
        #if min < 1 failure
        if np.sum(threshprobs + self.field == 0) > 0:
            #there is at least one unsolved field with no allowable entries
            self.retry()
            return 1
        #if min == 1 all fields with threshprobs == 1
        #known = threshprobs == 1
        #known = known[...,np.newaxis]
        #known = np.broadcast_to(known,self.probs.shape)
        #known = known * self.probs
        #known = known * self.probs_z_ind
        #known = np.sum(known,axis=2)

        knownIndexes = ([i for i in np.ndindex(self.field.shape) if threshprobs[i] == 1])
        if len(knownIndexes)>0:
            self.lastIndex = knownIndexes[np.random.randint(len(knownIndexes))]
            val = (self.probs_z_ind*self.probs)[self.lastIndex]
            val = val[val!=0][0]
            #print(self.lastIndex)
            #print(val)
            #print(self.field.T)
            self.field[self.lastIndex] = val
            return 1
        #set the known cells

        #if min > 1 guess on 1 of the min
        #print(threshprobs.T)
        minThresh = np.min([threshprobs[i] for i in np.ndindex(threshprobs.shape) if threshprobs[i] > 0])
        minIndexes = ([i for i in np.ndindex(self.field.shape) if threshprobs[i] == minThresh])
        self.lastIndex = minIndexes[np.random.randint(len(minIndexes))]
        randVal = (self.probs_z_ind*self.probs)[self.lastIndex]
        randVal = [i for i in randVal if i != 0]
        for i in randVal:
            #save the other guesses so we can go back if we get stuck
            self.field[self.lastIndex] = i    
            self.resets += [(copy.deepcopy(self.field),copy.deepcopy(self.probs),copy.deepcopy(self.lastIndex))]
            #print(self.field.T)
            self.field[self.lastIndex] = 0
        self.retry()
        #print('----------------')
        #print(self.field.T)
        return 1
        #random guess

    def retry(self,):
        self.field,self.probs,self.lastIndex = self.resets.pop()
        #print('_____________________________________')
        #print('n resets',len(self.resets))
        return

class MakeSudoku(Sudoku):
    def __init__(self,endState):
        super().__init__(endState)
        self.endState = endState
        self.compute_probs()
        return

    def step_back(self,):
        #remove one element such that the # of possible solutions remains 1
        #get random filled element index
        #
        return

        


def neighbors(field):
    #return a field of equal size to input field but with number of non zero neighbors per cell
    neighbors = np.zeros(field.shape)
    for i in np.ndindex(field.shape):
        ns = [j + l for j in i for l in [-1,0,1]]
        print(i,ns)
        #neighbors[i] = sum(field[j[0]+1] for j in [] for ])

def wavefunc_mountain(dims,maxval):
    #generate a terrain by wavefunction collapse
    field = np.zeros([dims,dims])
    #choose a random point to set
    field[np.random.randint(dims),np.random.randint(dims)] = np.random.randint(maxval-1)+1
    for i in range(1,dims*dims):
    #find the point with the minimum allowable states
        minstates = 0
    #set the next point

def plot_surface(field):
    #plot a field as a surface
    fig, ax = plt.subplots(subplot_kw={"projection": "3d"})

    # Make data.
    X = range(field.shape[1])
    Y = range(field.shape[0])
    X, Y = np.meshgrid(X, Y)
    Z = field
    print(X)

    # Plot the surface.
    surf = ax.plot_surface(X, Y, Z, cmap=cm.coolwarm,
                        linewidth=0, antialiased=False)

    # Customize the z axis.
    #ax.set_zlim(-1.01, 1.01)
    ax.zaxis.set_major_locator(LinearLocator(10))
    # A StrMethodFormatter is used automatically
    ax.zaxis.set_major_formatter('{x:.02f}')

    # Add a color bar which maps values to colors.
    fig.colorbar(surf, shrink=0.5, aspect=5)

    plt.show()


def test_convolve():
    #neighbors(np.zeros((2,3)))
    a = np.arange(15).reshape((3,-1))
    aInd = np.ndindex(a.shape)
    kernel = np.array([[0,1,0],[1,0,1],[0,1,0]])
    #make kernel square
    aorigshape = a.shape
    kernelShift = int((kernel.shape[0]-1)/2)
    a=np.pad(a,kernelShift)
    print(a)
    b = np.zeros(a.shape)
    for i,j in np.ndindex(aorigshape):
        im = i+kernelShift
        jm = j+kernelShift
        print(a[im - kernelShift : im + kernelShift,jm - kernelShift : jm + kernelShift])
        b[im - kernelShift : im + kernelShift, jm - kernelShift : jm + kernelShift] += a[im - kernelShift : im + kernelShift, jm - kernelShift : jm + kernelShift]
    print(b)
    plot_surface(b)
    return

if __name__ == '__main__':
    sud = Sudoku()
    count = 0
    r = 1
    sud.reset()
    sud.field[np.random.randint(9),np.random.randint(9)] = np.random.randint(1,9)
    sud.compute_probs()
    while True: 
        if r == -1:
            break
        elif r == 0:
            count+=1
            print(count)
            print(sud.field.T)
            if np.sum(sud.field) != 405:
                print('sum != 405')
                break
            sud.reset()
            sud.field[np.random.randint(9),np.random.randint(9)] = np.random.randint(1,9)
            sud.compute_probs()
        r = sud.step()
        


