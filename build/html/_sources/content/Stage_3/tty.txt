tty console
===========

现在终于明白了tty的设计原理了。简单的理解，就是一个socket通信。并且把两端通用化。例如一些编辑的功能，例如具备一些editor的初步功能。
一个最简单功能，那就是直接for循环，就可以搞定。拿浏览器来做对比，就会一目了然，那就是终端也需要一定的rendering功能。 而这些不是应用程序本身需要
考虑的功能。

未来的terminal 趋向于全终端editor+ browser + session management 的功能。例如QTconsole能够支持图表与公式的功能。

例如tmux 来实现多session的管理。以及asciinema 的录制。 
以及各个session之间的共享，其实就是socket的组播功能。

pts的原理，http://www.baike.com/ipadwiki/PTS

ssh,telnet这些与在本地的xterm都同相同地方，那就是其输入输出连接一个终端。并且都是双工通信或者三工通信，in,out,error.  而对于终端来说，那就是一个master,slave,一个读一个写。要正好与进程之间反过来才行。 而这些都是要终端打交道。


/dev/console 总是指向系统的TTY，它决定了系统的信息往哪里输出，/dev/tty0总是指向当前的tty, tty[1-x] 则是独立逻辑tty设备。


terminal 中显示符号
===================

这个关键是编码与字体的支持，只要有两者的支持就能显示，例如 `在terminal中显示数学符号 <https://unix.stackexchange.com/questions/96591/is-it-possible-to-show-mathematical-symbols-in-the-terminal>`_

远程网络shell之间
=================

ssh 的过程。
远程网络终端和本机shell之间建立了一条双向通道--“远程网络终端-(套接字)--本机协议处理进程--主终端--从终端--shell”

serial IO 的原理
================

CPU -> driver ->bus ->I/O pin
http://www.tldp.org/HOWTO/Serial-HOWTO-4.html

