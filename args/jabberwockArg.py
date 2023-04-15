image0txt = 'Jung qbrf n zveebe ybbx ng? ### sggkh://wirev.tlltov.xln/lkvm?rw=1qysZ3CRapNeyp-6Ne8j3OgM3SNTqywZc'
wav0name = 'zkjOOz9aNj'
alpha = 'abcdefghijklmnopqrstuvwxyz'
ALPHA = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

def atbashKey():
    lalpha = [i for i in alpha]
    lALPHA = [i for i in ALPHA]
    #print([i for i in range(len(lalpha)-1,-1,-1)])
    lkey = [(lalpha[i],lalpha[25-i]) for i in range(len(lalpha))]
    lKEY = [(lALPHA[i],lALPHA[25-i]) for i in range(len(lALPHA))]
    ckey = lkey + lKEY
    key = dict(ckey)
    return key

def shiftCyph(string):
    #returns a list of all 26 shifts of a string

    lalph = [i for i in alpha]

    shDecRet = []
    for i in range(27):
        shDec = ''
        for j in string:
            try:
                ind = lalph.index(j)
                shDec += lalph[(ind+i)%len(lalph)]
            except ValueError:
                shDec += j
        shDecRet.append(shDec)
    return shDecRet

def decrypt(cyphertext,key):
    plaintext = ''
    for i in cyphertext:
        if i in key.keys():
            plaintext+=key[i]
        else:
            plaintext += i
    return plaintext

if __name__ == '__main__':
    key = atbashKey()
    print(decrypt(image0txt,key))
    for i in shiftCyph(image0txt):
        print(i)
