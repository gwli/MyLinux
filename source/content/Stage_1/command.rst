Linux 基本命令
==============


开机关机操作
------------

#. 开机:  /sbin/halt
#. 关机:  /sbin/poweroff
#. 重启： /sbin/reboot 

修改密码：password

目录操作
--------

#. 查看当前目录：pwd
#. 返回目录：cd 
#. 返回上一层目录： cd ..
#. 当前目录：cd .

文件操作
--------

#. 创建目录: mkdir
#. 删除目录: rmdir
#. 打开文件(读写文件): vim 
#. 关闭文件:wq 
#. 移动文件: mv 
#. 删除文件: rm
#. 复制文件或目录: cp
#. 在文件间建立连接: ln -s（软连接）
#. 查找文件: find 
#. 基于内容查找： grep

其它：
-----

#. 查看网络设备: ifconfig
#. 安装程序包: sudo apt-get 
#. 查看任务管理器进程: ps 
#. 查看命令历史: history
#. 产看帮助： man，help

解压 
----

.. csv-table:: 
   :header: ext, cmd

   tar.gz , tar -xzvf  abc.tar.gz
   tar.bz2, tar -xjvf  abc.tar.bz2
   .zip  ,   unzip abc.zip
   .rar,   unrar x abc.rar, apt-get install unrar   

tar 到指定的目录
----------------

:command:`tar -xzvf abc.tgz -C Dest`

``python tarfile`` 以及 ``python zipfile``

`xz <http://en.wikipedia.org/wiki/Xz>`_

grep 
----

正则表达式，是不需要转义的， :command:` grep -E` 或者 :command:`egrep`.

对于输出的控制很灵活，可以计数，可以高亮，以及只显文件名，以及支持与或非。

对于或的支持 可以用  :command:`grep -F` 或者 :command:`fgrep` 后接一个文件列表
只要直接pattern列表，每一行一个，这些pattern的关系是 any(patterns)的关系。
同时正则表达式也是支持的 


:command:`grep -lincrE "localhost|127.0.0.1" ./* |grep -vE "tutorial|machine"`


du and df
---------

检查是否有文件分区使用率(Use%)过高(比如超过90%)

:command:`df -h |grep -vE "tmpfs|udev"` 

如发现某个分区空间接近用尽,用以下命令找出占用空间最多的文件或目录：

:command:`du -csh /var/lib/state/*` 或者排序 
:command:`du -cks * |sort -rn| head -n 10` 

如何查看linux的版本
-------------------

.. code-block:: bash

   /etc/issue 
   /etc/debian_version
   /etc/readhat-release
   /etc/os-release
   /etc/lsb-release

利用特征文件 :file:`/etc/issue` 或者 :file:`/etc/redhat-release` 或者 :file:`/etc/debian_version`

或者直接 :command:`cat /etc/*-release` 就可以看到了。


如何判断linux是否运行在虚拟机上
-------------------------------

http://www.vpsee.com/2011/01/how-to-detect-if-a-linux-system-running-on-a-virtual-machine/

主要是通过 :file:`/proc/vz  /proc/xen/` 等文件来做的，一般这些地址会体现系统环境的。

文件批量重命名
--------------

linux专门一条:command:`rename` 指令。例如 我要把  *.txt* 变成 *.rst*
:command:`rename 's/.txt/.rst/ *.txt` .

取文件的部分内容
----------------

.. csv-table::
   
   行, sed,grep,head,tail
   例,awk,column

在文件添加一行，一个方法那就是用vim就可以了。
如果只是简单的行尾，那就是>>就搞定了。


minicom
=======

:command:`minicom -D /dev/ttyUSB0` 
:command:`minicom -C log.txt -D /dev/ttypUSB0` 保存log

:command:`ctrl+A` 来进入控制台



Development Tools
=================

不同平台下，会有不同的名字，
在ubuntu 下那就是  build-essential
在centos 下 那就是 Development Tools


centos 的development tools
--------------------------

indent, C语言的格式美化工具。 

https://www.kernel.org/doc/Documentation/CodingStyle
kernel-devel 包

resize2fs 分区 
==============

:command:`resize2fs -F -f -p /dev/sda1 -M` 最小化。


