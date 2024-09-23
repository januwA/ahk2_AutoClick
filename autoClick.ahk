#Requires AutoHotkey v2.0

global my_pause := false ; 暂时暂停脚本
global click_delay := 30 ; 点击延迟

; 配置窗口表单
MyGui := Gui("+Resize", "配置")
MyGui.AddText(, "点击间隔(ms):")
MyGui.AddEdit("vclick_delay ym w100", click_delay)  ; ym 选项开始一个新的控件列.
MyGui.AddButton("default", "OK").OnEvent("Click", ProcessUserInput)

ProcessUserInput(*) {
  Pause(1)
  Saved := MyGui.Submit()  ; 将命名控件的内容保存到一个对象中.
  global my_pause := false
  global click_delay := Integer(Saved.click_delay)
}

; 在托盘菜单中加上配置按钮
A_TrayMenu.Insert("E&xit", "配置", ConfigCallback)
ConfigCallback(*) {
  Pause(1)
  MyGui.Show()
  global my_pause := false
}

Pause ; 开启后暂停脚本
Insert:: {
  Pause(-1) ; 按一次热键可暂停脚本. 再按一次即可取消暂停
  global my_pause := false
}

~e:: ; e技能按下
~q:: ; q技能按下
~LButton:: ; 鼠标左键按下重击
~RButton:: ; 鼠标右键按下冲刺
{
  if (A_IsPaused == 0) {
    Pause(1)
    global my_pause := true
  }
}
~e up::
~q up::
~LButton up::
~RButton up::
{
  if (my_pause) {
    Pause(0)
  }
}

SetKeyDelay -1

loop {
  Sleep click_delay
  SendEvent "{Click}"
}
