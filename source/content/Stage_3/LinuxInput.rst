Input设备
=========

核心问题，如何实现硬件输入与逻辑对象之间的映射。

.. image:: http://www.emyard.com/wp-content/uploads/2018/05/clip_image002.jpg
.. image:: http://www.emyard.com/wp-content/uploads/2018/05/clip_image003.jpg

Document/input/input-programming.txt
键盘模式：
键盘模式有4种， 在Linux 下可以用vc_kbd_mode（老版本中是kbd_mode）参数来设置和显示模式：
1） Scancode mode （raw ）raw模式：将键盘端口上读出的扫描码放入缓冲区
2） Keycode mode (mediumraw) mediumraw模式：将扫描码过滤为键盘码放入缓冲区
3） ASCII mode (XLATE ) XLATE模式：识别各种键盘码的组合，转换为TTY终端代码放入缓冲区
4） UTF-8 MODE (UNICODE) Unicode 模式：UNICODE模式基本上与XLATE相同，只不过可以通过数字小键盘间接输入UNICODE代码。
   在keyboard.c中，不涉及底层操作，也不涉及到任何体系结构，他主要负责：键盘初始化、键盘tasklet的挂入、按键盘后的处理、keymap的装入、scancode的转化、与TTY设备的通信

#. 信号流程
   
   * 硬件中断-> input subsystem->

#. udev的关系
   
   * /lib/udev/hwdb.d/60-keyboard.hwdb,键盘的mapping也都在这个文件里。

#. linux 各个位置文件的位置
#. 触摸屏的检测， 可以driver检测然后上报 input-subsystem. 只是前端不同。对于后端可以保持不变。
   * 触摸屏的虚拟键，只要driver能识别上报就行。

#. 如何troubleshoot
   * evtest  :* apt install evtest*
   * xev 
   
   .. code-block:: bash
      
      udevadm hwdb --update
      udevadm trigger /dev/input/eventXX

从这个 `https://bugs.launchpad.net/ubuntu/+source/systemd/+bug/1597415`_ 分析开始。 

硬件与driver 的关联是在

*/proc/bus/input/devices 这里对应的， handlers + devices.
* In /lib/udev/hwdb.d/60-keyboard.hwdb


最终真实硬件，都会变成文件对象，其实大部分的硬件都是基于寄存器的，无非提供了硬件复用机制，就像CPU一样，同样的道理适用于其他硬件，首先每一个硬件抽象化，然后映射到真实硬件的部分。而每一个抽象硬件，都有其独立寄存器，就像所谓的context,正所谓的open,close其实本质就是实现一个小的context,并且实现环境切换以得到复用，这也是 with context manager的实现的原理。

`ioctl <http://baike.baidu.com/link?url=xSR7hRAezhCFEgGa2o1n8ncvsY1LgnI1Qx6xahZpBQjuJ9pLzyIPJK1bakVVQqvKL5k1x-zdbDX-E2tk8ZM3Aa>`_ 大部分硬件都是基于寄存器，而一段时间内得到具体控制可以用ioctl来对I/O 通道进行管理。

对于xterm 更是如此，同一套硬件，还要多欠mapping,输入的多次，输出的多次。

所谓的无非就是查看共同一块数据而己，同时具有读写功能。本质那就是对同一个文件进行同时打开两次，并且都具有读写功能。这个也就是os.openpty,的功能，先得到pty,然后再打开一次，相当于一个主，一个slave.
可以用 os.open打开同一个文件即可。并且不用缓冲区即可。

.. seealso::
   * `linux input子系统详截 <http://wenku.baidu.com/view/a6c4b6bfc77da26925c5b001.html>`_ 
   * `Android 【真机】与【模拟器】触摸屏事件的模拟差异分析 <http://www.linuxidc.com/Linux/2011-06/37906.htm>`_  
   * `区分/dev/tty、/dev/console、/dev/pts、/dev/ttyn <http://bbs.chinaunix.net/thread-2080479-1-1.html>`_  

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

最原来的字符终端设备已经没有了，所以理解起来比较困难。本身就是一个显示与输出，有类似于键盘+屏幕一样的。 但是伪终端，从设备这一端与进程相联系的，而主役备是由窗口管理系统控制，与真正的终端的mapping是内核与窗口管理系统控制。 就是缓冲区，采用类似于进程一样的结构，来达到复用的效果。


linux 分三大块，CPU,内存，I/O. 最复杂的也就是IO设备，也就需要各种各样的驱动了。
对于终端的各种key的翻译可以用 stty 来进行设备，例如backspace是删除等等都保存在termio中。

pty 是采用的动态分配的机制，每一次需要的时候去 打开 ptmx 会自动得到主设备，然后去打开一个从设备，然后主从之间就可以通信了。就像pipe 是一样的。

操作模型
--------

#. open /dev/ptmx 得到 master fd_master
#. grantpt(fd_master)
#. unlockpt(fdm)
#. slavename = ptsname(fd_master)
#. fd_slave=open(slavename)

http://wenku.baidu.com/view/53d0daf8aef8941ea76e05d2.html


其实也简单，只要共享同一个文件就行了，并且实时更新，相当于共享了session. 也就是我们要共享shession. 例如ssh 共享session. 在python 中有直接pty模块，也可以spawn pty.
