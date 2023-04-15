;flintmaker

#MaxThreadsPerHotkey 3
!3::  ; Alt+3 hotkey (change this hotkey to suit your preferences).
	#MaxThreadsPerHotkey 1
	if KeepWinZRunning  ; This means an underlying thread is already running the loop below.
	{
		KeepWinZRunning := false  ; Signal that thread's loop to stop.
		return  ; End this thread so that the one underneath will resume and see the change made by the line above.
	}
	; Otherwise:
	KeepWinZRunning := true
	Loop
	{
		MouseClick, right
		Sleep, 200
		click, down
		Sleep, 1500
		click, up
		Sleep, 100
		click, wheelup
		Sleep, 100
		if not KeepWinZRunning  ; The user signaled the loop to stop by pressing Win-Z again.
			break  ; Break out of this loop.
	}
	KeepWinZRunning := false  ; Reset in preparation for the next press of this hotkey.
	return