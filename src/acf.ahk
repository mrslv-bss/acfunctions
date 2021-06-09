/*
	Miroslav Bass
	bassmiroslav@gmail.com
	Last stable version: [1.0] 4.14.2019
		~ Release
	Current version: [1.1]
		~ [1.1.1] Code and tabulation optimization

A_CaretX works by asking the system where the caret is. Some code editors does not use the system implementation of a caret, therefore the system does not know where's caret is. 
In a way, it has no caret, just an imitation of one.
Accordingly, keep in mind that the script may not work in VSCODE, Notepads (Basic notepad working) and other.
*/



#Persistent
#SingleInstance, Force
#InstallKeybdHook
#InstallMouseHook
CoordMode, Caret
OnExit, exit
TryAgain:
if not A_IsAdmin
	Run *RunAs "%A_ScriptFullPath%",,UseErrorLevel
if (errorlevel)	{
	MsgBox, 262212, ACFunctions, ACF`, was NOT run as administrator.`n`n===`nFor the text erase function to work correctly, the script must be run by the administrator.`n`nPress Yes - to run as administrator.`nPress No - to continue.
	IfMsgBox Yes
		goto TryAgain
}

Menu, tray, NoStandard
Menu, tray, add, Restore window, showhide
Menu, tray, add
Menu, tray, add, Quit, Exit
status = 0
Hotkey, (, off
Hotkey, ), off
Hotkey, Right, off
Hotkey, Left, off
HotKey, !^END, Exit
CoordMode, ToolTip
Gui, Add, Edit, x9 y10 w262 h20 +disabled vEdit, DIR\config.ini
Gui, Add, Text, x12 y50 w100 h40 vKeysList, Show/Hide []`nContinue ( ) []`nExit []
Gui, Add, Link, x220 y55 w120 h14 cBlue, <a href="https://github.com/BassTechnologies/acfunctions">Repository</a>
Gui, Add, GroupBox, x7 y30 w115 h65 , Config Settings
Gui, Add, Button, x230 y35 w40 h15 gselectd, Select
Gui, Add, Button, x188 y35 w41 h15 gcheck vcheck +disabled, Check
Gui, Show, w275 h100, ACFunctions
return

/*
Shift + Ctrl + ( + ) - start process
Shift + Space - recover process after completion
Alt + Ctrl + END - terminates the script immediately (should be changed by rewrite in config)
*/

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
	}	else if regexmatch(A_LoopReadLine, "Show/Hide menu - (.*)")	{
		showhide := RegExReplace(A_LoopReadLine, "Show/Hide menu - ", "")
	}	else if regexmatch(A_LoopReadLine, "Timer delay - (.*)")	{
		timerdelay := RegExReplace(A_LoopReadLine, "Timer delay - ", "")
	}
}
HotKey, !^END, Off
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
Gui, Show, % (i := !i) ? "Hide" : ""
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
	oldACaretX := A_CaretX, oldACaretY := A_CaretY
	sleep 1
}
TrayTip, A ,%oldACaretX%`n%oldACaretY%, 1
if (oldACaretX != A_CaretX or oldACaretY != A_CaretY)	{
	SoundBeep, 100, 10
	if (oldACaretY != A_CaretY)	{
		oldACaretX := A_CaretX, oldACaretY := A_CaretY
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
oldACaretX := A_CaretX, oldACaretY := A_CaretY
return

ContinueScript:
ch := saveClipboard()
if ch != ()
	return
send, {left}
oldACaretX := A_CaretX, oldACaretY := A_CaretY
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
	oldACaretX := A_CaretX, oldACaretY := A_CaretY
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

saveClipboard()	{
	local
	tmp := clipboardAll
	Send, {ctrl down}c{ctrl up}
	clipWait, 0.5 
	selected := clipboard
	clipboard := tmp 
	return selected
}

Exit:
ExitApp