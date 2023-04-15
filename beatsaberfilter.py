import os
import shutil
import numpy as np

def reduce_custom_levels(folder = 'C:\Program Files (x86)\Steam\steamapps\common\Beat Saber\Beat Saber_Data\CustomLevels'):
    rmd = 0
    for level in os.listdir(folder):
        sfs = [sf for sf in os.listdir(os.path.join(folder,level))]
        if sum(['ExpertPlus' in i for i in sfs]) == 0:
            print('remove',level)
            print(sfs)
            shutil.rmtree(os.path.join(folder,level))
            rmd+=1
        elif 'fall' in level:
            print('remove',level)
            print(sfs)
            shutil.rmtree(os.path.join(folder,level))
            rmd+=1
        elif '90' in level:
            print('remove',level)
            print(sfs)
            shutil.rmtree(os.path.join(folder,level))
            rmd+=1
        elif '360' in level:
            print('remove',level)
            print(sfs)
            shutil.rmtree(os.path.join(folder,level))
            rmd+=1
        elif 'one saber' in level:
            print('remove',level)
            print(sfs)
            shutil.rmtree(os.path.join(folder,level))
            rmd+=1
        elif np.random.randint(10) == 0:
            print('remove',level)
            print(sfs)
            shutil.rmtree(os.path.join(folder,level))
            rmd+=1
    print('removed '+str(rmd)+' levels')

if __name__=='__main__':
    reduce_custom_levels()