#music copyer
import os
import shutil
import simpleaudio as sa

import numpy as np
from scipy.io.wavfile import write
import scipy
import matplotlib.pyplot as plt




def copy(s,d):
    shutil.copytree(s,d)
    l = os.listdir(s)
    print(l)
    for l in os.listdir(s):
        print(l)
        shutil.copy(l,d)


def playFile(filePath):
    wave_obj = sa.WaveObject.from_wave_file(filePath)
    play_obj = wave_obj.play()
    play_obj.wait_done()


def saveNpWav(array,filePath,rate = 44100):
    scaled = np.int16(array / np.max(np.abs(array)) * 32767) # max scale and int
    write(filePath, rate, scaled)


def lowpass(array,f,sampleRate):
    resolution = 8
    size = int(sampleRate/resolution)
    lp = np.fft.fft(array,n = size)
    lp = np.fft.fftshift(lp)
    window = np.sinc(np.linspace(-np.pi,np.pi,size))
    lp = lp*window
    # cut = int(lp.size/22) # do a rectangular window
    # lp[:int(lp.size/2-cut)]=0
    # lp[int(lp.size/2+cut):]=0
    lp = np.fft.fftshift(lp)
    lp = np.fft.ifft(lp,n = array.size)
    return lp

def randomDeep(duration):
    rate = 44100
    tvec = np.arange(0,duration,1/rate)
    tone = np.sin(2*np.pi*39*tvec)
    tone += np.sin(2*np.pi*42*tvec)
    tone*= np.repeat(np.random.rand(10),tone.size/10)
    return tone


def sweep(f0,f1,t,rate=44100):
    fsweep = np.linspace(f0,f1,int(t*rate))
    tvec = np.linspace(0,t,int(t*rate))
    tone = np.sin(2*np.pi*tvec*fsweep)
    return tone

def tester():
    tone = np.random.uniform(-1,1,44100*2)
    # tone = randomDeep(10)
    tone = lowpass(tone,1,44100)
    tone = tone *np.tile(sweep(100,500,.1),(20))
    # tone = randomDeep(100)
    saveNpWav(tone,"tmp.wav")
    playFile("tmp.wav")


if __name__ == "__main__":
    tester()