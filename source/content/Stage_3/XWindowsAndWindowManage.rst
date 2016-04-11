XWindows 与窗口管理
*******************


introduction
============

所有的`GUI框架 <http://blog.csdn.net/baozi3026/article/details/7757293>`_ 主要有两大块，消息处理的机制与窗口布局。消息的路由。经常被隐藏在类的继承里面。

`Xwindows <http://wiki.ubuntu.org.cn/%E7%90%86%E8%A7%A3_Xwindow\>`_ 后面的:a.b是a指的是你的机器起的第几个Xwindows，直接起X 时，是可以指定硬件ID来显示在哪一个显示上。alt+F7~F8来进行切换。可以起多个X server,就像vncserver一样， X :1 &就是一个，1就是偏移量， X window 默认是6000端口，而VNC用了5800，而vnc的http用的是5900端口，这也是为什么VNC最多只能一个百个原因，因为6000以后就被Xwindows占用了。 ubuntu永启动X时是用 unix socket这个只适用于本地进程通信，而不能远程。这也就是为什么无法远程连接的原因。Xdefault 样式表默认配置，xdm是管理器，这样我就可以用telnet直接 Xserver来进行绘制窗口。同时我也可以hook一些事件了。可以进行屏幕录制了。考虑把这个做出来。
整个显示分为几层 
#. 物理屏幕 一块或者多块
#. 逻辑屏幕
#. 窗口
#. 控件，widget
#. 画布
#. 图层
#. 前景与后景
#. 作图
#. 各种种图形组
#. 各个图元
消息传递本质就是if,else判断，MFC是利用宏生成这个if,else的。另一种那就是利用OO的继承机制。或者采用观察者等设计模式来做。

表面上看起来很灵活的东西，发现在最后本质都是一样的，不过在上层利用编译器与宏来做了各种替换优化工作。就像那些模板一样。
各种各样的窗口管理器，处理了平台的相关性。就像OPENGL只处理画布内的内容。

XWindow 的启动分析
==================

SUSE下的启动
------------

:file:`/etc/init.d/xdm` 

没有显示连接的话，*x server* 会起不来。如果还想起就要用 `XVFB(virtual framebuffer X server) <http://www.x.org/archive/X11R7.7/doc/man/man1/Xvfb.1.xhtml>`_ .  或者添加  *AllowEmptyInitialConfiguration* to :file:`xorg.conf` 并且添加 :file:`~/.xinitrc`. 

配制文件里配置分配率 
====================

http://openmind.iteye.com/blog/1319868  或者http://forum.ubuntu.org.cn/viewtopic.php?f=48&t=346103

#. 计算 cvt, 然后把 ModeLine 写入 /etc/x11/xorg.conf
也可以调整显示方向可以在  :command:`xrander --rotate` 也可以用 `xrotate`

.. codeblock:: bash
   
   xrandr --setprovideroutputsource 0x46 0x2b4
   xrandr --output LVDS-0 --off
   xrandr --auto 
   exec startxfce4

https://devtalk.nvidia.com/default/topic/585014/how-to-configure-x-server-to-work-headless-as-well-with-any-monitor-connected-/
https://devtalk.nvidia.com/default/topic/567784/nvidia-325-08-optimus-no-screens-found-ee-/



或者 :command:`nvidia-xconfig --allow-empty-initial-configuration` 

X windows 采用的 properites and components模式，相当于screen一组，对应实体的inputs,mouse, monitor.


如何把VNC 跑在real X display上
==============================

ubuntu 默认的  vino-server直接跑在 real display上的
http://superuser.com/questions/136785/how-do-i-run-vino-server-without-a-monitor-attached-in-ubuntu-10-04

或者使用 X11vnc 并与 --display :0 这样就行了。
http://www.karlrunge.com/x11vnc/

V3L 14.04 下的启动
------------------




X windows 消息机制 
=======================


.. csv-table:: 

   xev -id WINDOW_ID , will print X11 "window events",
   xwininfo , ,
   xtrace ,,
   xeyes ,可以用来监控你的各种动作 ，通过修改xeyes 就会很容易做到 ,
   xdg ,*xdg-utils* 这个下面有很多很好玩的xdg-icon-resource,xdg-desktop-icon/menu xdm-mime,dxm-open,xdg-user-dir，xdg-emial这都是非常实现的Xwindows命令行程序，xdg-email是可以发副件的。xdg-settings 管理各种设置，并且这个是x desktop management. , 
   xgc , you can test various command and feature for xwindows GUI ,you do experiment on it with GUI , 
   `Event Structures <http://tronche.com/gui/x/xlib/events/structures.html>`_  , `Xlib Functions and Protocol Requests <http://tronche.com/gui/x/xlib/appendix/a.html#SendEvent>`_  ,
   xcutsel ,xcursorgen ,
   xlock ,xss , lock and screen saver ,
   xv  , http://www.trilon.com/xv/whatisxv.html ,
   `运用xlib进行事件响应(X11 API)的小例子 <http://socol.iteye.com/blog/579720>`_  , XSelectInput ,event_mask ,  所以在linux你可以hack所有的GUI ,
   `orca <https://projects.gnome.org/orca/>`_  ,The GNOME Desktop Accessibility Guide is for users, system administrators, and anyone else who is interested in how the GNOME Desktop supports people with disabilities from an end user point of view. If you are new to GNOME, you may wish to read this documentation first. ,

xkill 非常好用的的一个kill 工具。
http://blog.csdn.net/xiajian2010/article/details/9796365


Qt
==

`QT 类图 <http://wenku.baidu.com/view/b49a934d2b160b4e767fcfc0.html>`_  Glade GUI设计工具。

FVWM
====


the window manager has three parts, window, menu,button, mouse and keyboard.   
window,menu and button has style/menustyle/buttonstyle to control outline. for the module, there is module config.  these configfile could be substitue two times, so you can Exec to trigger the scripts and also, you could use the m4 to do these. 

*FVWM* 的主要设置，FVWM内部的环境变量。
#. 屏幕工作区域的划分
#. 窗体各种属性，默认大小，开始位置，边框的大小，以及标准button的位置。
#. mouse 的工作模式，click,hold,move的定义
#. focus 的方式，主要是mouse相关。
#. button,与menu的生成。这个都有menustyle与buttonstyle来指定其格式。button 可以关联函数动作，menu也是，mouse与key也是一样的。对于键盘的如何分配可以按照vim的模式还是按照emacs的查式去试一试。
#. 与外部接口。Exec,PipeRead,可以执行各种各样的命令，还有现成的perl接口。`python接口 <http://sourceforge.net/projects/fvwmpy/>`_  haskell.
对于样式表还是可以分组的，这样就构成了theme,利用desc来使用一组样式表。
对于函数一上来，那就是一个switch对于键盘与mouse操作，过滤，对于哪些操作reaction,哪些nop.

对于分屏的操作，PvwmPaper 来控制显示多个 virtual Desktop.

.. csv-table:: 

   http://www.fvwm.org/screenshots/desktops/Tavis_Ormandy-desk-1152x864/screenshot.jpg , try this one ,
   http://www.fvwm.org/screenshots/desktops/An_Thi_Nguyen_Le-desk2-1152x864/screenshot.gif , 
   http://www.fvwm.org/screenshots/desktops/An_Thi_Nguyen_Le-desk3-1152x864/screenshot.gif ,
   http://www.fvwm.org/screenshots/desktops/Remko_Troncon-desk-1024x768/screenshot.gif ,
   http://www.fvwm.org/screenshots/desktops/Paul_Johnson-desk-1280x1024/screenshot.jpg ,
   http://www.fvwm.org/screenshots/desktops/Nuno_Alexandre-1600x1200/screenshot.jpg ,
   http://www.fvwm.org/screenshots/desktops/Michael-desk-1152x900/screenshot.gif ,
   http://www.fvwm.org/screenshots/desktops/Lee_Willis-desk-1024x768/screenshot.gif ,


lockscreen
==========

锁屏一个套独立机制，例如强制占领桌面最前端，其他功能切换不能工作，只有收入密码才能解屏。

X windows 下有不少锁屏工具，例如xlock, 也有gnome-screensaver 来进行设置，而用:command:`gnome-screensaver-command -l` 来进行锁屏。
VNC
===

:command:`gnome-session` 用来开始窗口管理器的。 一般需要在 .xstartup中启动它，不然的话，就会出现只有一个灰色的窗口。

ubuntu 14.04 发现有版本不匹配时可以用。:command:`gsettings set org.gnome.Vino require-encryption false`  
https://bugs.launchpad.net/ubuntu/+source/vino/+bug/1290666


XWindows 恢复
=============

`dconf <http://en.wikipedia.org/wiki/Dconf>`_ 可以用来调整配置

例如XWindow墨屏没有显示可以用. :command:`sudo dconf -f /org/compiz` 进行恢复。 
对于 Gnome 定制可以参考 http://askubuntu.com/questions/22313/what-is-dconf-what-is-its-function-and-how-do-i-use-it

Remote Display
==============

#. `试一试这种远程的显示。把amyl的p4 显示到我的机器上来。 <http://www.hungry.com/~jamie/xexport.html>`_  
#. `Xauth <http://www.acm.uiuc.edu/workshops/cool_unix/xauth.html>`_ 简单的使用文档，xhost权限颗粒太大，Xauth小一些。
#. `where-does-xhost-store-the-allowed-network-addresses <http://stackoverflow.com/questions/689061/where-does-xhost-store-the-allowed-network-addresses>`_  最终还是记录的网络地址，所以当client的IP换了之后，就要删除以前重新加一次，从新获得新的IP。
#. `X windows for android <http://stackoverflow.com/questions/12811124/x-applications-over-ssh-in-android>`_ 现在android就可以很方便远程控制我的电脑了。
   一个最简单的方法那就是利用ssh forwarding, 在linux下

.. ::
 ssh -X 加主机名了
 当然，ssh本身也是可共享的，主要你把设置共享的(-M),ssh本身还有很多好玩的参数可以去看一下其manul. 并且它可以后台运行。
#. `how-to-make-x-org-listen-to-remote-connections-on-port-6000 <http://askubuntu.com/questions/34657/how-to-make-x-org-listen-to-remote-connections-on-port-6000>`_  修改lightdm的配置文件，原来gdm已经被lightdm给换掉了，同时改掉.xserverrc中的那一行。

See also
========

#. `UbuntuHelp:FVWM <http://wiki.ubuntu.org.cn/UbuntuHelp:FVWM/zh>`_  
#. `gentoo FVWM <http://en.gentoo-wiki.com/wiki/FVWM>`_  现在看到gentoo正是自己想要的东东
#. `fluxbox 提供了各种灵活的布局 <http://fluxbox.org/features/>`_  
#. `xmonad <https://wiki.archlinux.org/index.php/Xmonad&#95;&#37;28&#37;E7&#37;AE&#37;80&#37;E4&#37;BD&#37;93&#37;E4&#37;B8&#37;AD&#37;E6&#37;96&#37;87&#37;29>`_  用haskell 编写的窗口管理器，可以不用鼠标
#. `FLTK <http://www.cppblog.com/cyantree/archive/2006/04/16/5670.html>`_  
#. `SynergyHowto <https://help.ubuntu.com/community/SynergyHowto>`_  configuration on ubuntu
#. `fvwm tutorial <http://zensites.net/fvwm/guide/global.html>`_  
#. `understand X Windows <http://docs.huihoo.com/homepage/shredderyin/x.html>`_  
#. `FVWM simple tutorial <http://docs.huihoo.com/homepage/shredderyin/fvwm&#95;frame.html>`_  
#. `fvwm style manual page <http://fvwm.org/doc/unstable/commands/Style.html>`_  
#. `Xmonad (简体中文) <https://wiki.archlinux.org/index.php/Xmonad&#95;&#37;28&#37;E7&#37;AE&#37;80&#37;E4&#37;BD&#37;93&#37;E4&#37;B8&#37;AD&#37;E6&#37;96&#37;87&#37;29>`_  
#. `fvwm buttons introduction <http://forums.gentoo.org/viewtopic.php?t&#61;162177>`_  
#. `aterm-xterm-eterm-rxvt-konsole-oh-my <http://ayaz.wordpress.com/2007/04/07/aterm-xterm-eterm-rxvt-konsole-oh-my/>`_  aterm -tr -trsb -cr red +sb -fg gray -fn fixed -fb fixed   the difference, aterm, would be tranparent, and fixed font such so on. 
#. `ffmeg 屏幕录制 <http://community.spiceworks.com/scripts/show/961-linux-desktop-screen-capture-through-one-command>`_  
#. `x xwindows  常用命令列表 <http://www.x.org/wiki/UserDocumentation/GettingStarted/>`_  

Thinking
========



看来自己当年在TWiki写的东西，要想办法恢复出来，这样的话，把这些给完完全全的给整理出来了。同时把 Work.XVirtualFramebuffer的应用也加载进来。




*xterm bg*

.. csv-table:: 

   Sandy Brown , Brown , Tan ,

系统的颜色表可以在/etc/X11/rgb.txt 中找到。

-- Main.GangweiLi - 12 Dec 2013


今天的实践，只需要简单的调整，就得到自己想要背景了。不过离人家那种界面还差的老远了。一是直接修改了button的执行的参数，来改变了aterm,另外一个那就是利用style把程序xterm 的背景给改掉了。  并且FVWM可以动态的重起，并且还可以直接在console来做一些测试。看来要慢慢形成自己的风格。我会从实际出发，一点点添加功能，现在窗体除了xterm看起来，还是有些丑的，下一步就是要优化这些窗体，但重要的一个事情，那就是把手势语给先加上。另外一个那就是配制管理，网上它们都是利用github上的直接来做的，考虑一下，自己是不是也要这样做一下。实现自己的配制管理。要么就用自己的svn.这个要做起来。

并且X windows中样式表，对于应用程序，与窗体是如何区分，什么时候样式指定的应用程序，什么时候是窗体。

-- Main.GangweiLi - 12 Dec 2013

DRI Direct Rendering Infrastructure. 
RM & DRI
 DRI 全称 Direct Rendering Infrastructure。X11 是采用 C/S 架构的，客户端的任何操作都需要和服务器进行通讯，在实时的 3D 渲染上性能无法接受。DRI 在 X11 上能够允许直接访问硬件渲染器（显卡），从而直接将 3D 图形渲染到屏幕上，绕过 X11 ，提升性能，这种叫作直接渲染（direct render）。DRI 为上层 3D 库提供访问底层硬件的接口。DRM 全称 Direct Rendering Manager，直接渲染管理器，是真正操作硬件的层次。各个硬件厂商负责提供各自硬件的 drm 模块（开源的提供源码、不开源的提供二进制文件）。DRI 通过调用 DRM 的接口来实现上层 3D 图形库的接口。DRI 的源码则在 Mesa 中。

 `x window配置 <http://blog.csdn.net/wangjasonlinux/article/details/9194547>`_


 InputClass 会改把 /dev/input/event中映射过来。


XWindows 设置屏保
-----------------

.. code-block:: bash
   
   Section "ServerFlags"
       # Set the basic blanking screen saver timeout in minutes. 0 to disable.
       Option "blank time" "0"
           
       # Set the DPMS timeouts. 0 to disable.
       Option "standby time" "0"
       Option "suspend time" "0"
       Option "off time" "0"
   EndSection

添加开始菜单
============

在ubuntu 中是可以 ~/.local/share/application 下添加 XXX.desktop来实现。
全局的放在 /usr/share/applications 下面。

哪一类的文件用什么软件打开，这个关联在windows下叫 class,而在ubuntu 中可在 /usr/share/application-registry中实现。


如果没有安装desktop,也可以手动安装，apt-get install Ubuntu-desktop
