:author: GangweiLi
:comment: No
:CreateDate: 14-07-10
:status: C
:name: LinuxKernel

内存结构
--------

*内存模型*
由最初的点线面关系问题，自己理解了内存是如何转化的过程。也就是知道一个矩阵如何在内存的问题。至于类与结构体，都是我们人对被处理对象进行的建模，其实就是向量。但是向量的里面的每个成员是不一样。例如哪些是变量，哪些函数。然后哪里数据区存放的地方，以及代码存放的地方。在Ｃ与Ｃ＋＋中结构体与类都是从前往后按照先后顺序的。只要知道首地址，以及数据的长度，其实也就是ＴＬＶ格式。数据的类型就是代表数据长度。起始地址是可以推算出来的。

内存地址的长度是根据ＣＰＵ的地址线来决定的。
不同CPU的构架，内存框架结构也不一样的，一种ＵＭＡ模式所有内存地址都一样，另一种那就是分类内存，其实本质两者都是一样的，如果把他们看成内存地址的话。[[http://wenku.baidu.com/view/0364850b763231126edb11a8.html][内存的分类笔记]]   并且现在明白内核映像只有５１２ＫＢ的原因，并且压缩格式的原因，是始于硬件本身初以状态下能够读入程序块有多大。不同的硬件，限制不一样。最小是５１２kb.例如硬盘的０磁道０磁头０扇区。只有５１２KB.

以前看龙书，有点看不动，现在再回头看龙书是那么一目了然。把内存管理那一张给看了之后，就全明白了，段页式管理是要解决两个问题。page swapping是为了解决内存不足的问题。而segment是为了解决了灵活性的问题。例如把代码改了，然后大小变了，所有地址都要重定向了。有了段之后，就把把影响变到最小，只用改段基址就可以了。就不用所有段重排了。进程结构是与CPU的物理结构相对应的。
并且现在CPU大部分都已经支持段了吧。这个就要看CPU的性能了。首先要了解需求。在解决什么问题。那个在面试的问的问题，就已经解决了，是因为它们没有段的结构，所以不能解决灵活性的问题，它们只是简单的页式吧。page是基于硬件的，segment是基于逻辑需求的。理解这些如何快速来得到使用这些就可以根据新需求与以及硬件功能来实现新的算法了。其实就是各个层面的排序与查找了。数组的高效以及链表的灵活。现在也明白了malloc的实现原理了，其实就是在改进程的data的首尾了。
page 的base为重定向，而limit是为了防止越界。

.. graphviz::

   digraph memoryStucture {
       rankdir = LR;
       node [shape = box ];
       ZONE_DMA [  shape = record  label = "<f0> 0-16MB  | <f1> INIT address 0XFFFF0  BIOS  |<IDT> Interrupt Table  |<GDT>  Global Descriptor Table |<LDT> Local Descriptor Table "];
       ZONE_NORMAL [label = "16MB-896MB"];
       ZONE_HIGHMEM [label = "896- END of Physical memory"];
       MainLayout [ shape = "record" label = "<f0> ZONE_DMA |<f1> ZONE_NORML | <f2> ZONE_HIGHMEM "];
       MainLayout:f0 -> ZONE_DMA:f0;
      MainLayout:f1 -> ZONE_NORMAL;
      MainLayout:f2 -> ZONE_HIGHMEM;
       
   　//IDT
       IDT [shape =record  label ="<f0> 256 Items 8bytes/item |{selector | keyword | offset }" ];
       ZONE_DMA:IDT -> IDT:f0;
       //GDT
      GDT [shape = record  label = "<des> 256 items |<f0> NULL | <f1> CODE Segment  Descriptor| <f2> DATA Segment Descriptor |<f3> SYS Segment Descriptor | <f4> 252 for LDT and TSS　for each TSS"];
      ZONE_DMA:GDT -> GDT:f0;
      //LDT
      LDT [shape = record  label ="<fes> 5 items | <f0> CODE segment | <f1> Data segment |<f2> BSS | <f3> Heap | <f4> stack"];
        ZONE_DMA:LDT -> LDT:f0;
   
   }

#. [[http://guaniuzhijia.blog.163.com/blog/static/16547206920109914658702/][linux下进程的堆栈大小设置  ]] %IF{" 'ulimit -a 可以查看所有' = '' " then="" else="- "}%ulimit -a 可以查看所有
进程可以修改栈的大小，如果没有指定那么编译就是用默认的大小限制，linux 默认８Ｍ。

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


device Management
-----------------

when you plug in a new device such as USB. which label "sdb..." will be used for it. here you can use udev. 
   1. db store the user device information
   1. *rule* how to recognize the device.  当你发现你的OS在新的硬件上，不识别，例如网卡不能用了，第一步那就是先把这个rule给删除了。* rm -fr /etc/udev/rules.d/*
   * [[http://blog.csdn.net/absurd/article/details/1587938][ udev的实现原理 ]]
   * [[http://blog.csdn.net/fjb2080/article/details/4876314][ 使用udevadm修改usb优盘在/dev下的名字]]
   * [[http://www.mike.org.cn/articles/linux-xiangjie-udev/][Linux┊详解udev]]

driver 之间的依赖关系是由LKM来管理，`如何自动加载与实现逻辑设备与物理设备的mapping <http://blog.csdn.net/ruixj/article/details/3772798>`_ 主要是对应的pci数据结构，每一个硬件都会用vender,device ID,以及相对应的subID，是通过udev来实现的与管理的，这个就像windows，pnpUtils是一样的。

每一个设备成功后都会占用一个端口号或者内存地址段。应该是每一个硬件都会ID之类的东东，内核来做了这个mapping,例如eth0 对应哪 一个网口。 就像我们在NEAT所做的，逻辑设备与物理设备之间的mapping. 并这个关系更规范与通用化一些。
  
kernel module  driver install and debug
---------------------------------------

kernel module usually end with *xxx.ko*.  from linux kernel 2.6, the kernel use dynamic mechanism. you dynamically insmod,rmmod .  use the depmod to generate /lib/modules/2.6.xx/modules.dep and then modprob would automatically insert the module according the modules.dep.  the driver is one of module.  the module could have alias name. 

.. csv-table::
   :heder: Item,Content,Remark 

   module location , */lib/modules/kernel version /kernel/drivers* ,  ethernet card driver  /lib/modules/2.6.4-gentoo-r4/kernel/drivers/net/r8168.ko ,
   configuration file , etc/modules.autoload.d/XX , you just need to add the module name here. etc/modules.autoload.d/kernel-2.6 ,
   modprobe ,  modprobe  r8168.ko  , the module could have alias name.  etc/modprobe.d/XXXX ,
   depmod  , depmod -a r8168 ,
   dmesg  , kernel会将开机信息存储在ring buffer中。您若是开机时来不及查看信息，可利用dmesg来查看。开机信息亦保存在/var/log目录中，名称为dmesg的文件里。 , dmesg用来显示内核环缓冲区（kernel-ring buffer）内容，内核将各种消息存放在这里。在系统引导时，内核将与硬件和模块初始化相关的信息填到这个缓冲区中。内核环缓冲区中的消息对于诊断系统问题 通常非常有用。在运行dmesg时，它显示大量信息。通常通过less或grep使用管道查看dmesg的输出，这样可以更容易找到待查信息。例如，如果发现硬盘性能低下，可以使用dmesg来检查它们是否运行在DMA模式：,
   
.. seealso::
#. `解析 Linux 内核可装载模块的版本检查机制 <http://www.ibm.com/developerworks/cn/linux/l-cn-kernelmodules/>`_ 以及 `如何突破其CRC验证 <http://blog.aliyun.com/1123>`_ 简单直接把crc值，直接在elf里改成符合规定的值，说白了就是凑答案 .
#. `module common command <http://wiki.linuxdeepin.com/index.php?title=Linux%E5%86%85%E6%A0%B8%E6%A8%A1%E5%9D%97>`_ 以及其`实现机制 <http://read.pudn.com/downloads37/sourcecode/unix_linux/124135/Linux%E5%86%85%E6%A0%B8%E6%A8%A1%E5%9D%97%E7%9A%84%E5%AE%9E%E7%8E%B0%E6%9C%BA%E5%88%B6.PDF>`_ . 
.. code-block::
   
   $dmesg | grep DMA 

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
