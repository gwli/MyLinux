Common command
==============

解压 
----

.. csv-table:: 
   :header: ext, cmd

   tar.gz , tar -xzvf  abc.tar.gz
   tar.bz2, tar -xjvf  abc.tar.bz2
   .zip  ,   unzip abc.zip
   .rar,   unrar x abc.rar, apt-get install unrar   

tar 到批定的目录
----------------

:command:`tar -xzvf abc.tgz -C Dest`

grep 
----

正则表达式，是不需要转义的， :command:` grep -E` 或者 :command:`egrep`.

对于输出的控制很灵活，可以计数，可以高亮，以及只显文件名，以及支持与或非。

对于或的支持 可以用  :command:`grep -F` 或者 :command:`fgrep` 后接一个文件列表
只要直接pattern列表，每一行一个，这些pattern的关系是 any(patterns)的关系。
同时正则表达式也是支持的 



:command:`grep -lincrE "localhost|127.0.0.1" ./* |grep -vE "tutorial|machine"`


du and df
---------
检查是否有分区使用率(Use%)过高(比如超过90%)

:command:`df -h |grep -vE "tmpfs|udev"` 

如发现某个分区空间接近用尽,用以下命令找出占用空间最多的文件或目录：

:command:`du -csh /var/lib/state/*` 或者排序 
:command:`du -cks * |sort -rn| head -n 10` 

如何查看linux的版本
-------------------

.. code-block:: bash

   /etc/issue 
   /etc/debian_version
   /etc/readhat-release
   /etc/os-release
   /etc/lsb-release

利用特征文件 :file:`/etc/issue` 或者 :file:`/etc/redhat-release` 或者 :file:`/etc/debian_version`

或者直接 :command:`cat /etc/*-release` 就可以看到了。


如何判断linux是否运行在虚拟机上
-------------------------------

http://www.vpsee.com/2011/01/how-to-detect-if-a-linux-system-running-on-a-virtual-machine/

主要是通过 :file:`/proc/vz  /proc/xen/` 等文件来做的，一般这些地址会体现系统环境的。

文件批量重命名
--------------

linux专门一条:command:`rename` 指令。例如 我要把  *.txt* 变成 *.rst*
:command:`rename 's/.txt/.rst/ *.txt` .
