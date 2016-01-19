LinuxKernel
===========

与main函数的区别就在需要链接的地方不一样，至少开头是静态链接的，对用initrd 之类的都采用两次load法，起动之前一次，起动后更新。 为了解决鸡生蛋，蛋生鸡的问题。同时对模块的热加载功能，insmode,rmmode,其实本质就是dllexport的功能。只是内核支持动态加载，而一般的应用程序做不到，只能通过gdb来这样么做。但是unreal 是能够做到一点。做到热加载的，编译之后直接可以用，不需要重起。

https://onedrive.live.com/edit.aspx/%e6%96%87%e6%a1%a3/GW%20%e7%9a%84%e7%ac%94%e8%ae%b0%e6%9c%ac?cid=0620a0b4441149e5&id=documents&wd=target%28%E5%BF%AB%E9%80%9F%E7%AC%94%E8%AE%B0.one%7C38E3E883-E41F-4858-BFB1-0BD8ED9EC575%2F%E4%B8%89%E8%A8%80%E4%B8%A4%E8%AF%AD%E8%81%8AKernel%EF%BC%9A%E4%BB%8ELinux%E5%88%B0FreeBSD%20-%20One%20Man%27s%20Yammer%7C80CCE1E5-1CD0-4CFE-979A-1832E55AAA29%2F%29
onenote:https://d.docs.live.net/0620a0b4441149e5/文档/GW%20的笔记本/快速笔记.one#三言两语聊Kernel：从Linux到FreeBSD%20-%20One%20Man's%20Yammer&section-id={38E3E883-E41F-4858-BFB1-0BD8ED9EC575}&page-id={80CCE1E5-1CD0-4CFE-979A-1832E55AAA29}&end

对于linux  整体的理解在上面写的很到位。 内容启动顺序是何定义的，根据优先级，同一优先级是根据链接顺序来的。而FreeBSD 则是SYSINIT固定的。

*IO*

每一种外设都是通过读写设备上的寄存器来进行的，寄存器又分为：控制寄存器，状态寄存器，数据寄存器。

`Linux下的IO地址访问的研究 <http://wenku.baidu.com/view/00d760260722192e4536f6c7.html>`_ 

从Linux2.4以后，全部进程使用同一个TSS,2.4以后不再使用硬切换，而是使用软切换，寄存器不再保存在TSS中了，而是保存在task->thread中 <http://blog.csdn.net/shinesi/article/details/1933851>`_ 一个线程就对应一个LDT的一项，内核是对物理硬件所做的一层抽象。而进程则是对CPU+内存+硬盘一种抽象。而线程则是对CPU的一种抽象。
linux 采用二级页表机制，页表目录和页表＋页内基址。　Page=4K.

其实一个本质问题在于，如何这样的解读内存结构，这个与包的结构是一样的，是采用TLK的模式还是表头然后内容的方式。首先是分配大小。然后要根据自定义的结构来读写内存。类的内存结构与包的结构是一样的道理。

进程与程序的关系
----------------

     <img src="%ATTACHURLPATH%/C_memory.jpg" alt="C_memory.jpg" width='600' height='450'  align=right />
#. `C语言到汇编到机器语言到进程转换 <http://learn.akae.cn/media/ch18.html>`_ 
#. `从内存中加载并启动一个exe <http://wenku.baidu.com/view/1f70370a4a7302768e99398b.html>`_ 
#. `可执行程序加载到内存的过程 <http://blog.csdn.net/w_s_xin/article/details/5044457>`_   第一步就是把文件用`mmap <http://blog.chinaunix.net/uid-26669729-id-3077015.html>`_ 映射到内存中。哪些库是放在共享区，可以供所有程序去调用，或者还是用到的时候才去加载。 `Linux下程序的加载、运行和终止流程  <http://blog.csdn.net/tigerscorpio/article/details/6227730>`_ 
#. `程序的内存分配 <http://my.oschina.net/solu/blog/2537>`_ 只要看到thread_struct结构，它的那些寄存器值的大小限制。
#. `linux内核堆栈 <http://wenku.baidu.com/view/51337c1ab7360b4c2e3f64ce.html>`_ 是全局数据构使用的
#. `GDT与LDT的关系 <http://wenku.baidu.com/view/c982436d1eb91a37f1115cc4.html>`_ 

进程数取决于GDT数据组的大小，线程的最大数取决于该系统的可用虚拟内存的大小。默认每个线程最多可拥有至多1MB大小的栈的空间。所以至多可创建2028个线程。如果减少默认堆栈的大小则可以创建更多的线程。

自己学习单片机的时候，就存在一个迷惑，那些操作单片机的小片子如何来支持一个操作系统一样的东西。现在逐渐明白了，其实如何让更多的程序能在计算机跑起来。所谓的空闲，其实CPU一直没有闲着，CPU采用的心忙状态。除非CPU的所有调度都采用中断实现。单片机的存储机制只有两层，那就是寄存器与内存。CPU的操作是不能直接操作内存地址进行运行的，而是要把内容加载到自己的寄存器然后再进行计算，然后再把数据写给回去。现在CPU架构采用是统一地址，这样的话，地址就要分段了，哪些地址是可读的，哪些地址可写的。CPU执行原来就是依赖其那些寄存器。` 在此 <http://os.51cto.com/art/201005/199799.htm>`_  linux采用了内核地址与用户空间地址的做法，例如内核地址3G-4G这一段地址留取了内核来用，0-3G这段刘给了用户，用户之间隔离的，内核地址空间是共享的，这里有一个偏移量的问题，更好是3G，把内核地址减3G正好是从头开始，而用户空间从+3G就变成真实空间了。其实一个进程都是对CPU的运算结构进行了抽象，并且对CPU做了两级的抽象，那就是线程。然后由内核把每个程序相关的资源都放在一个进程结构里，一个每个进程就是GDT里的一项。即是哪一段内存给它用。记录与它相关于文件等等，然后按照CPU的结构把寄存器初始化，执行，保存结果然后再换出。每一个进程头是放在GDT中，所以去查看GDT表就以操作当前有多少进行在运行。LDT对应的是线程。一般线程只有代码执行区与寄存器的运行状态记录，而所有资源都是放在进程里。


进程的内存功能分块

#. 代码区，主要用来存储二制代码
#. 数据区 用于存放全局变量
#. 堆区，动态的进行内存的分配与回收。
#. 栈区，主要存储函数的参数以及返回地址等目的被 调用函数执行完毕后能够准确的返回到冷饮函数继续执行。



所以一个进程如右图那分了，３G-4G的那部分地址给内核的，自己的代码区还要占据一定的空间，另外一些全局的数据空间，以及堆栈的地址空间，最后还是自由的地址空间。所以在同一个框架下，一般程序的入口地址都是相同的。然后就把程序初始地址分给CP寄存器。到底指令要占多少呢，也就是我可执行程序有多大呢，这个就要你的`指令的长度 <http://www.mouseos.com/x64/puzzle01.html>`_ 再乘以指令数就是所要占的内存大小了. 当然只要这些计算机就能识别了。但是对于我们人来说有点难懂了。那好吧，再把符号表给加上。这里的`符号表 <http://zh.wikipedia.org/wiki/%E7%AC%A6%E5%8F%B7%E8%A1%A8>`_  来记录各种人为可读的标记。然而如何把C语言与汇编语言关联起的。是翻译的过程中如何会记录这些值的呢。  

地址的长度其中之一的功能，那就是寻扯空间变大了，这样的代码就可以更长了。例如8位机，如何顺序代码超过了其寻址能力的话，就无法实施了。就限制了其功能。 

现在回头把操作系统又看了一遍，原来进程是为了并行计算而产生的。解决了原来的只能顺序执行的问题。这样就有了数据段，程序段，进程控制块。这样进程其实就是对CPU结构以及计算机的存储单元的一种抽象。同时操作系统系统与进程的接口，就是这些信号。所在在链接时，所谓的链接器，是由内核来调用加载进程。信号是一种软中断。每一个进程对每一个信号都有一个默认的处理方式。操作系统也占用了几个。同时我们可以进程进行各种操作。通过信号。


对于内存地址的真实分配可以从 dmesg里看到 VirtualKernel memory layout，也可以从 /proc/
http://unix.stackexchange.com/questions/5124/what-does-the-virtual-kernel-memory-layout-in-dmesg-imply

一个kernel的内核也没有多大，也就几M大小，可以 ll -h /boot 就可以看到它的大小。 只是添加内存的分配与dll的扩展功能。一供也才不超过6M大小。一个指令4个字节。也就不超过 6M/4=1572864 条指令，最多需要1.5M地址就够了。 而8位的只能256条指令，16位也只64K的地址长度，32位 就有了4G的地址。 所以在32位上我们停留很长时间，因为我们32位对于我们来说，已经远远大于逻辑指令了。只所以要让上升64位，主要是数据空间的不足。而到了64位地址长度基本上就目前需求就相当于无穷大了，也很巧的周易也只推演到了64卦就停止了。

#. `代码混淆器 <http://www.ituring.com.cn/article/1574>`_ 也提供了一种代码互相翻译的功能。

安全策略
========

linux 的内核支持 security module的支持，你可以加添加各种安全模块，以及定义安全策略，例如selinux,

进程管理
========

以前是单核分时复用机制，只用考虑时间的分配，而现在出现了真正的多核与多线程机制。实时性的问题也就解决了很多。同时对于调度也有很大的区别。例如如果让进程在多个核上切换，而上车与下车都是要overhead,如何使减少。这个很重要。

出现这个sched_yield, 这个API是为了提高效率，当发现自己被blocking了，就CPU的运行权交出去。以前的进程比较难控制自己的执行。
http://blog.csdn.net/magod/article/details/7265555

*multi-process and multiple thread*
until now, I find how to use the fork, why we need the fork? when the fork the children copy the code,data from parent process. and then do their own things.  the `questions <http://bbs.csdn.net/topics/320004714>`_  of article is good, help me think. you can reference `here <http://blog.csdn.net/hairetz/article/details/4281931>`_  why need multiple process. 


*cputopology* 

多核CPU拓扑， https://www.kernel.org/doc/Documentation/cputopology.txt


`linux内核调度算法（3）--多核系统的负载均衡 <http://blog.csdn.net/russell_tao/article/details/7102297>`_ 


http://www.ibm.com/developerworks/cn/linux/l-cn-sysfs/   /sys 是sysfs的挂载点，取代了/proc的大部分功能，并且经过了很好的设计。

当然也可以用 man /proc 与man sysfs来得到更多信息。
.. ::
 
   print "Started with the heartbeat host $HeartbeatHost:$HeartbeatPort\n";
   
   if($ForkFlag)
     {
      if(fork())
       {
        exit(0);
       }
   
      close(STDIN);
      close(STDOUT);
      close(STDERR);
     }
   
   SetupSocket();
   while(1) 
    {
     SendHeartbeat();
     sleep($SleepTime);
    }
   
   
   

%ENDCOLOR%

system call
-----------

#. `Adding A System Call <http://www.csee.umbc.edu/courses/undergraduate/CMSC421/fall02/burt/projects/howto_add_systemcall.html>`_  CUDA 应该就是这么干的，添加调用，这样它才知道东东传给GPU去做。
#. `Implement-Sys-Call-Linux-2.6-i386 <http://www.tldp.org/HOWTO/html_single/Implement-Sys-Call-Linux-2.6-i386/>`_ 
  

   brk,sbrk,getrlimit,setrlimit,prlimit查看系统资源的systemcall.
libc的库有一个gensyscalls.py 生成 syscall 例表。 /ndk/toolchains/X/prebuild/<platofrm>/share/lib/syscalls 可以看到各个系统的system call 个数，现在linux 325个API。

这些systemcall与大部分 shell 命令是对应的，例如mkdir等，其实本质就让shell 过程 

   while(1) {
     switch {syscall} {
       case ...:  {do something};
     }
   }


其实内核就是一个数据结构，我们只是在不断的改其设备，就像 game Engine是一样的。

Signal
------
before, I always feel msterious about the signal. but now I know that the signal is always with us. for example, when shutdown, the OS should close all the process, how to do this, send the signal. the basic module of process with glibc should be able to the common signal. for example we use the *kill -9 process* to let the process close. 

essentially, the Signal is relevent logic/soft interrupt with CPU and Hardware. 
`在ring 0改变watchpoint的值 <http://bbs.chinaunix.net/forum.php?mod=viewthread&tid=3660999&page=1&extra=#pid21816738>`_  continus received SIGTRAP.
 for Debug, there are three way you can control.
 #. state register, this can control CPU behavoier. 
    2. CPU event
    3. interrupt.

SystemLog 机制 
--------------

多进程同写一个文件，就是会同步与原子操作问题。正常情况下，每一个系统调用都是原子操作。原子操作水平是什么样的。例子函数级的，还是指令级，还是API级的，中断CPU指令级，所以所有的单指令操作都是原子操作。同时原子操作都需要下一层的支持，在同一步不可有做到真正有效原子操作。就像第三方的中立性一样。这个就需要系统构构了，例如ARM的结构，并且内核的原子操作都是直接用汇编来锁定总线来搞定的，这个是C语言做不到的。

   `Linux系统环境下关于多进程并发写同一个文件的讨论  <http://blog.chinaunix.net/uid-24585858-id-2856540.html>`_ 
   `多个进程把日志记录在同一个文件的问题 <http://www.chinaunix.net/old_jh/23/804742.html>`_  利用消息队列+单进程读写文件 会大大改善IO，但是多机并行的机制呢。



debug
=====

内核中开发调试是最难的，简单是直接使用log,你如dmesg,以及在内核中打开更多的debug 选项，以及klogd,以及 在内核中打开远程调试来进行debug.
http://www.embeddedlinux.org.cn/html/yingjianqudong/201303/12-2480.html
也可以采用类似于pdb的做法，动态调试直接在加入汇编指令来做。
http://blog.chinaunix.net/uid-20746260-id-3044842.html


module 本身也是 debug选项可以用的。 可以参看manual.

See also
--------

#. `浅析动态内存分配栈与堆 <http://blog.sina.com.cn/s/blog&#95;6444798b0100pslu.html>`_  当数据量非常大时，使用什么策略来用内存。例如我们能同时对多少个数进行排序。
#. `linux sourcecode search <http://lxr.linux.no/+trees>`_  
#. `/sysfs 文件系统类似于/proc 但是优于/proc <http://www.ibm.com/developerworks/cn/linux/l-cn-sysfs/>`_  

Thinking
========

*你对linux哪一个熟*
我是当linux当作一个仓库，遇到一些问题，是里面看看他都是如何实现的。然后结合自己的需求来实现。



-- Main.GangweiLi - 02 Dec 2012


sysctl modifies kernel parameter at runtime

-- Main.GangweiLi - 15 Apr 2013


现在对于linux的文件系统有了更加深切的认识：
/usr/{include/src/lib)  这个里面放开发环境库
/usr/share/ 放了一些共享的信息例如man 等。
/lib/ 下面放的runtime lib 

-- Main.GangweiLi - 04 Nov 2013


*对于环境变量* 在操作系统内部进程之间的交互，很大一部分那就是还环境变量与配置文件，例如os.system如何知道系统有哪些环境变量呢，就是通过Path来知道的，所以如何才能加一条命令呢，那需要加入相应的path就可以，就可以让其os.system得到这条命令了。

-- Main.GangweiLi - 17 Apr 2014

