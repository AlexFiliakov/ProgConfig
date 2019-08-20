#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.

; script parameters
global large_win_width := 1280
global large_win_height := 800

global small_win_width := 800
global small_win_height := 600
 

; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
 
; Set Lock keys permanently
SetNumlockState, AlwaysOn
; other Locks may vary (Caps, Shift for Excel scrolling)
 
;FREE KEYES:
;shortcuts with bottom row: 0, -, +

; AHK Hotkey Symbols
/* https://www.autohotkey.com/docs/Hotkeys.htm#Symbols
    # := Win
    ! := Alt
    ^ := Control
    + := Shift
*/
 
; Refactor Actions (broadly)
/*
Extract Method
Extract Variable
Rename symbol
https://sourcemaking.com/refactoring/refactorings
*/
 
;map Alt+Wheel to PageUp/Down
;(takes care of Shift+Ctrl mods)
!WheelUp::Send, {PgUp}
+!WheelUp::Send, +{PgUp}
^!WheelUp::Send, ^{PgUp}
+^!WheelUp::Send, +^{PgUp}
 
!WheelDown::Send, {PgDn}
+!WheelDown::Send, +{PgDn}
^!WheelDown::Send, ^{PgDn}
+^!WheelDown::Send, +^{PgDn}


; Open Program shortcuts
#f::
    nav_title := "File Explorer"
    nav_path := "shell:::{679F85CB-0220-4080-B29B-5540CC05AAB6}"
 
    If !WinExist(nav_title)
        Run, %nav_path%,,, win_pid
        Sleep, 20
    ; Sleep, 20
    WinWait, %nav_title%, , 3
    if ErrorLevel {
        WinGetTitle, Title, A
        MsgBox, The active window is "%Title%" (expecting "%nav_title%").
        return
    }
 
    size_and_center_to_mouse(nav_title, small_win_width, small_win_height)
    return
 
; Open CMD (resize doesn't work, PID seems to change to HEX)
#c::
    cmd_path := "cmd"
    ; Run, %cmd_path%, %cmd_dir%,, win_pid
    Run, %cmd_path%, C:\,, cmd_pid
    ; cmd_pid := WinExist("A")
    ; ; MsgBox, %cmd_pid% %id%
    ; ; WinWait, ahk_pid %cmd_pid%, , 3
    ; ; if ErrorLevel {
    ; ;     WinGetTitle, Title, A
    ; ;     MsgBox, Can't find the CMD window, did it open?
    ; ;     return
    ; ; }
 
    ; ; WinWait, ahk_pid %cmd_pid%
    ; WinActivate, ahk_pid %cmd_pid%
    ; CoordMode, Mouse, Screen
    ; WinGetPos x, y, width, height, ahk_id %cmd_id%
    ; MouseGetPos, mx, my
    ; newx :=mx - small_win_width/2
    ; newy := my - small_win_height/2
    ; WinMove, ahk_pid %cmd_id%,, newx, newy, small_win_width, small_win_height
    return
 
;
#s::
    return
 
size_and_center_to_mouse(win_title, win_width, win_height) {
    ; Explorer and CMD aren't interchangeable here
    CoordMode, Mouse, Screen
    WinGetPos x, y, width, height, %win_title%
    MouseGetPos, mx, my
    WinActivate, %win_title%
    newx :=mx - win_width/2
    newy := my - win_height/2
    WinMove, %win_title%,, newx, newy, win_width, win_height
    ; WinShow, %win_title%
    return
}
 
;CapsLock Key
; double-click for Caps Lock Toggle
; otherwise modify Number Pad to arrows
; Capslock::
;     MsgBox "pressed Capslock"
;     KeyWait, Capslock, T1 ; wait for the left mouse button to be released, if it is not released after 1 second, time out and set ErrorLevel to 1
;     if ErrorLevel {
;         Keywait, Capslock ; wait for left mouse button to be released
;         ;Send, {click} ; send a click upon release
;         SetCapsLockState, % (t:=!t) ?  "On" :  "Off"
;     } else {
;         ; ignore single press
;     }
;     return


resize_top_left(hold_button) {
    While GetKeyState(hold_button,"P") {
        CoordMode Mouse, screen
        id := WinExist("A")
        WinGetPos x, y, width, height, ahk_id %id%
        MouseGetPos mx, my
        neww := width  + x - mx
        newh := height + y - my
        WinMove % "ahk_id" id,, mx, my, neww, newh
 
        Sleep, 20
    }
    return
}
 
resize_centered(hold_button) {
    MouseGetPos start_mx, start_my
    While GetKeyState(hold_button,"P") {
        CoordMode Mouse, screen
        id := WinExist("A")
        WinGetPos x, y, width, height, ahk_id %id%
        MouseGetPos mx, my
        neww := width  + x + (start_mx - mx)
        newh := height + y + (start_my - my)
 
        newx := x - (neww - width)/2
        newy := y - (newh - height)/2
        WinMove % "ahk_id" id,, newx, newy, neww, newh
 
        Sleep, 20
    }
    return
}
 
center_window(hold_button) {
    While GetKeyState(hold_button,"P") {
        CoordMode Mouse, screen
        id := WinExist("A")
        WinGetPos x, y, width, height, ahk_id %id%
        MouseGetPos mx, my
        newx := mx - width/2
        newy := my - height/2
        WinMove % "ahk_id" id,, newx, newy, width, height
 
        Sleep, 20
    }
    return
}
 
size_window(w, h) {
    CoordMode Mouse, screen
    id := WinExist("A")
    WinGetPos x, y, width, height, ahk_id %id%
    WinMove % "ahk_id" id,, x, y, w, h
    return
}
 
;WinKey + Wheel to size windows
#RButton::
    center_window("RButton")
    return
 
#LButton::
    resize_centered("LButton")
    return
 
!#MButton::
    size_window(small_win_width, small_win_height)
    center_window("MButton")
    return
 
#MButton::
    size_window(large_win_width, large_win_height)
    center_window("MButton")
    return
 
; doesn't work with mouse bind
; #Enter::
;     resize_top_left("Enter")
;     return
 
;resize window vertically
Wheel_Size_Height(step_size) {
  CoordMode Mouse, screen
  id := WinExist("A")
  WinGetPos x, y, width, height, ahk_id %id%
  WinMove % "ahk_id" id,, x, y-step_size, width, height+step_size*2
  return
}
 
Wheel_Size_Width(step_size) {
  CoordMode Mouse, screen
  id := WinExist("A")
  WinGetPos x, y, width, height, ahk_id %id%
  WinMove % "ahk_id" id,, x-step_size, y, width+step_size*2, height
  return
}
 
#WheelUp::
  Wheel_Size_Height(80)
  return
+#WheelUp::
  Wheel_Size_Height(20)
  return
^#WheelUp::
  Wheel_Size_Width(80)
  return
^+#WheelUp::
  Wheel_Size_Width(20)
  return
 
#WheelDown::
  Wheel_Size_Height(-80)
  return
+#WheelDown::
  Wheel_Size_Height(-20)
  return
^#WheelDown::
  Wheel_Size_Width(-80)
  return
^+#WheelDown::
  Wheel_Size_Width(-20)
  return
 
;Below Overrides typical Winkey+[Ctrl+Shift]+Numkeys
 
;resize window from Top-Left
#^+1::
  resize_top_left("1")
  return
 
;resize window from Top only
#^+2::
  CoordMode Mouse, screen
  id := WinExist("A")
  WinGetPos x, y, width, height, ahk_id %id%
  MouseGetPos mx, my
  newh := height + y - my
  WinMove % "ahk_id" id,, x, my, new, newh
  return
 
;resize window from Top-Right
#^+3::
  CoordMode Mouse, screen
  id := WinExist("A")
  WinGetPos x, y, width, height, ahk_id %id%
  MouseGetPos mx, my
  neww := mx - x
  newh := height + y - my
  WinMove % "ahk_id" id,, x, my, neww, newh
  return
 
;resize window from Left only
#^+4::
  CoordMode Mouse, screen
  id := WinExist("A")
  WinGetPos x, y, width, height, ahk_id %id%
  MouseGetPos mx, my
  neww := width  + x - mx
  WinMove % "ahk_id" id,, mx, y, neww, new
  return
 
;move window
#^+5::
    center_window("5")
    return
 
;resize window from Right only
#^+6::
  CoordMode Mouse, screen
  id := WinExist("A")
  WinGetPos x, y, width, height, ahk_id %id%
  MouseGetPos mx, my
  neww := mx - x
  WinMove % "ahk_id" id,, x, y, neww, new
  return
 
;resize window from Bottom-Left
#^+7::
  CoordMode Mouse, screen
  id := WinExist("A")
  WinGetPos x, y, width, height, ahk_id %id%
  MouseGetPos mx, my
  neww := width  + x - mx
  newh := my - y
  WinMove % "ahk_id" id,, mx, y, neww, newh
  return
 
;resize window from Bottom only
#^+8::
  CoordMode Mouse, screen
  id := WinExist("A")
  WinGetPos x, y, width, height, ahk_id %id%
  MouseGetPos mx, my
  newh := my - y
  WinMove % "ahk_id" id,, x, y, new, newh
  return
 
;resize window from Bottom-Right
#^+9::
  CoordMode Mouse, screen
  id := WinExist("A")
  WinGetPos x, y, width, height, ahk_id %id%
  MouseGetPos mx, my
  neww := mx - x
  newh := my - y
  WinMove % "ahk_id" id,, x, y, neww, newh
  return
 