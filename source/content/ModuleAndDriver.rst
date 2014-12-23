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

when you plug in a new device such as USB. which label "sdb..." will be used for it. here you can use udev. 
1. db store the user device information
1. *rule* how to recognize the device.  当你发现你的OS在新的硬件上，不识别，例如网卡不能用了，第一步那就是先把这个rule给删除了。* rm -fr /etc/udev/rules.d/*
1. `udev的实现原理  <http://blog.csdn.net/absurd/article/details/1587938>`_ 
1. `使用udevadm修改usb优盘在/dev下的名字 <http://blog.csdn.net/fjb2080/article/details/4876314>`_ 
1. `Linux┊详解udev <http://www.mike.org.cn/articles/linux-xiangjie-udev/>`_ 

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
一般是要把module放在 :fifle:`/lib/modules/<kernel version>/kernel/driver/net` 以及去修改 :file:`/etc/modules.d/<kernel version`
2.4 的版本 用的是module.conf,而2.6的版本用是modeprobe.conf
所以多个硬件可以共用一个driver,只需要用alias 把硬件本身映射到一个别名。

