linux 的生与死
==============

   linux 启动模式是由 `linux的运行模式：Runlevel详细解析 <http://linux.ccidnet.com/art/9513/20070428/1072625&#95;1.html>`_  决定的，它是由 `/etc/inittab <http://book.51cto.com/art/200906/127324.htm>`_  来控制的，telinit 是用来发送信号进行init. shutdown reboot都是跟 runlevel相关，默认的level,都在rc.XX.d下软链接，并且也是00-99的数字，并且SK表示特殊的意义来开始。原来的GTL的方式是在学习RC 机制。
   
   
   对于系统的控制，很大部分那就是各种service的起动的控制，系统基本起来了，就是各种服务进程，这个主要就在init.d这个阶段进行，如何开机自己等都是在此做的，同时自己需要一些定制的也主要集中此的。
   
   对于ubuntu简单直接，/ect/rc.local就可以了。并且可以查看rc.d 这个目录下东东。 这个每个系统也是不一样的。同时有些系统已经支持并行启动了，例如SUSE中已经支持了。具休可查看/ect/rc.d/README,并且在/etc/rc.d/boot中控制。 一旦并行就会有步同步依赖的问题，也这也是各种before,after 机制的原因，这些就是用来控制顺序的吧。
   对于SUSE 是有一些麻烦，要用到http://unix.stackexchange.com/questions/43230/how-to-run-my-script-after-suse-finished-booting-up， 写标准init 脚本并注册了。当然也简单的做法例如直接/etc/rc.d/after.local 等来进行hook, http://www.linuxidc.com/Linux/2012-09/71020.htm.
   对于windows 来说，也就是注册表了开机启动了。
   不同的系统对于这部分都有不同的优化。



