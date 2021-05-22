import numpy as np
import cv2
import pytesseract
import os
import jellyfish
import shutil
import pickle
import math
pytesseract.pytesseract.tesseract_cmd = r'C:\\Program Files\\Tesseract-OCR\\tesseract.exe'

banlist = [' ','"=}','"|','\\',]
class TessWrap:
    def __init__(self,outFolder):
        self.trainingDir = outFolder
        self.dictionary = {} #string:occurances
        self.text_lag_buffer = []
        self.numImg = 0
        self.imageFolder = os.path.join(self.trainingDir,'images')
        self.labelFolder = os.path.join(self.trainingDir,'labels')
        


    def clear_output(self):
        try:
            shutil.rmtree(self.imageFolder)
        except:
            pass
        try:
            shutil.rmtree(self.labelFolder)
        except:
            pass
        os.mkdir(self.imageFolder)
        os.mkdir(self.labelFolder)
        return

    def self_generating_dictionary(self,txtfile):
        '''
            from an array of text inputs remove text inputs that occur below a thresholded number of times
        '''
        with open(txtfile,'r') as f:
            tList = [i.strip() for i in f.readlines()]
        for i in tList:
            if i in self.dictionary.keys():
                self.dictionary[i] += 1
            else:
                self.dictionary[i] = 0
        print(self.dictionary)

        return 

    def crop_frame(self):
        '''
            crop the frame into smaller sub images
            the center most sub image will probably be the most important most of the time
            but I might try to have a sub image that specifically centers on the cursor
            when the cursor is visible
        '''
        return

    def nearest_dictionary_word(self,inputStr):
        '''
            map the input string to the nearest dictionary word
        '''
        return

    def text_persistence(self,inputStr):
        '''
            text is displayed for multiple sequential frames
            implement a low pass filter to remove noise
        '''
        inputStr = inputStr.split(' ')
        wc = [sum([w in lag for lag in self.text_lag_buffer]) for w in inputStr]
        print(inputStr)
        print(wc)
        self.text_lag_buffer.append(inputStr)
        self.text_lag_buffer.pop(-1)
        return 

    def get_label(self,image):
        labels = []
        label = []
        for colorchannel in range(3):
            #frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            frame = image
            #cv2.imshow('image',image)
            frame = frame[:,:,colorchannel]
            #print(framecolor.shape)
            #print(frame.shape)
            #cv2.imshow('wat',frame)
            #channel = cv2.medianBlur(channel,3)
            ret,frame = cv2.threshold(frame,150,255,cv2.THRESH_BINARY)
            #channel = cv2.adaptiveThreshold(channel,255,cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY,51,2)
            try:
                frame = 255 - frame
            except TypeError:
                #sometimes the image is empty but still says it has length
                continue
            new_text = pytesseract.image_to_string(frame, lang = 'eng').replace('\n','')[:-1]
            #remove special characters and numbers
            new_text = ''.join([i for i in new_text if i.isalnum()])
            #remove 'x2' type things for stacked items
            if len(new_text)>1:
                if new_text[-2] == 'x' and new_text[-1].isdigit():
                    new_text = new_text[:-2]
            if 'EMPTY' in new_text:
                new_text = new_text.replace('EMPTY','')
            new_text = ''.join([i for i in new_text if not i.isdigit()])
            #print(new_text)
            #text += new_text                    
            #cv2.imshow("Image", frame)
            if len(new_text) > 2:
                labels += [new_text]
        labels = list(set(labels))
        return labels


    def focus_label(self, image):
        """
        get the labels of the focus window
        """
        #cv2.imshow("i",image)
        
        framecolor = image[int(image.shape[0]*.505):int(image.shape[0]*.525),int(image.shape[1]*.51):int(image.shape[1]*.625)]
        #prepare a random shift and 2/3 downscale
        #imgshift = [np.random.rand()/3,np.random.rand()/3]
        imgshift = [1.0/6,1.0/6]
        objCenter = [(image.shape[0]*.5)-(imgshift[0]*image.shape[0]),(image.shape[1]*.5)-(imgshift[1]*image.shape[1])] 
        #objCenter = [.5,.5]
        objSize = [.15*image.shape[1]/image.shape[0],.15]

        #return
        #get the label
        #attempt to get the label for each color channel
        labelsOut = []
        labels = self.get_label(framecolor)
        #approximately the center of the image

        #cv2.imshow("imagea",framecolor)
        
        for label in labels:
            if len(label) > 0:
                labelsOut.append([label,objCenter,objSize])

        if len(labelsOut) > 0:
            #remove the text from the image so it can't just learn to read
            image[int(image.shape[0]*.505):int(image.shape[0]*.525),int(image.shape[1]*.51):int(image.shape[1]*.625)] = np.zeros(shape = [int(image.shape[0]*.525) - int(image.shape[0]*.505),int(image.shape[1]*.625) - int(image.shape[1]*.51),3])
            #remove the label

            #add a random offset to the image, shift image size to 640
            xlims = [int(image.shape[1] * imgshift[1]), int(image.shape[1] * imgshift[1]) + int(image.shape[1]*2/3)]
            ylims = [int(image.shape[0] * imgshift[0]), int(image.shape[0] * imgshift[0]) + int(image.shape[0] *2/3)]
        
            image = image[ylims[0]:ylims[1],xlims[0]:xlims[1]]
            objCenter = [objCenter[0]/image.shape[0],objCenter[1]/image.shape[1]]
            #print(labelsOut)


            image = chop_image(image,objCenter,labelsOut[0][2])

            #labelsOut = [[l[0],objCenter,l[2]] for l in labelsOut]
            labelsOut = [[l[0],[.5,.5],[1,1]] for l in labelsOut]

            #print(objCenter,objSize)
            #show_bounds(image,objCenter,objSize)

            #cv2.imshow('img',image)
            #print(labelsOut)
            #cv2.waitKey(0)


            return [image,labelsOut]
        return False

    
    def hp_label(self,oimage):
        """
        get the labels from hp bar labels
        """
        #search image for hp bar
        #mask the menus
        oimage = oimage[int(oimage.shape[0]*.2):int(oimage.shape[0]*.8),int(oimage.shape[1]*.2):int(oimage.shape[1]*.8)]
        #cv2.imshow('i',oimage)
        image = oimage
        #get the red channel
        #image = image[:,:,2] - 2*image[:,:,0] - 2*image[:,:,1]
        babs = (cv2.absdiff(image[:,:,2],image[:,:,0]))
        gabs = (cv2.absdiff(image[:,:,2],image[:,:,1]))
        image = image[:,:,2] / 3 + babs / 3 + gabs / 3
        #print(cv2.absdiff(image[:5,:5,2],image[:5,:5,0]))#-image[:5,:5,1])
        image = np.array(image)
        _,image = cv2.threshold(image,130,255,cv2.THRESH_BINARY)
        #look for horizontal lines
        #image = (image/256).astype('uint8')
        image = cv2.Sobel(image,cv2.CV_8UC1,0,1,ksize = 7)
        
        lines = cv2.HoughLinesP(image=image,rho=1,theta=np.pi/180, threshold=100, minLineLength=60,maxLineGap=10)
        linePoints = []
        if not lines is None:
            fLines = []
            lines = [l[0] for l in lines]
            #print(lines)
            #remove duplicates
            #if the lines are close together take the longer one
            if len(lines) > 1:
                ldists = [[max(cdist(i[:2],ii[:2]),cdist(i[2:],ii[2:])) for i in lines] for ii in lines]
                llengs = [cdist(lines[il][:2],lines[il][2:]) for il in range(len(lines))]
                #print(ldists)
                #print(llengs)
                for r in range(len(ldists)):
                    rm = [i<10 for i in ldists[r]]
                    #print(lines[llengs.index(max([llengs[m] for m in range(len(llengs)) if rm[m]]))])
                    fLines += [list(lines[llengs.index(max([llengs[m] for m in range(len(llengs)) if rm[m]]))])]
            else:
                fLines = lines
            #print(fLines)
            fLines = [list(i) for i in set(map(tuple, fLines))]
            #print(fLines)
        #get name from hp bar(s)
            
            labelsOut = []
            limage = []
            for hp in fLines:
                labels = []
                framecolor = oimage[int(hp[1]-30):int(hp[1]),int(hp[0]-(hp[2]-hp[0])/1.7):int(hp[2]+(hp[2]-hp[0])/1.7),:]
                #the image here can be broken??
                #cv2.imshow('slice',framecolor)
                labels += self.get_label(framecolor)
                #print(labels)
                for label in labels:
                    if len(label)>1:
                        #print('hp',hp)
                        #print(oimage.shape)
                        hpl = hp[2] - hp[0]
                        center = [(hp[1] + hpl*.9)/oimage.shape[0], (hp[0] + hpl/2) / oimage.shape[1]]
                        size = [hpl * 1.7 /oimage.shape[0], hpl * 1.7/oimage.shape[1]]
                        
                        
                        #labelsOut.append([label,center,size]) #this version if i'm not reducing the image to only the labeled section
                        labelsOut.append([label,[.5,.5],[1,1]]) #this version if i'm chopping the image

                        #print('shape',oimage.shape)
                        #print(center,size)
                        #show_bounds(oimage,center,size)
                        #cv2.waitKey(0)

                        #chop image to only the labeled section
                        limage.append(chop_image(oimage,center,size))

            if len(labelsOut)>1:
                return [limage,labelsOut]
        return False

    def tess_video(self, video_path):
        #self.clear_output()
        cap = cv2.VideoCapture(video_path)
        text = []
        labels = []
        bflag = False
        while True:
            if bflag:
                break
            ret, image = cap.read()

            if ret and not image is None:
                #cv2.imshow('nomod',image)   
                labelImg = self.focus_label(image)
                if labelImg: 
                    #print(numImg,labelImg[1])        
                    imgFile = os.path.join(self.imageFolder,str(self.numImg)+'.png')
                    try:
                        cv2.imwrite(imgFile,labelImg[0])
                    except:
                        print('broke on error')
                        bflag = True
                        break
                    #cv2.imshow('a',labelImg[0][ln])
                    #print([i[0] for i in labelImg[1]])
                    #cv2.waitKey(0)
                    labels+=[[self.numImg]+i for i in labelImg[1]]
                    self.numImg += 1
                    #print(labels)

                labelImg = self.hp_label(image)
                if labelImg: 
                    #print(numImg,labelImg[1])     
                    for ln,l in enumerate(labelImg[1]):

                        labels += [[self.numImg] + l]   
                        imgFile = os.path.join(self.imageFolder,str(self.numImg)+'.png')
                        try:
                            cv2.imwrite(imgFile,labelImg[0][ln])
                        except:
                            print('broke on error')
                            bflag = True
                            break
                        #cv2.imshow('a',labelImg[0][ln])
                        #print(l[0])
                        #cv2.waitKey(0)
                        #nl = labelImg[1]

                        self.numImg += 1

            else:
                break

            #if self.numImg >100:
            #    break
            #key = cv2.waitKey(1)
            #if key == 27:
                #break
        cap.release()
        cv2.destroyAllWindows()
        print('done tess')
        return labels


    def generate_keys(self,labels,numclasses):
        print(labels)
        classRules = [
            'Cookingstation',
            'Branch',
            'Copperdeposit',
            'Raspberries',
            'Cloudberries',
            'Stone',
            'Forge',
            'Blueberries',
            'Skeletalremains',
            'Resin',
            'Cauldron',
            'Trollhide',
            'Finewood',
            'Trolltrophy',
            'Mushrooms',
            'Door',
            'Tindeposit',
            'Surtlingcore',
            'Fermenter',
            'Pinecone',
            'Pine',
            'Fir',
            'Chest',
            'Workbench',
            'Log',
            'Stump',
            'Turnipseeds',
            'Unclaimedbed',
            'Ancienttree',
            'Loxpelt',
            'Corewood',
            'Wood',
            'Chair',
            'Fuling',
            'Evilbonepile',
            'Coins',
            'Tin',
            'Beehive',
            'Honey',
            'Tinore',
            'Carrotseeds',
            'Carrot',
            'YtturigansBed',
            'Birch',
            'Beech',
            'Yellowmushroom',
            'Bonefragments',
            'Copper',
            'Thistle',
            'Leatherscraps',
            'Coal',
            'Gate',
            'Blobtrophy',
            'Cookedloxmeat',
            'Greydwarfshaman',
            'Deer',
            'Boar',
            'Greydwarf',
            'Greydwarfbrute',
            'Fuling',
            'Fulingbeserker',
            'Skeleton',
            'enemyblob',
            'Draugr',
            'Troll',
            'Deathsquito',
            'Neck',
        ]

        #remove digits and stuff
        labels = [[i[0],''.join([c for c in i[1] if c.isalpha()]),i[2],i[3]] for i in labels]
        classes = list(set([i[1] for i in labels]))
        #print(classes)
        #sort classes on frequency
        classSorted = np.argsort([len([i for i in labels if i[1] == j]) for j in classes])
        classSorted = [classes[i] for i in classSorted]
        #print(classSorted)
        #map classes to classrules
        fmap = dict([
            ('Gate','Door'),
            ('Pine','Tree'),
            ('Beech','Tree'),
            ('Birch','Tree'),
            ('Fir','Tree'),
            ('Ancienttree','Tree'),
            ('Bush','Tree'),
            ('Stump','Tree'),
            ('Log','Tree'),
            ('Greyling','Enemy'),
            ('Greydwarf','Enemy'),
            ('Greydwarfshaman','Enemy'),
            ('Greydwarfbrute','Enemy'),
            ('Troll','Enemy'),
            ('Fuling','Enemy'),
            ('Fulingbeserker','Enemy'),
            ('Draugr','Enemy'),
            ('Deathsquito','Enemy'),
            ('Skeleton','Enemy'),
            ('Boar','Enemy'),
            ('Neck','Enemy'),
            ('enemyblob','Enemy'),
            ('Copperdeposit',False),
            ('Tinore',False),
            ('Tindeposit',False),
            ('Finewood','Loot'),
            ('Loxpelt','Loot'),
            ('Unclaimedbed','Bed'),
            ('Corewood','Loot'),
            ('YtturigansBed','Bed'),
            ('Branch','Loot'),
            ('Resin','Loot'),
            ('Coal','Loot'),
            ('Cauldron',False),
            ('Stone',False),
            ('Wood','Loot'),
            ('Forge',False),

        ])
        for c in classes:
            if c not in fmap.keys():
                similarity = find_similarity(c,classRules)
                if min(similarity) < min(len(c)-2,4):
                    mostSimilar = classRules[similarity.index(min(similarity))]
                    #if the most similar class has a fmap
                    if mostSimilar in fmap.keys():
                        fmap[c] = fmap[mostSimilar]
                    else:
                        #if there's not existing map
                        fmap[c] = classRules[similarity.index(min(similarity))]
                else:
                    print('no map for ',c)
                    fmap[c] = False
        #print(fmap)
        labels = [[i[0],fmap[i[1]],i[2],i[3]] for i in labels]
        classes = list(set([i[1] for i in labels if i[1]]))
        classSorted = np.argsort([len([i for i in labels if i[1] == j]) for j in classes])
        classSorted = [classes[i] for i in classSorted][-numclasses:]
        print(classSorted)

        shutil.rmtree(self.labelFolder)
        os.mkdir(self.labelFolder)
        classes = [i for i in classSorted if i]
        for lN,label in enumerate(labels):
            if label[1] and label[1] in classSorted:
                labelName = os.path.join(self.labelFolder,str(label[0])+'.txt')
                labelClass = str(classSorted.index(label[1]))
                objCenter = label[2]
                objSize = label[3]
                #print('center',objCenter)
                #print('size',objSize)

                with open(labelName,'w+') as f:
                    f.write(labelClass +' '+ str(objCenter[1])+' '+str(objCenter[0])+' '+str(objSize[1])+' '+str(objSize[0]))
                    #print(labelName)

        return classes

def show_bounds(oimage,center,size):
    #convert from pct to pix
    print('pct',center,size)
    center = [center[0] * oimage.shape[0], center[1] * oimage.shape[1]]
    size = [size[0] * oimage.shape[0], size[1]*oimage.shape[1]]
    print('pixel',center,size)
    #convert to corners
    obj = [max(int(center[0] - size[0]/2),0) , min(int(center[0] + size[0]/2),oimage.shape[0]), max(int(center[1] - size[1]/2),0), min(int(center[1] + size[1]/2),oimage.shape[1])]
    print('obj',obj)
    #obj = oimage[obj[0]: obj[1], obj[2]:obj[3], :]
    cv2.rectangle(oimage,(obj[2],obj[0]),(obj[3],obj[1]),(0,0,255),3)
    cv2.imshow('bounds',oimage)
    cv2.waitKey(0)

def cdist(a,b):
    if len(a) != len(b):
        return False
    dR = []
    #print(a,b)
    for d in range(len(a)):
        dR += [a[d] - b[d]]
    #print('dR',dR)
    return np.sqrt(sum([i**2 for i in dR]))

def flatten(ll):
    return [e for l in ll for e in l]

def find_similarity(item,plist):
    return [jellyfish.levenshtein_distance(item,i) for i in plist]

def sliceD(pctTrain):
    labels = os.listdir('val9k\\labels')
    with open('val9k\\trainList.txt','w') as trainF:
        with open('val9k\\testList.txt','w') as testF:
            for label in labels:
                img = label[:-3]+'png'
                if np.random.randint(100) < pctTrain:
                    #add to trainlist
                    trainF.write(os.path.join('C:\\Users\\ben titzer\\Documents\\code\\ml\\val9k\\images',img)+'\r')
                else:
                    testF.write(os.path.join('C:\\Users\\ben titzer\\Documents\\code\\ml\\val9k\\images',img)+'\r')


def chop_image(oimage,center,size):
    center = [center[0] * oimage.shape[0], center[1] * oimage.shape[1]]
    size = [size[0] * oimage.shape[0], size[1]*oimage.shape[1]]
    #print('pixel',center,size)
    #convert to corners
    obj = [max(int(center[0] - size[0]/2),0) , min(int(center[0] + size[0]/2),oimage.shape[0]), max(int(center[1] - size[1]/2),0), min(int(center[1] + size[1]/2),oimage.shape[1])]
    #print('obj',obj)
    oimage = oimage[obj[0]-10: obj[1]+10, obj[2]-10:obj[3]+10, :]
    return oimage

def writeYaml(classes):
    #remove 'False' from labels
    #labels = [i for i in labels if i[0]]
    with open('val9k\control.yaml','w') as f:
        f.write(
        'train: C:\\Users\\ben titzer\\Documents\\code\\ml\\val9k\\trainList.txt\r'
        'val: C:\\Users\\ben titzer\\Documents\\code\\ml\\val9k\\testList.txt\r'
        'test: C:\\Users\\ben titzer\\Documents\\code\\ml\\val9k\\testList.txt\r'
        )
        f.write('nc: '+str(len(classes))+'\r')
        f.write('names: '+str(list(classes))+'\r')

if __name__ == '__main__':
    t = TessWrap('val9k')
    #t.numImg = 0
    #t.clear_output()
    #labels = t.tess_video(os.path.join('C:\\Users\\ben titzer\\Videos','2021-02-22 19-53-27.mkv'))
    #with open('labelDump.pkl','wb') as lD:
    #    pickle.dump(labels,lD)
    with open('labelDump.pkl','rb') as lD:
        labels = pickle.load(lD)
    classes = t.generate_keys(labels,15)
    sliceD(80)
    writeYaml(classes)
    #t.self_generating_dictionary('text.txt')
    #with open('text.txt','r') as f:
    #    tList = [i for i in f.readlines()]
    #tp = [t.text_persistence(te) for te in tList]
