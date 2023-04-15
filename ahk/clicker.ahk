#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

!1::
	done = 0
	Loop
	{
		if (done = 1)
			return
		click down
		Loop, 100
		{
			Sleep, 100
			if (done = 1)
			{
				click up
				return
			}
		}
		click up
		
		Sleep, 20000
	}
	return

!+1:: 
	done = 1
	return
	