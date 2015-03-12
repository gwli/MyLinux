Common command
==============

��ѹ 
----

.. csv-table:: 
   :header: ext, cmd

   tar.gz , tar -xzvf  abc.tar.gz
   tar.bz2, tar -xjvf  abc.tar.bz2
   .zip  ,   unzip abc.zip
   .rar,   unrar x abc.rar, apt-get install unrar   

tar ��������Ŀ¼
----------------

:command:`tar -xzvf abc.tgz -C Dest`

grep 
----

������ʽ���ǲ���Ҫת��ģ� :command:` grep -E` ���� :command:`egrep`.

��������Ŀ��ƺ������Լ��������Ը������Լ�ֻ���ļ������Լ�֧�����ǡ�

���ڻ��֧�� ������  :command:`grep -F` ���� :command:`fgrep` ���һ���ļ��б�
ֻҪֱ��pattern�б�ÿһ��һ������Щpattern�Ĺ�ϵ�� any(patterns)�Ĺ�ϵ��
ͬʱ������ʽҲ��֧�ֵ� 



:command:`grep -lincrE "localhost|127.0.0.1" ./* |grep -vE "tutorial|machine"`


du and df
---------
����Ƿ��з���ʹ����(Use%)����(���糬��90%)

:command:`df -h |grep -vE "tmpfs|udev"` 

�緢��ĳ�������ռ�ӽ��þ�,�����������ҳ�ռ�ÿռ������ļ���Ŀ¼��

:command:`du -csh /var/lib/state/*` �������� 
:command:`du -cks * |sort -rn| head -n 10` 

��β鿴linux�İ汾
-------------------

.. code-block:: bash

   /etc/issue 
   /etc/debian_version
   /etc/readhat-release
   /etc/os-release
   /etc/lsb-release

���������ļ� :file:`/etc/issue` ���� :file:`/etc/redhat-release` ���� :file:`/etc/debian_version`

����ֱ�� :command:`cat /etc/*-release` �Ϳ��Կ����ˡ�


����ж�linux�Ƿ��������������
-------------------------------

http://www.vpsee.com/2011/01/how-to-detect-if-a-linux-system-running-on-a-virtual-machine/

��Ҫ��ͨ�� :file:`/proc/vz  /proc/xen/` ���ļ������ģ�һ����Щ��ַ������ϵͳ�����ġ�

�ļ�����������
--------------

linuxר��һ��:command:`rename` ָ����� ��Ҫ��  *.txt* ��� *.rst*
:command:`rename 's/.txt/.rst/ *.txt` .
