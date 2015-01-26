Common command
==============

��ѹ 
----

.. csv-table:: 
   :header: ext, cmd

   tar.gz , tar -xzvf  abc.tar.gz
   tar.bz2, tar -xjvf  abc.tar.bz2
   .zip  ,   unzip abc.zip



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


�ļ�����������
--------------

linuxר��һ��:command:`rename` ָ����� ��Ҫ��  *.txt* ��� *.rst*
:command:`rename 's/.txt/.rst/ *.txt` .
