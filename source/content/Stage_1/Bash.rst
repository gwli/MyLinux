*******************************
Linux Shell Effecitive Skills 
*******************************

What's is shell
================

.. figure:: Stage_1/images/LinuxArch.png
.. figure:: Stage_1/images/shell_families.png

sh,csh/Tcsh,ksh,bash,zsh

Csh  1978 
Ksh  1983
Bash 1988
zsh  1990 

* 系统可交互接口,简练，接近自己语言。 

   * Unix小而美的哲学的典范。
   * 所有的UNIX 命令,系统调用,公共程序,工具,和编译过的二进制程序,对于shell 脚本来说,都是可调用的.
   * 所有shell feature 成熟，并且能够在新的shell上完成兼容。 

Bash
=====

#. 通用性强, 大部分linux发行版本的默认shell
#. 各种shell发展成熟，也成为后续的shell的事实标准
#. 灵活的IO重定向，命令替换，管道组合可以 大大提高效率。

   `find | grep`, `()& < > $()`

* 高效交互方式

  * Shell history and choose one
  * Shell expansion
  * Command execution
  * Command line editing
  * Text process

Bash 的原理框图
================

.. figure:: Stage_1/images/bash_component_architecture.png


shell expansions
================

* brace expansion
* tilde expansion
* parameter and variable expansion 
* arithmetic expansion
* command substitution 
* word splitting; and
* filename expansion.

{} 直积(笛卡尔积) 
-------------------

:math:`(a,b)* (x,y,z) => (a,x),(a,y),(a,z),(b,x),(b,y),(b,z)`

  .. code-block:: bash
     
     $ echo {1..10}
     1 2 3 4 5 6 7 8 9 10
     $ echo {a..e}
     a b c d e
     $ echo {1..10..3}
     1 4 7 10
     $ echo {a..j..3}
     a d g j

  .. code-block:: bash

     Bash$ mkdir -p Top/{a,b}/{i,k}/{o,p,q}
     Bash$ tree Top
     Top
     ├── a
     │   ├── i
     │   │   ├── o
     │   │   ├── p
     │   │   └── q
     │   ├── j
     │   │   ├── o
     │   │   ├── p
     │   │   └── q
     │   └── k
     │       ├── o
     │       ├── p
     │       └── q
     └── b
         ├── i
         │   ├── o
         │   ├── p
         │   └── q
         ├── j
         │   ├── o
         │   ├── p
         │   └── q
         └── k
             ├── o
             ├── p
             └── q


     scp -p  xxx/{a,c,d,e}  user@host:dest/

     #备份命令，就是利用一个空参数来实现。
     cp filename{,.bak} 
     
     bash$ ls
     grub.cfg
     bash$ cp grub.cfg{,.bak}
     bash$ ls
     grub.cfg  grub.cfg.bak

     ls *.{jpg,jpeg,png}    # expands to *.jpg *.jpeg *.png - after which,
                            # the wildcards are processed
     echo *.{png,jp{e,}g}   # echo just show the expansions -
                            # and braces in braces are possible.


~扩展
-----

.. code-block:: bash

   ~ The value of $HOME
   ~/foo #$HOME/foo
   ~fred/foo  #The subdirectory foo of the home directory of the user fred
   ~+/foo $PWD/foo



变量与参数扩展
-----------------

* `=`前后没有空格  `varname="value"` `$varname ${varable}`


  - 把你常用的路径直接存为变量，可以减少cd 的次数

    .. image:: Stage_1/asciinema/variable_expand.gif
       :scale: 50%


  - 把你复杂的变量直接存为变量

    .. code-block:: bash
       
       mydu="du -csh"   

* speical variable 替换  扩展

 

.. code-block:: bash
   
   "$0","The filename of the current script."
   "$n","These variables correspond to the arguments with which a script was invoked. Here n is a positive decimal number corresponding to the position of an argument (the first argument is $1, the second argument is $2, and so on)."
   "$$","The process ID of the current shell. For shell scripts, this is the process ID under which they are executing."
   "$#",The number of arguments supplied to a script.
   "$@","All the arguments are individually double quoted. If a script receives two arguments, $@ is equivalent to $1 $2."
   "$*","All the arguments are double quoted. If a script receives two arguments, $* is equivalent to $1 $2."
   "$?","The exit status of the last command executed."
   "$!","The process ID of the last background command."
   "$_", "The last argument of the previous command."
      
   * 利用$* 来实现命令的封装，在你需要定制你的命令的时候
     
.. code-block:: bash
   
   ll.sh 
   ls -l $* 

   *$@*
   exec /usr/bin/flex -l "$@" 以前不知道为什么要有这些用法。现在明白了主要为了方便二次的转接。尤其在做接口函数的，这样可以无缝传给那些函数。正是通过些符号，我们很方便定制各种各样的命令，就样android中build 中envsetup,sh 中那些cgrep,regrep, 等等这些命令。进行二次封装可以大大加快的自己的速度。

.. ::

   $# 命令行参数的个数
   $* 所有的位置参数当做一个单词
   $@ 所有的位置参数每一个独立。


* 参数替换

   * default value
     
     .. code-block:: bash

        ${parameter:-word} 
        ${parameter:=word}
        ${parameter:?word}
        ${parameter:+word}

   * string slice

     .. code-block:: bash

        ${parameter:offset}
        ${parameter:offset:length}
        #左匹配删除
        ${parameter#word}
        ${parameter##word}
        
        # 右侧删除
        ${parameter%word}
        ${parameter%%word}

        # 替换
        ${parameter/pattern/string}
        # 小写 
        ${parameter^pattern}
        ${parameter,pattern}

        #小写
        ${parameter^^pattern}
        ${parameter,,pattern}



* 数学计算替换 仅支持整数 `$(( expression ))`

  .. code-block:: bash
     
     $(( 1+2 +3 ))

* 命令替换
      
.. code-block:: bash
      
   $(command)  
   `command`

.. code-block:: bash

   bash~$ date +%Y%m%d%H%M%S
   20190330203926
   bash~$ mkdir log_$(date +%Y%m%d%H%M%S)
   bash~$ ls
   log_20190330204008  
   bash~$
   
* 进程替换 `<(list) or  >(list)`

可以实现比管道复杂的功能

  .. code-block:: bash

     diff <(ls $first_directory | sort) <(ls $second_directory | sort)` 直接来对比两条命令的输出。

Filename expansion (pattern matching)
-----------------------------------------

.. code-block:: bash

   * any
   ** rcursive match
   ? 0,1
   [...] charter range
   ?(pattern-list)  0,1
   *(pattern-list)  any
   +(pattern-list)  1+
   @(pattern-list)  1+
   !(pattern-list)  not match

* example1

.. code-block:: bash

   bash$ ls /etc/pam.d/
   atd                  gdm-autologin           login             postlogin-ac       smtp              system-auth
   chfn                 gdm-fingerprint         other             ppp                smtp.postfix      system-auth-ac
   chsh                 gdm-launch-environment  passwd            remote             sshd              systemd-user
   config-util          gdm-password            password-auth     runuser            sssd-shadowutils  vlock
   crond                gdm-pin                 password-auth-ac  runuser-l          su                vmtoolsd
   cups                 gdm-smartcard           pluto             setup              sudo              xserver
   fingerprint-auth     ksu                     polkit-1          smartcard-auth     sudo-i
   fingerprint-auth-ac  liveinst                postlogin         smartcard-auth-ac  su-l
   bash$ cp /etc/pam.d/gdm-+(auto|pass)* .
   bash$ ls
   gdm-autologin  gdm-password
   bash$ 

* 善用通配符，减少输入

   .. code-block:: bash

      vim **/*READ*  #open the README at any subfolder
      vim /etc/pa*ac

 Word Split
 -----------

 $IFS  <space>,<tab>,<newline>
      
Shell Command execution 
============================
      
命令,管道,IO重定向
      
      
commands
---------
      
* 简单命令

* list of Commands

  && || ; &

https://www.gnu.org/software/bash/manual/html_node/index.html#SEC_Contents

.. code-block:: bash

   command1;comand2
   command1 && command2
   command1 || command2

* component Commands

.. code-block:: bash

   if test-commands; then
     consequent-commands;
   [elif more-test-commands; then
     more-consequents;]
   [else alternate-consequents;]
   fi

   case word in
    [ [(] pattern [| pattern]…) command-list ;;]…
   esac

   until test-commands; do consequent-commands; done
   while test-commands; do consequent-commands; done
   for name [ [in [words …] ] ; ] do commands; done


* 在大部分情况下避免使用if,通过 find,grep等filter来实现过滤。
* loop 大部分情况只用for就够了,少部分使用while

Grouping commands  as a unit 
-----------------------------

.. code-block:: bash

   ( list ) #/executed in a subshell  
   { list; } #at current shell context

* redirection and pipeline is applied to the entire command list. 
* parellel

.. code-block:: bash

   bash$ cat test.sh
   for i in 10.19.189.{1..255};
   do
      (ping -c 1 $i &)
   done 2>&1 | grep "ttl"

   64 bytes from 10.19.189.1: icmp_seq=1 ttl=249 time=99.9 ms
   64 bytes from 10.19.189.2: icmp_seq=1 ttl=249 time=107 ms
   64 bytes from 10.19.189.3: icmp_seq=1 ttl=248 time=102 ms
   64 bytes from 10.19.189.59: icmp_seq=1 ttl=57 time=92.2 ms
   64 bytes from 10.19.189.69: icmp_seq=1 ttl=121 time=86.8 ms
   64 bytes from 10.19.189.74: icmp_seq=1 ttl=56 time=86.6 ms
   64 bytes from 10.19.189.177: icmp_seq=1 ttl=56 time=99.5 ms
   64 bytes from 10.19.189.179: icmp_seq=1 ttl=57 time=95.5 ms
   64 bytes from 10.19.189.207: icmp_seq=1 ttl=56 time=188 ms
   64 bytes from 10.19.239.1: icmp_seq=1 ttl=249 time=94.5 ms


pipelines
-----------
  
.. image:: Stage_1/images/How_pipe_works.png

在Unix设计哲学中，有一个重要设计原则--KISS(Keep it Simple, Stupid)，大概意思就是只关注如何做好一件事，并把它做到极致。每个程序都有各自的功能，那么有没有一样东西将不同功能的程序互相连通，自由组合成更为强大的宏工具呢？此时，管道出现了，它能够让程序实现了高内聚，低耦合
管道的发名者叫，Malcolm Douglas McIlroy，他也是Unix的创建者，是Unix文化的缔造者之一。他归纳的Unix哲学如下：

.. image:: Stage_1/images/pipe_design.png

* Pipes

  .. code-block:: bash

     command1 | command2
     command1 |& command2

.. code-block:: bash

   find -iname ".c"| xargs grep "open"
   ls -l |sed -e 's/[aeio]/u/g'


   bash$ ldd /usr/autodesk/maya2019/bin/maya.bin 
        linux-vdso.so.1 =>  (0x00007ffdbb5d8000)
        libMaya.so => /usr/autodesk/maya2019/bin/../lib/libMaya.so (0x00007f52e43ad000)
        libIMFbase.so => /usr/autodesk/maya2019/bin/../lib/libIMFbase.so (0x00007f52e40db000)
        libAG.so => /usr/autodesk/maya2019/bin/../lib/libAG.so (0x00007f52e3a74000)
        libiff.so => /usr/autodesk/maya2019/bin/../lib/libiff.so (0x00007f52e383f000)
        libawGR.so => /usr/autodesk/maya2019/bin/../lib/libawGR.so (0x00007f52e3632000)
        libglew.so => /usr/autodesk/maya2019/bin/../lib/libglew.so (0x00007f52e33b3000)
        libclew.so => /usr/autodesk/maya2019/bin/../lib/libclew.so (0x00007f52e31ad000)
        libOpenCLUtilities.so => /usr/autodesk/maya2019/bin/../lib/libOpenCLUtilities.so (0x00007f52e2f89000)
        ... skip 30 lines ....
        libXp.so.6 => not found
        libXmu.so.6 => /lib64/libXmu.so.6 (0x00007f52c4131000)
        libXpm.so.4 => /lib64/libXpm.so.4 (0x00007f52c3f1f000)
        libXt.so.6 => /lib64/libXt.so.6 (0x00007f52c3cb8000)
        libXi.so.6 => /lib64/libXi.so.6 (0x00007f52c3aa8000)
        libXext.so.6 => /lib64/libXext.so.6 (0x00007f52c3896000)
        libxcb.so.1 => /lib64/libxcb.so.1 (0x00007f52b32c8000)
        .... skip 89 lines ....
        libjbig.so.2.0 => /lib64/libjbig.so.2.0 (0x00007f52b30bb000)
        libexpat.so.1 => /lib64/libexpat.so.1 (0x00007f52b2e91000)
        libbz2.so.1 => /lib64/libbz2.so.1 (0x00007f52b2c81000)
        libtbbmalloc_proxy.so.2 => not found
        libtbb_preview.so.2 => not found
        libtbbmalloc_proxy.so.2 => not found
        libtbb_preview.so.2 => not found
        libpcre.so.1 => /lib64/libpcre.so.1 (0x00007f52b2a1b000)
        libffi.so.6 => /lib64/libffi.so.6 (0x00007f52b2812000)
        libidn.so.11 => /lib64/libidn.so.11 (0x00007f52b25df000)
        libssh2.so.1 => /lib64/libssh2.so.1 (0x00007f52b23b5000)
        libssl3.so => /lib64/libssl3.so (0x00007f52b2162000)
        libplds4.so => /lib64/libplds4.so (0x00007f52b1f5e000)
        libplc4.so => /lib64/libplc4.so (0x00007f52b1d59000)
        libgssapi_krb5.so.2 => /lib64/libgssapi_krb5.so.2 (0x00007f52b1b0b000)
        libkrb5.so.3 => /lib64/libkrb5.so.3 (0x00007f52b1822000)
        libk5crypto.so.3 => /lib64/libk5crypto.so.3 (0x00007f52b1607000)
        libcom_err.so.2 => /lib64/libcom_err.so.2 (0x00007f52b1402000)
        liblber-2.4.so.2 => /lib64/liblber-2.4.so.2 (0x00007f52b11f3000)
        libldap-2.4.so.2 => /lib64/libldap-2.4.so.2 (0x00007f52b0f9e000)
        libgmodule-2.0.so.0 => /lib64/libgmodule-2.0.so.0 (0x00007f52b0d99000)
        libselinux.so.1 => /lib64/libselinux.so.1 (0x00007f52b0b72000)
        libresolv.so.2 => /lib64/libresolv.so.2 (0x00007f52b0958000)
        libmount.so.1 => /lib64/libmount.so.1 (0x00007f52b0715000)
        libgsttag-1.0.so.0 => /lib64/libgsttag-1.0.so.0 (0x00007f52b04d9000)
        liborc-0.4.so.0 => /lib64/liborc-0.4.so.0 (0x00007f52b0255000)
        libsystemd.so.0 => /lib64/libsystemd.so.0 (0x00007f52b0023000)
        libXau.so.6 => /lib64/libXau.so.6 (0x00007f52afe1f000)
        libkrb5support.so.0 => /lib64/libkrb5support.so.0 (0x00007f52afc0f000)
        libkeyutils.so.1 => /lib64/libkeyutils.so.1 (0x00007f52afa0b000)
        libsasl2.so.3 => /lib64/libsasl2.so.3 (0x00007f52af7ed000)
        libblkid.so.1 => /lib64/libblkid.so.1 (0x00007f52af5ad000)
        libcap.so.2 => /lib64/libcap.so.2 (0x00007f52af3a7000)
        liblz4.so.1 => /lib64/liblz4.so.1 (0x00007f52af192000)
        libgcrypt.so.11 => /lib64/libgcrypt.so.11 (0x00007f52aef11000)
        libgpg-error.so.0 => /lib64/libgpg-error.so.0 (0x00007f52aed0b000)
        libdw.so.1 => /lib64/libdw.so.1 (0x00007f52aeabc000)
        libcrypt.so.1 => /lib64/libcrypt.so.1 (0x00007f52ae884000)
        libattr.so.1 => /lib64/libattr.so.1 (0x00007f52ae67f000)
        libelf.so.1 => /lib64/libelf.so.1 (0x00007f52ae466000)
        libfreebl3.so => /lib64/libfreebl3.so (0x00007f52ae263000)
   bash$ ldd /usr/autodesk/maya2019/bin/maya.bin | grep "not"
     libXp.so.6 => not found
     libfam.so.0 => not found
     libXp.so.6 => not found
     libXp.so.6 => not found
     libtbbmalloc_proxy.so.2 => not found
     libtbb_preview.so.2 => not found
     libtbbmalloc_proxy.so.2 => not found
     libtbb_preview.so.2 => not found
  
IO redirection
---------------

.. image:: Stage_1/images/io.png

.. list-table:: 
   
   * - stdin
     - stdout
     - stderr 
   * - 0
     - 1
     - 2
     - & 

   * - >, >>
     - <, <<,<<<
     - [n]<&[fd]-
     - [n]<>filesmae

   << here doc
   <<<"here string" 就是python 中"""三目符的用法。


.. code-block:: bash

   exec &> >(tee -a "$log_file")
   echo This will be logged to the file and to the screen
   $log_file will contain the output of the script and any subprocesses, and the output will also be printed to the screen.
   
   >(...) starts the process ... and returns a file representing its standard input. exec &> ... redirects both standard output and standard error into ... for the remainder of the script (use just exec > ... for stdout only). tee -a appends its standard input to the file, and also prints it to the screen.
   https://unix.stackexchange.com/questions/145651/using-exec-and-tee-to-redirect-logs-to-stdout-and-a-log-file-in-the-same-time


* basic concept
  
  * stdin 0,stdout 1,stderr 2, exec
  * `` $() 
  * fork  {},() &
  
* simple one

  ls -l > ls-l.txt
  grep da * 2> grep-errors.txt
  xxxx 2>&1 | tee log.txt
  stdout/stderr  >
  stdin/exec <

  rm -f $(find / -iname core) &> /dev/null

* { 
    action one
    action two
   }> 1>out.out 2>error.log

*对于文件的读写* 例如读入前三行

.. code-block:: bash
    
   { read line1
     read line2
     read line3
   } < /etc/fstab

.. code-block:: bash

   { code-block} >> output.log

例如下边的例子，生成 :file:`/etc/udev/rules.d/70-persistent-net.rules` 的 
:file:`/lib/udev/write_net_rules` 生成函数。

.. code-block:: bash

   write_rule() {
           local match="$1"
           local name="$2"
           local comment="$3"
   
           {
           if [ "$PRINT_HEADER" ]; then
                   PRINT_HEADER=
                   echo "# This file was automatically generated by the $0"
                   echo "# program, run by the persistent-net-generator.rules rules file."
                   echo "#"
                   echo "# You can modify it, as long as you keep each rule on a single"
                   echo "# line, and change only the value of the NAME= key."
           fi
   
           echo ""
           [ "$comment" ] && echo "# $comment"
           echo "SUBSYSTEM==\"net\", ACTION==\"add\"$match, NAME=\"$name\""
           } >> $RULES_FILE
   }

*重定向代码块的输出* {} >log.txt 直接一段代码所有输出都重定向到文件中。这样可以分以直接compile的log分开保存起来，在其内部直接重定向。

.. code-block:: bash

   
   exec https://askubuntu.com/questions/525767/what-does-an-exec-command-do

.. code-block:: bash

   exec 3</dev/null; ls -l /proc/self/fd
   exec 3<&- ; ls -l /proc/&&/fd
   exec <&-
   
   https://www.tldp.org/LDP/abs/html/io-redirection.html
   
   M>N
     # "M" is a file descriptor, which defaults to 1, if not explicitly set.
     # "N" is a filename.
     # File descriptor "M" is redirect to file "N."
   M>&N
     # "M" is a file descriptor, which defaults to 1, if not set.
     # "N" is another file descriptor.
   0< FILENAME
    < FILENAME
     # Accept input from a file.
     # Companion command to ">", and often used in combination with it.
     #
     # grep search-word <filename
    [j]<>filename
     #  Open file "filename" for reading and writing,
     #+ and assign file descriptor "j" to it.
     #  If "filename" does not exist, create it.
     #  If file descriptor "j" is not specified, default to fd 0, stdin.
     #
     #  An application of this is writing at a specified place in a file.
     echo 1234567890 > File    # Write string to "File".
     exec 3<> File             # Open "File" and assign fd 3 to it.
     read -n 4 <&3             # Read only 4 characters.
     echo -n . >&3             # Write a decimal point there.
     exec 3>&-                 # Close fd 3.
     cat File                  # ==> 1234.67890
     #  Random access, by golly.

更好完的重定向要属端口应用功能 了。
------------------------------------

:command:`mknod /dev/tcp c 30 36` 就可以STDIN/STDOUT/STDERR一样重定向了。

特别是/dev/tcp   /dev/upd这些伪设备也是很好完的。

.. code-block:: bash
 
    cat </dev/tcp/time.nist.gov/13

就得到的实现。


command line editing
=====================

.. image:: Stage_1/asciinema/auto-complete.gif
   :scale: 50%

- 路径补全，
- 命令补全，
- 命令参数补全，
- 智能拼写纠正
- 插件内容补全

command complete
---------------------

:command:`apt-get install bash-completion` 

并且随着 bash的升级，4.3之后已经可以 自动补全 参数了。看来是越来越强了。如果是想自定义可以使用
http://kodango.com/bash-competion-programming

这一点zsh 做更灵活，各种补全，尽可能tab. 并且支持** 来递归。
如果这个做好，可以大大加快工作效率。例如 
#. `More on Using the Bash Complete Command <http://www.linuxjournal.com/content/more-using-bash-complete-command>`_  可以利用来自定义命令补全，是可以加上过滤条件的
#. `Programmable-Completion <http://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion>`_  bash 中有专门的文档来说明，据说zsh的补全做的最好。
#. 目前在对于android，已经有现在与补全功能了，在sdk/bash_compeletion/adb  加载了它之后，android下就可以自动补全了。
#. `zsh adb completion  <https://github.com/zsh-users/zsh-completions>`_  


编辑模式 vi/emcas
-------------------

set -o vi

*man builtins* 可以看许多有用东东，例如bind就可以进行键盘绑定的。就像vi  的map一样。

对于编辑模式的改变 bindkey -v vi vi模式。
https://www.ibm.com/developerworks/cn/linux/shell/z/
http://wdxtub.com/2016/02/18/oh-my-zsh/


history skill
---------------

这个是从 Tcsh 里学来的，https://www.wikiwand.com/en/Tcsh

.. code-block:: bash
 
   ! Start a history substitution, except when followed by a space, tab, the end of
   the line, `=' or `('.
   !n Refer to command line n.
   !-n Refer to the command n lines back.
   !! Refer to the previous command. This is a synonym for `!-1'.
   !string Refer to the most recent command starting with string.
   !?string[?]
   Refer to the most recent command containing string. The trailing `?' may be
   omitted if the string is followed immediately by a newline.
   ^string1^string2^
   Quick Substitution. Repeat the last command, replacing string1 with string2.
   Equivalent to !!:s/string1/string2/.
   !# The entire command line typed so far.
   
troubleshoot debug 
----------------------------

set -eux, strace
   
   `cmd1 &&  cmd2 && cm3`  = `set -e ;cmd1;cmd2;cmd3`
* set -u  The shell prints a message to stderr when it tries to expand a variable that's is not set.Also it immediately exits.

* set -x print each command in sript to stderr before running it.  
* set -o pipefail Pipelines failed on the first command which failes instead of dying later on down the pipepline.
#. has options to control output format and support  and OR
#. "Exit Traps" Can Make Your Bash Scripts Way More Robust And Reliable
    http://redsymbol.net/articles/bash-exit-traps/
并且bash 命令回显机制是做的最好的，-verbose以及打印命令回显呢。
对于linux 下大部分的命令输出都是可以参数可控控制，并且大部分命令都支持 与或非
同时直接支持把结果当命令进一步执行这个不正是自己之前到 tcl 用到 subst 功能吗。

同时也就具备了m4 的部分功能。


shell function
----------------

*如何在shell环境中添加自己的命令*
之前自己干过，直接添加变量，或者直接在命令行赋值，直接添加全局变量，其实也很简单，那就是直接source 一个sh文件，它会当前的进程下执行。其本质那就是你是eval,exec,system,等等之间不同了。现在真正明白了这些操作区别，取决于如何得到这些操作以及结果。在python中脚本，那就execfile, 就像tcl的中source一样的。就像bash一样，我把可以把tcl,python直接当做脚本，但是perl是不行的，perl本身是没有交互环境。
并且在bash 中 ". " 点+ 空格就相当于source.

.. code-block:: bash
  
   # perl style
   #!/bin/bash 
   function quit {
      exit
   }  
   function e {
       echo $1 
   }  
   e Hello
   e World
   quit
   echo foo 
   
   # C style

   function e () {
       echo $1 
   }

#. include other bash scripts into current context.
   `source  and "."`


text Process
============

Regular Expression 
---------------------

.. image::  Stage_1/images/regexp-en.png

|Meta character|Description|
|:----:|----|
|.|Period matches any single character except a line break.|
|[ ]|Character class. Matches any character contained between the square brackets.|
|[^ ]|Negated character class. Matches any character that is not contained between the square brackets|
|*|Matches 0 or more repetitions of the preceding symbol.|
|+|Matches 1 or more repetitions of the preceding symbol.|
|?|Makes the preceding symbol optional.|
|{n,m}|Braces. Matches at least "n" but not more than "m" repetitions of the preceding symbol.|
|(xyz)|Character group. Matches the characters xyz in that exact order.|
|&#124;|Alternation. Matches either the characters before or the characters after the symbol.|
|&#92;|Escapes the next character. This allows you to match reserved characters <code>[ ] ( ) { } . * + ? ^ $ \ &#124;</code>|
|^|Matches the beginning of the input.|
|$|Matches the end of the input.|

https://github.com/ziishaned/learn-regex/blob/master/README.md


* tools collections
  

   - diff,sort/tsort,uniq,join,paste,join,wc,
   - expand,cut,head,tail,look,sed,awk,tr,grep
   - fold,fmt,col,column,nl,pr
   https://www.tldp.org/LDP/abs/html/textproc.html


交并补
--------

* sort/tsort

  .. code-block:: bash 

     -b, --ignore-leading-blanks  ignore leading blanks
     -d, --dictionary-order      consider only blanks and alphanumeric characters
     -f, --ignore-case           fold lower case to upper case characters
     -g, --general-numeric-sort  compare according to general numerical value
     -i, --ignore-nonprinting    consider only printable characters
     -M, --month-sort            compare (unknown) < 'JAN' < ... < 'DEC'
     -h, --human-numeric-sort    compare human readable numbers (e.g., 2K 1G)
     -n, --numeric-sort          compare according to string numerical value
     -r, --reverse               reverse the result of comparisons
     -k, --key=KEYDEF          sort via a key; KEYDEF gives location and type
     -m, --merge               merge already sorted files; do not sort
     -t, --field-separator=SEP  use SEP instead of non-blank to blank transition
     -u, --unique              with -c, check for strict ordering;
                              without -c, output only the first of an equal run
     $ cat  employee.txt
     manager  5000
     clerk    4000
     employee  6000
     peon     4500
     director 9000
     guard     3000
     
     $ sort -k 2n employee.txt
     guard    3000
     clerk    4000
     peon     4500
     manager  5000
     employee 6000
     director 9000

.. code-block:: bash

   $ cat call-graph
   main parse_options
   main tail_file
   main tail_forever
   tail_file pretty_name
   tail_file write_header
   tail_file tail
   tail_forever recheck
   tail_forever pretty_name
   tail_forever write_header
   tail_forever dump_remainder
   tail tail_lines
   tail tail_bytes
   tail_lines start_lines
   tail_lines dump_remainder
   tail_lines file_lines
   tail_lines pipe_lines
   tail_bytes xlseek
   tail_bytes start_bytes
   tail_bytes dump_remainder
   tail_bytes pipe_bytes
   file_lines dump_remainder
   recheck pretty_name
   $ # note: 'tac' reverses the order
   $ tsort call-graph | tac
   dump_remainder
   start_lines
   file_lines
   pipe_lines
   xlseek
   start_bytes
   pipe_bytes
   tail_lines
   tail_bytes
   pretty_name
   write_header
   tail
   recheck
   parse_options
   tail_file
   tail_forever
   main

https://www.wikiwand.com/en/Tsort
https://github.com/Idnan/bash-guide,有大量的例子可以用直接用

.. code-block:: bash

   uniq -c
   sed -e 's/lamb/goat/'
   cut -d ' ' -f1,2 /etc/mtab

* paste

.. code-block:: bash
   bash$ cat items
   alphabet blocks
    building blocks
    cables
   
   bash$ cat prices
   $1.00/dozen
    $2.50 ea.
    $3.75
   
   bash$ paste items prices
   alphabet blocks $1.00/dozen
    building blocks $2.50 ea.
    cables  $3.75
   
*精确的文档生成*

.. code-block:: bash

   $> 
   -> for cl in 19156448 19064514 19006994; do p4 shelve -r -c $cl && echo -e "-------------\n"; done
   Shelving files for change 19156448.
   add //sw/README.mkd#none
   add //sw/TestPlan.pm#none
   add //sw/build_checker.pl#none
   add //sw/build_installer.pl#none
   add //sw/builds/aardvark/nightly/20141218_aardvark_nightly_debug/data/hello.txt#none
   add //sw/builds/aardvark/nightly/20141218_aardvark_nightly_debug/data/world.txt#none
   add //sw/builds/aardvark/nightly/20141219_aardvark_nightly_debug/data/hello.txt#none
   add //sw/builds/aardvark/nightly/20141219_aardvark_nightly_debug/data/world.txt#none
   add //sw/builds/aardvark/nightly/20141219_aardvark_nightly_debug/installer/installer.pl#none
   add //sw/test_project/data/taskEntry.pl#none
   Change 19156448 files shelved.
   -------------
   
   Shelving files for change 19064514.
   edit //sw/devtools/QA/Tools/Farm/exec/Nexus/Submit_ToT.pl#4
   Change 19064514 files shelved.
   -------------
   
   Shelving files for change 19006994.
   edit //sw/doc/code-notes.mkd#1
   edit //sw/FarmEntry.pm#33
   add //sw/BuildCheckerV2.pl#none
   add //sw/d/TestPlan.pm#none
   add //sw/AppConfigValidator.pm#none
   add //sw/Machine.pm#none
   Change 19006994 files shelved.
   -------------

参考
====

.. [Advanced Bash Scripting Guide] https://www.tldp.org/LDP/abs/html/
.. [bash architecture]   http://aosabook.org/en/bash.html
.. [gnu bash manual]  https://www.gnu.org/software/bash/manual/html_node/index.html#SEC_Contents
.. [Bash Prog Intro HowTo] http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO.html#toc7
.. [text process] https://www.tldp.org/LDP/abs/html/textproc.html
.. [brace expansion examples] https://www.wikiwand.com/en/Bash_(Unix_shell)
