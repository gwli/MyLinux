****
网络
****



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



