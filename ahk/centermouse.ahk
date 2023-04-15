#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

!4:: ;#triggers on alt+4
    CoordMode, Mouse, Screen
    MouseMove, A_ScreenWidth/2, A_ScreenHeight/2, 0