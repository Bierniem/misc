#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Event  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#InstallMouseHook
#InstallKeybdHook

#MaxThreadsPerHotkey 3
#SingleInstance, force
SetTitleMatchMode, 2
#IfWinActive, Valheim
!1::  ; Alt+1 hotkey (change this hotkey to suit your preferences).
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
		MouseClick, left
		Sleep, 2500
		if not KeepWinZRunning  ; The user signaled the loop to stop by pressing Win-Z again.
			break  ; Break out of this loop.
	}
	KeepWinZRunning := false  ; Reset in preparation for the next press of this hotkey.
	return
	
	
#MaxThreadsPerHotkey 3
!2::  ; Alt+2 hotkey (change this hotkey to suit your preferences).
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
		Click,Right,"Down"
		if not KeepWinZRunning  ; The user signaled the loop to stop by pressing Win-Z again.
			Click,Right,"Up"
			break  ; Break out of this loop.
	}
	KeepWinZRunning := false  ; Reset in preparation for the next press of this hotkey.
	return
	
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
		Send {e Down}
		Sleep, 10
		Send {e Up}
		Sleep, 2500
		if not KeepWinZRunning  ; The user signaled the loop to stop by pressing Win-Z again.
			break  ; Break out of this loop.
	}
	KeepWinZRunning := false  ; Reset in preparation for the next press of this hotkey.
	return