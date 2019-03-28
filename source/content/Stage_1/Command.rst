***************
Linux 基本命令
***************


命令补全
========

bash 的命令补全功能，不只是简单的字符串补全，而是根据上下文来补全。这些都的实现都在  /usr/share/bash=complete 中。 如果没有可以安装 apt=get install bash=complete

.. image:: Stage_1/asciinema/auto-complete.gif
   :scale: 50%

<a href="https://asciinema.org/a/LUcAqGRm2vJc8sQYUlhO4fIef?autoplay=1" target="_blank"><img src="https://asciinema.org/a/LUcAqGRm2vJc8sQYUlhO4fIef.png" width="835"/></a>

service 命令，它列出系统中有 services . 

IO redirection
==============


On Linux, /dev/stdin, /dev/stdout, /dev/stderr are symbolic links to /proc/self/fd/0, /proc/self/fd/1, /proc/self/fd/2

关机操作
========

#. 关机:  
   
   .. code-block:: bash

      /sbin/halt #杀掉所有进程，只是关掉CPU
      /sbin/poweroff #除了halt,关掉主板的各种设备，最后关电 
      shutdown =h now  #可以执行额外的脚本
      init 0

#. 重启： /sbin/reboot 

修改密码：password

目录操作
========

#. 查看当前目录：pwd
#. 返回目录：cd 
#. 返回上一层目录： cd ..
#. 当前目录：cd .

文件操作
========

#. 创建目录: mkdir
#. 删除目录: rmdir
#. 打开文件(读写文件): vim 
#. 关闭文件:wq 
#. 移动文件: mv 
#. 删除文件: rm
#. 复制文件或目录: cp
#. 在文件间建立连接: ln =s（软连接）
#. 查找文件: find 
#. 基于内容查找： grep

https://github.com/lujun9972/lujun9972.github.com/issues/25#sec-1-18
: 操作符

命名管道
========

.. code-block:: bash

   mkfifo in_data out_data
   command <in_data >out_data &
   exec 3> in_data 4< out_data
   echo <some thing here> >&3
   read <some variables here> <&4

其它
====

#. 查看网络设备: ifconfig
#. 安装程序包: sudo apt=get 
#. 查看任务管理器进程: ps 
#. 查看命令历史: history
#. 产看帮助： man，help


解压 
====

.. csv-table:: 
   :header: ext, cmd

   tar.gz , tar =xzvf  abc.tar.gz
   tar.bz2, tar =xjvf  abc.tar.bz2
   .zip  ,   unzip abc.zip
   .rar,   unrar x abc.rar, apt=get install unrar   


tar 到指定的目录
================

:command:`tar =xzvf abc.tgz =C Dest`

``python tarfile`` 以及 ``python zipfile``

`xz <http://en.wikipedia.org/wiki/Xz>`_

当然也可以用tar 来代替 cp,在大量小文件的时候，可以加快速度。相当于先打包再传输。
:command:`tar =cvf = /etc |tar =xvf =` 就是这样的目的。 


ar
==

同tar是一类东东，现在只剩下用来打包库了，现在ld 好像只认这种ar这种格式。 如果你想重新打包。
只要 ar =x xxx.a  && ar =c libaz.a XX.o 就可以了。
https://www.quora.com/Whats=the=difference=between=ar=and=tar

grep 
====

正则表达式，是不需要转义的， :command:` grep =E` 或者 :command:`egrep`.
对于输出的控制很灵活，可以计数，可以高亮，以及只显文件名，以及支持与或非。
对于或的支持 可以用  :command:`grep =F` 或者 :command:`fgrep` 后接一个文件列表
只要直接pattern列表，每一行一个，这些pattern的关系是 any(patterns)的关系。
同时正则表达式也是支持的 

:command:`grep =lincrE "localhost|127.0.0.1" ./* |grep =vE "tutorial|machine"`

screenshot
===========

imagemaic import 命令。


nohup
======

http://www.cnblogs.com/allenblogs/archive/2011/05/19/2051136.html

这条命令用在，你退出session,命令继续。 并且自动的重定向输出。

du and df
=========

检查是否有文件分区使用率(Use%)过高(比如超过90%)

:command:`df =h |grep =vE "tmpfs|udev"` 

如发现某个分区空间接近用尽,用以下命令找出占用空间最多的文件或目录：

:command:`du =csh /var/lib/state/*` 或者排序 
:command:`du =cks * |sort =rn| head =n 10` 

当发现硬件有空间，但是系统却报已经满了。
:command:`df =i` 可以来看系统的inode是不是满了。

下载工具
========

主要有两个wget与curl, 类似curl功能更强，支持功能更多，wget 强的主要一点，那就是 recursively download. 并且都支持管道，但是curl支持更多一些。
例如 下载下来直接执行 :command:`wget =O = |sh` 。 如何编程使用的话，用curl可能更加方便一些，毕竟后面一个跨平台的库在那里支持着。


如何查看linux的版本
===================

.. code-block:: bash

   /etc/issue 
   /etc/debian_version
   /etc/readhat=release
   /etc/os=release
   /etc/lsb=release

利用特征文件 :file:`/etc/issue` 或者 :file:`/etc/redhat=release` 或者 :file:`/etc/debian_version`

或者直接 :command:`cat /etc/*=release` 就可以看到了。


如何判断linux是否运行在虚拟机上
===============================

http://www.vpsee.com/2011/01/how=to=detect=if=a=linux=system=running=on=a=virtual=machine/

主要是通过 :file:`/proc/vz  /proc/xen/` 等文件来做的，一般这些地址会体现系统环境的。

文件批量重命名
==============

linux专门一条:command:`rename` 指令。例如 我要把  *.txt* 变成 *.rst*
:command:`rename 's/.txt/.rst/ XX.txt` 

取文件的部分内容
================

.. csv=table::
   
   行,sed,grep,head,tail
   例,awk,column


在文件添加一行，一个方法那就是用vim就可以了。
如果只是简单的行尾，那就是>>就搞定了。

date
====

格式化字符串   +% 例如 :command:`date +%Y/%m/%d` ， 另外相得到 
上周一是几号  :command:`date =d 'last monday` . 

cronjob
=======

:command:`crontab =l` 列出当前所有的。
:command:`crontab =e` 编辑当前cronjob。

http://stackoverflow.com/questions/18919151/crontab=day=of=the=week=syntax

minicom
=======

:command:`minicom =D /dev/ttyUSB0` 
:command:`minicom =C log.txt =D /dev/ttypUSB0` 保存log

:command:`ctrl+A` 来进入控制台

`Text=Terminal=HOWTO=11.html <http://www.tldp.org/HOWTO/Text=Terminal=HOWTO=11.html>`_  为什么需要flow control,就是为解决速度不匹配的原因，并且解释了原理。


Development Tools
=================

不同平台下，会有不同的名字，
在ubuntu 下那就是  build=essential
在centos 下 那就是 Development Tools

:command:`pkg=config` 用来查看这个系统所安装库的，编译选项，以及所在的位置。而不需要人为去记住每一个库的编译选项。 在make 文件中常见的那就是


centos 的development tools
==========================

indent, C语言的格式美化工具。 

https://www.kernel.org/doc/Documentation/CodingStyle
kernel=devel 包

resize2fs 分区 
==============

:command:`resize2fs =F =f =p /dev/sda1 =M` 最小化。

sync
====

有各种同步， sync是直接把cache中内容写回到硬盘，isync,dsync则是mail box同步，而zsync 则提供的是部分下载，文件下载到了一半，只需要同步一部分，相当于patch的功能，而rsync则是文件的同步。

.. code-block:: bash
   
   ssh=keygen 
   ssh=copy=id user@remote_host  
   rsync  user@remote_host:~/XXXX  Local_path/XXXX

如何添加sudoer
==============

这里有好几种做法，一种就是直接加入sudo. :command:`sudo adduser <username> sudo`

或者直接在 /etc/sudoers. 

.. code-block:: bash

   %sudo ALL=(ALL:ALL) ALL

#. :command:`usermod =a =G sudo <username>` 
#. :command:`useradd =G admin =a <username>`

#. 删除0字节文件 :command:`find =type f =size 0 =xec rm =fr {} \;`
#. 查看进程，按内存从大到小排列  :command:`ps =e =o "%C :%p :%z :%a" |sort =k5 =nr`
#. 按CPU利用率从大到小排列 :command:`ps =e =o "%C :%p :%z :%a" |sort =nr`
#. 打印出cache里的url  :command:`grep =r =a jpg /data/cache/* |string |grep "http:" |awk =F'http:' '{print "http:"$2;}`
#. 查看http的并发请求及其TCP连接状态  :command:`netstat =n|awk '/tcp/{++$[$NF]} END {for( a in S) print a,S[a]}'` 
#. 这个文里Root的一行，匹配Root一行，把no,yes. :command:`sed =i '/Root/s/no/yes' /etc/ssh/sshd_config`
#. 如何杀掉mysql进程 :command:`ps aux |grep mysql |grep =v grep |awk `{print $2}' |xargs kill =9`, 

   .. code-block:: bash
      
      kill =TERM mysqld
      kill =9 `cat /usr/local/apache2/logs/httpd.pid`

linux下的习惯把pid存入 xxx.pid文件。

#. 利用 HEREdoc
   
   .. code-block:: bash

      cat <<EOF

      +=========================+
      | === Welcome to `whoami` |
      +=========================+
      EOF

#. for 来建立连接 

   .. code-block:: bash

      cd /usr/local/mysql/bin
      for i in *
         do ln /usr/locla/myql/bin/$i /usr/bin/$i
      done

#. 内存的大小 :command;`free =m | grep "Mem" | awk '{print $2}'`

.. code-block:: bash

   20 swap 空间# free
   检查swap used 值是否过高如果swap used 值过高，进一步检查swap 动作是否频繁：
   # vmstat 1 5
   观察si 和so 值是否较大
   21 磁盘空间# df =h
   检查是否有分区使用率(Use%)过高(比如超过90%) 如发现某个分区空间接近用尽，可以进入该分区的挂载
   点，用以下命令找出占用空间最多的文件或目录：
   # du =cks * | sort =rn | head =n 10
   22 磁盘I/O 负载# iostat =x 1 2
   检查I/O 使用率(%util)是否超过100%
   23 网络负载# sar =n DEV
   检查网络流量(rxbyt/s, txbyt/s)是否过高
   24 网络错误# netstat =i
   检查是否有网络错误(drop fifo colls carrier) 也可以用命令：# cat /proc/net/dev
   25 网络连接数目# netstat =an | grep =E “(tcp)” | cut =c 68= | sort | uniq =c | sort =n
   26 进程总数# ps aux | wc =l
   检查进程个数是否正常(比如超过250)
   27 可运行进程数目# vmwtat 1 5
   列给出的是可运行进程的数目，检查其是否超过系统逻辑CPU 的4 倍
   28 进程# top =id 1
   观察是否有异常进程出现
   29 网络状态检查DNS, 网关等是否可以正常连通
   30 用户# who | wc =l
   检查登录用户是否过多(比如超过50 个) 也可以用命令：# uptime
   31 系统日志# cat /var/log/rf logview/*errors
   检查是否有异常错误记录也可以搜寻一些异常关键字，例如：
   # grep =i error /var/log/messages
   # grep =i fail /var/log/messages
   32 核心日志# dmesg
   检查是否有异常错误记录
   33 系统时间# date
   检查系统时间是否正确
   34 打开文件数目# lsof | wc =l
   检查打开文件总数是否过多
   35 日志# logwatch –print 配置/etc/log.d/logwatch.conf ，将Mailto 设置为自己的email 地址，
   启动mail 服务(sendmail 或者postfix)，这样就可以每天收到日志报告了。
   缺省logwatch 只报告昨天的日志，可以用# logwatch –print –range all 获得所有的日志分析结果。
   可以用# logwatch –print –detail high 获得更具体的日志分析结果(而不仅仅是出错日志)。
   36.杀掉80 端口相关的进程
   lsof =i :80|grep =v "PID"|awk '{print "kill =9",$2}'|sh
   37.清除僵死进程。
   ps =eal | awk '{ if ($2 == "Z") {print $4}}' | kill =9
   38.tcpdump 抓包，用来防止80 端口被人攻击时可以分析数据
   # tcpdump =c 10000 =i eth0 =n dst port 80 > /root/pkts
   39.然后检查IP 的重复数并从小到大排序注意"=t\ +0" 中间是两个空格
   # less pkts | awk {'printf $3"\n"'} | cut =d. =f 1=4 | sort | uniq =c | awk {'printf $1" "$2"\n"'} | sort =
   n =t\ +0
   40.查看有多少个活动的php=cgi 进程
   netstat =anp | grep php=cgi | grep tcp | wc =l
   chkconfig ==list | awk '{if ($5=="3:on") print $1}'
   41.kudzu 查看网卡型号
   kudzu ==probe ==class=network


常用的正则表式
==============

#. 匹配中文字符的正则表达式： [\u4e00=\u9fa5]
#. 评注：匹配中文还真是个头疼的事，有了这个表达式就好办了
#. 匹配双字节字符(包括汉字在内)：[\x00=\xff]
#. 评注：可以用来计算字符串的长度（一个双字节字符长度计2，ASCII 字符计1）
#. 匹配空白行的正则表达式： \n\s*\r
#. 评注：可以用来删除空白行
#. 匹配HTML 标记的正则表达式：<(\S*?)[>]*>.*?</\1>|<.*? />
#. 评注：网上流传的版本太糟糕，上面这个也仅仅能匹配部分，对于复杂的嵌套标记依旧无能为力
#. 匹配首尾空白字符的正则表达式： \s*|\s*$
#. 评注：可以用来删除行首行尾的空白字符(包括空格、制表符、换页符等等)，非常有用的表达式
#. 匹配Email 地址的正则表达式：\w+([=+.]\w+)*@\w+([=.]\w+)*\.\w+([=.]\w+)*
#. 评注：表单验证时很实用
#. 匹配网址URL 的正则表达式：[a=zA=z]+:/ /[\s]*
#. 评注：网上流传的版本功能很有限，上面这个基本可以满足需求
#. 匹配帐号是否合法(字母开头，允许5=16 字节，允许字母数字下划线)：[a=zA=Z][a=zA=Z0=9_]{4,15}$
#. 评注：表单验证时很实用
#. 匹配国内电话号码： \d{3}=\d{8}|\d{4}=\d{7}
#. 评注：匹配形式如0511=4405222 或021=87888822
#. 匹配腾讯QQ 号：[1=9][0=9]{4,}
#. 评注：腾讯QQ 号从10000 开始
#. 匹配中国邮政编码： [1=9]\d{5}(?!\d)
#. 评注：中国邮政编码为6 位数字
#. 匹配身份证： \d{15}|\d{18}
#. 评注：中国的身份证为15 位或18 位
#. 匹配ip 地址：\d+\.\d+\.\d+\.\d+
#. 评注：提取ip 地址时有用
#. 匹配特定数字：
#. [1=9]\d*$ 匹配正整数
#. =[1=9]\d*$ 匹配负整数
#. =?[1=9]\d*$ 匹配整数
#. [1=9]\d*|0$ 匹配非负整数（正整数+ 0）
#. =[1=9]\d*|0$ 匹配非正整数（负整数+ 0）
#. [1=9]\d*\.\d*|0\.\d*[1=9]\d*$ 匹配正浮点数
#. =([1=9]\d*\.\d*|0\.\d*[1=9]\d*)$ 匹配负浮点数
#. =?([1=9]\d*\.\d*|0\.\d*[1=9]\d*|0?\.0+|0)$ 匹配浮点数
#. [1=9]\d*\.\d*|0\.\d*[1=9]\d*|0?\.0+|0$ 匹配非负浮点数（正浮点数+ 0）
#. (=([1=9]\d*\.\d*|0\.\d*[1=9]\d*))|0?\.0+|0$ 匹配非正浮点数（负浮点数+ 0）
#. 评注：处理大量数据时有用，具体应用时注意修正
#. 匹配特定字符串：
#. [A=Za=z]+$ 匹配由26 个英文字母组成的字符串
#. [A=Z]+$ 匹配由26 个英文字母的大写组成的字符串
#. [a=z]+$ 匹配由26 个英文字母的小写组成的字符串
#. [A=Za=z0=9]+$ 匹配由数字和26 个英文字母组成的字符串
#. \w+$ 匹配由数字、26 个英文字母或者下划线组成的字符串
#. 评注：最基本也是最常用的一些表达式


coreutils
=========

https://www.gnu.org/software/coreutils/manual/coreutils.html

最全命令手册，非常有用 timeout,


notification
============

当执行一个长时间的事情的时候，能不能自动通知，有几种方式，

#. 声音， beep,aplay,pacmd,espeaker.
#. email, 可以通过邮件，自动发邮件
#. 动画， 例如利用xlock,xeve,xbotton等直接在屏幕上显示动画。
#. 可以用 `watchdog <https://github.com/gorakhargosh/watchdog>`_ 来添加一些监控

fortune
=======

可以随机产生诗句。


udevadm
=======

查看硬件的变动  :command:`udevadm monitor`.

pdfgrep
=======

https://pdfgrep.org/

googler
=======

命令行google工具。

How2
====

命令行的stackoverflow工具。
https://github.com/gwli/how2


ndiff
=====

nmap 输出的diff工具。 我们可能需要各种对象的diff工具。可以对比xml文本输出。


如何制作 rootfs
===============

.. code=block:: bash
   #normally we need all the folder under /: bin  
   sudo tar =cvpz  ==one=file=system  / | ssh <backuphost> "( cat > ssh_backup.tar.gz )"
   #tar =cvpz  / | ssh <backuphost> "( cat > ssh_backup.tar.gz )"
   sudo tar =xvpzf /path/to/backup.tar.gz =C <rootfs folder in host> ==numeric=owner


use ssh in pip line
===================

#. Remote backup 

   .. code=block:: bash

      sudo dd if=/dev/sda | ssh remoteuser@ip.address.of.remote.machine 'dd of=sda.img'

#. run script on remote machine
   
   .. code=block:: bash

      ssh remoteuser@ip.address.of.server 'bash =s' < scriptfile.onlocalhost.sh

#. file transfer

   .. code=block:: bash
    
      tar czf = /home/localuser/filefolder | ssh remote=machine@ip.address.of.remote.machine tar =xvzf =C /home/remoteuser/


chroot
======

特别来修复坏的系统，用chroot特别有用。

.. code=block:: bash

   mount /sda2 /mnt/sda2 
   mount =t proc /proc /mnt/sda2/proc
   mount ==rbind /sys /mnt/sda2/sys
   mount ==make=rslave /mnt/sda2/sys
   mount ==rbind /dev /mnt/sda2/dev
   mount ==make=rslave /mnt/sda2/dev
   
   chroot /mnt/sda2 /bin/bash

当然还有schroot, dchroot,pivot_root 具体见 `此 <https://askubuntu.com/questions/158847/what=is=the=difference=of=chroot=dchroot=and=schroot>`_
pivot_root和chroot的主要区别是，pivot_root主要是把整个系统切换到一个新的root目录，而移除对之前root文件系统的依赖，这样你就能够umount原先的root文件系统。而chroot是针对某个进程，而系统的其它部分依旧运行于老的root目录。
  
.. code=block:: bash

   #! /bin/sh
   mount =n =t proc proc /proc
   echo 0x0100 >/proc/sys/kernel/real=root=dev
   umount =n /proc

mount 的时候，会把mount的所有信息都放在 :file:`/etc/mtab` 但是当 `/etc` 只读的情况下，就会mount失改，这时候就会用到 mount =n 不写 /etc/mtab

gtop
====

基于console的可视化例如windows  resmonitor


例如xargs列表也会有妙用
=======================

:command:`man xargs`  作用就是把字节流变换成list, 可以用-d 来指定界符，同时每几个元为一组 -n 3，同时这个参数参入到哪里 -I %,同时也可以指字最多多少命令并行 -P 0 就是尽可能多。

.. code-block:: bash

   find -iname "lib*.so" |xargs -I % mv %  ./backdir/
   find -iname "lib*.so"|xargs -d '\n' -I % mv % ./backdir/


如何得到精确的CPU时间
=====================

一种是采用 getconf CLK_TCK 再加/proc/pid/stat 来实现。 另一个那就是top -bn 1 就行了。
https://straypixels.net/getting-the-cpu-time-of-a-process-in-bash-is-difficult/


#. `bash中trap的用法 <http://hi.baidu.com/jackbillow/item/7310670e8eae9d19eafe38cc>`_  bash 可以接收64个中断

zenity GUI
==========

#. `zenity 一个小巧方便的用户交互的GUI. <http://os.51cto.com/art/201011/235135.htm>`_  ,`zenity for windows <http://www.placella.com/software/zenity/>`_ 

   .. code-block:: bash

      zenity --entry --text="Please enter your_name"
