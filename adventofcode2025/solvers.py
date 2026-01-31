import numpy as np


a,b,c
0,0,0
0,1,1
1,0,1
1,1,1


def day1(inputFile):
    zcount = 0
    dial = 50
    with open(inputFile,'r') as fid:
        for i in fid.readlines():
            numi = int(i.strip().replace("L","-").replace("R",""))
            print(numi)
            dial+=numi
            dial%=100
            if dial == 0:
                zcount +=1
    print(f"zcount: {zcount}")

def day2(inputFile):
    incrementer = 0
    with open(inputFile,'r') as fid:
        data = fid.read()
        # data = day2Test
        data = data.split(',')
        for d in data:
            dA,dB = d.split('-')
            for i in range(int(dA),int(dB)+1):
                i = str(i)
                iarray = np.array([c for c in i]).astype(int)
                spl = len(iarray)/2
                if spl == int(spl):
                    spl = int(spl)
                    # only even slices i'm lazy
                    if (len(iarray)//spl) == (len(iarray)//spl):
                        if (iarray.reshape(-1,spl)==iarray[:spl]).all():
                            print(iarray[:spl])
                            incrementer+=int(i)
                            print(i)
                # whups I overcomplicated it... this was working to finds n duplicated sections not only 2 duplicated sections ie 111 also gets caught
                # iarray = np.array([c for c in i]).astype(int)
                # for spl in range(1,len(i)):
                #     # only integer slices
                #     if (len(iarray)/spl) == (len(iarray)//spl):
                #         if (iarray.reshape(-1,spl)==iarray[:spl]).all():
                #             incrementer+=int(i)
                #             print(i)
                #             break   
    print(f"solution {incrementer}")                    

day2Test = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

def day3()

if __name__ == "__main__":
    #day1("day1input.txt")
    day2("day2input.txt")