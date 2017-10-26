****
SUSE
****

安装要求 
========

#. install build toolchain
#. auto login as root
#. config vnc  yast/vnc administrator
#. install nvidia driver
#. disable fireware
#. setup ssh 
#. startup application
#. config /etc/fstab
#. disable screen lock


.. note::
   
  gnome-control-center 控制面板





如何安装 nvidia driver
======================

.. code-block:: bash

   # install kernel source
   # insert 2nd DVD
   zypper install kernel-source
   rcxdm start
   ./NVIDIA-linux-x86_64.run
   rcxdm stop



#. chkconfig 启动service http://superuser.com/questions/752448/how-to-make-a-service-start-in-suse-enterprise-linux
#. How to run my script after SuSE finished booting up http://unix.stackexchange.com/questions/43230/how-to-run-my-script-after-suse-finished-booting-up

#. disable firewall

   .. code-block:: bash

      /sbin/SuSEfirewall2 off
      /sbin/SuSEfirewall2 on
      /etc/init.d/SuSEfirewall2_setup stop

#. Root autologin: https://gist.github.com/gwli/c94fec782aab125d6a0c
  
   :command:`vi /etc/sysconfig/displaymanager`

   .. code-block:: python
      :emphasize-lines: 1

      DISPLAYMANAGER_AUTOLOGIN=”root”

