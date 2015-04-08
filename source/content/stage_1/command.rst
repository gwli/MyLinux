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

``python tarfile`` �Լ� ``python zipfile``

`xz <http://en.wikipedia.org/wiki/Xz>`_

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

ȡ�ļ��Ĳ�������
----------------

.. csv-table::
   
   ��, sed,grep,head,tail
   ��,awk,column

���ļ����һ�У�һ�������Ǿ�����vim�Ϳ����ˡ�
���ֻ�Ǽ򵥵���β���Ǿ���>>�͸㶨�ˡ�


minicom
=======

:command:`minicom -D /dev/ttyUSB0` 
:command:`minicom -C log.txt -D /dev/ttypUSB0` ����log

:command:`ctrl+A` ���������̨



Development Tools
=================

��ͬƽ̨�£����в�ͬ�����֣�
��ubuntu ���Ǿ���  build-essential
��centos �� �Ǿ��� Development Tools


centos ��development tools
--------------------------

indent, C���Եĸ�ʽ�������ߡ� 

https://www.kernel.org/doc/Documentation/CodingStyle


kernel-devel ��


resize2fs ���� 
==============

:command:`resize2fs -F -f -p /dev/sda1 -M` ��С����
