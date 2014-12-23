:author: GangweiLi
:comment: No
:CreateDate: 14-07-10
:status: C
:name: LinuxKernel

*IO*
每一种外设备都是通过读写设备上的寄存器来进行的，寄存器又分为：控制寄存器，状态寄存器，数据寄存器。

[[http://wenku.baidu.com/view/00d760260722192e4536f6c7.html][Linux下的IO地址访问的研究]]
[[http://wenku.baidu.com/view/f439355777232f60ddcca152.html][Linux系统启动过程分析详解]]
[[http://blog.csdn.net/shinesi/article/details/1933851][从Linux2.4以后，全部进程使用同一个TSS,2.4以后不再使用硬切换，而是使用软切换，寄存器不再保存在TSS中了，而是保存在task->thread中]]一个线程就对应一个LDT的一项，内核是对物理硬件所做的一层抽象。而进程则是对CPU+内存+硬盘一种抽象。而线程则是对CPU的一种抽象。
linux 采用二级页表机制，页表目录和页表＋页内基址。　Page=4K.

其实一个本质问题在于，如何这样的解读内存结构，这个与包的结构是一样的，是采用TLK的模式还是表头然后内容的方式。首先是分配大小。然后要根据自定义的结构来读写内存。类的内存结构与包的结构是一样的道理。
进程与程序的关系
----------------

     <img src="%ATTACHURLPATH%/C_memory.jpg" alt="C_memory.jpg" width='600' height='450'  align=right />
   * [[http://learn.akae.cn/media/ch18.html][C语言到汇编到机器语言到进程转换]]
   * [[http://wenku.baidu.com/view/1f70370a4a7302768e99398b.html][从内存中加载并启动一个exe]]
   * [[http://blog.csdn.net/w_s_xin/article/details/5044457][可执行程序加载到内存的过程]]  第一步就是把文件用[[http://blog.chinaunix.net/uid-26669729-id-3077015.html][mmap]]映射到内存中。哪些库是放在共享区，可以供所有程序去调用，或者还是用到的时候才去加载。 [[http://blog.csdn.net/tigerscorpio/article/details/6227730][Linux下程序的加载、运行和终止流程 ]]
   * [[http://my.oschina.net/solu/blog/2537][程序的内存分配]]只要看到thread_struct结构，它的那些寄存器值的大小限制。
   * [[http://wenku.baidu.com/view/51337c1ab7360b4c2e3f64ce.html][linux内核堆栈]]是全局数据构使用的
   * [[http://wenku.baidu.com/view/c982436d1eb91a37f1115cc4.html][GDT与LDT的关系]]

进程数取决于GDT数据组的大小，线程 的 最 大 数 取 决 于 该 系 统 的 可 用 虚 拟 内 存 的 大 小 。 默 认 每 个 线 程 最 多 可 拥 有 至 多1 M B大小 的 栈 的 空 间 。 所 以 至 多 可 创 建2 0 2 8个 线 程 。 如 果 减 少 默 认 堆 栈 的 大 小  则 可 以 创 建 更多 的 线 程 。

自己学习单片机的时候，就存在一个迷惑，那些操作单片机的小片子如何来支持一个操作系统一样的东西。现在逐渐明白了，其实如何让更多的程序能在计算机跑起来。所谓的空闲，其实CPU一直没有闲着，CPU采用的心忙状态。除非CPU的所有调度都采用中断实现。单片机的存储机制只有两层，那就是寄存器与内存。CPU的操作是不能直接操作内存地址进行运行的，而是要把内容加载到自己的寄存器然后再进行计算，然后再把数据写给回去。现在CPU架构采用是统一地址，这样的话，地址就要分段了，哪些地址是可读的，哪些地址可写的。CPU执行原来就是依赖其那些寄存器。[[http://os.51cto.com/art/201005/199799.htm][ 在此]] linux采用了内核地址与用户空间地址的做法，例如内核地址3G-4G这一段地址留取了内核来用，0-3G这段刘给了用户，用户之间隔离的，内核地址空间是共享的，这里有一个偏移量的问题，更好是3G，把内核地址减3G正好是从头开始，而用户空间从+3G就变成真实空间了。其实一个进程都是对CPU的运算结构进行了抽象，并且对CPU做了两级的抽象，那就是线程。然后由内核把每个程序相关的资源都放在一个进程结构里，一个每个进程就是GDT里的一项。即是哪一段内存给它用。记录与它相关于文件等等，然后按照CPU的结构把寄存器初始化，执行，保存结果然后再换出。每一个进程头是放在GDT中，所以去查看GDT表就以操作当前有多少进行在运行。LDT对应的是线程。一般线程只有代码执行区与寄存器的运行状态记录，而所有资源都是放在进程里。

所以一个进程如右图那分了，３G-4G的那部分地址给内核的，自己的代码区还要占据一定的空间，另外一些全局的数据空间，以及堆栈的地址空间，最后还是自由的地址空间。所以在同一个框架下，一般程序的入口地址都是相同的。然后就把程序初始地址分给CP寄存器。到底指令要占多少呢，也就是我可执行程序有多大呢，这个就要你的[[http://www.mouseos.com/x64/puzzle01.html][指令的长度]]再乘以指令数就是所要占的内存大小了. 当然只要这些计算机就能识别了。但是对于我们人来说有点难懂了。那好吧，再把符号表给加上。这里的[[http://zh.wikipedia.org/wiki/%E7%AC%A6%E5%8F%B7%E8%A1%A8][符号表]] 来记录各种人为可读的标记。然而如何把C语言与汇编语言关联起的。是翻译的过程中如何会记录这些值的呢。  

地址的长度其中之一的功能，那就是寻扯空间变大了，这样的代码就可以更长了。例如8位机，如何顺序代码超过了其寻址能力的话，就无法实施了。就限制了其功能。 

现在回头把操作系统又看了一遍，原来进程是为了并行计算而产生了。解决了原来的只能顺序执行的问题。这样就有了数据段，程序段，进程控制块。这样进程其实就是对CPU结构以及计算机的存储单元的一种抽象。同时操作系统系统与进程的接口，就是这些信号。所在在链接时，所谓的链接器，是由内核来调用加载进程。信号是一种软中断。每一个进程对每一个信号都有一个默认的处理方式。操作系统也占用了几个。同时我们可以进程进行各种操作。通过信号。
   * [[http://www.ituring.com.cn/article/1574][代码混淆器]]也提供了一种代码互相翻译的功能。

---++++ 进程管理
*multi-process and multiple thread*
until now, I find how to use the fork, why we need the fork? when the fork the children copy the code,data from parent process. and then do their own things.  the [[http://bbs.csdn.net/topics/320004714][questions]] of article is good, help me think. you can reference [[http://blog.csdn.net/hairetz/article/details/4281931][here]] why need multiple process. 

%AQUA%
Next to do :
read the init code of linux kernel. to understand the shell and interpreter programming.   
[[http://bbs.chinaunix.net/thread-3685404-1-1.html][Linux系统下init进程的前世今生]]  [[http://lxr.linux.no/linux-old+v0.11/init/main.c#L168][init/main.c sourcecode]]

<verbatim>
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


</verbatim>
%ENDCOLOR%

system call
-----------

   * [[http://www.csee.umbc.edu/courses/undergraduate/CMSC421/fall02/burt/projects/howto_add_systemcall.html][Adding A System Call]] CUDA 应该就是这么干的，添加调用，这样它才知道东东传给GPU去做。
   * [[http://www.tldp.org/HOWTO/html_single/Implement-Sys-Call-Linux-2.6-i386/][Implement-Sys-Call-Linux-2.6-i386]]
  

   brk,sbrk,getrlimit,setrlimit,prlimit查看系统资源的systemcall.


Signal
------
before, I always feel msterious about the signal. but now I know that the signal is always with us. for example, when shutdown, the OS should close all the process, how to do this, send the signal. the basic module of process with glibc should be able to the common signal. for example we use the *kill -9 process* to let the process close. 

essentially, the Signal is relevent logic/soft interrupt with CPU and Hardware. 
[[http://bbs.chinaunix.net/forum.php?mod=viewthread&tid=3660999&page=1&extra=#pid21816738][在ring 0改变watchpoint的值]] continus received SIGTRAP.
 for Debug, there are three way you can control.
    1. state register, this can control CPU behavoier. 
    2. CPU event
    3. interrupt.

SystemLog 机制 
--------------

多进程同写一个文件，就是会同步与原子操作问题。正常情况下，每一个系统调用都是原子操作。原子操作水平是什么样的。例子函数级的，还是指令级，还是API级的，中断CPU指令级，所以所有的单指令操作都是原子操作。同时原子操作都需要下一层的支持，在同一步不可有做到真正有效原子操作。就像第三方的中立性一样。这个就需要系统构构了，例如ARM的结构，并且内核的原子操作都是直接用汇编来锁定总线来搞定的，这个是C语言做不到的。
   [[http://blog.chinaunix.net/uid-24585858-id-2856540.html][ Linux系统环境下关于多进程并发写同一个文件的讨论 ]]
   [[http://www.chinaunix.net/old_jh/23/804742.html][多个进程把日志记录在同一个文件的问题]] 利用消息队列+单进程读写文件 会大大改善IO，但是多机并行的机制呢。

See also
--------

   * [[http://blog.sina.com.cn/s/blog&#95;6444798b0100pslu.html][浅析动态内存分配栈与堆]] 当数据量非常大时，使用什么策略来用内存。例如我们能同时对多少个数进行排序。
   * [[http://lxr.linux.no/+trees][linux sourcecode search]] %IF{" '' = '' " then="" else="- "}%
   * [[http://www.ibm.com/developerworks/cn/linux/l-cn-sysfs/][/sysfs 文件系统类似于/proc 但是优于/proc]] %IF{" '' = '' " then="" else="- "}%
#ReferenceLink
%TWISTY{link="add a bookmark"  imageleft="%ICON{edittopic}%"}%
%COMMENT{type="bookmark"  location="#ReferenceLink"}%
%ENDTWISTY%

---+++ Thinking


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
#ReflectAndStudy
%TWISTY{showimgleft="%ICON{rfc}%"
	hideimgleft="%ICONURLPATH{toggleclose}%"}%
%COMMENT{ location="#ReflectAndStudy"}%
%ENDTWISTY%

%META:FORM{name="System.TopicForm"}%
%META:FIELD{name="Title" attributes="" title="Title" value="LinuxKernel"}%
%META:FIELD{name="Category" attributes="" title="Category" value="Infrastructure"}%
%META:FIELD{name="Date" attributes="" title="Date" value="3 Dec 2012"}%
%META:FIELD{name="Status" attributes="" title="Status" value="New"}%
%META:FIELD{name="tags" attributes="" title="tags" value=""}%
%META:FILEATTACHMENT{name="DirectedGraphPlugin_1.png" attachment="DirectedGraphPlugin_1.png" attr="h" comment="<nop>DirectedGraphPlugin: DOT graph" date="1354466801" size="53990" user="GangweiLi" version="7"}%
%META:FILEATTACHMENT{name="C_memory.jpg" attachment="C_memory.jpg" attr="" comment="" date="1360289024" path="C_memory.jpg" size="35851" user="GangweiLi" version="1"}%
