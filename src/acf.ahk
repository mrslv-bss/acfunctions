/*
A_CaretX works by asking the system where the caret is. Some code editors does not use the system implementation of a caret, therefore the system does not know where's caret is. 
In a way, it has no caret, just an imitation of one.
Accordingly, keep in mind that the script may not work in VSCODE, Notepads (Basic notepad working) and other.
*/

#Persistent
#SingleInstance, Force
#InstallKeybdHook
#InstallMouseHook
CoordMode, Caret
TryAgain:
if not A_IsAdmin
	Run *RunAs "%A_ScriptFullPath%",,UseErrorLevel
if (errorlevel)	{
	MsgBox, 262212, SWHelper : bass_devware, SWHelper`, was NOT run as administrator.`n`n===`nAntiMissBtn - disabled.`n===`n`nAntiMissBtn guarantees the absence of random erasing of the text at the work of the script`, therefore`, its presence is mandatory.`n`nPress Yes - to run as administrator.`nPress No - to continue.
	IfMsgBox Yes
		goto TryAgain
}
;~ FileInstall, BASS_DEVWARE.jpg, %A_Temp%\BASS_DEVWARE.jpg, 1
CustomColor = C0C0C0
Gui, 2:+AlwaysOnTop +LastFound +Owner
Gui, 2:Color, %CustomColor%
loop, 25
{
	sleep 40
	;~ Gui 2:Add, Picture,, %A_Temp%\BASS_DEVWARE.jpg
	WinSet, TransColor, %CustomColor% %A_Index%0
	Gui, 2:-Caption
	Gui, 2:Show, xCenter yCenter
	if (A_Index == 25)	{
		sleep 700
		SINDEX := A_Index
		loop, 25
		{
			sleep 40
			SINDEX -= 1
			WinSet, TransColor, %CustomColor% %SINDEX%0
			Gui, 2:Show, xCenter yCenter
		}
	}
}
Menu, tray, NoStandard
Menu, tray, add, @bass_devware, link
Menu, tray, add
Menu, tray, add, Restore window, Restore
Menu, tray, add
Menu, tray, add, Quit, Exit
status = 0
Hotkey, (, off
Hotkey, ), off
Hotkey, Right, off
Hotkey, Left, off
CoordMode, ToolTip
Gui, Add, Edit, x9 y10 w262 h20 +disabled vEdit, DIR\config.ini
Gui, Add, Text, x12 y50 w100 h40 vKeysList, Show/Hide []`nContinue ( ) []`nExit []
Gui, Add, Text, x155 y55 w120 h14 glink cBlue, VK / BASS_DEVWARE
Gui, Add, GroupBox, x7 y30 w115 h65 , Config Settings
Gui, Add, Button, x230 y35 w40 h15 gselectd, Select
Gui, Add, Button, x188 y35 w41 h15 gcheck vcheck +disabled, Check
Gui, Show, w275 h100, SWHelper : bass_devware
return

recheck:
FuncsList := ""
label:
Loop, read, %dirfile%
{
	Loop, parse, A_LoopReadLine, %A_Tab%
	{
		aSSa := " " . A_LoopField
		if regexmatch(aSSa, "(.[\s]*)?([\s].[^(=)%!.]*)\((.[A-z]*)?\)", exits)	{
			if regexmatch(exits2, "[!|^|%|(|)|#](.*)", ifsaaa)
				continue, label
			exits1 := RegExReplace(exits, " ", "")
			exits2 := RegExReplace(exits2, " ", "")
			Loop, parse, FuncsList
				if regexmatch(FuncsList, exits2)
					continue, label
			FuncsList := FuncsList . exits2 . "(" . exits3 . ")" . ", "
		}
	}
}
FuncsList := RegExReplace(FuncsList, "-", "")
if regexmatch(FuncsList, "return.[,]*")
	FuncsList := RegExReplace(FuncsList, "return", "")
if regexmatch(FuncsList, "if(errorlevel)")
	FuncsList := RegExReplace(FuncsList, "if(errorlevel)", "")
return

check:
gui, submit, nohide
Loop, read, %edit%
{
	if regexmatch(A_LoopReadLine, "List with funcs - (.*)")	{
		dirfile := RegExReplace(A_LoopReadLine, "List with funcs - ", "")
		StringTrimRight, localdir, A_WorkingDir, 4
		dirfile = %localdir%\res\%dirfile%
	}	else if regexmatch(A_LoopReadLine, "Close the script - (.*)")	{
		exitscript := RegExReplace(A_LoopReadLine, "Close the script - ", "")
	}	else if regexmatch(A_LoopReadLine, "Edit exist scipt\(_\) - (.*)")	{
		createB := RegExReplace(A_LoopReadLine, "Edit exist scipt\(_\) - ", "")
	}	else if regexmatch(A_LoopReadLine, "Show/Hide InfoWindow - (.*)")	{
		showhide := RegExReplace(A_LoopReadLine, "Show/Hide InfoWindow - ", "")
	}	else if regexmatch(A_LoopReadLine, "Timer delay - (.*)")	{
		timerdelay := RegExReplace(A_LoopReadLine, "Timer delay - ", "")
	}
}
HotKey, %exitscript%, Exit
HotKey, %showhide%, showhide
HotKey, %createB%, ContinueScript
GuiControl, ,KeysList, Show/Hide [%showhide%]`nContinue ( ) [%createB%]`nExit [%exitscript%]
GuiControl, disable, check
SetTimer, looplabel, %timerdelay%
SetTimer, looplabel, off
goto recheck
return

showhide:
IfWinNotActive, SWHelper : bass_devware
	gui, show
else	
	gui, hide
return

selectd:
FileSelectFile, SelectedFile, 3, , Open a config.ini, Text Documents (config.ini)
if SelectedFile =
	return
else	{
	GuiControl, , Edit, %SelectedFile%
	GuiControl, enable, check
}
return

looplabel:
SendMessage, 0x50,, 0x4090409,, A
Hotkey, (, on
Hotkey, ), on
Hotkey, Right, on
Hotkey, Left, on
if (oldACaretX = "" or oldACaretY = "")	{
	oldACaretX := A_CaretX
	oldACaretY := A_CaretY
	sleep 1
}
TrayTip, A ,%oldACaretX%`n%oldACaretY%, 1
if (oldACaretX != A_CaretX or oldACaretY != A_CaretY)	{
	SoundBeep, 100, 10
	if (oldACaretY != A_CaretY)	{
		oldACaretX := A_CaretX
		oldACaretY := A_CaretY
		Hotkey, (, off
		Hotkey, ), off
		Hotkey, Left, off
		Hotkey, Right, off
		ToolTip
		SetTimer, looplabel, off
		return
	}
	BlockInput, on
	send, ^+{left}
	Copyed := saveClipboard()
	send, ^{Right}
	BlockInput, off
	AINDEXD := "0"
	if regexmatch(Copyed, "(.)(.)(.)")	{
		Loop, parse, FuncsList, `,
		if regexmatch(A_LoopField, "i)"Copyed)	{
			AINDEXD += 1
			okeylines := okeylines . "`n *"AINDEXD "*" . A_LoopField
		}
		ToolTip, Find function: %Copyed% `n`n %okeylines%, A_CaretX, A_CaretY+50
		okeylines =
	}
}
oldACaretX := A_CaretX
oldACaretY := A_CaretY
return

ContinueScript:
ch := saveClipboard()
if ch != ()
	return
send, {left}
oldACaretX := A_CaretX
oldACaretY := A_CaretY
sleep 100
SetTimer, looplabel, on
return

^+9::
if dirfile =
	return
send, {(}
status = 1
return

^+0::
if dirfile =
	return
send, {)}
if (status)	{
	send, ^{left}
oldACaretX := A_CaretX
oldACaretY := A_CaretY
sleep 100
	SetTimer, looplabel, on
}
status = 0
return

(::
)::
Right::
Left::
return

link:
run, https://vk.com/bass_devware
return

Restore:
Gui,Show
return

exit:
ExitApp
return

saveClipboard()	{
	local
	tmp := clipboardAll
	Send, {ctrl down}c{ctrl up}
	clipWait, 0.5 
	selected := clipboard
	clipboard := tmp 
	return selected
}

GetWords(text, target, separator) {
	result := [], partNumber := 2, parts := StrSplit(text, target)
	Loop,% parts.Length() - 1
	result.Push(StrSplit(StrSplit(parts[partNumber++], "`r`n")[1], separator))
	return result
}