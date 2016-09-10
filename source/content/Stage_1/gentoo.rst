vebegin,veend, ebegin,eend. ewarning
====================================

这些是gentoo为了美化console的输出,而实现的一些格式化命令.
ewaring 给你前面加个* 并且还绿色.

对于rc.local的输出,没有有产生,是在于被 重定向到/dev/null中了.

只需要这个改掉了就行了.https://forums.gentoo.org/viewtopic-t-1009110.html?sid=ab27cf116dba07711a215b9a7ae8f3bb

可以参考https://devmanual.gentoo.org/ebuild-writing/messages/index.html message的格式化.

对于从stage1,开始,无非要从buildchain的准备开始.然后根据依赖,逐个库的编译. 
https://forums.gentoo.org/viewtopic-t-420117-highlight-fiordland.html
http://www.linuxforums.org/forum/gentoo-linux/191522-gentoo-stage-1-installation-info.html

编译,主要 也就是编译选项与链接选项.

对于kernel的生成,也有现成工具来一步生成kernel,initramfs
https://wiki.gentoo.org/wiki/Genkernel
https://wiki.gentoo.org/wiki/Initramfs/Guide
https://gitweb.gentoo.org/proj/genkernel.git
