****************
Bash Scripting
****************

*优点*

#. 简练，接近自然语言，容易扩展. 

   * Unix小而美的哲学的典范。
   * 所有的UNIX 命令,系统调用,公共程序,工具,和编译过的二进制程序,对于shell 脚本来说,都是可调用的.
   * 所有shell feature 成熟，并且能够在新的shell上完成兼容。 

#. 通用性强, 大部分linux发行版本的默认shell
#. 灵活的IO重定向，命令替换，管道组合可以 大大提高效率。

   `find | grep`, `()& < > $()`
   

*缺点*

#. 变量没有作用域,没有类型，只有字符串
#. 没有复杂的数据结构 ,队列，堆栈，链表等
#. 速度慢
#. ... `see more <http://mywiki.wooledge.org/BashWeaknesses>`_

Bash 的原理框图
===============

.. figure:: Stage_1/images/bash_component_architecture.png


shell expansions
================

{} 直积(笛卡尔积) 
-------------------

:math:`(a,b)* (x,y,z) => (a,x),(a,y),(a,z),(b,x),(b,y),(b,z)`

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

shell pattern matching
------------------------

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

   [test@localhost pam.d]$ ls
   [test@localhost pam.d]$ ls /etc/pam.d/
   atd                  gdm-autologin           login             postlogin-ac       smtp              system-auth
   chfn                 gdm-fingerprint         other             ppp                smtp.postfix      system-auth-ac
   chsh                 gdm-launch-environment  passwd            remote             sshd              systemd-user
   config-util          gdm-password            password-auth     runuser            sssd-shadowutils  vlock
   crond                gdm-pin                 password-auth-ac  runuser-l          su                vmtoolsd
   cups                 gdm-smartcard           pluto             setup              sudo              xserver
   fingerprint-auth     ksu                     polkit-1          smartcard-auth     sudo-i
   fingerprint-auth-ac  liveinst                postlogin         smartcard-auth-ac  su-l
   [test@localhost pam.d]$ cp /etc/pam.d/gdm-+(auto|pass)* .
   [test@localhost pam.d]$ ls
   gdm-autologin  gdm-password
   [test@localhost pam.d]$ 

* 善用通配符，减少输入

   .. code-block:: bash

      vim **/*READ*  #open the README at any subfolder
      vim /etc/pa*ac

~扩展
-----

.. code-block:: bash

   ~ The value of $HOME
   ~/foo #$HOME/foo
   ~fred/foo  #The subdirectory foo of the home directory of the user fred
   ~+/foo $PWD/foo


 变量与参数扩展
-----------------

* =前后没有空格  `varname="value"` `$varname ${varable}`

* speical variable 替换  特殊变量 特殊符号的扩展

以及 $<,$*,$@ 
对于参数，一个种是列表，key-value值对，变长，以及位置参数。 参数的传递是默认是位置参数 

$0 $1,$2  
$# 命令行参数的个数
$* 所有的位置参数当做一个单词
$@ 所有的位置参数每一个独立。


*$@*
exec /usr/bin/flex -l "$@" 以前不知道为什么要有这些用法。现在明白了主要为了方便二次的转接。尤其在做接口函数的，这样可以无缝传给那些函数。正是通过些符号，我们很方便定制各种各样的命令，就样android中build 中envsetup,sh 中那些cgrep,regrep, 等等这些命令。进行二次封装可以大大加快的自己的速度。

       
.. csv-table::
   :header": "Variable","Description"
   
   "$0",The filename of the current script.
   "$n",These variables correspond to the arguments with which a script was invoked. Here n is a positive decimal number corresponding to the position of an argument (the first argument is $1, the second argument is $2, and so on).
   "$$",The process ID of the current shell. For shell scripts, this is the process ID under which they are executing.
   "$#",The number of arguments supplied to a script.
   "$@",All the arguments are individually double quoted. If a script receives two arguments, $@ is equivalent to $1 $2.
   "$*",All the arguments are double quoted. If a script receives two arguments, $* is equivalent to $1 $2.
   "$?",The exit status of the last command executed.
   "$!",The process ID of the last background command.
   "$_",The last argument of the previous command.
      
   * 利用$* 来实现命令的封装，在你需要定制你的命令的时候
     
     .. code-block:: bash
        
        ll.sh 
        ls -l $* 

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

    - 把你复杂的变量直接存为变量

      .. code-block:: bash
         
         mydu="du -csh"   


* 数学计算替换 仅支持整数 `$(( expression ))`
* 进程替换 `<(list) or  >(list)`
* 命令替换

  .. code-block:: bash

     $(command)  
     `command`

* Word Split $IFS  <space>,<tab>,<newline>

Shell Command execution 
============================

组合命令，管道，命令替换，进程替换，IO重定向


commands
---------

* 简单命令

* list of Commands

  .. code-block:: bash

     command1 && command2
     command1 || command2

*  component Commands

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


* Grouping commands  as a unit, 

  .. code-block:: bash

     ( list ) #/executed in a subshell  
     { list; } #at current shell context

  - redirection and pipeline is applied to the entire command list. 
  - *() in bash*
    可以用以进程替换，再加>，<就像管道了。 ,$()就当于相当于 subst可以任意次的替换，而不相双引号与反勾号替换执行次数。
    并且今天添加了cleanApk这样功能，让大家都来用这样才能显示自己的实力。

命令替换 进程替换
---------------------



  特别具有函数编程有味道，例如
  :command:`diff <(ls $first_directory) < (ls $second_directory)` 把半命令的输出直接来对比。
  这个正是自己一直要想要的结果吗。 这样就不需要临时文件。
  shell 的强大，就在于各种替换与连接替换。 对于任意代码块可以用 {} < 来取输入，


串行与并行计算与同步
--------------------

简单的管道是串行，而并行就要用() 再加上这些与列表与或者表了。不过bash实现都是进程级的并行了。
()&&()|tee log.txt

而简单的语列表与或列表是串行的，如果加()就是并行了，同并与或之间也就具有同步的机制。

并且sh 中很有函数式编程味道。

并且bash 命令回显机制是做的最好的，-verbose以及打印命令回显呢。

所以对于bash来说，直接看其执行的log就可以了。这样就可以利用gentoo把整个启动过程完全搞明白了。


*多进程*

`Bash script parallel processing (concurent exec) <http://ubuntuforums.org/showthread.php?t=382330>`_ 

 {} & 就可以直接把这块代码放在了后台运行。 直接用wait来进行同步，并且如何等可以用 man wait 来查参数。
   
.. code-block:: bash
 
   for i in `seq 1 100` ; do
       (ping www.google.com &)
   done
   
   
   maxjobs = 10
   
   foreach line in the file {
        jobsrunning = 0
        while jobsrunning < maxjobs {
            do job &
            jobsrunning += 1
        }
        wait
   }
   
   job ( ){
      ...
   }

IO redirection
---------------


*bash 有最好用重定向*

.. code-block:: bash

   { code-block} >> output.log

例如下边的例子，生成 :file:`/etc/udev/rules.d/70-persistent-net.rules` 的 
:file:`/lib/udev/write_net_rules` 生成函数。

.. code-block:: bash

   diff -u < (ls | sort ) <(ssh -i ~/my.key dove@myhost grep amazon mp3.urltxt)

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

   << 重定向到文件，从文件中读取。
   <<<就是 "here string" 就是python 中"""三目符的用法。


更好完的重定向要属端口应用功能 了。
------------------------------------

:command:`mknod /dev/tcp c 30 36` 就可以STDIN/STDOUT/STDERR一样重定向了。

特别是/dev/tcp   /dev/upd这些伪设备也是很好完的。

.. code-block:: bash
    
    cat </dev/tcp/time.nist.gov/13

就得到的实现。

pipelines
-----------
  
* Pipes

  .. code-block:: bash

     command1 | command2
     command1 |& command2

  
Redirections
------------

命令的模型 这个图不错
http://www.jianshu.com/p/3687e12b8d48

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
     - [n]<&digit-
     - [n]<>word



*对于文件的读写*


bash 是最简化的， read 指定就可以，写可以用echo也可以write以及重定了。

例如读入前三行

.. code-block:: bash
    
   { read line1
     read line2
     read line3
   } < /etc/fstab


这是多么的简练，原来perl中那些符号也都是从这里来的吧。并且bash中的read指定很强的。

不仅支持 timeout还支持 列表输入，就像 a,b,c=1,2,3这样。并且自动把多余给最后一个。
还可以指令一行，还是一个字符，还是指定分界符。还可以设置不回显等等。
当然如果想读入特定几行，并且放在一个数据组里，有readarray,mapfile.都是这些功能。
http://omicron2012.blog.163.com/blog/static/236148083201442483739536/

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


* pipepline just connect  output of one program to other output

  .. code-block:: bash

     find -iname "xx"| xargs grep "afaf"
     ls -l |sed -e 's/[aeio]/u/g'

* pipepline just connect  output of one program to other output
  
  * `` $() 

* list of commands

  && || ; &

https://www.gnu.org/software/bash/manual/html_node/index.html#SEC_Contents


command line editing
=====================





*command complete*

如果这个做好，可以大大加快工作效率。例如 

#. `More on Using the Bash Complete Command <http://www.linuxjournal.com/content/more-using-bash-complete-command>`_  可以利用来自定义命令补全，是可以加上过滤条件的
#. `Programmable-Completion <http://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion>`_  bash 中有专门的文档来说明，据说zsh的补全做的最好。
#. 目前在对于android，已经有现在与补全功能了，在sdk/bash_compeletion/adb  加载了它之后，android下就可以自动补全了。
#. `zsh adb completion  <https://github.com/zsh-users/zsh-completions>`_  

#. 好用自动补齐功能

   - 路径补全，命令补全，命令参数补全，插件内容补全
   - 智能拼写纠正

   :command:`apt-get install bash-completion` 

   并且随着 bash的升级，4.3之后已经可以 自动补全 参数了。看来是越来越强了。如果是想自定义可以使用
   http://kodango.com/bash-competion-programming

   这一点zsh 做更灵活，各种补全，尽可能tab. 并且支持** 来递归。

   .. image:: Stage_1/asciinema/auto-complete.gif
      :scale: 50%


- 把你常用的路径直接存为变量，可以减少cd 的次数

   .. image:: Stage_1/asciinema/variable_expand.gif
      :scale: 50%

编辑模式 vi/emcas
-------------------

set -o vi

*man builtins* 可以看许多有用东东，例如bind就可以进行键盘绑定的。就像vi  的map一样。
对于编辑模式的改变 bindkey -v vi vi模式。

对于编辑模式的改变 bindkey -v vi vi模式。
https://www.ibm.com/developerworks/cn/linux/shell/z/
http://wdxtub.com/2016/02/18/oh-my-zsh/


history skill
---------------
   
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
   
#. troubleshoot set -x, strace
   set -e

#. has options to control output format and support  and OR






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
 
*精确的文档生成*

对于linux 下大部分的命令输出都是可以参数可控控制，并且大部分命令都支持 与或非
同时直接支持把结果当命令进一步执行这个不正是自己之前到 tcl 用到 subst 功能吗。

同时也就具备了m4 的部分功能。

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

分隔符
------

现在明白了，sh 的了些限制，sh 直接用空格当做分隔符，并且调用也这样。 也就是为什么赋值，不能分开写的原因。
如果替换就得用 `` , 或者$()

默认的都是空格， 换行。
列表分隔符是,  
key,value的分隔符是:, =>,或者=
列表的符号，[]/()
哈希数组:  {}
默认的引用 . -> 等等。

* Regular Expression 
  
  .. code-block:: bash
     
     . * [] ? {} () ^,$

* tools collections
  
   - diff,sort/tsort,uniq,join,paste,join,wc,grep
   - expand,cut,head,tail,look,sed,awk,tr
   - fold,fmt,col,column,nl,pr
   https://www.tldp.org/LDP/abs/html/textproc.html

参考
====

.. [Advanced Bash Scripting Guide] https://www.tldp.org/LDP/abs/html/
.. [bash architecture]   http://aosabook.org/en/bash.html
.. [gnu bash manual]  https://www.gnu.org/software/bash/manual/html_node/index.html#SEC_Contents
.. [Bash Prog Intro HowTo] http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO.html#toc7
.. [text process] https://www.tldp.org/LDP/abs/html/textproc.html
