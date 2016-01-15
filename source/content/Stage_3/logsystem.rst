log system
**********

如想快速的了解一个系统，并且得到真实的运行时数据，并想避免代码的细节，那么查看log是经常重要事情。

严格意义上 linux中 /proc ,/system  等等都算是log系统吧。


如何在命令行直接使用logger呢，:command:`logger` 直接使用。
用法 http://blog.longwin.com.tw/2011/11/linux-data-syslog-logger-2011/。

:command:`loginctl` 可以在命令行对其进行配置

:command:`logsave` 有点类似于 :command:`tee` 的功能， 经常时时查看log的功能时，我经常使用 :command:`tail -f` . 


:command:`logresolve` 把apache log中IP地址换成hostname. 这个用一个替换就很容易的实现了。

而logcat 也是采用这样的机制。

另一个重要的机制logrotate 自动保存最近几次的机制。


:command:`logrotate`  并且再 :file:`/etc/logrotate.conf` 这里配制每一份log的大小，多少次，并且压缩格式等等。 每一个 app 都可以添加一个自己的log conf 放在 :file:`/etc/logrotate.d/` 下面。


系统log记录了，所有用户登陆的信息，wtmp,utmp,等等，同时也记录login 失
