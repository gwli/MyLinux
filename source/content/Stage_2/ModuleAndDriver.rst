==============
Module与driver 
==============


linux下driver的安装还是很有挑战的，会遇到各种的不兼合，并且会无法适从。但是明白其加载原理之后，自然一切都了然于心了。

driver起的就是逻辑设备，要想到一个linux中使用一个设备，就为其建立一个逻辑设备也就是driver,正是因为这一层逻辑设备，我们才可以各种虚拟设备。以及实现虚拟化的。

这个映射关心是由udev来做实现的，而driver本身的管理是由modeprobe.conf来管理的。
module的依赖，以及alias,以及blacklist机制,还可以配制module的参数。并且还可以不用加载直接执行就可以直接执行的。每一个module,driver的管理配置都可以放在 `etc/moduleprobe.d/` 下面。

`kernel modules <https://wiki.archlinux.org/index.php/kernel_modules>`_ 

例如  http://askubuntu.com/questions/112302/how-do-i-disable-the-nouveau-kernel-driver 就是利用了blacklist


并且一般情况下换了硬件之后，OS不工作了，或者工作不正常了，例如桌面进不去了换了显卡之后，只要重装一下，所有状态reset为正常值应该就好了。
例如 `sudo apt-get install nvidia-331` 然后 `reboot` .

device Management
-----------------

这个事情起因是在这里http://www.kroah.com/linux/talks/ols_2003_udev_paper/Reprint-Kroah-Hartman-OLS2003.pdf
原因硬件命名规则太死板了，例如硬盘太多，原来那种major/minor号又不够。 因为每位都8位，并且还有很预留的，另外
是热插拔的硬件很多，总不能都事先留着吧，那样/dev的目录太大了。另外也能保证每一次都在同一个地方。这样内核就头疼了。

后边就有udev这种方法，由kernel只告诉用户有硬件来了，它叫什么名字，由你告诉我，然后再用对应的driver来读取他。
也就是为什么多个硬件可以共用一个driver,或者你可以靠一个假的硬件原因。现在有了逻辑设备。 driver与逻辑设备对应。
我可以指这个mapping,也可以系统自己生成。系统采用第一次生成后保存下来。以后延用。

mdev,udev两者实现的基理不同，udev采用 netlink的机制，自己造一个Dameo来检测 uevent,而mdev 则是注册一个回调函数来实现。 /sys/kernel/hotplug 。http://blog.csdn.net/lifengxun20121019/article/details/17403527

http://git.busybox.net/busybox/plain/docs/mdev.txt
http://wiki.gentoo.org/wiki/Mdev

when you plug in a new device such as USB. which label "sdb..." will be used for it. here you can use udev. 
1. db store the user device information
1. *rule* how to recognize the device.  当你发现你的OS在新的硬件上，不识别，例如网卡不能用了，第一步那就是先把这个rule给删除了。* rm -fr /etc/udev/rules.d/*
1. `udev的实现原理  <http://blog.csdn.net/absurd/article/details/1587938>`_ 
1. `使用udevadm修改usb优盘在/dev下的名字 <http://blog.csdn.net/fjb2080/article/details/4876314>`_ 
1. `Linux┊详解udev <http://www.mike.org.cn/articles/linux-xiangjie-udev/>`_ 


如果你想定义硬件的命名等都是可以用 udev.rules 来解决的。
`writing udev rules <http://www.reactivated.net/writing_udev_rules.html>`_ . 

如何写查询属性可以用  :command:`udevinfo` 或者 :command:`udevadm info -qury=property -path=/sys/block/sda`

driver 之间的依赖关系是由LKM来管理，`如何自动加载与实现逻辑设备与物理设备的mapping <http://blog.csdn.net/ruixj/article/details/3772798>`_ 主要是对应的pci数据结构，每一个硬件都会用vender,device ID,以及相对应的subID，是通过udev来实现的与管理的，这个就像windows，pnpUtils是一样的。

每一个设备成功后都会占用一个端口号或者内存地址段。应该是每一个硬件都会ID之类的东东，内核来做了这个mapping,例如eth0 对应哪 一个网口。 就像我们在NEAT所做的，逻辑设备与物理设备之间的mapping. 并这个关系更规范与通用化一些。
  
kernel module  driver install and debug
---------------------------------------

kernel module usually end with *xxx.ko*.  from linux kernel 2.6, the kernel use dynamic mechanism. you dynamically insmod,rmmod .  use the depmod to generate /lib/modules/2.6.xx/modules.dep and then modprob would automatically insert the module according the modules.dep.  the driver is one of module.  the module could have alias name. 

.. csv-table::
   :heder: Item,Content,Remark 

   module location , */lib/modules/kernel version /kernel/drivers* ,  ethernet card driver  /lib/modules/2.6.4-gentoo-r4/kernel/drivers/net/r8168.ko ,
   configuration file , etc/modules.autoload.d/XX , you just need to add the module name here. etc/modules.autoload.d/kernel-2.6 ,
   modprobe ,  modprobe  r8168.ko  , the module could have alias name.  etc/modprobe.d/XXXX ,
   depmod  , depmod -a r8168 ,
   dmesg  , kernel会将开机信息存储在ring buffer中。您若是开机时来不及查看信息，可利用dmesg来查看。开机信息亦保存在/var/log目录中，名称为dmesg的文件里。 , dmesg用来显示内核环缓冲区（kernel-ring buffer）内容，内核将各种消息存放在这里。在系统引导时，内核将与硬件和模块初始化相关的信息填到这个缓冲区中。内核环缓冲区中的消息对于诊断系统问题 通常非常有用。在运行dmesg时，它显示大量信息。通常通过less或grep使用管道查看dmesg的输出，这样可以更容易找到待查信息。例如，如果发现硬盘性能低下，可以使用dmesg来检查它们是否运行在DMA模式：,
   
.. seealso::

#. `解析 Linux 内核可装载模块的版本检查机制 <http://www.ibm.com/developerworks/cn/linux/l-cn-kernelmodules/>`_ 以及 `如何突破其CRC验证 <http://blog.aliyun.com/1123>`_ 简单直接把crc值，直接在elf里改成符合规定的值，说白了就是凑答案 .
#. `module common command <http://wiki.linuxdeepin.com/index.php?title=Linux%E5%86%85%E6%A0%B8%E6%A8%A1%E5%9D%97>`_ 以及其`实现机制 <http://read.pudn.com/downloads37/sourcecode/unix_linux/124135/Linux%E5%86%85%E6%A0%B8%E6%A8%A1%E5%9D%97%E7%9A%84%E5%AE%9E%E7%8E%B0%E6%9C%BA%E5%88%B6.PDF>`_ . 

.. code-block::
   
   $dmesg | grep DMA 



内核检测到硬件，然后去加载mapping的driver,在加载的过程中要经过modeprobe.conf这样的过虑，并且解决其依赖关系。没有对应关系就要手工加载了。 
一般是要把module放在 :file:`/lib/modules/<kernel version>/kernel/driver/net` 以及去修改 :file:`/etc/modules.d/<kernel version`
2.4 的版本 用的是module.conf,而2.6的版本用是modeprobe.conf
所以多个硬件可以共用一个driver,只需要用alias 把硬件本身映射到一个别名。


内核的调试

`Linux 系统内核的调试 <http://www.ibm.com/developerworks/cn/linux/l-kdb/>`_  主要有三种kgdb,SkyEye,UML三种技术。


intel  ethernet 153a 网卡不稳定
-------------------------------

查看问题的，第一个要收集信息，不要轻易破坏了环境。尽可能多的收集信息
#.  保存error 信息
#.  save /var/log/dmesg  与 /var/log/syslog
#.  查看 是否内核加载了 cat /proc/modules |view -
#.  根据error message进行初步的推理并验证
#.  提炼你的问题，一句话，几个词
#.  ehtools 查看并且修改硬件。
#.  insmod -m 查看插入时信息
#.  看看没有新版本可以用，看看CL.   http://sourceforge.net/projects/e1000/
#.  去官网查看相关的FAQ 以及bugs.  http://sourceforge.net/p/e1000/bugs/430/
#.  还有那是 READE
#.  最后看一个 开发framework,去找一个init, close函数，只需要看看其做了什么，就知道了。

driver 的开发
=============

一般都是register, init, shutdown, close等等几个函数接口。
http://10.19.226.116:8800/trac/ticket/2705
就是标准 .so 只是链接的库不同，以及编译的选项要与主机匹配。
http://www.tldp.org/LDP/lkmpg/2.6/html/x181.html 有详细的教程


内核的编译都需要内核的头文件，以及symbols表，以及依赖与加载的先后关系。
以及内核的版本号，如果开启了版本的匹配功能，则需要对应，不然不能加载。
