ansible
========

本质相当于 bash + forloop on mutiplenodes. 如何在多机执行同一条bash命令，这个最常见的场景那就是 网管系统。


机器的管理，有很多种方式，一是如何这些机器通信，master P2P,还是通过中间，还是可以网络自同步。这个当机器node足够多的时候，这个overhead就值的注意了。还是lot模式，ansible采用masterless模式，salt 采用master-slave模式，而GTL采用的是lot server服务模式,这样可以scale up不成问题,但是直接用起来庥烦,最灵活的则是k8s的方式.即可以直接操作,又可以编排. 还能自动的scale up. 如何实现硬件 auto scale up呢,例如 当多少机器开始down或者坏了,就开始自动准备安装新的机器,然后开始开机运行. 所以能够控制自主上电,也就可以大大节省的电力. 形成全套的 auto profiling. 所以现在down就当做出了问题,不是一个好的方式,对于没事就关机,是一个不错并且节省资源的方式, 我们需要的是能耗也随着负载 scale up, 不需要的时候关机是一个不错选择. 因为测试机器也需要各种各样的重启操作.

在网速的足够块的情况下,需要路由功能尽可能降低成本+再加上一个低功耗管理口，就可以实现硬件路由化，nvswitch只是一个很初级的产品. 实现硬件路由化需要多大带宽呢. 

硬件的重组.


例外采用有状态，还是无状态，如何管理这些机器分组以及像docker service一样编排。 进一步具体到具体命令编排。 

playbook
=========
https://www.ansible.com/overview/how-ansible-works, 也就是把自己的远程装driver的ssh脚本规模化了。主要用了ssh 连接远程机器，并且copy一段代码上去，然后 直接执行。
可以自己定义代码块module,然后playbook来进行编排，而ad-hoc的直接一些modules. 最基本配置，那就是IP地址，ssh key 提前配好。 最基本依赖是python2，
这样部分自动利用pip 来处理依赖。

https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html
https://jensrantil.github.io/post/salt-vs-ansible/


对于windows 的支持
===================

* https://chocolatey.org/ 不错的第三方ansible 包管理。
