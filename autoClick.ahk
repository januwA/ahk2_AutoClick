#Requires AutoHotkey v2.0

global loop_delay := 300 ; 点击延迟
global f_key := 1 ; f键连发

; 配置窗口表单
MyGui := Gui("+Resize", "配置")
MyGui.AddText(, "点击间隔(ms):")
MyGui.AddText(, "f连发:")
MyGui.AddEdit("vloop_delay ym w100", loop_delay)  ; ym 选项开始一个新的控件列.
MyGui.AddCheckbox("vf_key Checked" f_key, "")
MyGui.AddButton("default", "OK").OnEvent("Click", ProcessUserInput)

ProcessUserInput(*) {
  Saved := MyGui.Submit()  ; 将命名控件的内容保存到一个对象中.
  global loop_delay := Integer(Saved.loop_delay)
  global f_key := Saved.f_key
}

; 在托盘菜单中加上配置按钮
A_TrayMenu.Insert("E&xit", "配置", ConfigCallback)
ConfigCallback(*) {
  MyGui.Show()
}

~f12::
{
  global f_key := not f_key
  TrayTip
  TrayTip((f_key ? "[启动]" : "[关闭]") . " f连发")
}

~f:: ; 按下f键 拾取
{
  if (!f_key) {
    return
  }
  loop 20 {
    SendEvent "{f}"
    Sleep 100
    ; if (!GetKeyState("f", "P")) { ; 抬起f键
    ;   break
    ; }
  }
}

~e:: ; e技能按下
~q:: ; q技能按下
~LButton:: ; 鼠标左键按下重击
~RButton:: ; 鼠标右键按下冲刺
{
  Pause(1)
}

~e up::
~q up::
~LButton up::
~RButton up::
{
  Pause(0)
}

~PgUp::
{
  global loop_delay += 100
  TrayTip
  TrayTip("[延迟] " . loop_delay)
}
~PgDn::
{
  if (loop_delay - 100 < 30) {
    global loop_delay := 30
  } else {
    global loop_delay -= 100
  }
  TrayTip
  TrayTip("[延迟] " . loop_delay)
}

SetKeyDelay -1

~Insert:: ; 按下开关，启动
{
  TraySetIcon(A_AhkPath, 2)

  loop {
    Sleep loop_delay
    SendEvent "{Click}"
    if (!GetKeyState("Insert", "T")) { ; 再次按下开关，关闭
      TraySetIcon(A_AhkPath, 1)

      break
    }
  }
}
