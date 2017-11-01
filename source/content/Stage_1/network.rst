****
网络
****


如何检查网速
============

自己直接ifconfig ; sleep 1;ifconfig 查看结果相减就可以了。当然也有一些其他的命令
nload,iftop,iptraf,nethogs,bmon http://os.51cto.com/art/201404/435279.htm

dns lookup
==========

nslookup 可以查询IP,或者域名。

:file:`/etc/resolve.conf` 来配置DNS 

IP 冲突
=======

在windows下会有直接提示IP冲突。 在linux下则没有。

如何检则
--------

#. 在其中冲突的一台用 :command:`arping` . 

   .. code-block::
      
      localhost:~ # arping -I eth1 10.19.189.113
      ARPING 10.19.189.113 from 10.19.189.122 eth1
      Unicast reply from 10.19.189.113 [AC:22:0B:4B:98:6F]  0.735ms
      Unicast reply from 10.19.189.113 [78:24:AF:C0:B7:48]  0.787ms
      Unicast reply from 10.19.189.113 [78:24:AF:C0:B7:48]  0.866ms
      Unicast reply from 10.19.189.113 [78:24:AF:C0:B7:48]  0.861ms
      Unicast reply from 10.19.189.113 [78:24:AF:C0:B7:48]  0.863ms
      Unicast reply from 10.19.189.113 [78:24:AF:C0:B7:48]  0.930ms
      Unicast reply from 10.19.189.113 [78:24:AF:C0:B7:48]  0.861ms
      Unicast reply from 10.19.189.113 [78:24:AF:C0:B7:48]  0.863ms
      Unicast reply from 10.19.189.113 [78:24:AF:C0:B7:48]  0.861ms
      Unicast reply from 10.19.189.113 [78:24:AF:C0:B7:48]  0.863ms

#. 查看本地的arp cache

   .. code-block::
      
      $ arp -a <IP>

如何更新DHCP获得IP地址
----------------------

#.  用ifconfig 
    
    :command:`ifconfig set eth0 DPCP`

#. 用dhclient

   :command:`dhclient -r && sleep 20 && dhclient`

dhcp 的配置文件在 /etc/sysconfig/network/dhcp

.. code-block:: bash

   # If it happens during booting it won't be a problem and you can
   # safely say "yes" here. For a roaming notebook with X kept running, "no"
   # makes more sense.
   #
   DHCLIENT_SET_HOSTNAME="no"
   
   ## Type:        string
   ## Default:     AUTO


gentoo 的网卡启动过程
---------------------

#. 上电启动，内核的加载驱动并注册相应的中断，内核可以识别硬件了。
#. udev 识别硬件信息，并建立相应的逻辑设备，例如网卡哪一个eth0,哪一个是eth1,以及USB
   等等。所以要改设备的逻辑名，就是在这个时候时候改的 :file:`/etc/udev/rules.d/`
#. init 根据runlevel决定起哪些服务。
   各个启动过程，几家linux的实现，大体上一致，而事实是各个不相同。 
   
   #. gentoo 是在 :file:`/etc/runlevel` 下的，并且采用 :command:`rc-config` 来查看的。 
      直接在对应的level下建立一个link 就可以了。
   #. SUSE 的启动是并行的，是用.before, .after等来实现的。
   #. 

#. 对于
