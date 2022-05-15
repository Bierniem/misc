#music copyer
import os
import shutil

def copy(s,d):
    shutil.copytree(s,d)
    l = os.listdir(s)
    print(l)
    for l in os.listdir(s):
        print(l)
        shutil.copy(l,d)
