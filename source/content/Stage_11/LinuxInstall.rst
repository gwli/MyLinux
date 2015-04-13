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

   
.. ::
 
   apt-get --yes install $something
   
   is that it will ask for a manual confirmation if the package signature owner's public-key is not in the keyring, or some other conditions. to be sure it does not ask a confirmation just do this:
   
   apt-get --yes --force-yes install $something
   
   If you want to have these settings permanent, create a file in /etc/apt/apt.conf.d/, like /etc/apt/apt.conf.d/90forceyes with the following content:
   
   APT::Get::Assume-Yes "true";
   APT::Get::force-yes "true";
   apt-cache search 库。
   

   
   #. `apt-get  代理设置 <http://hi.baidu.com/penglaiguoguo/item/385acb1553da648c88a9569e>`_  
   #. `源列表格式说明 <http://windorain.net/sources-list-format/>`_ , `说明名2 <http://blog.csdn.net/xizaizhuanyong_/article/details/8170093>`_ 
   #. `source list 制作方法 <http://www.debian.org/doc/manuals/apt-howto/ch-basico.zh-cn.html>`_ 


dpkg
====

查询包 :command:`dpkg -l |grep vnc`

删除   :command:`dpkg -r vnc`
   
   
   如何快速的制作一个linux系统
   ---------------------------
   #. 在一个现在系统上直接把系统文件打包

      .. code-block::

         $tar cvzf suse11_sp3.tgz bin boot etc lib lib64 opt root sbin selinux srv usr var 

   
   #. 在目标机上直接硬盘分区格式化，然后解压

      .. code-block::
         $ tar xvf suse11_sp3.tgz
   
   #. 并创建那些动态的目录 
   
      .. code-block::
         @mkdir dev media mnt proc tmp
   
   4. 然后启动盘来修复起动项
   
      .. code-block::
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
   
      
.. ::
 
       Creat bootable usb 
   ===========================

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

.. ::
 
cat ***ISO  >/dev/sdb ;sync


network install
===============

思考
======

`Start NFS server on Ubuntu <http://www.linuxidc.com/linux/2011-02/31947.htm>`_   `filesystem <FileSystem>`_ 

.. ::
 
    A as linux server, B as Solaris server.  We want to mount /home/A/ directory on Ubuntu into Solaris. <br/>
##### Install NFS on Ubuntu
sudo apt-get install nfs-kernel-server
3. Edit /etc/exports, add line at the end of file:
/home/tss3st  *(rw,sync,no_root_squash)
4. Restart NFS service
sudo service portmap restart
sudo service nfs-kernel-server restart
showmount -e
######Mount A:/home/A/ on Solaris
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


#### Mount and chmod on each Solaris
For all Solaris which we run NEAT, we need to mount this directory to local /mnt directory and chmod for it:






*双系统看不到起动菜单*
自己来搞grub,或者把linux先装一下，再然后再重装一下就Ok了。再次重装的时候，它会识别出两个系统就会自动去做。

-- Main.GangweiLi - 15 Jan 2013


*vmware share folder* linux 下的目录是 /mnt/hgfs

-- Main.GangweiLi - 15 Jan 2013


*如何快速部署linux*
1. 使用dd, 或者类似于ghost东西，把一个硬件快速复制另一个硬件，然后拿去直接启动使用，但是windows7要把设置成初始安装模式，这样才能启动，因为它的启动会去读硬盘信息。

-- Main.GangweiLi - 15 Jan 2013


*使用户具有sudo功能*
addsuer "victor"
sudo usermod -G adm -a victor
vim /etc/sudoers     copy root to a new line change root to victor

-- Main.GangweiLi - 15 Jan 2013


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
    include /etc/ld.so.conf.d/*.conf
/etc/ld.so.conf.d/
   XXXXXXXXX.conf
   AAAAAAA.conf



-- Main.GangweiLi - 14 Apr 2013


*file operation*
each one type of archive file, would support XXgrep,XXcat,xxxfind,xxxless. 

???BLOCK MISSING
