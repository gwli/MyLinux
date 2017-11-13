linux 和选择
============

其实只要看到每一个事情起源就自然明白其源由了，例如这么多linux，到底各有什么区别，只要再一下其各个发展史，以及先后顺序就知道了。例如 apt-get dpkg这种方式是debian首创的。 后面系统都会吸取前面系统的优点。 gentoo是出现最迟的，当然也就是优点更多一些了。

`linux服务器系统CentOS、uBuntu、Gentoo、FreeBSD、Debian的比较 <http://www.jb51.net/article/32657.htm>`_ 
redhat由于追求稳定性，而发展太慢。而ubuntu 则是通过快速的迭代用的新的技术也保证稳定性。那也就是敏捷也追求吧。这也是 `为什么ubuntu server在逐步蚕食CentOS的市场份额？ <http://www.zhihu.com/question/24180649>`_  由于技术本质就是求新求快。例如redhat 中自带的python现在还是2.6。 这些采用自己安装。当然他有一些自己特定的优势。但是长期是谬论， python 2.7 肯定比2.6要更强，更稳定。不管的你的内核更稳定，你的用python不行，还是不行的。当然还得瓶颈是在哪里。


usb 启动盘制作
==============

要想让其可启动，就要让BIOS能够认出来，也就是BIOS本身具有相应的驱动，或者中间的转接，然后是在其引导有引导代码类似于grub的代码能执行，并加载相应的kernel.

`用AT&T 汇编实现 第一个bootloader <http://www.imsiren.com/archives/917>`_   BIOS 通电-将磁盘第一个扇区512字节copy到内存的0x0000:0x7c0处，并将CS寄存器设置为0x0000,IP设置为0x07c0, 因为现在CPU处于实模式下，所以CPU下一条将要执行的指令就是CS:IP 将是 0x:0000:0x7c0, 这样就能挂靠 到我们写的bootloader了。

所以只要把USB变成可引导盘，并且分区格式化并不会影响MBR，因为这个是分区之外的事情。 然后就可以像里面copy kernel了。这也就是为什么，今天直接往U盘copy 光盘内容就可以用了的原因。

software install apt-get 
------------------------


One of the key function is process the package denpendencies.  this is a troubleness on linux. but the apt-get help to handle them.

as long as,you use share resource with each other, there must be an issue of dependencies. kernel module has this issue. system package has this issue.  dependency is anywhere of linux system. 

so there are so many managetools. for ubuntu and debian there is apt-get, dpkg, for SUSE there are zypper and yaST. for Centos and Redhat , there is yup. 

gentoo also has its own package system and configuration management system.



sourcelist support three source
#. deb
#. deb-src
#. ppa
#. `add-apt-repository <http://www.cnblogs.com/cute/archive/2012/05/21/2511571.html>`_  ,`PPA <How do I use software from a PPA?]] [[https://launchpad.net/ubuntu/+ppas>`_  is Personal Package Archives (PPA) allow you to upload Ubuntu source packages to be built and published as an apt repository by Launchpad. 

   
.. code-block:: bash
 
   apt-get --yes install $something
   
   is that it will ask for a manual confirmation if the package signature owner's public-key is not in the keyring, or some other conditions. to be sure it does not ask a confirmation just do this:
   
   apt-get --yes --force-yes install $something
   
   If you want to have these settings permanent, create a file in /etc/apt/apt.conf.d/, like /etc/apt/apt.conf.d/90forceyes with the following content:
   
   APT::Get::Assume-Yes "true";
   APT::Get::force-yes "true";
   apt-cache search 库。
   
   // get the lib url 
   apt-cache policy "xxxlib" 
  
如果出现 出现PGP key error 缺 key
---------------------------------

.. code-block:: bash

   sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 437D05B5 3E5C1192
   sudo apt-get update

如果想添加不同架构的deb
========================

可以用 APT::Architectures 
http://stackoverflow.com/questions/6331109/how-to-setup-multiple-architecture-development-environment-under-ubuntu-11-04

同时还可以下载代码 `apt-get source package-name` 就可以直接下载当前目录了。



如何查看所有可用更新
====================

#. :command:`aptitude search '~U'`
#. 可用命令
  
   .. code-block:: bash
      
      apt list
      apt search
      apt full-upgrade
      apt install
      apt remove

#. aptdcon, 这个可以把安装放在队列里，以及不需要root,而不需要人为等另一个install 完成。
#. 同时采用 apt-extracttemplate 把当前系统安装包生成template. 然后在其他机器上安装。

源列表格式
==========

http://manpages.ubuntu.com/manpages/wily/man5/sources.list.5.html

#. `源列表格式说明 <http://windorain.net/sources-list-format/>`_ , `说明名2 <http://blog.csdn.net/xizaizhuanyong_/article/details/8170093>`_ 

   
#. `apt-get  代理设置 <http://hi.baidu.com/penglaiguoguo/item/385acb1553da648c88a9569e>`_  
#. `source list 制作方法 <http://www.debian.org/doc/manuals/apt-howto/ch-basico.zh-cn.html>`_ 

apt-get upgrade 只是升级到当前的软件到最新版本， apt-get dist-upgrade,升级到大版本。
或者用 :command:`sudo do-release-upgrade`

安装列表
========

:command:`apt-get install $(grep -vE "^\s*#"|tr "\n" '')`
http://askubuntu.com/questions/252734/apt-get-mass-install-packages-from-a-file

dpkg
====

#. 查询包 :command:`dpkg -l |grep vnc`
#. 删除   :command:`dpkg -r vnc`
#. 查看依赖 :command:`apt-cache depends packagename`
#. 查看安装了哪些文件 :commmand:`dpkg -L packagename`



安装位置的选择
==============

usr is stand for unix system resource,  
http://askubuntu.com/questions/1148/what-is-the-best-place-to-install-user-apps
如果只是zip包 standalone App，可以直接使用就放在/opt下面。 
   
如何快速的制作一个linux系统
---------------------------

#. 在一个现在系统上直接把系统文件打包

   .. code-block:: bash

      $tar cvzf suse11_sp3.tgz bin boot etc lib lib64 opt root sbin selinux srv usr var 
      tar -czpf --one-file-system / | ssh name@hostname "(cat >ssh_systemrootfs.tgz)"



#. 在目标机上直接硬盘分区格式化，然后解压

   .. code-block:: bash

      $ tar xvf suse11_sp3.tgz

#. 并创建那些动态的目录 

   .. code-block:: bash

      @mkdir dev media mnt proc tmp

4. 然后启动盘来修复起动项

   .. code-block:: bash

      $restore grub,
      mount /dev/sda1 /mnt/sda1
      grub-install --boot-directory=/mnt/sda1/boot /dev/sda1 --force
      grub-mkconfig -o /mnt/sda1/boot/grub.cfg

 
   .. seealso::
   
   #. `使用官方Ubuntu软件库构建DVD镜像 <http://linux.chinaunix.net/docs/2007-04-03/4110.shtml>`_  
   
   #. `linux release server <Get:3 http://us.archive.ubuntu.com/ubuntu/ precise/universe libstroke0 amd64 0.5.1-6 &#91;9,590 B]>`_  
   #. `利用 Zsync 更新已有的 Ubuntu ISO 镜像 <http://linuxtoy.org/archives/use-zsync-to-update-existing-iso-images.html>`_  http://zsync.moria.org.uk/  
   #. `Jigdo（&#34;Jigsaw download&#34;，曲线下载）是为Debian包设计的下载工具，可以从几个镜像站点下载不同的文件，然后再生成一个CD镜像 <http://zh.wikipedia.org/wiki/Jigdo>`_  
   #. `metalink <http://zealtea.yo2.cn/articles/metalink.html>`_  
   #. `ubuntu alternate版和desktop版区别&#95; <http://hi.baidu.com/wy975740772/item/4d44bc092c64b53df3eafcf2>`_  
   
   #. `lsb standard <http://refspecs.linuxfoundation.org/lsb.shtml>`_  
   #. `中文支持 <http://www.4wei.cn/archives/1001458/comment-page-1>`_  
   Grub2AndBootup.rst
   
   USB install 
   -----------


install
=======

所有安装最终操作就是copy文件，并且配制正确的权限与属性，以及根据系统的环境，向系统注册一些信息，或者添加环境变量。  所以纯手工的操作那就是cp+chown,chmod+strip 等等。 而在 install 一条命令就把这些全度搞定了。
http://unix.stackexchange.com/questions/94679/what-is-the-purpose-of-the-install-command
   

ubuntu 发行光盘的制作 
=====================

现在对于linux的整个框架熟悉了之后，再怎么操作，就容易了，也就是那些stage3 tarball就看你怎么安装了。 用什么介质就要使用对应的格式。 例如光盘格式 sqfs 就是为方面其把从光盘放进内存里。 或者其他的.img格式。直接放在哪里，然后直接chroot启动，或者chroot之后再更新。或者可以在 android 的源码中可以找到各种工具  /build/tools/XXX。 例如img 解压，对比工具等等。

至于采用什么格式，还得看启动kernel支持哪种类型，一般都会支持sqfs格式的。

由于ISO文件中只读，于是不能写入。 于是就有casper-rw 的功能，实际就是在系统里默认mount这个目录，利用autofs,unionfs的功能http://unionfs.filesystems.org/  就实现了这个功能。也就是在USB生成一个casper-rw的文件。 并利用mkfs -f 把这个文件当做系统格式化。 dd 来生成这样一个文件。
#. http://www.syslinux.org/wiki/index.php/ISOLINUX
#. http://unix.stackexchange.com/questions/122832/how-to-use-casper-rw-file-for-persistance
#. https://help.ubuntu.com/community/LiveCDCustomization
#. http://lifehacker.com/5085405/make-any-linux-directory-into-an-iso-file

而casper,ubuntu 等这些用户都是动态创建的。主要过程那就是/casper/filesystem.squashfs 的制作与修改。
而起动时需要initrd.lz 以及其修改。当然也可以利用ubuntu Customization Kit. 
https://help.ubuntu.com/community/LiveCD/Persistence 原来创建一个Casper-rw 文件来进行存储，这个大小
还是可以重定义的。

preseed 目录是用来存放预配置文件。

实现也是采用grub来起动的。



 
Creat bootable usb 
==================

#. Download syslinux on windows
      http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-4.04.zip
   2. Format USB stick in fat32
   3. Copy syslinux.exe to <usb>/boot/syslinux
   4. boot
      cd <usb>\boot\syslinux
      syslinux.exe -ma -d /boot/syslinux <usb driver letter:>
   5. find these files and copy to <usb>\boot\syslinux
      memdisk                   引导IMG镜像的文件
      vesamenu.c32               二种窗口模块之一
      menu.c32                   二种窗口模块之一
      chain.c32                   指定分区启动  如：chain.c32 hd0,1 (或chain.c32    hd1,1)
      reboot.c32                  重新启动计算机
   6. Create an empty file named livecd in usb root
      


`create-a-usb-stick-on-windows <http://www.ubuntu.com/download/help/create-a-usb-stick-on-windows>`_ 

.. code-block:: bash
 
   cat ***ISO  >/dev/sdb ;sync


network install
===============

思考
======

`Start NFS server on Ubuntu <http://www.linuxidc.com/linux/2011-02/31947.htm>`_   `filesystem <FileSystem>`_ 

.. ::
 
    A as linux server, B as Solaris server.  We want to mount /home/A/ directory on Ubuntu into Solaris. <br/>

Install NFS on Ubuntu
======================

#. sudo apt-get install nfs-kernel-server
#. Edit /etc/exports, add line at the end of file:

   .. code-block:: bash

      /home/tss3st  *(rw,sync,no_root_squash)

#. Restart NFS service
   
   .. code-block:: bash

      sudo service portmap restart
      sudo service nfs-kernel-server restart
      showmount -e

### Mount A:/home/A/ on Solaris

1. Login to B as user "root"
2. Create directory:

.. csv-table:: 

   mkdir -p /mnt/svlinux01/home/A/,

3. Mount:

.. csv-table:: 

   mount -F nfs -o rw A:/home/A/   /mnt/A/home/A,

4. Chmod:

.. csv-table:: 

   chmod 777 /mnt/A/home/A/automation/mail/,

5. Create soft link:

.. csv-table:: 

   ln -s /mnt/svlinux01/home/A/automation/mail/ /home/A/WWW/automation/mail/,


*Mount and chmod on each Solaris*
For all Solaris which we run NEAT, we need to mount this directory to local /mnt directory and chmod for it:


*双系统看不到起动菜单*
自己来搞grub,或者把linux先装一下，再然后再重装一下就Ok了。再次重装的时候，它会识别出两个系统就会自动去做。

-- Main.GangweiLi - 15 Jan 2013


*vmware share folder* linux 下的目录是 /mnt/hgfs

-- Main.GangweiLi - 15 Jan 2013


*如何快速部署linux*
1. 使用dd, 或者类似于ghost东西，把一个硬件快速复制另一个硬件，然后拿去直接启动使用，但是windows7要把设置成初始安装模式，这样才能启动，因为它的启动会去读硬盘信息。

-- Main.GangweiLi - 15 Jan 2013


使用户具有sudo功能
-------------------

addsuer "victor"
sudo usermod -G adm -a victor
vim /etc/sudoers     copy root to a new line change root to victor



*backup and restore*

when backup and restore, there is three things to know:
%BROWN%
#.  size of data 
#.  start address, in another way where is it?
#. what type of the data. do we need now the internal structure, due to some manipulation on the data is base on its internal structure ,that's the type.
%ENDCOLOR%
there is some way:
dd   directly copy sectors to the harddisk. but how the dd know the how many the space is used.
partclone   can do the backup and restore base on the partition. and it know many space is used.


-- Main.GangweiLi - 28 Mar 2013


*Configuration structure*
Now, most of the big application use configuration. and these configuration mechanism should have *include*, so that there is structure:

.. ::
 
/etc/ld.so.conf 
    include /etc/ld.so.conf.d/XX.conf
/etc/ld.so.conf.d/
   XXXXXXXXX.conf
   AAAAAAA.conf



-- Main.GangweiLi - 14 Apr 2013


*file operation*
each one type of archive file, would support XXgrep,XXcat,xxxfind,xxxless. 

???BLOCK MISSING

can't resolve dns
=================

只需要设置一下DNS，就是 */etc/resolve.conf* 

常见的配置

.. code-block:: bash
   
   nameserver 127.0.1.1
   search nvidia.com

如何修复系统 
============

https://help.ubuntu.com/community/LiveCdRecovery

#. livecd 起动
#. chroot to harddisk 

   .. code-block:: bash
   
      mount /sda2 /mnt/sda2 
      mount -t proc /proc /mnt/sda2/proc
      mount --rbind /sys /mnt/sda2/sys
      mount --make-rslave /mnt/sda2/sys
      mount --rbind /dev /mnt/sda2/dev
      mount --make-rslave /mnt/sda2/dev
      
      chroot /mnt/sda2 /bin/bash
      
      #open 2nd terminal
      cat /etc/resolve.conf /mnt/sda2/etc/resolve.conf
      apt remove <bad package>
      apt autoremove
      apt update
      apt install <right packages>
      #apt install linux-generic
      apt upgrade      



