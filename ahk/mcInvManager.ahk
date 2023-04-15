;inv scripts

;full dump
!0::  ;alt 6
	Loop
	{
	;SoundBeep
		keydn := GetKeyState("Space")
		if keydn
		{
			SoundBeep ,600,500
			MouseGetPos x,y
			FileAppend,
			(
			%x%,%y%`r`n
			),C:\Users\Ben\Desktop\ahkRec.txt
		}
	}
	
!6:: ;alt 6
	Send Input {shift down}
	Sleep 500
	MouseClick,left,732,716
	Sleep 15
	MouseClick,left,807,711
	Sleep 15
	MouseClick,left,877,711
	Sleep 15
	MouseClick,left,953,704
	Sleep 15
	MouseClick,left,1005,706
	Sleep 15
	MouseClick,left,1097,702
	Sleep 15
	MouseClick,left,1113,703
	Sleep 15
	MouseClick,left,1263,710
	Sleep 15
	MouseClick,left,1258,757
	Sleep 15
	MouseClick,left,1202,773
	Sleep 15
	MouseClick,left,1098,773
	Sleep 15
	MouseClick,left,1037,772
	Sleep 15
	MouseClick,left,982,778
	Sleep 15
	MouseClick,left,901,779
	Sleep 15
	MouseClick,left,797,771
	Sleep 15
	MouseClick,left,746,779
	Sleep 15
	MouseClick,left,719,772
	Sleep 15
	MouseClick,left,677,842
	Sleep 15
	MouseClick,left,752,853
	Sleep 15
	MouseClick,left,792,839	
	Sleep 15
	MouseClick,left,919,845
	Sleep 15
	MouseClick,left,923,845
	Sleep 15
	MouseClick,left,1016,845	
	Sleep 15
	MouseClick,left,1105,845
	Sleep 15
	MouseClick,left,1144,845
	Sleep 15
	MouseClick,left,1203,842
	Sleep 15
	MouseClick,left,1256,846
	Sleep 15
	Send {shift up}