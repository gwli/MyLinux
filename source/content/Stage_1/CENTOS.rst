******
Centos
******


how to config 
=============

#. sshd run on startup
   :command:`chkconfig sshd on`

#. install python 2.7 on centos 6.5
  
   http://bicofino.io/blog/2014/01/16/installing-python-2-dot-7-6-on-centos-6-dot-5/

#. hostname

   .. code-block:: bash

      hostname computername
      vim /etc/hostname

#. build-essential
   
   :command:`yum groupinstall "Development Tools"`

#. bootup options

   .. code-block:: bash

      /etc/rc.local 
      /etc/rc.d/rc.local


#. vncserver

   .. code-block:: bash
      
      rpm -qa |grep vnc
      yum install tigervnc
      yum install tigervnc-server
      vncserver

   #. disable firewall
         
      :command:`/sbin/service iptables stop`
   
   
   #. change xstartup file
   
      .. code-block:: bash
         
         unset SESSION_MANAGER
         exec /etc/X11/xinit/xinitrc
         [ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
         [ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
         xsetroot -solid grey
         vncconfig -iconic &
         xterm -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
         gnome-session & #set starting GNOME desktop
         #startkde & #kde desktop
         #twm & #Text interface
         #/usr/bin/startxfce4
         #exec /usr/bin/fluxbox

      #. bootup
         :command:`chkconfig vncserver on`
         :command:`chkconfig iptables off`


this new method is working `vnc-server-installation-on-centos-7 <https://www.howtoforge.com/vnc-server-installation-on-centos-7>`_

#. autologin

   .. code-block:: bash
       
       vim /etc/gdm/custom.conf
       [daemon]
       AutomaticEnable=true
       AutomaticLogic=root
      
.. note::

   this just work VM.

.. [#CSDNAUTOLOGIN] http://blog.csdn.net/kpshare/article/details/7523546


https://www.centos.org/forums/viewtopic.php?f=47&t=48288

#. usb install

http://wiki.centos.org/zh/HowTos/InstallFromUSBkey
   dd if=CenOS-6.5.iso of=/dev/sdb
   ## method 2
   cat XX.iso >/dev/sdb
   sync


install nvidia driver
=====================

http://www.dedoimedo.com/computers/centos-7-nvidia.html

yum and rpm
===========

http://wiki.centos.org/PackageManagement/Yum

#. search

   .. code-block:: bash
      
      rpm -qa |grep vnc


init bootup
===========

`checkconfig <http://www.cnblogs.com/phpnow/archive/2012/07/14/2591849.html>`_


grub
====

#. change  device.map   

#. /etc/default/grub
#. /etc/grub.d/RAME
#. /etc/fstab or /etc/init/fstab

mountall
========

the bootmenu just like an txt control. as you use the raw_input. 


enter text interface
====================

:command:`ctrl+alt+F1~F6`


no lock screen
==============

change power management.


config boot
===========

#. config /etc/fstab

   .. code-block:: bash

      #. /etc/fstab
      #
      # /etc/fstab
      # Created by anaconda on Tue Mar 17 01:42:54 2015
      #
      # Accessible filesystems, by reference, are maintained under '/dev/disk'
      # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
      #
      /dev/sda1 /                       ext4    defaults        1 1


#. change /boot/grub2/grub.cfg

   .. code-block:: bash

      if [ x$feature_platform_search_hint = xy ]; then
          search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos1 --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1 --hint='hd0,msdos1'  35bf2afd-b8f4-4a7e-ab82-12adba3e8cbc
      else
          search --no-floppy --fs-uuid --set=root 35bf2afd-b8f4-4a7e-ab82-12adba3e8cbc
      fi

      ####### change from above to the below  
      if [ x$feature_platform_search_hint = xy ]; then
                search --no-floppy --file --set=root --hint-bios=hd0,msdos1 --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1 --hint='hd0,msdos1'  /boot/vmlinuz-3.10.0-123.20.1.el7.x86_64
      else
          search --no-floppy --file --set=root /boot/vmlinuz-3.10.0-123.20.1.el7.x86_64
      fi


      
redhat
======

just select software devleopment workstation. anything is ready except python 2.7.

you can use vino-preference to config.

unlock keyring
--------------

rm -fr ~/.gnomme2/default/default.keyring
