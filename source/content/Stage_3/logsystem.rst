log system
**********

������ٵ��˽�һ��ϵͳ�����ҵõ���ʵ������ʱ���ݣ������������ϸ�ڣ���ô�鿴log�Ǿ�����Ҫ���顣

�ϸ������� linux�� /proc ,/system  �ȵȶ�����logϵͳ�ɡ�


�����������ֱ��ʹ��logger�أ�:command:`logger` ֱ��ʹ�á�
�÷� http://blog.longwin.com.tw/2011/11/linux-data-syslog-logger-2011/��

:command:`loginctl` �����������ж����������

:command:`logsave` �е������� :command:`tee` �Ĺ��ܣ� ����ʱʱ�鿴log�Ĺ���ʱ���Ҿ���ʹ�� :command:`tail -f` . 


:command:`logresolve` ��apache log��IP��ַ����hostname. �����һ���滻�ͺ����׵�ʵ���ˡ�

��logcat Ҳ�ǲ��������Ļ��ơ�

��һ����Ҫ�Ļ���logrotate �Զ�����������εĻ��ơ�


:command:`logrotate`  ������ :file:`/etc/logrotate.conf` ��������ÿһ��log�Ĵ�С�����ٴΣ�����ѹ����ʽ�ȵȡ� ÿһ�� app ���������һ���Լ���log conf ���� :file:`/etc/logrotate.d/` ���档


ϵͳlog��¼�ˣ������û���½����Ϣ��wtmp,utmp,�ȵȣ�ͬʱҲ��¼login ʧ
