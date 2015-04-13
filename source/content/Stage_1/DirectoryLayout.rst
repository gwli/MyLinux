Linux 的目录结构
****************


最基本目录
==========
:file:`/bin,/dev,/etc,/lib,/proc,/sbin,/usr`


linux 的目录结构采用是Array register 制。
标准的流程就是把配置文件放在 :file:`/etc/` 下面。so,ko 都是放在 :file:`/lib/`
而其log 等等放在 :file:`/var/log` 里面。  *var* 的意思本来就是经常读写，变动的意思。


/var/log
========

log是非常重要的东东，出了问题第一个要看那就是log了。 并且 linux 默认都有 X.org.0.log -- X.org.6.log 默认是0 是最新的，也就是保留最近6次的log. 这个是由logrotate 机制来提供的。

例如syslog以及syslog-ng 等等的应用会自动实现这些，同样在android上也有logcat这样东东是同样的道理。

http://blog.chinaunix.net/uid-26569496-id-3199434.html




