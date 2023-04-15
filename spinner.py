import sys
import time
import threading


class TerminalSpinner:
    def __init__(self, text=None):
        self.text = text

        self.symbols = ['\\', '|', '/', '-']
        self.spinnerState = False
        self.spinnerDelay = 0.15

        self.spinnerThread = threading.Thread(target=self.spinner_func)

    def start(self):
        self.spinnerState = True
        self.spinnerThread.start()

    def stop(self):
        self.spinnerState = False
        self.spinnerThread.join()

    def spinner_func(self):

        if self.text is not None:
            sys.stdout.write(self.text)

        while self.spinnerState:
            for sym in self.symbols:
                sys.stdout.write(sym)
                time.sleep(self.spinnerDelay)
                sys.stdout.write('\b')

        # Only reached after stop is called. Empty space hides last symbol.
        sys.stdout.write(' \n\n')