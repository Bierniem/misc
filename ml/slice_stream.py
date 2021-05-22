#chop video into images... like grab every 100 frames and save it into a folder
#use this for manual annotation
import os
import cv2

def decimate_video(videoPath, dumpFolder, decimate):
    cap = cv2.VideoCapture(videoPath)
    text = []
    fc = 0
    while True:
        ret, image = cap.read()
        if ret:
            fc+=1
            if fc % decimate == 0:
                print(fc)
                #save the image
                imgFile = os.path.join(dumpFolder,str(fc)+'.png')
                cv2.imwrite(imgFile,image)
        else:
            break
    cap.release()
    cv2.destroyAllWindows()
    return

if __name__ == '__main__':
    decimate_video(os.path.join('C:\\Users\\ben titzer\\Videos','2021-02-22 19-53-27.mkv'),'slicedvideo',50)   