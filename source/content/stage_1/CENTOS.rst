Centos
******

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



#. autologin

   .. code-block:: bash
       
       vim /etc/gdm/custom.conf
       [daemon]
       AutomaticEnable=true
       AutomaticLogic=root

.. [ref] http://blog.csdn.net/kpshare/article/details/7523546


#. usb install

http://wiki.centos.org/zh/HowTos/InstallFromUSBkey
   dd if=CenOS-6.5.iso of=/dev/sdb
   ## method 2
   cat XX.iso >/dev/sdb
   sync

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


