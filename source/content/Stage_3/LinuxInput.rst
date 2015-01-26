.. seealso::
   * `linux input子系统详截 <http://wenku.baidu.com/view/a6c4b6bfc77da26925c5b001.html>`_  %IF{" '' = '' " then="" else="- "}%
   * `Android 【真机】与【模拟器】触摸屏事件的模拟差异分析 <http://www.linuxidc.com/Linux/2011-06/37906.htm>`_  %IF{" '' = '' " then="" else="- "}%
   * `区分/dev/tty、/dev/console、/dev/pts、/dev/ttyn <http://bbs.chinaunix.net/thread-2080479-1-1.html>`_  %IF{" '' = '' " then="" else="- "}%

thinking
--------


*sendEvent*
linux内核是支持事件，与输入设备的操作，你可以加入伪信号来实现，例如发送一个事件，就像windows下面的那sendMessage一样。直接像设备发送十六进制数据来模拟各种操作。就相当于直接写寄存器了。


-- Main.GangweiLi - 27 Oct 2012


*/dev/full /dev/zero   /dev/null  /dev/random*
/dev 下面有各种各样的特殊设备，例如些都可以模枋一些低层需求。

-- Main.GangweiLi - 03 Apr 2013


*wall* sends a message to everybody logged in with their mesg permission.


linux实现了对物理设备与逻辑设备的映射关系。当然了映射关系，再加上context机制的分时，就可以分时复用了。同时我们还可以做一些伪设备来发送数据。来达到虚拟化的效果，并且这个mapping规范化就是虚拟机了。
原来进程模型，stdin指就是键盘，而stdout就是文本显示器。同时出错也是显示器。
进程再输入与输出以出错信息。在linux都是以文件方式来进行。
