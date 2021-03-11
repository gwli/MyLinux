*********
SETLINUX
*********

最初权限管理的度太大，owner,group,public等。 
为了实现更细粒度的保证。selinux采用了标签加权限的机制。


采用 client/Server, policy code 与 descision-make， 计算放在服务器端，当然本地会有一个cache,以及 context SSID为索引。 

API接口，execve_secure,open_secure,stat_secure.
:file:`proc/self/attr/exec` , :file:`/proc/self/attr/fscreate` .
实现原理https://www.nsa.gov/research/_files/selinux/papers/module/t1.shtml

权限分两部分，文件本身的权限。 用户的权限。
两者相匹配才能工作。

权限分配的最小粒度是每条命令，还是基于进程的。


`Linux的SElinux用法 <http://jingyan.baidu.com/article/af9f5a2d24123f43140a453a.html>`_ 

/proc/pid/attr 就是linux selinux组成部分。
`SELINUX的基本用法 <http://blog.sina.com.cn/s/blog_8930178b0100z65u.html>`_

可以用 :command:`ls -Z` 来查看selinux context,同是可以用chcon来改变权限。
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security-Enhanced_Linux/sect-Security-Enhanced_Linux-Working_with_SELinux-SELinux_Contexts_Labeling_Files.html
以及windows的组策略也是同样的机制。

linux 一切权限都是UID为基础的。

https://en.wikipedia.org/wiki/Linux_Security_Modules


现在的linux权限管理LSM管理即有task,文件本身，以及user自身的。要所以要想突破这种限制就必须其原子操作内部实现。
LSM 是集成在内核里。

.. code-block:: python

   task_struct,   Task(Proces)
   linux_binprm   Program
   supper_block   Filesystem
   inode          Pipe,File, or Socket
   file           Open File
   sk_buff        Network Buffer(Packet)
   net_device     NetworkDevice
   kem_ipc_Perm   Semaphore,Shared Memory Segment or Message Queue
   msg_msg        Individual Message


AppArmor
========

基于文件路径的，防护，简单容易维护。与selinux的对比见https://www.suse.com/support/security/apparmor/features/selinux_comparison.html

https://wiki.ubuntu.com/AppArmor 使用说明。


PAM
===

https://github.com/linux-pam/linux-pam

主要是对用户的验证。 采用分离的模块，把验证与正常的程序使用分离开来。更利于扩展开发，而不是每一个应用程序里包含自己的验证。所有默认的库放在 /usr/lib/security下面，并且支持一些if的判断条件，includer指令。 实现小的验证语言，并且在/etc/pam.d/每一个应用程序一个验证脚本。每一个模块的用法，都可以用man pam_access这样来访问。这里有一个例子https://www.ibm.com/developerworks/cn/linux/l-polyinstantiation/l-polyinstantiation-pdf.pdf。 之前的ssh的登录session的环境变量的问题，应该就是出在这里。

如何troubleshoot,可以使用 pam_echo 指令，以及各个模块的debug选项， log都打在syslog 可以在/var/log/secure. 

https://www.ibm.com/developerworks/cn/linux/l-pam/
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Managing_Smart_Cards/PAM_Configuration_Files.html
其实这三种都是验证与应用要本身是分离的。使用说明见 http://www.linux-pam.org/, 在 linux能看到那就是 /etc/pam.conf 有点类似于把权限管理给外包出去，这样有助于集中管理。同时也不需要应用程序开发者来考虑安全问题。


