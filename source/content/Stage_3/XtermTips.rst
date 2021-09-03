Introduction
============

在linux中接处最多就是终端，所以熟悉各种的使用技巧与用法，可以大大的提高效率。同时也可以打开多终端实现多用户的并行操作。或者使用expect来实现多用户交互。或者直接使用socket 来进行模似。

windows manager
===============

.. csv-table:: 

   `fvwm <http://www.fvwm.org/>`_  `a good introduction <http://home.ustc.edu.cn/~lixuebai/GNU/FVWM.html>`_ , amiwm,icewm,windowmaker,afterstep,sawfish,kwm, 

*FVWM* 它的采用与Xwindows 通过语法格式。设置一些全局变量，对于是ImagePath,Button,Menu等控制。以及键盘消息的映射。窗口布局的管理。对它的使用也像VIM的配置文件一样。先找来一个模板，然后根据自己的需求来改。 FVWM另外强大的一点那就是可以SHELL 进行交互。也就是配置文件是可以动态的生成的。这样就极大提搞了其灵活性。

Toolkit
=======


.. csv-table:: 

   motif,XForms,FLTK,Gtk,Qt,LessTif,

Desktop Environments
====================


.. csv-table:: 

   CDE Common Desktop Environment , KDE ,GNOME,GUNStep,ROX,GTK+XFce,UDE ,`Xview/OpenLook <http://step.polymtl.ca/~coyote/xview_main.html>`_ , 

FIle manager
============


.. csv-table:: 

   gmc ,Nautilus,

#StandIOTerminal
terminal
========

首先要搞明白的这个定义，终端就是可以主机进行输入输出通信的设备。对于终端的分类与介绍在OS Design and Implementation有详细的介绍。基本上分三类：%BR%<img src="%ATTACHURLPATH%/TerminalType.jpg" alt="TerminalType.jpg"  />

.. csv-table:: 

   `xterm <http://invisible-island.net/xterm/xterm.faq.html>`_ , ,功能强大，最初版本,
   dtterm,,
   rvxt,支持更好的画面，同时支持perl脚本扩展,
   xterm tty pts pty 的区别,`概念区分一 <http://kpshare.blog.51cto.com/1195439/275837>`_  `概念区分之一 <http://topic.csdn.net/u/20100201/17/a34370cc-8a61-4315-a4d0-84242362064d.html>`_ ,

所以对于终端的控制主要是两大类，一个是对其输入的控制，一个就是对其输出控制。 在linux中使用`termInfo <http://billtym.blog.51cto.com/1745172/418510>`_ 来配置终端。其实所有的操作最终都是通过它来起作用。其实是UNIX哲学中，所有算法都是围绕数据结构转的。
#. *对输入的控制* 对于输入模式主要有常见两种那就是RAW模式与cooked 模式。另外一个那就是echo 与否。例外就是一些特殊字符的输入，以及编辑习惯都是都可以设置的，一个重要的话题，对其进行配置，这个可以通过profile 与.shellrc这些文件来进行配置。%BR%

.. csv-table:: 

   setty , 来进行对于输入进行各种设置, setty -echo, set -o, settty ,


#. *对于输出的控制* %BR%

.. csv-table:: 

   颜色与光标的移动, `tput入门使用 IBM <http://www.ibm.com/developerworks/cn/aix/library/au-learningtput/index.html>`_   `tput user manual  <http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x405.html>`_ , 想要对屏幕显示进行个性化设置，可以利用这个命令，例如在屏幕上实现语法高亮等等。,
   ^ , 通过转义字符来实现 ESC [ , 使用echo -e  "ESC [ XX " 来使用, `使用ncurses来操作或者开发 <http://blog.sina.com.cn/s/blog_613454190100lzwl.html>`_ ,

#. *对于TTY的管理控制*  TTY也也是C/S模式，分主端，与从端。一般情况下，主端都是系统建好的。%BR%


`如何查看TTY端口的服务状态 <http://docs.sun.com/app/docs/doc/819-6951/modsafapp-18?l=zh&a=view>`_ , pmadm,ttyadm,contty ,

如何连接，与配置, `linux 设备驱动，TTY驱动 <http://www.deansys.com/doc/ldd3/ch18.html>`_  , `getty <http://stevens0102.blogbus.com/logs/47327581.html>`_ 

连接tty, `清除被占用的tty端口的方法,rmdev ,stty-cxms fuser, pdisalble,strreset <http://blog.chinaunix.net/u/25969/showart_1084733.html>`_ ,` mkdev  <http://study.chyangwa.com/IT/AIX/aixcmds3/mkdev.htm>`_ ,



终端使用技巧
==================

#. 共享terminal环境。利用screen 命令。 

.. csv-table:: 

   `使用 screen 管理你的远程会话 <http://www.ibm.com/developerworks/cn/linux/l-cn-screen/>`_ ,

#. `term 转义字符大全以及颜色大全 <http://hooney.javaeye.com/blog/167062>`_ 
#. `xterm 命令大全 <http://study.chyangwa.com/IT/AIX/aixcmds6/xterm.htm>`_ 
#. `rxvt perl 二次开发 <http://www.perlmonks.org/?node_id=569933>`_ 
#. ` tty,pty 区别与模式 <http://www.svn8.com/linux/WL/20091223/15601.html>`_ 
#. `为什么要用PTY <http://blogold.chinaunix.net/u3/103643/showart_2200383.html>`_ 
#. `PTY 开发 <http://topic.csdn.net/t/20060426/13/4715138.html>`_ 
#. `linux 命令大全 <http://study.chyangwa.com/IT/AIX/aixcmds6/mastertoc.htm#mtoc>`_ 

tmux 使用
=============

tmux 可以把terminal变成vim一样的使用.

#. 分屏 ctl+B,%  ctl+B,"
#. 最大化 ctl+B,z
#. 切换windows   ctrl+B,Q 然后选数字,只是当前的两个切,"
#. 进入copy 模式  ctrl+b,[  , paste ctrl+b,]   ctl+space开始复制,enter/atl+w,ctl+w 结束复制.
#. 进入vim 模式  tmux set -g mode-keys vim

