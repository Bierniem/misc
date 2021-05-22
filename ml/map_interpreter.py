import numpy as np 
import cv2
import pytesseract
import os
import jellyfish
import shutil
import pickle

pytesseract.pytesseract.tesseract_cmd = r'C:\\Program Files\\Tesseract-OCR\\tesseract.exe'