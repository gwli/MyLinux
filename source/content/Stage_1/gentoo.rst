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

对于ntfs-3g 找不到2.8的库
==========================

经过对比好的机器上的库的依赖，发现只是ln 不对，在出错的机器上的，libfuse.so.2 -> libfuse.so.2.7,而机器 上是有 libfuse.so.2.9
ntfs-3g 要求 2.8. 所以2.9肯定可以用。 所以只用修改一下软链就行了。
