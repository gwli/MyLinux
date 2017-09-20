SUSE
====

如何安装NV driver
-----------------

.. code-block:: bash

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

