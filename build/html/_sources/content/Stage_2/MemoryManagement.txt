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

而如何查看这些东东呢。 linux采用的策略那就是能用我就尽量用，你需要用我就让给你。所以你会发现linux的buffer与cache会非常的大。

.. csv-table:: memory management
   :header: command/file, content,remark

   free, 查看系统的剩余内存
   /proc/meminfo/, 系统占用的内存
   /proc/pid/maps, 进程占用的虚拟地址
   /proc/pid/stam, 进程所占用的内存
   /proc/kcore,   kernel的大小
   /etc/sysctl.conf, 来控制各种内存资源分配情况, http://blog.csdn.net/leshami/article/details/8766256 
   /etc/sysctl, 直接动态的去改内核的参数,并取代ulimit的接口

进程的内存分配
==============

前1G之前是给内核用的，在gdb中通过info file 就可以看一个进程文件占用多大的空间。 
在android, 它一般是从 0x400d0134=1G的地方开始的。
然后就是逐section，逐文件地进行加加载。
基本上都是 .interp->.dynsym->.dynstr->.hash->.rel.dyn->.rel.plt->.plt->.text->XXX->.rodata->.preinit_array->.init_array->fini_array->.data.rel.ro->.dynamic->.got>.bass

