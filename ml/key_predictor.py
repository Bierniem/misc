import torch
import numpy as np
import os
from torch import nn
from torch.utils.data import Dataset, DataLoader
from torchvision.transforms import ToTensor, Lambda
from torchvision.transforms.functional import resize
from torchvision.io import read_image, decode_image
from PIL import Image
import matplotlib.pyplot as plt
import pickle
import mouse
import keyboard
import datetime
import cv2
import pydirectinput
import keylog


"""
first stage is just to predict keys and figure out the tools some

then try to train up a model that gets keys from video with no prediction
    this would allow me to train the next version on just recorded video

then try to train up a model that predicts next key from video, this one needs some memory somewhere, maybe lstm 

then maybe try to mess around with dreamer or something...
or maybe try to come up with a continuous value state so that i can try reinforcement learning, health + stamina + collected item/s + ...

"""



def compress_keys(period,inputF,outputF):
    #generate a new key file from an old keyfile

    #for each period get only the final mouse position
    #change the action times to be periodic so that any actions that occur in the same period have the same time
    with open(inputF,'r') as fid:
        keys = [i.strip().split(',') for i in fid.readlines()]

    times = [int(float(i[-1])/period) for i in keys if len(i)==4]
    tks = [i * period for i in range(min(times),max(times))]
    with open(outputF,'w') as fid:
        for t in tks:
            nks = [i for i in keys if (t <= float(i[-1])<t+period)]
            keys = [i for i in keys if not (t <= float(i[-1])<t+period)]
            #remove all but the final mouse position
            mm = [n for n,i in enumerate(nks) if i[0] == '0']
            mms = [i for n,i in enumerate(nks) if n in mm] #mouse movements
            nks = [i for n,i in enumerate(nks) if n not in mm ] #not mouse movements
            #nks = [i for i in nks]   #change the times to t
            if len(mms)>0:
                mmouse = [float(i[-1]) for i in mms].index(max([float(i[-1]) for i in mms]))
                mms = mms[mmouse]
                mms[-1] = t
                mms = [str(i) for i in mms]
                #print('mms',mms)
                fid.write(','.join(mms)+'\n')
            if len(nks)>0:
                nks = [i[:-1]+[t] for i in nks]
                nks = [[str(i) for i in j] for j in nks]
                #print('nks',nks)
                fid.write('\n'.join([','.join([i for i in j]) for j in nks]) + '\n')
            
    return


def sync_video_keys(videoFile,keysFile,outputDir):
    #try to sync video and keys.... they should actually be synced...
    #automatically align to the nearest second and then scroll through the frames one at a time
    cap = cv2.VideoCapture(videoFile)
    fps = cap.get(cv2.CAP_PROP_FPS)
    videoST = os.path.getctime(videoFile)
    with open(keysFile,'r') as fid:
        keys = [i.strip().split(',') for i in fid.readlines()]
    kts = [float(i[-1]) for i in keys]
    fts = [float(videoST) + float(i)/fps for i in range(int(cap.get(cv2.CAP_PROP_FRAME_COUNT)))]
    
    print('kts',min(kts),max(kts))
    print('fts',min(fts),max(fts))
    fc = 0
    imgBuf = []
    buflen = 3
    keyactive = False
    while True:
        ret, image = cap.read()
        if ret:
            fc += 1
            if fc%3 == 0: #decimate by 3...
                fid = os.path.join(outputDir,'frame_'+str(fts[fc])+'.jpg')
                cv2.imwrite(fid,image)
            """imgBuf.append(image)
            if len(imgBuf) > buflen:
                imgBuf.pop(0)
            else:
                #cannot work if buffer is not full
                continue
            if max(kts) < fts[fc - buflen] or fts[fc-buflen] < min(kts):
                #skip frames with no keylog
                continue
            #print(fts[:5])
            #ft = [fts[fc-buflen], fts[fc-buflen+1]]
            #know = [keys[kts.index(i)] for i in kts if ft[0]<i<ft[1]] #get the keys in the first frame of the buffer
            #print(know)
            #cv2.imshow('w',image)
            #cv2.waitKey(0)

            #if len(know) > 0: #there are keypresses in the frame
                #print(know)
                #cv2.imshow('w',image)
                #cv2.waitKey(0)

                #save frames and keys
                for n,i in enumerate(imgBuf):
                    fid = os.path.join(outputDir,'frame_'+str(fts[fc-buflen+n])+'.jpg')
                    try:
                        cv2.imwrite(fid,i)
                    except:
                        #file already exists
                        continue
            """
        else:
            break
    cap.release()
    cv2.destroyAllWindows()
    return

def combinekeys():
    ck = []
    for f in os.listdir('keylogs'):
        with open(os.path.join('keylogs',f),'rb') as fid:
            data = pickle.load(fid)
            data = [control_to_ints(d) for d in data]
            print(min([d[-1] for d in data]), max([d[-1] for d in data]))
            data = [[data[i][:-1] + [int(10000*(data[i][-1] - data[i-1][-1]))]] for i in range(1,len(data))]    #convert time to delays between
            ck += data
            #print(data)
    with open('keyfile.pkl','wb') as lD:
        pickle.dump(ck,lD)


class TKDataVectors(Dataset):
    def __init__(self, imagesDir, keysFile, ttIndex, device):
        print('TKDataVectors.__init__')
        with open(keysFile,'r') as fid:
            self.keys = [i.strip().split(',') for i in fid.readlines()]
        self.kts = [float(i[-1]) for i in self.keys]
        self.imgs = os.listdir(imagesDir)
        self.imagesDir = imagesDir
        self.ttIndex = ttIndex
        self.device = device
        self.screens = [i for i in self.imgs]
        #print(self.screens[:10])
        self.screensT = [float(i.split('_')[1][:-4]) for i in self.screens]
        self.buflen = 10

        #print(len(self.screens))
        #print(len(self.screensT))

        ssc = np.argsort(self.screensT)
        self.screens = [self.screens[i] for i in ssc]
        self.screensT = [self.screensT[i] for i in ssc]

    def __len__(self):
        print('TKDataVectors.__len__')
        return len(self.ttIndex)

    def __getitem__(self, idx):
        print('TKDataVectors.__getitem__')
        keyp = self.keys[self.ttIndex[idx]-10:self.ttIndex[idx]] #previous 10 keys and next keys
        keyn = self.keys[self.ttIndex[idx]:self.ttIndex[idx]+10] #previous 10 keys and next keys
        keyTime = float(keyn[0][-1])
        keyn = [i[:-1]+[float(i[-1]) - keyTime] for i in keyn] #convert to time from now
        keyp = [i[:-1]+[float(i[-1]) - keyTime] for i in keyp]
        #remove duplicate key kinds 
        ddkey = []
        ddck = []
        for i in keyn:
            if i[0] in ddck:
                continue
            else:
                ddkey.append(i)
                ddck.append(i[0])
        #sortk ddck on kind
        ddcks = np.argsort([i[0] for i in ddkey])
        keyn = [ddkey[i] for i in ddcks]

        mt = self.screensT.index([i for i in self.screensT if i < keyTime][-1])
        aScreens = self.screens[mt-self.buflen+1:mt+1]
        if len(aScreens) < self.buflen:
            print('error missing frames in ',aScreens, ' for key ', key)
            #for i in self.imgs:
                #print(float(''.join(i.split('_')[-1].split('.')[:2])))
        #print(aScreens)
        aScreens = [resize(read_image(os.path.join(self.imagesDir,i)),[216,384])  for i in aScreens]
        keyp = [[float(j) for j in i[:-1]] for i in keyp]
        keyZ = [[0,0,0] for i in range(4)]
        for i in keyn:
            keyZ[int(i[0])] = [float(j) for j in i[1:]]
        keyn = flatten(keyZ)
        #print(keyn)
        #print(screens[0])
        #print(len(aScreens),len(keyp),len(keyn))
        img = torch.from_numpy(np.concatenate(aScreens)).to(self.device)
        #print(img.shape())
        keyp = torch.from_numpy(np.array(keyp)).float().to(self.device)
        keyn = torch.from_numpy(np.array(keyn)).float().to(self.device)
        #print('...',keyX)
        
        sample = [img,keyp,keyn]
        #print(screens[0].size(),len(sample[0][0][0]))
        return sample    

def computeSize(size,kernel,pad,stride):
    return(((size-kernel+2*pad)/stride) +1)

class ExplicitMemConvnet(nn.Module):
    def __init__(self):
        print('ExplicitMemConvnet.__init__')
        super(ExplicitMemConvnet, self).__init__()
        #define input screen size
        screenSize = [216,384]
        kernelSize = 9
        stride = 3
        padding = 3
 
        #measure accuracy for each key type separate from key accuracy?
        #use longer and variable length streams to train/test

        #compute modification to screen size from convlayer.
        for i in range(len(screenSize)):
            screenSize[i] = int(computeSize(screenSize[i],kernelSize,padding,stride))
            screenSize[i] = int(computeSize(screenSize[i],kernelSize,padding,stride))
            screenSize[i] = int(computeSize(screenSize[i],2,0,2))

        print('instantiating memory')
        self.screenSize = screenSize
        self.memory = [[0 for j in range(4)] for i in range(10)] #10 memory slots for screens and for keys
        #self.memory = [[[0 for j in range(screenSize[0]*screenSize[1])] for i in range(10)],[[0 for j in range(4)] for i in range(10)]] #10 memory slots for screens and for keys
        newScreenSize = screenSize[0] * screenSize[1] * 50
        memorySize = sum([len(flatten(i)) for i in self.memory])

        self.convLayers = nn.Sequential(
            nn.Conv2d(30, 50, kernel_size = kernelSize, stride = stride, padding = padding),
            nn.ReLU(),
            #nn.MaxPool2d(kernel_size = 2, stride = 2),
            nn.Conv2d(50,50, kernel_size = kernelSize, stride = stride, padding = padding),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size = 2, stride = 2),
            #self.norm = nn.BatchNorm1d(ysize*xsize*50)
        )
        self.layer2 = nn.Sequential(
            #add the explicit memory back in now

            nn.Linear(memorySize, 3000),
            nn.Linear(3000,3000),
            nn.Linear(3000,3000),
            nn.Linear(3000,3000),
            nn.Linear(3000,16),
        )
    def forward(self,xv,kp,xp = False):
        print('ExplicitMemConvnet.forwardLoop')

        kn = self.layer2(xp+kp)
        return kn

    def forwardcon(self,x):
        print('ExplicitMemConvnet.forwardcon')
        #x = self.flatten(x)
        x = x.float()
        x = self.convLayers(x)
        x = x.reshape(x.size(0),-1)
        return x


class KeyConvNet(nn.Module):
    def __init__(self):
        super(KeyConvNet, self).__init__()
        ysize = 108
        xsize = 192
        kernelSize=9
        stride = 3
        padding = 3
        nk = 10

        ysize = int(self.computeSize(ysize,kernelSize,padding,stride))
        ysize = int(self.computeSize(ysize,2,0,2))
        #ysize = int(self.computeSize(ysize,kernelSize,padding,stride))
        #ysize = int(self.computeSize(ysize,2,0,2))
        
        
        xsize = int(self.computeSize(xsize,kernelSize,padding,stride))
        xsize = int(self.computeSize(xsize,2,0,2))
        #xsize = int(self.computeSize(xsize,kernelSize,padding,stride))
        #xsize = int(self.computeSize(xsize,2,0,2))

        self.layer1 = nn.Sequential(
            nn.Conv2d(9, 50, kernel_size=kernelSize, stride=stride, padding=padding),
            nn.ReLU(),
            nn.MaxPool2d(kernel_size=2, stride=2)
        )
        #self.layer2 = nn.Sequential(
        #    nn.Conv2d(50, 50, kernel_size=kernelSize, stride=stride, padding=padding),
        #    nn.ReLU()
        #    #nn.MaxPool2d(kernel_size=2, stride=2)
        #)
        #self.drop_out = nn.Dropout() 
        #print('size of norm', ysize, xsize, 50)
        self.norm = nn.BatchNorm1d(28800)
        #print(xsize *ysize * 50 +nk *4 +200)
        #self.fc1 = nn.Linear(115434, 2000)
        self.fc1 = nn.Linear(29160,2000)
        self.fc2 = nn.Linear(2000,2000)
        self.fc3 = nn.Linear(2000, 2000)
        self.fc3 = nn.Linear(2000, 1016)
        self.flatten = nn.Flatten()
    def computeSize(self,sin,f,p,s):
        return(((sin-f+2*p)/s) +1)
    def forward(self,x,k,z):
        #x = self.flatten(x)
        x = x.float()
        #print(x.size())
        x = self.layer1(x)
        #x = self.layer2(x)
        #print(x.size())
        x = x.reshape(x.size(0),-1)
        k = k.reshape(k.size(0),-1)
        z = z.reshape(z.size(0),-1)
        
        #print(x.size())
        #print(k.size())
        #print(k)
        #removed for use
        #x = self.norm(x)

        #print(len(x),len(x[0]),len(x[0][0]))
        #print(x.size())
        x = torch.cat((x,k),1)
        #print(x.size())
        x = torch.cat((x,z),1)
        #print(x.size())
        x = self.fc1(x)
        x = self.fc2(x)
        x = self.fc3(x)
        return x


class TKData(Dataset):
    def __init__(self, imagesDir, keysFile, ttIndex, device):
        self.buflen = 3
        with open(keysFile,'r') as fid:
            self.keys = [i.strip().split(',') for i in fid.readlines()]
        self.kts = [float(i[-1]) for i in self.keys]
        self.imgs = os.listdir(imagesDir)
        self.imagesDir = imagesDir
        self.ttIndex = ttIndex
        self.device = device
        self.screens = [i for i in self.imgs]
        #print(self.screens[:10])
        self.screensT = [float(i.split('_')[1][:-4]) for i in self.screens]

        #print(len(self.screens))
        #print(len(self.screensT))

        ssc = np.argsort(self.screensT)
        self.screens = [self.screens[i] for i in ssc]
        self.screensT = [self.screensT[i] for i in ssc]
        self.last = [0,0,0,0,0]

    def __len__(self):
        return len(self.ttIndex)

    def __getitem__(self, idx):
        keyp = self.keys[self.ttIndex[idx]-40:self.ttIndex[idx]] #previous 10 keys and next keys
        if len(keyp) != 40:
            print(idx)
            print(self.ttIndex[idx])
            print(self.keys[self.ttIndex[idx]])
            print(self.keys[self.ttIndex[idx]-40])
            print('1',keyp)
        keyn = self.keys[self.ttIndex[idx]:self.ttIndex[idx]+40] #previous 10 keys and next keys
        keyTime = float(keyn[0][-1])
        keyn = [i[:-1]+[float(i[-1]) - keyTime] for i in keyn] #convert to time from now
        keyp = [i[:-1]+[float(i[-1]) - keyTime] for i in keyp]
        #remove duplicate key kinds 
        ddkey = []
        ddck = []
        for i in keyn:
            if i[0] in ddck:
                continue
            else:
                ddkey.append(i)
                ddck.append(i[0])
        #sortk ddck on kind
        ddcks = np.argsort([i[0] for i in ddkey])
        keyn = [ddkey[i] for i in ddcks]

        keyp = [[float(j) for j in i] for i in keyp]
        
        keyp = flatten(keyp)
        if len(keyp) != 160:
            print('4',keyp)
        keyZ = [[0,0,0,0] for i in range(4)]
        for i in keyn:
            keyZ[int(i[0])] = [float(j) for j in i]
        keyn = flatten(keyZ)

        keyp = torch.from_numpy(np.array(keyp)).float().to(self.device)
        keyn = torch.from_numpy(np.array(keyn)).float().to(self.device)
        #print('keyn',keyn)

        mt = self.screensT.index([i for i in self.screensT if i < keyTime][-1])
        aScreens = self.screens[mt-self.buflen:mt]
        if len(aScreens) < self.buflen:
            print('error missing frames in ',aScreens, ' for key ', key)
            #for i in self.imgs:
                #print(float(''.join(i.split('_')[-1].split('.')[:2])))
        #print(aScreens)
        aScreens = [resize(read_image(os.path.join(self.imagesDir,i)),[108,192])  for i in aScreens]
        """
        print(type(aScreens))
        print(type(aScreens[0]))
        print(type(aScreens[0][0]))
        print(type(aScreens[0][0][0]))
        print(type(aScreens[0][0][0][0]))
        print(aScreens[0])
        """

        img = torch.from_numpy(np.concatenate(aScreens)).to(self.device)
        #print(img.size())
 
        z = torch.from_numpy(np.zeros(200)).float().to(self.device)

        #print('...',keyX)
        
        sample = [img,keyp,keyn,z,self.ttIndex[idx]]
        nlast = [len(img),len(keyp),len(keyn),len(z),1]
        if nlast != self.last:
            print(self.last, nlast, idx)
            self.last = nlast
        #print(screens[0].size(),len(sample[0][0][0]))
        return sample

        
def flatten(ll):
    return [e for l in ll for e in l]

def sort_solutions(keysFile,imageFolder):
    #run all the cases through a model and sort them by accuracy
    """takes images and keys and trains a key identifier"""
    trainTT = []
    loss = []
    device = 'cpu'
    
    with open(keysFile,'r') as fid:
        keys = [i.strip().split(',') for i in fid.readlines()]
    for i in range(40,len(keys)-40):
        trainTT.append(i)
        loss.append(0)

    trainDataset = TKData(imageFolder, keysFile, trainTT, device)

    trainDataloader = DataLoader(trainDataset, batch_size=1, shuffle=True)

    #model = ExplicitMemConvnet().to(device)
    model = KeyConvNet().to(device)
    model.load_state_dict(torch.load('best.pt'))
    loss_fn = nn.L1Loss()
    optimizer = torch.optim.AdamW(model.parameters(), lr = 1e-3)
    epochs = 20
    bestPct = 10000000000000000
    #for ep in range(epochs):
        #train
    loss = []
    losIdx = []
    losOut = []
    #count = 0
    with torch.no_grad():
        for batch, (x,k,y,z,idx) in enumerate(trainDataloader):
            #count+=1
            #if count == 1000:
            #    break
            #print(x)
            #print(y)
            pred = model(x,k,z)
            pred = pred.narrow(1,0,16)
            loss.append(np.abs(loss_fn(pred,y).squeeze(0).numpy()))
            losIdx.append(int(idx.squeeze(0).numpy()))
            #print(loss[idx.squeeze(0)])

    #sort losses
    #lossIndex = np.argsort(loss)
    #losIdx = [losIdx[i] for i in lossIndex]
    #print('lenbefore',len(lossIndex))
    print('best',min(loss))
    print('worst',max(loss))
    losOut = np.random.choice(losIdx,60000,p=[i/sum(loss) for i in loss])
    """for n,i in enumerate(losIdx):
        if np.random.randint(10) < n/len(losIdx)*10:
            losOut.append(i)
    """
    #print('lenafter',len(losOut))
    #print(losOut)
    return losOut


def train_key_id(keysFile,imageFolder,pctTrain,tt = []):
    """takes images and keys and trains a key identifier"""
    trainTT = []
    testTT = []
    device = 'cuda'
    with open(keysFile,'r') as fid:
        keys = [i.strip().split(',') for i in fid.readlines()]
    if len(tt) == 0:
        for i in range(40,len(keys)-40):
            if np.random.randint(100) < pctTrain:
                trainTT.append(i)
                #print(trainTT)
            else:
                testTT.append(i)
    else:
        for i in tt:
            if np.random.randint(100) < pctTrain:
                trainTT.append(i)
                #print(trainTT)
            else:
                testTT.append(i)

    trainDataset = TKData(imageFolder, keysFile, trainTT, device)
    testDataset = TKData(imageFolder, keysFile, testTT, device)

    trainDataloader = DataLoader(trainDataset, batch_size=200, shuffle=True)
    testDataloader = DataLoader(testDataset, batch_size=200, shuffle=True)

    #model = ExplicitMemConvnet().to(device)
    model = KeyConvNet().to(device)
    model.load_state_dict(torch.load('best.pt'))
    loss_fn = nn.L1Loss()
    optimizer = torch.optim.AdamW(model.parameters(), lr = 1e-3)
    epochs = 3
    bestPct = 10000000000000000
    #while True:
    for ep in range(epochs):
        #train
        for batch, (x,k,y,z,idx) in enumerate(trainDataloader):
            #print(x)
            #print(y)
            pred = model(x,k,z)
            pred = pred.narrow(1,0,16)
            loss = loss_fn(pred,y)

            optimizer.zero_grad()
            loss.backward()
            optimizer.step()

            if batch % 100 == 0:
                loss, current = loss.item(), batch * len(x)
                print("loss: ", loss, current)
        #test
        size = len(testDataloader.dataset)
        model.eval()
        test_loss, correct = 0, 0

        correctpct=[0 for i in range(12)]
        with torch.no_grad():
            for x,k,y,z,idx in testDataloader:
                #x,y = x.to(device), y.to(device)
                pred = model(x,k,z)
                pred = pred.narrow(1,0,16)
                test_loss += loss_fn(pred, y).item()
                #typepred = [[p[i] for i in [0,3,6,9]].index(max([p[i] for i in [0,3,6,9]]))for p in pred]
                #typeK = [[p[i] for i in [0,3,6,9]].index(max([p[i] for i in [0,3,6,9]]))for p in y]
                #print(correctpct)
                #print(pred.size)
                #print(y.size)
                y = y.to('cpu')
                pred = pred.to('cpu')
                pred = pred.reshape(pred.size(0),-1)
                y = y.reshape(y.size(0),-1)
                correcteach = [0 for i in range(16)]
                for i in range(len(pred)):
                    correctpct += pred[i] - y[i]
                    correcteach[i%16] += pred[i%16] - y[i%16]

                    #print('pred',pred) 
                    #print('y',y)
                #correct += (pred.argmax(1) == y).type(torch.float).sum().item()
        #test_loss /= size
        #correct /= size
        #print("test error: ", 100*correct)
        print("test result", np.mean(correctpct))

        if np.mean(correctpct)<bestPct:
            bestPct = np.mean(correctpct)
            torch.save(model.state_dict(),'best.pt')
        
        torch.save(model.state_dict(),'last.pt')


def run_model():
    device = 'cpu'
    model = KeyConvNet().to(device)
    model.load_state_dict(torch.load('best.pt'))

    #connect video stream to frame buffer
    stream = cv2.VideoCapture('udp://@127.0.0.1:9999')
    fps = stream.get(cv2.CAP_PROP_FPS)
    if not stream.isOpened():
        print("could not open stream")
    #connect keyboard and mouse to output

    #connect loopback

    #run
    loopback = [0 for i in range(200)]
    keysHistory = [0 for i in range(40*4)]
    keysFuture = []
    keySchedule = []
    aScreens = []
    tform = ToTensor()
    while True:
        ret, image = stream.read()
        if not ret:
            continue
        #cv2.imshow('raw',image)
        #cv2.waitKey(0)
        imgFile = os.path.join('tmp.png')
        cv2.imwrite(imgFile,image)

        aScreens+=[resize(read_image(imgFile),[108,192])]

        """
        print(type(aScreens))
        print(type(aScreens[0]))
        print(type(aScreens[0][0]))
        print(type(aScreens[0][0][0]))
        print(type(aScreens[0][0][0][0]))
        print(aScreens[0])
        """

        if len(aScreens) > 3:
            aScreens.pop(0)
        if len(aScreens) < 3:
            continue
        img = torch.from_numpy(np.concatenate(aScreens)).float().to(device)
        #print(img.size())
        keyp = torch.from_numpy(np.array(keysHistory[-40*4:])).float().to(device)
        loopback = torch.from_numpy(np.array(loopback)).float().to(device)
        newKeys = model(img.unsqueeze(0),keyp.unsqueeze(0),loopback.unsqueeze(0))
        newKeys = newKeys.narrow(1,0,16).reshape((4,4)).tolist()
        #loopback = newkeys[12:] #this ist't set up yet 
        #print(newKeys)
        newKeys = [[i]+newKeys[i] for i in range(4)]
        #keysHistory = [keysHistory[i:i+4] for i in range(0,len(keysHistory),4)]
        newKeys = [i for i in newKeys if 10 > i[-1] > 0] #only schedule future keys up to 10s
        #print(newKeys)
        newKeys = [i for i in newKeys if i[0] != 2]# or i[2] !=0] #remove mouse wheel
        newKeys = [i for i in newKeys if i[0] != 3 or i[2] != 1] #remove mouse wheel
        keysFuture += newKeys
        #print(keysFuture)
        nkeyind = [n for n,i in enumerate(keysFuture) if 0 < i[-1] <=.1] #get indexes of keys in the next frame
        if len(nkeyind) < 0:
            #print('no nkeys')
            continue
        nkeys = [keysFuture[i] for i in nkeyind] #make a new key list
        keysHistory += flatten(nkeys) #add pressed keys to keys history
        keysFuture = [i for n,i in enumerate(keysFuture) if n not in nkeyind]
        #send new keys
        #print(keysHistory)
        #print(keysFuture)
        keysFuture = [[i[0],i[1],i[2],i[3]-.1] for i in keysFuture] #add frame time to future keys
        keysHistory = flatten([keysHistory[i:i+3]+[keysHistory[i+3] - .1] for i in range(0,len(keysHistory)-3,4)]) #add frame time to old keys
        for k in nkeys:
            k = [int(i) for i in k]
            #print('key',k)
            if k[0] == 0: #mousemove
                print('mouse move',k[1],k[2])
                #mouse.move(k[1],k[2])
                pydirectinput.moveTo(k[1],k[2])

            elif k[0] == 1: #mouse button
                k[2] = ['left','right','middle'][k[2]]
                print('mouse button ',k[2])
                if k[1] == 0:
                    if mouse.is_pressed(k[2]):
                        mouse.release(k[2])
                    else:
                        mouse.click(k[2])
                elif k[1] == 1:
                    if not mouse.is_pressed(k[2]):
                        mouse.press(k[2])
                    else:
                         mouse.click(k[2])
                elif k[1] == 2:
                    mouse.double_click(k[2])

            elif k[0] == 2:
                mouse.wheel(k[2])
                #print('mouse wheel ',k[2])

            elif k[0] == 3: #keyboard
                print('keyboard ',k[2])
                if k[1] == 0:
                    if keyboard.is_pressed(k[2]):
                        keyboard.release(k[2])
                    else:
                        keyboard.send(k[2])
                elif k[1] == 1:
                    if not keyboard.is_pressed(k[2]):
                        keyboard.press(k[2])
                    else:
                        keyboard.send(k[2])
                elif k[1] == 3:
                    keyboard.send(k[2])  

if __name__ == '__main__':
    #train_key_prediction()
    #sync_video_keys("C:\\Users\\ben titzer\\Videos\\2021-03-09 19-09-03.mkv","C:\\Users\\ben titzer\\Documents\\code\\ml\\data-3-10-21\\keyfile.txt",'data-3-10-21\\images')
    #compress_keys(.1,'data-3-10-21\\keyfile.txt','data-3-10-21\\keyfileCompressed.txt')
    #train_key_id('data-3-10-21\\keyfileCompressed.txt','data-3-10-21\\images',80)
    
    #tt = []
    #train_key_id('data-3-10-21\\keyfileCompressed.txt','data-3-10-21\\images',80,tt)
    #while True:
    #    tt =sort_solutions('data-3-10-21\\keyfileCompressed.txt','data-3-10-21\\images')
    #    train_key_id('data-3-10-21\\keyfileCompressed.txt','data-3-10-21\\images',80,tt)

    run_model()

    """
    try it on compressed images with deeper lookback? or higher effective resolution
    try it with larger loopback

    connect it to video stream
    write my own bp for "on the job training"
    """