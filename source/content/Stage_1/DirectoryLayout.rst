********************
Linux 的目录结构
********************

.. figure:: Stage_1/images/linux_file_tree.png
   :align: center
   :alt: alternate text
   :figclass: align-center

   Linux 树状目录结构表

简单类比 windows 
================

.. csv-table::
   :header: "Linux", "Windows"
   
   "/usr", "C:\\Programe files"
   "/lib", "C:\\windows\\system32"
   "/etc",  "Windows Registery"   

最基本目录
==========

:file:`/bin,/dev,/etc,/lib,/proc,/sbin,/usr,/home,/root,/mnt`

常用目录
========

#. /home: 存放各用户的主目录。

   * /home/<username>/.config
   * /home/test/.config/autostart/xxxx.desktop
   * 各种各样的配置文件 例如 `.bashrc`

#. /etc: 系统设置文件

   * /etc/init.d/  开机启动的服务
   * /etc/apt/     apt-get 配置

#. **/var/log : 系统的log**

   * dmesg     */var/log/dmesg*
   * boot.log  */var/log/boot.log*
   * XWindow log  */var/log/Xorg.0.log*
   * system log  */var/log/syslog*

#. /usr: 安装主要的系统文件和软件

   * /usr/include/: 头文件的位置；
   * /usr/src: 内核和软件的源代码的位置；
   * /usr/local: 安装外来软件的地方；

#. /lib: 库文件以及driver；
   
   * 网卡的driver目录 *lib/modules/`uname -r`/kernel/drivers/net/ethernet*  

#. /dev: 设备文件，主要是各种驱动；
   
   * /dev/sda*   硬盘
   * /dev/tty*   Terminal
   * /dev/null 
   * /dev/urandrom 随机数生成器
   * /dev/stdin,/dev/stdout,/dev/stderr
     
     .. code-block:: bash
        
        echo "hello world" > /dev/stdout
       
#. /proc: Linux 内核的接口，可以通过它在运行时获取、改变系统内核的许多参数；但是逐渐 /sys 取待

   * 各个进程的内核信息 /proc/<pid>
   * 系统所有mount信息  /proc/mount
   * 系统的上线时间     /proc/uptime
   * 开机启动参数       /proc/cmdline  
   * 内核的sysbol表     /proc/kallsysms

#. /boot 系统启动用的文件 : grub config, initrd,vmlinuz；
   
   .. code-block:: bash
      $ ls /boot/
      grub
      config-4.13.0-37-generic
      initrd.img-4.13.0-37-generic
      vmlinuz-4.13.0-37-generic

#. /tmp: 用于创建临时文件或目录；系统重启就会清空
#. /bin： 用来存储用户命令和可执行程序
#. /sbin: 包含一些主要供超级用户用的可执行程序；
#. /mnt: 外挂设备的挂接点；
#. /root: 超级用户的目录；









