import numpy as np 
import matplotlib.pyplot as plt
import os

    
'''
*BB**BB***
****BB***B*BBB*B**BBBB**B*
*****B*BB*******B*BBBB**BB
'''
'''
[2,3,6,7]
[4,5,9,11,12,13,15,18,19,20,21,24]
[5,7,8,16,18,19,20,21,24,25]
'''

'''
01001001 01010101 01000101 25514 23192017
0100100101010101010001011100011101010101011000011110000111010001
*BB**BB*** ****BB***B*BBB*B**BBBB**B* *****B*BB*******B*BBBB**BB
0  01  101 1010  100 1   1 00    10 0 01011 0  1111000 1    00
 10  00        10   0 011 0  1110  1       0 00       0 1101  01
12223 4231131124211 5112711422
'''
"""
{
  "ns": "yt",
  "el": "detailpage",
  "cpn": "6JTaFA5a5gRBEBfo",
  "docid": "Ss9fYapvR-U",
  "ver": 2,
  "referrer": "https://www.youtube.com/watch?v=Ss9fYapvR-U",
  "cmt": "1.66",
  "ei": "ByTLXqY41suKBKv4imA",
  "fmt": "136",
  "fs": "0",
  "rt": "19.501",
  "of": "GC6OCn1lTVgpgJyrp2hYjw",
  "euri": "",
  "lact": 1,
  "cl": "312565800",
  "mos": 0,
  "state": "4",
  "vm": "CAEQABgEKiBsUmpoTXRxc1czUTVHZ2RJbmktOXBNdnY3X3JnV3ItNjoyQUdiNlo4UGFjSTcwSi1BZ05QWjM0Z3VObkZnUExEU1ZYNEJSOUdPdE1RTXhpbzFXS2c",
  "volume": 80,
  "subscribed": "1",
  "cbr": "Chrome",
  "cbrver": "81.0.4044.138",
  "c": "WEB",
  "cver": "2.20200521.03.02",
  "cplayer": "UNIPLAYER",
  "vw": 861,
  "vh": 861,
  "creationTime": 19814.754999999877,

}
"""
"""
{
  "ns": "yt",
  "el": "detailpage",
  "cpn": "kRkgFl7g_BIiwQyZ",
  "docid": "YXLywtntdok",
  "ver": 2,
  "referrer": "https://www.youtube.com/channel/UCUilFFNs3dqcH2_uGkUq4FQ",
  "cmt": "8.071",
  "ei": "cSfLXq-xJJLkD-qPv6AL",
  "fmt": "135",
  "fs": "0",
  "rt": "8.436",
  "of": "AQxBy4BCaVjNbdwAu8Sjgw",
  "euri": "",
  "lact": 2,
  "cl": "312565800",
  "mos": 0,
  "state": "8",
  "vm": "CAQQARgCKiBsUmpoTXRxc1czUTVHZ2RJbmktOXBNdnY3X3JnV3ItNjoyQUdiNlo4TmZBQnRTYTFNeGV0THRUaVVBX01OcmwxUmljanFmNDJPMW5SanZENjlFN1E",
  "volume": 80,
  "subscribed": "1",
  "cbr": "Chrome",
  "cbrver": "81.0.4044.138",
  "c": "WEB",
  "cver": "2.20200521.03.02",
  "cplayer": "UNIPLAYER",
  "cos": "Windows",
  "cosver": "10.0",
  "hl": "en_US",
  "cr": "US",
  "len": "94.621",
  "fexp": "23744176,23804281,23837040,23837993,23839597,23856950,23857950,23859802,23860859,23865856,23868329,23876128,23876458,23877068,23880389,23880619,23880720,23882502,23884386,23886825,23888589,23891425,23891856,23892344,23892589,23894825,23896518,23897308,23897936,23898054,23898675,23899235,23900839,23901904,23902105,23904810,23905292,23907145,3300110,3300134,3300161,3313321,3313707,3315664,3315772,3316461,3317006,9405987,9449243",
  "feature": "c4-overview",
  "afmt": "251",
  "vct": "8.071",
  "vd": "94.621",
  "vpl": "0.000-8.071",
  "vbu": "0.000-32.033",
  "vpa": "0",
  "vsk": "0",
  "ven": "0",
  "vpr": "1",
  "vrs": "4",
  "vns": "2",
  "vec": "null",
  "vemsg": "",
  "vvol": "0.8",
  "vdom": "1",
  "vsrc": "1",
  "vw": 860,
  "vh": 861,
  "creationTime": 883608.275,
  "totalVideoFrames": 247,
  "droppedVideoFrames": 0,
  "corruptedVideoFrames": 0,
  "lct": "8.065",
  "lsk": false,
  "lmf": false,
  "lbw": "6631731.213",
  "lhd": "0.064",
  "lst": "0.000",
  "laa": "itag=251,type=3,seg=3,time=30.0-40.0,off=0,len=137775,end=1",
  "lva": "itag=135,type=3,seg=5,time=26.7-32.0,off=0,len=428567,end=1",
  "lar": "itag=251,type=3,seg=3,time=30.0-40.0,off=0,len=171744.99999999994,end=1",
  "lvr": "itag=135,type=3,seg=5,time=26.7-32.0,off=0,len=769951.875,end=1",
  "lab": "0.000-40.001",
  "lvb": "0.000-32.033",
  "ismb": 16660000,
  "relative_loudness": "-8.210",
  "optimal_format": "480p",
  "user_qual": "hd720",
  "debug_videoId": "YXLywtntdok",
  "0sz": false,
  "op": "",
  "yof": false,
  "dis": "",
  "gpu": "ANGLE_(NVIDIA_GeForce_GTX_1080_Ti_Direct3D11_vs_5_0_ps_5_0)",
  "cgr": true,
  "debug_playbackQuality": "large",
  "debug_date": "Sun May 24 2020 20:03:38 GMT-0600 (Mountain Daylight Time)"
}
"""

def flatten(l):
    return [e for sl in l for e in sl]

def setcheck(ltc):
    for n,i in enumerate(ltc):
        ltr = ltc
        ltr.pop(n)        
        #print('n',n,'i',i,'ltc',ltc,'ltr',ltr)
        if i in ltr:
            return(False)
    return True
class croonhouse():
    def __init__(self):
        self.alph = 'abcdefghijklmnopqrstuvwxyz'
        self.ALPH = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

        #croonhouse stuff
        '''first video
            Fineware sink!!
            Accident
            INDIA(SPACE) SIERRA OSCAR ROMEO ROMEO YANKEE.

            b*s
            maybe the b*s are all 3 masks?
            10 for base ten digits
            2x 26 for english(?) alphabet
        '''
        """
        'DROPBLEEDFORMEDIDN'T YOU HAVE FUN
        0123456789
        *BB**BB***
        BBBB*
        """
        self.videoTxt2 = [
            "Hrxp hlfmw",
            "01001001 01010101 01000101 25514 23192017"
            "howami?"
            "drip",
            "drop",
            "bleedforme",
            "897985",
            "7765846772737871",
            "PFKD.QL.JB",
            ""
            "are you ready for a gift?",
            "U ENJOYING YOURSELF?",
            "ENJOYING YOURSELF?",
            "DIDN'T YOU HAVE FUN?!",
            "YOUCALLEDANDIANSWERED",
            "YOUCALLEDANDIANSWERED",
            "YOUDIDTOYOURSELFMARK",
            "YOUR PUNISHMENT",
            "WILL COME",
            "*BB**BB***",
            "****BB***B*BBB*B**BBBB**B*",
            "*****B*BB*******B*BBBB**BB"
        ]
        '''
        85 31121254 135 11911 8913 23825 1511 
        '''
        self.videoTxt = [
            'qeeortf, o rorfz dtqf zg',
            'INDIA(SPACE) SIERRA OSCAR ROMEO ROMEO YANKEE.', 
            'youcalledme',
            'iheardyou',
            'getready',
            'imgoingtomakeyoumusic',
            'illsingtoyou',
            'ready'
        ]
        self.Description = 'QEEORTF, O RORFZ DTQF ZG'
        self.description = 'qeeortf, o rorfz dtqf zg'
        self.descriptionPoss = 'a..iden, i didnt mean to'
        self.descCyph = ['.','.','.','m','.','n','o','.','.','.','.','.','.','.','i','.','a','d','.','e','.','.','.','.','.','t']
        self.singtomeCyph = ['.','e','.','g','.','i','.','.','.','m','n','o','.','.','.','s','t','.','.','.','.','.','.','.','.','.']
        self.atbashCyph = ['z','y','x','w','v','u','t','s','r','q','p','o','n','m','l','k','j','i','h','g','f','e','d','c','b','a']

    '''def vigenere_cipher(text,key):
        ciphered = ''
        ltext = [str(i) for i in text]
        lkey = [str(i) for i in key]
        lalph = [str(i) for i in self.alph]
        for i in text:
            try
    '''

    def caseOpt(self,string):
        #returns lowercase and uppercase version of the string
        lalph = [str(i) for i in self.alph]
        lALPH = [str(i) for i in self.ALPH]
        lowercase = ''
        uppercase = ''
        string = [str(i) for i in flatten(string)]
        for i in string:
            try:
                lowercase += lalph[lALPH.index(i)]
            except ValueError:
                lowercase += i
        for i in string:
            try:
                uppercase += lALPH[lalph.index(i)]
            except ValueError:
                uppercase += i
            
        return([lowercase,uppercase])

    def atbashCypher(self,string):
        lalph = [i for i in self.alph]
        atbash = [lalph[n] for n in range(len(lalph)-1,-1,-1)]
        sol = self.replaceCyph(string,atbash)
        return sol


    def trialReplaceCyph(self,string,permutable):
        #attempts english replacement cyphers returning attempts with words

        #make each possible replacement cypher
        lp = len(permutable)
        for attempt in range(lp**(lp-1),lp**lp):
            cyphInd = [int(np.floor(attempt/lp**n)%lp) for n in range(lp)]
            #disallow common mappings
            if setcheck(cyphInd):
                a = 1
                #print(cyphInd)
        print('no')

    def replaceCyph(self,string,cyph):
        #performs specified replacement cypher
        lalph = [i for i in self.alph]
        string = [i for i in flatten(string)]
        out = ''
        for i in string:
            try:
                out += cyph[lalph.index(i)]
                #print(lalph.index(i))
            except ValueError:
                out += '.'
        return out

        #for i in string:

    def shiftCyph(self,string):
        #returns a list of all 26 shifts of a string

        lalph = [i for i in self.alph]
        lALPH = [i for i in self.ALPH]

        shDecRet = []
        for i in range(27):
            shDec = ''
            for j in self.description:
                try:
                    ind = ALPH.index(j)
                    shDec += ALPH[(ind+i)%len(ALPH)]
                except ValueError:
                    shDec += j
            shDecRet.append(shDec)
        return shDecRet

    def separateTracks(self):
        audio1 = np.fromfile('AudioTrack.wav',dtype = np.float16,count = -1)
        audio2 = np.fromfile('AudioTrack-2.wav',dtype = np.float16,count = -1)

        audioa = np.append(audio1, abs(audio1) - abs(audio2))
        audiob = np.append(audio2, abs(audio2) - abs(audio1))
        plt.plot(audioa)
        plt.plot(audiob)
        plt.show()

        audioa.tofile('Audioa.wav')
        audiob.tofile('Audiob.wav')

    def rawHist(self,listIn):
        lset = set(listIn)
        ldict = dict([(ln,0) for ln in lset])
        for i in listIn:
            ldict[i] += 1

        return ldict

    def letterFreq(self,text):
        #generates statistics to help id/solve cyphers up to 4 alphabet
        ltext = [str(i) for i in text]
        ltext2 = [[ltext[i] for i in range(0,len(ltext),2)],[ltext[i] for i in range(1,len(ltext),2)]]
        ltext3 = [[ltext[i] for i in range(0,len(ltext),3)],[ltext[i] for i in range(1,len(ltext),3)],[ltext[i] for i in range(2,len(ltext),3)]]
        one = np.histogram(ltext)
        two = [np.histogram(i) for i in ltext2]
        three = [np.histogram(i) for i in ltext3]

        print('one',one)
        print('two',two)
        print('three',three)

    def testMasks(self,text):
        masks = ["*BB**BB***", "****BB***B*BBB*B**BBBB**B*", "*****B*BB*******B*BBBB**BB"]
        dmask = ['145890','2367','034789','1256']
        doubleAMask = ['abcdgkorwx','ftuv','abcdefghijklmnopqrstuvwxyz']
        amask = ['abcdghikoqrwxz','efjlmnpstuvy','abcdegjklmnoprwx','fhiqstuvyz']
        pp = '71029132 41552  589798 1787372776485677'


if __name__ == '__main__':
    cr = croonhouse()
    #print(shiftCyph(description))
    #separateTracks()
    #lalph = [i for i in cr.alph]
    #cr.trialReplaceCyph(cr.description,[1,2,3,4,5,6,7])
    #cr.separateTracks()
    #print(cr.caseOpt(cr.videoTxt2))
    print(cr.replaceCyph('nbspuhtayam',cr.atbashCyph))
    print(cr.replaceCyph(cr.caseOpt(cr.videoTxt)[0],cr.atbashCyph))
    #print(hmm)
    #print('------------------------')
    print(cr.replaceCyph(cr.caseOpt(cr.videoTxt2)[0],cr.atbashCyph))
    #print(hmm2)
    #cr.letterFreq(cr.caseOpt(cr.videoTxt)[0])


"""
got new numbers
atbash and binascii is all that has been clearly used so far
try steno on the videos
try to figure out numbers
"""