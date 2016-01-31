linux 的生与死
==============

先由BIOS上电之后，由BIOS决定你从哪一个分区起，然后BIOS把对应分区的上bootloader 加载。然后bootloader把kernel的代码，以及所需要东东，都加载到内存里放一个地方。然后再kernel开始初始内存，建立内存表，以及中断表等等之后，然后才是种driver的加载。然后各个东东才开始各自的执行。builtin与module进去，采用都是相同的结构。module的内存结构。
内存结构可以用http://code.metager.de/source/xref/linux/utils/kmod/libkmod/libkmod-module.c#63 这里看到，采用的struct然后里边就是指针了。形成一个列表。insmod,rmmod插入，列表，查询列表的过程。


   linux 启动模式是由 `linux的运行模式：Runlevel详细解析 <http://linux.ccidnet.com/art/9513/20070428/1072625&#95;1.html>`_  决定的，它是由 `/etc/inittab <http://book.51cto.com/art/200906/127324.htm>`_  来控制的，telinit 是用来发送信号进行init. shutdown reboot都是跟 runlevel相关，默认的level,都在rc.XX.d下软链接，并且也是00-99的数字，并且SK表示特殊的意义来开始。原来的GTL的方式是在学习RC 机制。
   
   
   对于系统的控制，很大部分那就是各种service的起动的控制，系统基本起来了，就是各种服务进程，这个主要就在init.d这个阶段进行，如何开机自己等都是在此做的，同时自己需要一些定制的也主要集中此的。
   
   对于ubuntu简单直接，/ect/rc.local就可以了。并且可以查看rc.d 这个目录下东东。 这个每个系统也是不一样的。同时有些系统已经支持并行启动了，例如SUSE中已经支持了。具休可查看/ect/rc.d/README,并且在/etc/rc.d/boot中控制。 一旦并行就会有步同步依赖的问题，也这也是各种before,after 机制的原因，这些就是用来控制顺序的吧。

实践上 init 现在已经支持并行了，并且之间也是有依赖关系与event的话，起动依赖配置放在 /etc/init/XX.conf中, 所以当然也可以对此的应用如此的定制。

gentoo用OPENRC来实现一套并行机制， centos则采用的队列来实现机制。http://man7.org/linux/man-pages/man7/dracut.modules.7.html
主要的功能那就是rc本身也支持语法输法，这样就可以很方便的进行定制。 
init 是一个event-based daemon,1号进程. 给出更宽泛的地义，那是context, exec 等等。 只管输入输出，与环境变量。
http://linuxmafia.com/faq/Admin/init.html， *sbin/init* 是第一进程。 rc-.>(run control).
http://leaf.sourceforge.net/doc/bootproc.html,linuxrc->init->RC.

各家系统的对比。
https://wiki.gentoo.org/wiki/Comparison_of_init_systems

以及现在XIP, execute in place技术，直接起动，而不需要加载,例如使用ROM等等。这样可以大大加快启动的速度。这种一般是直接从 flash来读kernel，主要是一些嵌入式的设备。 直接启动。而不需要向PC这样的复杂。

   对于SUSE 是有一些麻烦，要用到http://unix.stackexchange.com/questions/43230/how-to-run-my-script-after-suse-finished-booting-up， 写标准init 脚本并注册了。当然也简单的做法例如直接/etc/rc.d/after.local 等来进行hook, http://www.linuxidc.com/Linux/2012-09/71020.htm.
   对于windows 来说，也就是注册表了开机启动了。
   不同的系统对于这部分都有不同的优化。

ubuntu 中bootup https://help.ubuntu.com/community/UbuntuBootupHowto, 并且这里有一个service 的模板可以用。

内核的启动与一般函数调用
========================

是一样的，或者一个复杂的命令行而己，就像gcc一样，哪些自身的参数，哪些是传给你init,哪些是传给module中。
都可以在这里查到的。
http://man7.org/linux/man-pages/man7/bootparam.7.html
https://www.kernel.org/doc/Documentation/kernel-parameters.txt

例如要不要使用 initrd,可以直接使用 noinitrd,就可以了。具体其他的起动参数都是可以从上面的文档中查到。

对于启动的时候，initramfs 都是initrd的压缩版，只是把当前文件系统的一些东东直接cpio,gzip打包成.img而己。并且也都有现成工具可以来做。
http://www.stlinux.com/howto/initramfs
http://www.ibm.com/developerworks/cn/linux/l-k26initrd/index.html
https://wiki.ubuntu.com/Initramfs
http://lugatgt.org/content/booting.inittools/downloads/presentation.pdf

什么需要呢，例如些module没有编译在内核里，但是启动又需要的。这些就需要的。这样可以启动内核做的很少，然后灵活的定制。 这里就有一个问题，操作系统是什么加载driver的。
并且由bootloader 利用 initrd 建立一个  / root system. 并在这里起动 kernel.
http://www.mjmwired.net/kernel/Documentation/initrd.txt
read the init code of linux kernel. to understand the shell and interpreter programming.   
`Linux系统下init进程的前世今生 <http://bbs.chinaunix.net/thread-3685404-1-1.html>`_   `init/main.c sourcecode <http://lxr.linux.no/linux-old+v0.11/init/main.c#L168>`_ 


`Linux系统启动过程分析详解 <http://wenku.baidu.com/view/f439355777232f60ddcca152.html>`_ 
module 加载在 /etc/init.d/kmod 里实现的加载哪一个driver,并且加载的顺序。而这些应该在init之前。

http://leaf.sourceforge.net/doc/bootproc.html 这里说细的linux启动流程。

并且启动过程是可以打断的加入参数 break=init就可以了，或者在起动的时候按快捷键，例如按 Ifor gentoo os.https://wiki.debian.org/BootProcess


init 开始并行化，event_base化。
https://en.wikipedia.org/wiki/Init，有各种各样的 init. 


mdev是用来创建 /dev的目录， 使用方法
https://git.busybox.net/busybox/tree/docs/mdev.txt?h=1_18_stable

所以当你发现硬件没有发现的时候，直接使用 :command:`mdev -s`, 就可以了。
或者

.. code-block::
   
   mount -t sysfs sysfs /sys 
   sysctl -w kernel.hotplug=/sbin/mdev
   mdev -s


