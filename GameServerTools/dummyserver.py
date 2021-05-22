#dummy server proc
import time
import sys
if __name__ == '__main__':
	sys.stdout.write('starting dummy server\n')
	while True:
		time.sleep(5)
		sys.stdout.write('still alive ' + str(time.time())+'\n')