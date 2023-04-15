#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

move_click(x, y)
{
    MouseMove, x, y
    sleep 50
    MouseClick, left
    sleep 50
}
craft_last()
{   
    MouseGetPos x,y
    move_click( x, y)
    sleep 3000
    move_click( 1231, 527)  
    move_click( 1180, 743)   
    move_click( 959, 711)  
    move_click( 1072, 809)    
    Loop 20{
        move_click( 1579, 1057)       
        move_click( 951, 836)        
    }
    move_click( 1882, 1059)
    sleep 2500
	return
}
smelt()
{
    MouseGetPos x,y
    move_click( x, y)
    sleep 3000
    move_click( 257, 26)    
    move_click( 1528, 263)  
    Loop 50{
        move_click( 1579, 1057)
    }
    move_click( 1882, 1059)
    sleep 2500
	return
}
charcoal()
{
    MouseGetPos x,y
    move_click( x, y)
    sleep 3000
    move_click( 1018, 43)    
    Loop 50{
        move_click( 1579, 1057)
    }
    move_click( 1882, 1059)
    sleep 2500
	return
}


!1::  ; Alt+1 hotkey (change this hotkey to suit your preferences).
	return
	
!2::  ; Alt+1 hotkey (change this hotkey to suit your preferences).
    ; autocraft last
    craft_last()
    return

#MaxThreadsPerHotkey 3
!3::  ; Alt+1 hotkey (change this hotkey to suit your preferences).
    ; charcoal
     #MaxThreadsPerHotkey 1
	if KeepWinZRunning  ; This means an underlying thread is already running the loop below.
	{
		KeepWinZRunning := false  ; Signal that thread's loop to stop.
		return  ; End this thread so that the one underneath will resume and see the change made by the line above.
	}
	; Otherwise:
	KeepWinZRunning := true
    MouseGetPos x,y
    Loop 20{
        if not KeepWinZRunning  ; The user signaled the loop to stop by pressing Win-Z again.
			break  ; Break out of this loop.
        sleep 2500
        MouseMove x,y
        sleep 50
        charcoal()
        if not KeepWinZRunning  ; The user signaled the loop to stop by pressing Win-Z again.
			break  ; Break out of this loop.
        move_click( x, y+50)
        sleep 15000
        move_click( 127, 220)
    }
    KeepWinZRunning := false
    return

#MaxThreadsPerHotkey 3
!4::  ; Alt+1 hotkey (change this hotkey to suit your preferences).
    ; charcoal
     #MaxThreadsPerHotkey 1
	if KeepWinZRunning  ; This means an underlying thread is already running the loop below.
	{
		KeepWinZRunning := false  ; Signal that thread's loop to stop.
		return  ; End this thread so that the one underneath will resume and see the change made by the line above.
	}
	; Otherwise:
	KeepWinZRunning := true
    MouseGetPos x,y
    Loop 20{
        if not KeepWinZRunning  ; The user signaled the loop to stop by pressing Win-Z again.
			break  ; Break out of this loop.
        sleep 2500
        MouseMove x,y
        sleep 50
        smelt()
        if not KeepWinZRunning  ; The user signaled the loop to stop by pressing Win-Z again.
			break  ; Break out of this loop.
        move_click( x, y+50)
        sleep 15000
        move_click( 127, 220)
    }
    KeepWinZRunning := false
    return



#MaxThreadsPerHotkey 3
!5::  ; Alt+1 hotkey (change this hotkey to suit your preferences).
    ; charcoal
     #MaxThreadsPerHotkey 1
	if KeepWinZRunning  ; This means an underlying thread is already running the loop below.
	{
		KeepWinZRunning := false  ; Signal that thread's loop to stop.
		return  ; End this thread so that the one underneath will resume and see the change made by the line above.
	}
	; Otherwise:
	KeepWinZRunning := true
    MouseGetPos x,y
    Loop 20{
        if not KeepWinZRunning  ; The user signaled the loop to stop by pressing Win-Z again.
			break  ; Break out of this loop.
        sleep 2500
        MouseMove x,y
        sleep 50
        craft_last()
        if not KeepWinZRunning  ; The user signaled the loop to stop by pressing Win-Z again.
			break  ; Break out of this loop.
        move_click( x, y+50)
        sleep 15000
        move_click( 127, 220)
    }
    KeepWinZRunning := false
    return



#MaxThreadsPerHotkey 3
!6::  ; Alt+1 hotkey (change this hotkey to suit your preferences).
    ; grind
    #MaxThreadsPerHotkey 1
	if KeepWinZRunning  ; This means an underlying thread is already running the loop below.
	{
		KeepWinZRunning := false  ; Signal that thread's loop to stop.
		return  ; End this thread so that the one underneath will resume and see the change made by the line above.
	}
	; Otherwise:
	KeepWinZRunning := true
    MouseGetPos x,y
    Loop 20{
        sleep 2500
        if not KeepWinZRunning  ; The user signaled the loop to stop by pressing Win-Z again.
			break  ; Break out of this loop.
        MouseMove x,y
        sleep 50    
        craft_last()
        if not KeepWinZRunning  ; The user signaled the loop to stop by pressing Win-Z again.
			break  ; Break out of this loop.
        MouseMove x,y
        sleep 50 
        smelt()
        if not KeepWinZRunning  ; The user signaled the loop to stop by pressing Win-Z again.
			break  ; Break out of this loop.
        move_click( x, y+50)
        sleep 15000
        move_click( 127, 220)
        
    }
    KeepWinZRunning := false
	return
