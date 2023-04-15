;autohotkey mc fishing script

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#MaxThreadsPerHotkey 3
!4::  ; Alt+4 hotkey (change this hotkey to suit your preferences).
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
		MouseGetPos, MouseX, MouseY
		Sleep, 50
		PixelGetColor, color, %MouseX%, %MouseY%
		FileAppend, 
		(
		%MouseX% %MouseY% %color% `n
		), %A_ScriptDir%\colordump.txt
		if not KeepWinZRunning  ; The user signaled the loop to stop by pressing Win-Z again.
			break  ; Break out of this loop.
	}
	KeepWinZRunning := false  ; Reset in preparation for the next press of this hotkey.
	return
	
#MaxThreadsPerHotkey 3	
!5::  ; Alt+5 hotkey (change this hotkey to suit your preferences).
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
		Sleep, 100
		PixelSearch ,outx,outy,500,400,1100,800,0x2023B8,10,fast
		PixelGetColor, color, %outx%, %outy%
		PixelSearch ,outx,outy,500,400,1100,800,0x2023B8,10,fast
		;PixelSearch ,outx,outy,500,400,1100,800,0x131F49,5,fast
		;PixelSearch ,outx,outy,100,100,200,200,0x131F49,1,fast
		;PixelSearch, Px, Py, 200, 200, 300, 300, 0x9d6346, 3, Fast
		if (ErrorLevel==1)
		{
			mouseclick, right
			Sleep, 2000
		}
		;if (ErrorLevel==2)
		;	FileAppend, 
		;	(
		;	ERROR 
		;	), %A_ScriptDir%\colorfound.txt
		;if (ErrorLevel==0)
		;{
		;	FileAppend, 
		;	(
		;	%outx%, %outy% %color%`n;
		;	), %A_ScriptDir%\colorfound.txt
		;}
		if not KeepWinZRunning  ; The user signaled the loop to stop by pressing Win-Z again.
			break  ; Break out of this loop.

	}
	KeepWinZRunning := false  ; Reset in preparation for the next press of this hotkey.
	return