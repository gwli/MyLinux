Linux 的目录结构
****************

.. figure:: images/LinuxFileTree.png
    :width: 400px
    :align: center
    :height: 200px
    :alt: alternate text
    :figclass: align-center

    Linux 树状目录结构表

#. /bin： 用来存储用户命令和可执行程序
#. /sbin: 包含一些主要供超级用户用的可执行程序；
#. /usr: 安装主要的系统文件和软件
#. /home: 存放各用户的主目录。
#. /etc: 系统设置文件
#. /dev: 设备文件，主要是各种驱动；
#. /proc: Linux 内核的接口，可以通过它在运行时获取、改变系统内核的许多参数；
#. /mnt: 外挂设备的挂接点；
#. /root: 超级用户的目录；
#. /boot 和 /initrd: 系统启动用的文件；
#. /lib: 库文件；
#. /tmp: 用于创建临时文件或目录；
#. /usr/include/: 头文件的位置；
#. /src: 内核和软件的源代码的位置；
#. /local: 安装外来软件的地方；
#. /sudo: 使得普通用户可以得到超级用户权利。

最基本目录
==========

:file:`/bin,/dev,/etc,/lib,/proc,/sbin,/usr`


linux 的目录结构采用是Array register 制。
标准的流程就是把配置文件放在 :file:`/etc/` 下面。so,ko 都是放在 :file:`/lib/`
而其log 等等放在 :file:`/var/log` 里面。  *var* 的意思本来就是经常读写，变动的意思。


/var/log
========

log是非常重要的东东，出了问题第一个要看那就是log了。 并且 linux 默认都有 X.org.0.log -- X.org.6.log 默认是0 是最新的，也就是保留最近6次的log. 这个是由logrotate 机制来提供的。

例如syslog以及syslog-ng 等等的应用会自动实现这些，同样在android上也有logcat这样东东是同样的道理。

http://blog.chinaunix.net/uid-26569496-id-3199434.html




