*********
USBOverIP
*********


现在这个是linux已经支持的protocal, USBoverIP. 
你可以 apt-install usbip
但是在 14.04是 linux-tools-genric-lts--utopic.

命令行工具在 :file:`/usr/lib/linux-lts-uptoic-tools-xxx.xx/`


基本流程
========

#. server 
   
   .. code-block:: bash

      ./usbipd -D
       
      #check what device on local
      ./usbip list -l 
      
      # bind the device to the server
      ./usbip bind -b 3-3
      #or
      ./usbip bind -b 3-3:1.0

#. client
   
   .. code-block:: bash

      ./usbip list -r <remotehostip>
      ./usbip attach 



但在ubuntu14.04 跑不起来。

.. code-blocK:: bash

   ../usbipd -D -d
   libuspip: error:  udev_device_get_sysattr_value failed

https://github.com/torvalds/linux/tree/master/tools/usb/usbip
https://github.com/solarkennedy/wiki.xkyle.com/wiki/USB-over-IP-On-Ubuntu
https://github.com/forensix/libusbip
