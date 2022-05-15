import mouse
import keyboard
import pickle
import time
import os
sttime = str(time.time())


def control_to_ints(control):
    """
    maps mouse and keyboard values to some consistent numbers
    """
    types = 0
    x = 0
    y = 0
    time = 0

    #print(str(type(control)).split("'")[1])
    types = ['mouse._mouse_event.MoveEvent', 'mouse._mouse_event.ButtonEvent', 'mouse._mouse_event.WheelEvent', 'keyboard._keyboard_event.KeyboardEvent']
    types = types.index(str(type(control)).split("'")[1])
    if types in [1]: 
        #print(control)
        x = ['up','down','double']
        x = x.index(control.event_type)
        y = ['left','right','middle']
        y = y.index(control.button)
    if types in [3]: 
        x = ['up','down','double']
        x = x.index(control.event_type)
        y = control.scan_code
    elif types in [2]:
        y = control.delta
    elif types in [0]:
        x = control.x
        y = control.y
    t = control.time
    if types!=0:
        print(types)
    return [types,x,y,t] #these will probably have to be converted to some kind of byte format

def print_logger():
    """will run until the terminal is closed"""
    kl = []
    mouse.hook(kl.append)
    keyboard.hook(kl.append)
    while(True):
        time.sleep(.0001)
        while len(kl) > 0:
            print(','.join([str(i) for i in control_to_ints(kl.pop(0))]))
            #fout.write(','.join([str(i) for i in control_to_ints(kl.pop(0))])+'\r')

def add_record(kl):
    dumpFolder = 'keylogs'
    filename = 'keylog_'+str(time.time())+'.pkl'
    dumpfile = os.path.join(dumpFolder,filename)
    with open(dumpfile,'ab') as d:
        pickle.dump(kl,d)
    return

def start_logger():
    """will run until the terminal is closed"""
    kl = []
    with open('keyfile.txt','w') as fout:
        mouse.hook(kl.append)
        keyboard.hook(kl.append)
        while(True):
            time.sleep(.0001)
            while len(kl) > 0:
                fout.write(','.join([str(i) for i in control_to_ints(kl.pop(0))])+'\r')
            """parse keys into keylog.txt"""
    return

def look_log():
    times = []
    logs =[log for log in os.listdir('keylogs')]
    times = [int(log.split('_')[1].split('.')[0]) for log in logs]
    newlog = logs[times.index(max(times))]
    with open(os.path.join('keylogs',newlog),'rb') as f:
        data = pickle.load(f)
    print(data)
    
if __name__ == '__main__':
    start_logger()
    #look_log()
