#threaded function mapper v2

import multiprocessing as mp

def make_groups(array,fcols):
    kgs = [[],[]]
    for i in array:
        nk = [v for n,v in enumerate(i) if n not in fcols]
        nv = [v for n,v in enumerate(i) if n in fcols]
        if nk not in kgs[0]:
            kgs[0].append(nk)
            kgs[1].append(nv)
        else:
            kgs[1][kgs[0].index[nk]].append(nv)
    return kgs
        
def function_mapper(array,fcols,function):
    ppool = mp.Pool(5)
    #make groups
    
    #run groups through function
    #put output into input format