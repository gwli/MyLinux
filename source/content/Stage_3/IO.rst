IO
===


对于linux 中每一个程序都会有三个默认的IO，0 标准输入，1标准输出，2标准error输。 其实它们于正常的文件打开是一样的。 只是他们打开的是设备文件，而这个是filesystem
已经帮我们进行屏蔽了。 并且里程的继承关系，默认情况下，每起一个进程都会默认继承复进程的东东。所以你看到大部分程序输入与输出都在同一个地方，键盘与屏幕。

而真实的过程就是可以是任意的文件。你可以起动一个进程的时候就指定 0，1，2的变化。
用代码控制就是dup2 直接 link 一个系统里打开的文件，包括其读写的位置。相当于共享一个文件。 (而不是真实的复制，只是复制的两者就没有关系了，这个从man dup2 的说明就可以看，这就是文件系统的一个link ). 所以两个指针写，一个读。 并且把这个文件属于写不完就行， 只是需要建立一个buffer,然后在此基础上实现一个循环队列就搞定了，头尾两个指针，用于读，一个用写就行了。

文件同时会读写两个指针，但是为了避免冲突，程序使用一个文件不会同时即读又写的。

Pipefs文件系统不需要太大，只是需要循环的链表，并且基于字节的两个指针而己。这个是个文件不是独占，共享指针。

从文件中读取的方式，可以按行读，也可以按字切读，当然也可以是扫描式的读，那就是scanf. 以前读这种读法，不理解，现在终于理解了。

所以我们读写对应是一个FD,把可以这个FD任意的变换，现在对于M4 的对于输出那么灵活重定向明白了其实现原理。

http://blog.csdn.net/dog250/article/details/7484102
http://www.cnblogs.com/weidagang2046/p/io-redirection.html
http://bbs.chinaunix.net/thread-2079678-1-1.html

http://my.oschina.net/u/158589/blog/69047  这一篇讲的就不太对了


对于IO的读写，是各个系统很重要的一部分。
也就是 read,write后面的原理。是如何内存读写过来的。
select,poll都是能够针对FD是事件进行检测。
linux 把IO都当做一个文件，所有与相关的事件是不是都应该用可以select,poll来读写呢。
硬件的变化，可以硬件的线路反馈给CPU，然后CPU现在都已经可以达700-1000个引角。能实现
的功能大大复杂了。
http://www.cnblogs.com/xkfz007/archive/2012/10/08/2715163.html

像文件读写也是一样的，需要一定的结构，把各个引脚的状态放在内存里。那些管脚有一半为供电的。


exec 用法，也就加载segment,以及data段的过程，并且几种不同接口都是针对具体的细节的应用。例如要不要不环境变量等等。


例如现在想看到一个进程的输出怎么办法，可直接可用 tail -f /proc/fd/1。 或者debugger attach上去就可查看输出了。或者直接用ptrace来修改其输出。
:command:`strace -ewrite -p $pid`

使用linux watch 命令。

或者像https://etbe.coker.com.au/2008/02/27/redirecting-output-from-a-running-process/这样 用gdb来实现

.. code-block:: cpp
   gdb -p pid execfile
   p close(1)
   p creat("/tmp/newlog",0600) or dup2
   ls -l /proc/pid/fd 
   ls 

同样如何连接http://unix.stackexchange.com/questions/31824/how-to-attach-terminal-to-detached-process

.. code-block:: cpp
   mkifo /tmp/fifo
   gdb -p PID
   p close(0)
   p open('tmp/fifo',0600)
   echo balahs>fifo


当然也会些相关的小工具http://pasky.or.cz//dev/retty/, http://pasky.or.cz//dev/retty/,http://pasky.or.cz//dev/retty/
