虚拟化本质就是松耦合，接口化。 加一个中间层。最简单的虚拟化就是 输入输出的重定向。 因为正常的情况下程序没有打开多余的输入输出的。只有0，1，2.程序只认0，1，2.不管他们绑在谁身上。

再复杂一些虚拟化chroot,这样上升到context的切换。 但还不够。程序最初的设计是代码与数据分离的。 但是代码与执行本身强耦合的。这也是为什么大部分情况下，一般人讲进程与代码的关系的讲不清的原因。

更进一步的虚拟就是代码，数据，执行三者都是分离的。因为当初的设计，代码的执行context要求比较大那就是 OS级的context. 也就是你看到虚拟机。有两种一种是 JVM这种。另一种那就是 virtual box以及更一层的Xen 这种。

从实现上只是执行与代码的分离，而在linux 中还出现多细分的。
`LXC: Linux 容器工具 <http://www.ibm.com/developerworks/cn/linux/l-lxc-containers/index.html>`_  这个实现正是基于chroot 实现的进程级别的虚拟化。
http://blog.csdn.net/cbmsft/article/details/7214371


Docker 是一种更轻质化的容器,就为了实现大一统,达到资源与效率的平衡.
Docker可以做什么 http://blog.2baxb.me/archives/1136 
