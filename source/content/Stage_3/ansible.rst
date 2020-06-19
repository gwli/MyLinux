ansible
========

本质相当于 bash + forloop on mutiplenodes. 如何在多机执行同一条bash命令，这个最常见的场景那就是 网管系统。



playbook
=========
https://www.ansible.com/overview/how-ansible-works, 也就是把自己的远程装driver的ssh脚本规模化了。主要用了ssh 连接远程机器，并且copy一段代码上去，然后 直接执行。
可以自己定义代码块module,然后playbook来进行编排，而ad-hoc的直接一些modules. 最基本配置，那就是IP地址，ssh key 提前配好。 最基本依赖是python2，
这样部分自动利用pip 来处理依赖。
