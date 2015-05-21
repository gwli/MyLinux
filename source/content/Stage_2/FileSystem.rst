介绍
====

`文件系统 <http://wenku.baidu.com/view/aef3dbc69ec3d5bbfd0a74f3.html>`_ ，任何时候不明白的都先回来看看最原始的教材。文件系统基本的功能，就是文件管理与目录管理。以及磁盘空间分配使用。
为什么要有这么多种文件系统。原因在于一定是不同的硬件实现。底层的实现是不样的。例如磁片硬件，与flash,以及固态硬盘，以及 人们对数据操作要求的不同。这种逻辑的需求与硬件结合的接口就是文件系统。对于不同的存储读写需求以及硬件实现，就会不同的实现实现算法机制。而这些就是文件系统。

对于硬件来说，对于磁盘片来说，那就是CHS。三级了。而对于flash也就又不一样了。 还是拿CHS模型来说，CHS最终还是定位到扇区上，每一个磁道的扇区数是不同的，最外圈的最大，最内圈的最小。每一个硬盘的参数表会有这些值的。
但是对CHS这种分区表方式会8G限制的问题，就有了后来的LBA模式，但是LBA模式最大支持2T限制。 CHS的MBR都是早期老掉牙方案了，虽然大部分讲分区原理都还在讲，但是拿这些理论已经不能解释现在的硬盘分区原理了，例如为什么现在分区是可以用GUID的。不过现在方案兼容老式的MBR。现在你看到的磁盘参数AAAA cylinders, BBBB Headers, CCCC sectors. 主要是为了让你换算LBA值来用的。LBA是绝对扇区号。换算方法是在这里`这里 <http://wenku.baidu.com/view/30e874c789eb172ded63b7c6.html>`_ . 而AAAA，BBBB，CCCC会做为硬盘参数的。
在往后会更大。这个主要是由于MBR机制造成的，因为MBR只留了６４个字节给分区表。现在又出了一种新机制EFI方案中GPT表。`这里 <http://wenku.baidu.com/view/b32e3ac0bb4cf7ec4afed027.html>`_ 有详细的说明。

对应的逻辑设备分为族/块，卷/分区。对应的逻辑存储单位，如何把逻辑单位与物理单位对应起来，就是格式化的过程，在Windows里就是format, 在linux里就是mkfs这条命令的过程之一。系统之上操作都是基于逻辑单位操作的。例如现在是利用的位图来表示，一个位表示一个逻辑单位的空闲与否。同样大小的位图可以多少空间，取决于这个逻辑单位的大小。这个颗粒度的大小匹配你的存储对象的特点。而这些管理都是基于分区的，每一个分区内部肯定首先这些控制模块，还是这些控制模块是放在全局的。每一个最小单位chunk只能在一个文件里，两个文件不能共享同一个chunk.就是为什么你经常看到的，文件的大小与实际占用空间大小是不一样的原因，因为文件本身的大小不可能每次都正好是最小单位的整数倍。

对于管理还说还inode. 对于文件数据本身是可读可写，以及是否支持加密压缩等等。实现起来都是不一样的。每是每一个文件系统都能够提供的。并且还有。例如日志文件系统。对于文件的操作都是如何记录存储的。并且如何进行数据恢复。 常见的存储需求：本身是可读可写，以及是否支持加密压缩，数据恢复功能，读多还是写多，是大数据多还是小数据多等等。以及`性能的要求 <http://wenku.baidu.com/view/a8608606cc175527072208a7.html>`_ 。

为什么要分区呢，是为了管理上的方便，使之具有隔离性，例如装操作系统，就要在独立的分区上。等等。另外也取与操作系统有关心，硬盘的结构MBR. 启动信息与分区表都在这里放着，但是分区表只有64节节，第一个分区占16字节，这样一个分区可如果大于2*312*512=2TB时，这个分区表就不行了。这种物理结构决定了如何进行分区。GPT分区。`EFI、UEFI、MBR、GPT技术 <http://wenku.baidu.com/view/4e9f2714fad6195f312ba677.html>`_  但是GPT模式在Windows上有很大的限制，那就是目录不能当启动盘。

.. graphviz::

   digraph hardisk {
      HardDisk [shape=MRecord, label =< 
        <table>
         <tr>
            <td>
                  <table><tr><td>MBR</td> <td>Partition Table</td> </tr></table>
            </td>
            <td>DBR </td>
            <td>FAT </td>
            <td>DIR </td>
            <td>DATA </td>
         </tr>
        </table>
   >];
   }
   

 | fdisk |  Partition Table |
 | format/mkfs |   DBR |
 | filesystem (inode )| FAT | `这个是基于文件系统的 <http://blog.csdn.net/qianjintianguo/article/details/712590>`_ ，是不同的，主要inode 的结构。
 |    ^ | DIR |
 |  real data | DATA |

每一个分区的超级块放在这个分区的头，如果有就在第二个逻辑块里，一般情况下，第一块是引导块，第二块为super block并且大小固定。并且格式，大小固定。


每一个分区四大块:

.. graphviz::
   digraph filesystem {
      partition  [ shape=Record, label="boot block|super block | inode index block |data block"]
   }

`各种挂载问题 <http://man.chinaunix.net/linux/mandrake/cmuo/admin/camount3.html>`_ 


并且这个根文件系统是在内存里。 可以通过chroot 来修系统 的根在哪里。这在很多地方都能用到，例如安装机制，例如 apache中，当然不能一般用户得以/etc/目录了，所以要把 apache中根目录要改掉才行。并且还可以其他目录拼接成一个新的目录。 

例一个用法，那就是修复系统时可以用到，例如 https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base 把proc 从加载一下，

每一个进程的都会记录自己的根目录在哪里，这样才能解析绝对目录与相对路径。

#. `硬盘知识,硬盘逻辑结构,硬盘MBR详解 <http://wenku.baidu.com/view/b131844d2e3f5727a5e9620d.html>`_ 64 字节的分区表
#. ` Partition Tables <http://thestarman.pcministry.com/asm/mbr/PartTables.htm>`_  
#. `INIX文件系统中，第一个块为引导块，第二个块为超块，之后的N个块是inode位图块(表示哪几个inode被使用了，总的inode个数由超块给出)，紧接着是数据块位图，表示哪些数据块被使用了，紧接着就是inode块和数据块 <http://hi.baidu.com/bicener/item/b628c909039b7b1ceafe38bd>`_ 
#. `ext3 启动过程 <http://alanwu.blog.51cto.com/3652632/1105681>`_ 
#. `硬盘及通用分区结构 <http://cs.ecust.edu.cn/snwei/studypc/operatepc/005.htm>`_ 


`使用sfdisk实现多操作系统引导 <http://wangchunhai.blog.51cto.com/225186/203621>`_   既然说到文件系统，就会主分区以及如何引导启动的问题。无非是在主引导区放了一个自己的引导管理器，来设置起动。而GTL的实现原理在于，用sfdisk来分区，把linux放在这个上面，并且如何保证始终在这个系统。目前看来，默认到都是先到这个操作系统，然后再由这个操作来用sdisk来改分区先项。但是如何来保证每一次都要改了启动选项呢。  `其原理  <http://www.cl.cam.ac.uk/cgi-bin/manpage?8+sfdisk>`_ 是的windows 里使用LBOOT的原理就是利用GDisk 先改分区表，然后再起动。sfdisk 有一堆分区表，而MBR的分区表只表示当前活动的系统可见的分区。 一共有四个启动分区，其中一个常住了linux，并且在这个linux系统里放着sfdisk里的放着一堆分区表，然后系统活动的几个放在系统分区表。并且这个linux始终是第三个分区，所改变的前两项分区表。而Windows能够看到，就是把始动分区切到这个linux分区如果不需要切系统的就不需要了。然后linux再根据自己的分区表来更新系统的分区表。 所以sfdisk 需要一个第三方的东西来保存其分区表，在这里GTL用了第三个分区自身，并且在sfdisk里的一个参数 -o file 就是那个分区表的位置。

分区表除了要表示，分区的大小（通过起点，终点/长度来表示). 还需要分区的状态(活动与否），分区的类型也主要是用操作系统的类型。同一个值可能在不能操作系统下的识别是不一样的。`MBR、分区表、CHS等概念 <http://www.cnblogs.com/hopeworld/archive/2011/03/27/1997298.html>`_  
在DOS或Windows系统下，基本分区必须以柱面为单位划分（Sectors*Heads个扇区），如对于CHS为764/256/63的硬盘，分区的最小尺寸为256*63*512/1048576=7.875MB.
`深入浅出硬盘分区表 <http://www.vckbase.com/index.php/wv/260.html>`_ 分区表实际上一个单向的链表。

　　由于硬盘的第一个扇区已经被引导扇区占用，所以一般来说，硬盘的第一个磁道（0头0道）的其余62个扇区是不会被分区占用的。某些分区软件甚至将第一个柱面全部空出来。并且分区中就有一项，那就是第一个分区前面有多少个隐藏扇区。其实每个分区都会有一个引导扇区，也就是`VBR <http://en.wikipedia.org/wiki/Volume_boot_record>`_ ,整个硬盘的Boot record就是MBR。

现在明白了，老大的要讲故事，也就是要问为什么需要。同时也就是事情的前因后果，以及历史。自己如何早些问，那些文件系统有什么区别，现在也就早明白。直到现在才问。所以现在才明白。
 
| ext2 | http://learn.akae.cn/media/ch29s02.html |
| ntfs  |http://bbs.intohard.com/thread-66957-1-1.html, http://blog.csdn.net/daidodo/article/details/2702648  | `mount utfs as rw <http://www.linuxquestions.org/questions/linux-newbie-8/error-mounting-mount-unknown-filesystem-type-ntfs-926355/>`_  use fuse and ntfs-3g|
| FAT | http://www.sjhf.net/document/fat/#4.3%20%20FAT%E8%A1%A8%E5%92%8C%E6%95%B0%E6%8D%AE%E7%9A%84%E5%AD%98%E5%82%A8%E5%8E%9F%E5%88%99 |
| rootfs |http://blog.21ic.com/user1/2216/archives/2006/25028.html |
|ramfs, rootfs, initrd and initramfs | http://hi.baidu.com/nuvtgbuqntbfgpq/item/537f1638797a88c01b9696f4 |
|loop device /dev/loopXXX | http://www.groad.net/bbs/read.php?tid-2352.html| 把文件以及镜象挂载| 是不是可以利用它来做系统血备份 |
看到现在终于把文件系统看懂一些吧，文件系统分为三层，文件本身内部结构一层，文件系统一层，分区与硬盘之间是一样。当然最初的概念都是结合物理模型的，随着后期的演化，最初的概念已经不是最初了的概念了。例如文件，最初都是就是一段扇区。但是到后期文件的已经完全脱离了，那个物理模型，就是变成了长度，并且这个常度就代表一个字节，并且字节也是一个抽象概念。不同的硬件，扇区的等等的分布是不一样的，不同的文件系统，block,inode之间对扇区对应关系都是不一样的。并且在文件系统上，文件不是顺序存储的。所以也就没有办法智能恢复了，也就只能整个硬盘做一个镜象，虽然你只用了一部分空间。 并且PBR的信息是放在分区里的，如果两个分区参数不一样，也是不行，相当于把分区的信息也复制过来了。而dd只能按块来读，在块之间来做转换。所以dd是在操作系统之下进行的，如果想用dd来做，要么两个分区一模一样，包括同样的位置有同样的坏道。要么要自己去解析文件系统的文件分配自己去读写分配每一个扇区。
   
.. ::
 
   如果想用dd来做,   先做一个OS,并且在硬盘上连续存放的，并且要知道这个区域的大小，或者说估计大约的值。并且硬盘状态一样。 这样可以像Copy文件一样，那样去做了。
   
   另一个问题，分区的结构是否一样呢，如果分区的结构不样，例如索引节点的个数是不一样，这可能是按照分区的大小的百分比来进行的，如果新的分区足够大，就会出现浪费的问题，如果不够大就会可能出现错误。所以partitionclone最好的方式是能够认识文件系统。建立在文件系统上。就样可以解决这个问题了，这也就是为什么partclone要有那么多的，文件系统类型的支持。
   可以直接使用 dd if=/dev/sda of=XXX.ISO   或者cat 直接做光盘镜象，然后直接使用mount来进行挂载。
   




分区是对硬盘的一个抽象，对于ＯＳ来说，分区基本硬盘是一样的，并且分区上面还可以逻辑分区。block是对 扇区的一种抽象。文件相当于heads, 而目录相当于cylinders.


可以用 :command:`dumpe2fs` 来查看文件系统，并且可以用 :command:`tune2fs` 来调整参数。

如何制作文件系统
================

mount 各种各样的文件系统，loop 表示把本地文件当做文件系统来进行挂载。同时也还可以重新mount --bind 挂载点。对于物理分区有的时候会用完，添加就需要重起机器。所以也就产生了LVM. 逻辑分区。随着云计算到来，一切的虚拟化。原来的系统都是建立物理设备上的，现在都直接在逻辑设备上了。这样就具有更大的移值性，就像我们的CAS就是把逻辑拓扑与物理拓扑的隔离。LVM就在物理分区与文件系统之间又加了一层。文件系统直接建在LVM。

数据的存储系统是任何一个现代系统必不可少的一部分。它关系着系统是否高效与稳定。使用数据库要求太多，而文件系统而是最灵活的，但是效率可能没有数据高。为了结合自己的数据存储需求，产生定制的文件系统，而非通过的OS文件系统。例如版本控制的文件存储系统，以及现在云计算系统都有自己存储系统。例如Google的GFS。`fuse <http://fuse.sourceforge.net/>`_ 文件系统是在用户空间的文件系统。`如何使用 <http://www.ibm.com/developerworks/cn/linux/l-fuse/>`_ 。并且通过它可以把一些服务当做文件系统来使用。例如google的mail空间。以及ftp等等。

#. `SquashFS HOWTO (一) ---简介 <http://blog.csdn.net/karmy/article/details/1427315>`_  
#. `如何制作文件系统  <http://mcuol.com/download/upfile/armLinuxEMB10.pdf>`_  
#. `mkfs manual  <http://study.chyangwa.com/IT/AIX/aixcmds3/mkfs.htm>`_  
通过对gentoo对于各种概念有了更深的认识。



不同的文件系统就是硬件磁盘与逻辑存储之间的映射关系。 所谓的超级块就是与文件系统有关的。
并且存储的效率以及备份与压缩的机制。

还有在备份的时候，先碎片整理最小化，然后再copy数据，这样会加块的速度。
:command:`e4defrag` ，可以用碎片的整理，同时利用 gparted可以还直接对硬盘进行拉大与拉小，关键是存放的文件不要被覆盖。

分区与格式化挂载
================

`sfdisk <http://jarson.blog.51cto.com/1422982/573541>`_   是分区为了逻辑设备，就像人们有了多个硬盘一样。这个是由硬盘前面的分区表来决定的。而分区表的大小决定了，你可以有多少个分区，并且在分区表建立文件系统，在linux 下有各种各样的mkfs工具来供你使用。然后加载在OS上，这里就要mount了。
对于mount 由于这个概念泛化了。你可以mount 本地硬盘，也可以远程（NFS，autofs,samba) 还以把本地文件本身当做文件系统进行访问。同时也可以用bind 来把一个目录绑到另一个目录里，来避免ln的不足.`mount --bind挂载功能，避免ln -s链接的不足 <http://blog.csdn.net/islandstar/article/details/7774121>`_ ,`mount --bind 的妙用  <http://www.cnitblog.com/gouzhuang/archive/2012/07/15/65503.html>`_ 
`windows自带磁盘分区工具Diskpart使用介绍 <http://www.bitscn.com/os/windows7/200912/179453.html>`_ 
分区与`格式化 <http://baike.baidu.com/view/902.htm>`_ 是两步不同的操作.格式化又分为低级，与高级，低级格式化是物理级的格式化，主要是用于划分硬盘的磁柱面、建立扇区数和选择扇区间隔比。硬盘要先低级格式化才能高级格式化，而刚出厂的硬盘已经经过了低级格式化，无须用户再进行低级格式化了。高级格式化主要是对硬盘的各个分区进行磁道的格式化，在逻辑上划分磁道。对于高级格式化，不同的操作系统有不同的格式化程序、不同的格式化结果、不同的磁道划分方法。


#. `linux 访问windows 共享目录 <http://linhui.568.blog.163.com/blog/static/9626526820117822835844/>`_ 也可以直接使用`smbclient <http://wenku.baidu.com/view/ab3e7ffc910ef12d2af9e7bb.html>`_ 
   #. `autofs <http://www.autofs.org/>`_  our builds use it on farm
.. ::
 
       apt-get install autofs
        mkdir /network
        auto.master  
                /network /etc/auto.mymounts --timeout=35 --ghost
        auto.mymounts 
               prerelease -fstype=cifs,rw,noperm,user=devtools_tester1,pass=nvidia3d,dom=nvidia.com ://builds/prerelease
   

#. `cifs common interface  filesystem <http://linux-cifs.samba.org/>`_  
#. `mkfs IBM manual <http://pic.dhe.ibm.com/infocenter/aix/v7r1/index.jsp?topic=%2Fcom.ibm.aix.cmds%2Fdoc%2Faixcmds3%2Fmkfs.htm>`_ 
#. `高级文件系统实现者指南 日志和 ReiserFS <http://www.ibm.com/developerworks/cn/linux/filesystem/l-fs/>`_ 

硬盘检查与修复
==============

.. csv-table::

   extfs, e2fsck -y /dev/sda1
   HFSP, fsck.htfsplus  -f -y /dev/sda1 
   NTFS, ntfsfix -d /dev/sda1
   Reiserfs,reiserfsck -a -y /dev/sda1

#. e2fsck 还有一个配置文件 :file:`etc/e2fsck.conf`

修复的原理，那就是各种文件系统的，格式 

`Ext3日志原理 <http://m.blog.chinaunix.net/uid-20196318-id-152429.html>`_ 
`whats-the-difference-between-e2fsck-and-fsck-and-which-one-i-should-use <http://unix.stackexchange.com/questions/87415/whats-the-difference-between-e2fsck-and-fsck-and-which-one-i-should-use>`_ 

man
===

:command:`H` 可以打开man的命令帮助文档。

HardLink and softlink
=====================

我们知道文件包括文件名和数据，在Linux上被分为两个部分：用户数据（user data）和元数据（metadata），用户数据主要记录文件真实内容的地方，元数据是记录文件的附加信息，比如文件大小、创建信息、所有者等信息。在Linux中的innode才是文件的唯一标示而非文件名。文件名是方便人们的记忆。

为了解决文件共享的问题，Linux 引入两种链接：硬链接和软连接。 

#. 若一个innode号对应于多个文件名，则成为硬链接
#. 若文件用户数据块中存放的内容是另一个的路径名的指向，则该文件就是软链接。


`http://www.ibm.com/developerworks/cn/linux/l-cn-hardandsymb-links/`_

`what-is-the-difference-between-a-hard-link-and-a-symbolic-link <http://askubuntu.com/questions/108771/what-is-the-difference-between-a-hard-link-and-a-symbolic-link>`_ 

http://www.ibm.com/developerworks/cn/linux/l-cn-hardandsymb-links/  hardlink 一个用途那就是做备份，要比copy更加快速方便。

`Easy Automated Snapshot-Style Backups with Linux and Rsync <http://www.mikerubel.org/computers/rsync_snapshots/#Incremental>`_ 

See also
========

#. `TFS <http://code.taobao.org/p/tfs/src/>`_  taobao 分布式文件系统，`TFS集群文件系统 <http://baike.baidu.com.cn/view/4253974.htm>`_ 把原数据放在文件名与路径上，采用对象存储，
#. `存储领域面临六大趋势  <http://www.pcworld.com.cn/Article/ShowArticle.asp?ArticleID&#61;15927>`_  
#. `什么是对象存储？OSD架构及原理 <http://www.chinastor.com/a/jishu/OSD.html>`_  核心是将数据通路（数据读或写）和控制通路（元数据）分离，并且基于对象存储设备
#. `OpenStack对象存储——Swift <http://www.programmer.com.cn/12403/>`_  
#. `图片存储系统设计 <http://www.itivy.com/ivy/archive/2012/2/16/image-storage-1.html>`_  

#. `学会理解并编辑fstab <http://forum.ubuntu.org.cn/viewtopic.php?t&#61;58468>`_  

Paper
=====

   `Data processing virus protecton on partition table <http://www.google.com/patents?hl=zh-CN&lr=&vid=USPAT5367682&id=UWgeAAAAEBAJ&oi=fnd&dq=partition+table&printsec=abstract#v=onepage&q=partition%20table&f=false>`_ 
#. `court law of disk  <http://www.cybersecurity.my/data/content&#95;files/13/71.pdf>`_  
#. `parition ID <http://en.wikipedia.org/wiki/Partition&#95;type>`_  
#. `对/dev/shm认识 <http://www.xifenfei.com/1605.html>`_  
#. `解析 Linux 中的 VFS 文件系统机制 <http://www.ibm.com/developerworks/cn/linux/l-vfs/>`_  简单明了
#. `Linux2.6 内核的 Initrd 机制解析 <http://www.ibm.com/developerworks/cn/linux/l-k26initrd/>`_  用在内存中
#. `parted-3.1 doxygen document. <http://fossies.org/dox/parted-3.1/index.html>`_  看看能否只更新部分硬盘
#. `understanding-android-file-hierarchy <http://www.all-things-android.com/content/understanding-android-file-hierarchy>`_  与linux差别不大

Thinking
========



*CHS* 记住硬盘这一物理存储结构就知道来理解一切就都会明白了，物理结构本身三级目录。柱面 磁头，扇区。第一个磁道的扇区数一样吗。柱面与磁头决定一个磁道。 grub 的原理与硬盘的结构是相关的。并且始终记住一点那就是对于处理器来说，它能做的那就是程序在哪儿，程序指针指哪从哪开始执行。开始执行前要把需要的程序加载在内存。grub其实就是做了这样的事，BIOS把MBR放在内存中，并且处理器的跳转那里。MBR放的就是grub引导程序。然后呢，grub做了三件事，要确定系统放在哪。然后从那里把去把内核镜像加载在内存中，并设置相关的环境变量，例如root目录，以及内核在哪里。 然后把执行权交给内核。

-- Main.GangweiLi - 15 Jan 2013


*长路径与文件夹的作用*
长路径来保证文件名的唯一性，能过长路径来保正。其实也就是字符串长与短一种映射，这一个就是能够解决集体操作。一次对多个文件进行同样的操作。也就是有一种方法可以直接对压缩文件来进行操作。如果解决了这个问题，其实也要不要这么文件夹。也就不是大的问题。更多的逻辑分块的需要。

-- Main.GangweiLi - 12 Mar 2013


*数据库与文件系统*
本质上数据库本身也是一种文件系统。对于不同的存储对象，采用不同的机制。例如一些锁碎的类似于ERP这样数据适合于数据库这种存储系统。而大的块数据例如视频则任何于直接存储于文件系统上。例如不同的文件系统对于备份以及权限的管理是不一样的。 并且还有一个分布式文件系统的问题。还有版本控制库的文件系统。并且各种文件系统有融合之意。例如mongo,TFS,GFS等等。

-- Main.GangweiLi - 12 Mar 2013


*内存文件系统*
为了使启动更加方便，把内核更不断不分层模块化。来使其更加通用，与复用。因为内核变化速度要比文件系统要快。

-- Main.GangweiLi - 19 Apr 2013


*文件属性*
在查找的，排序的时候，利用文件属性会具有很大的优势，另外一个文件的属性是存储在哪里的。例如我想基于文件属性的查找排序是会很有用，在win7上是可以随时调整的，但是linux上却没有发现，如何大规模对象存储。对于图象。更是如此。例如利用find可以查找有限的文件属性。
`IBM filesystem 系列 <http://www.ibm.com/developerworks/cn/linux/filesystem/>`_ 现在才对文件系统的认识有了更深的认识。需要文件系统具有什么样的能力。
