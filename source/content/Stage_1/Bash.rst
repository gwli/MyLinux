****************
Bash Scripting
****************


What's is shell
================

* 系统可交互接口,简练，接近自己语言。 
   * Unix小而美的哲学的典范。
   * 所有的UNIX 命令,系统调用,公共程序,工具,和编译过的二进制程序,对于shell 脚本来说,都是可调用的.
   * 所有shell feature 成熟，并且能够在新的shell上完成兼容。 

* 高效交互方式

  * shell expansion
  * command execution
  * command line editing

* 可编程性

  * varirable
  * flow control constructs
  * quoting,
  * functions

Way Bash
========

dash,csh,ksh,

zsh  1990 
Bash 1988
Tcsh  
Csh  1978 https://www.wikiwand.com/en/C_shell
Ksh  1983

#. 通用性强, 大部分linux发行版本的默认shell
#. 各种shell发展成熟，也成为后续的shell的事实标准
#. 灵活的IO重定向，命令替换，管道组合可以 大大提高效率。

   `find | grep`, `()& < > $()`

#. 
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

https://www.wikiwand.com/en/Bash_(Unix_shell)

  .. code-block:: bash
     
     echo {1..10}
     echo {a..e}
     echo {1..10..3}
     echo {a..j..3}

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

  .. code-block:: bash

     exec &> >(tee -a "$log_file")
     echo This will be logged to the file and to the screen
     $log_file will contain the output of the script and any subprocesses, and the output will also be printed to the screen.
     
     >(...) starts the process ... and returns a file representing its standard input. exec &> ... redirects both standard output and standard error into ... for the remainder of the script (use just exec > ... for stdout only). tee -a appends its standard input to the file, and also prints it to the screen.
     https://unix.stackexchange.com/questions/145651/using-exec-and-tee-to-redirect-logs-to-stdout-and-a-log-file-in-the-same-time

* 命令替换
      
.. co de-block:: bash
      
  $(c ommand)  
  `co mmand`
      
* Wor d Split $IFS  <space>,<tab>,<newline>
      
Shell Command execution 
============================
      
组合命令，管道，命令替换，进程替换，IO重定向
      
      
commands
---------
      
* 简  单命令

* list of Commands

.. code-block:: bash

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


* Grouping commands  as a unit, 

.. code-block:: bash

   ( list ) #/executed in a subshell  
   { list; } #at current shell context

- redirection and pipeline is applied to the entire command list. 
- *() in bash*
 可以用以进程替换，再加>，<就像管道了。 ,$()就当于相当于 subst可以任意次的替换，而不相双引号与反勾号替换执行次数。
 并且今天添加了cleanApk这样功能，让大家都来用这样才能显示自己的实力。

.. code-block:: bash

   [test@DEVTOOLS-QA130 ~]$ ldd /usr/autodesk/maya2019/bin/maya.bin 
        linux-vdso.so.1 =>  (0x00007ffdbb5d8000)
        libMaya.so => /usr/autodesk/maya2019/bin/../lib/libMaya.so (0x00007f52e43ad000)
        libIMFbase.so => /usr/autodesk/maya2019/bin/../lib/libIMFbase.so (0x00007f52e40db000)
        libAG.so => /usr/autodesk/maya2019/bin/../lib/libAG.so (0x00007f52e3a74000)
        libiff.so => /usr/autodesk/maya2019/bin/../lib/libiff.so (0x00007f52e383f000)
        libawGR.so => /usr/autodesk/maya2019/bin/../lib/libawGR.so (0x00007f52e3632000)
        libglew.so => /usr/autodesk/maya2019/bin/../lib/libglew.so (0x00007f52e33b3000)
        libclew.so => /usr/autodesk/maya2019/bin/../lib/libclew.so (0x00007f52e31ad000)
        libOpenCLUtilities.so => /usr/autodesk/maya2019/bin/../lib/libOpenCLUtilities.so (0x00007f52e2f89000)
        libAppVersion.so => /usr/autodesk/maya2019/bin/../lib/libAppVersion.so (0x00007f52e2d87000)
        libFoundation.so => /usr/autodesk/maya2019/bin/../lib/libFoundation.so (0x00007f52e27b7000)
        libAnimEngine.so => /usr/autodesk/maya2019/bin/../lib/libAnimEngine.so (0x00007f52e250f000)
        libCommandEngine.so => /usr/autodesk/maya2019/bin/../lib/libCommandEngine.so (0x00007f52e2126000)
        libDependEngine.so => /usr/autodesk/maya2019/bin/../lib/libDependEngine.so (0x00007f52e1b15000)
        libGeometryEngine.so => /usr/autodesk/maya2019/bin/../lib/libGeometryEngine.so (0x00007f52e18ad000)
        libNurbsEngine.so => /usr/autodesk/maya2019/bin/../lib/libNurbsEngine.so (0x00007f52e14d1000)
        libImage.so => /usr/autodesk/maya2019/bin/../lib/libImage.so (0x00007f52e0f27000)
        libDependCommand.so => /usr/autodesk/maya2019/bin/../lib/libDependCommand.so (0x00007f52e0cf4000)
        libExtensionLayer.so => /usr/autodesk/maya2019/bin/../lib/libExtensionLayer.so (0x00007f52e04a2000)
        libDataModel.so => /usr/autodesk/maya2019/bin/../lib/libDataModel.so (0x00007f52df815000)
        libPolyEngine.so => /usr/autodesk/maya2019/bin/../lib/libPolyEngine.so (0x00007f52df17f000)
        libSubdivEngine.so => /usr/autodesk/maya2019/bin/../lib/libSubdivEngine.so (0x00007f52deec9000)
        libSubdivGeom.so => /usr/autodesk/maya2019/bin/../lib/libSubdivGeom.so (0x00007f52dec62000)
        lib3dGraphics.so => /usr/autodesk/maya2019/bin/../lib/lib3dGraphics.so (0x00007f52de9f2000)
        libNurbs.so => /usr/autodesk/maya2019/bin/../lib/libNurbs.so (0x00007f52de628000)
        libRenderModel.so => /usr/autodesk/maya2019/bin/../lib/libRenderModel.so (0x00007f52ddb4c000)
        libPoly.so => /usr/autodesk/maya2019/bin/../lib/libPoly.so (0x00007f52dd134000)
        libShared.so => /usr/autodesk/maya2019/bin/../lib/libShared.so (0x00007f52dc5d8000)
        libModelSlice.so => /usr/autodesk/maya2019/bin/../lib/libModelSlice.so (0x00007f52dc2b1000)
        libAnimSlice.so => /usr/autodesk/maya2019/bin/../lib/libAnimSlice.so (0x00007f52dbdec000)
        libPolySlice.so => /usr/autodesk/maya2019/bin/../lib/libPolySlice.so (0x00007f52db641000)
        libSubdiv.so => /usr/autodesk/maya2019/bin/../lib/libSubdiv.so (0x00007f52db27c000)
        libSharedUI.so => /usr/autodesk/maya2019/bin/../lib/libSharedUI.so (0x00007f52da714000)
        libHWFoundation.so => /usr/autodesk/maya2019/bin/../lib/libHWFoundation.so (0x00007f52da4cc000)
        libHWGL.so => /usr/autodesk/maya2019/bin/../lib/libHWGL.so (0x00007f52da25c000)
        libHWRender.so => /usr/autodesk/maya2019/bin/../lib/libHWRender.so (0x00007f52d9fef000)
        libHWRenderMaya.so => /usr/autodesk/maya2019/bin/../lib/libHWRenderMaya.so (0x00007f52d9d6b000)
        libOGSRender.so => /usr/autodesk/maya2019/bin/../lib/libOGSRender.so (0x00007f52d9740000)
        libOGSMayaBridge.so => /usr/autodesk/maya2019/bin/../lib/libOGSMayaBridge.so (0x00007f52d904c000)
        libRenderSlice.so => /usr/autodesk/maya2019/bin/../lib/libRenderSlice.so (0x00007f52d8b68000)
        libMetaData.so => /usr/autodesk/maya2019/bin/../lib/libMetaData.so (0x00007f52d88e1000)
        libGeometryDefn.so => /usr/autodesk/maya2019/bin/../lib/libGeometryDefn.so (0x00007f52d869d000)
        libGeometryAlg.so => /usr/autodesk/maya2019/bin/../lib/libGeometryAlg.so (0x00007f52d83a1000)
        libTesselation.so => /usr/autodesk/maya2019/bin/../lib/libTesselation.so (0x00007f52d80f2000)
        libpcre.so => /usr/autodesk/maya2019/bin/../lib/libpcre.so (0x00007f52d7ec8000)
        libADSKAssetBrowserLib.so => /usr/autodesk/maya2019/bin/../lib/libADSKAssetBrowserLib.so (0x00007f52d7bfa000)
        libDeformSlice.so => /usr/autodesk/maya2019/bin/../lib/libDeformSlice.so (0x00007f52d74b0000)
        libNurbsSlice.so => /usr/autodesk/maya2019/bin/../lib/libNurbsSlice.so (0x00007f52d6f37000)
        libKinSlice.so => /usr/autodesk/maya2019/bin/../lib/libKinSlice.so (0x00007f52d6680000)
        libTranslators.so => /usr/autodesk/maya2019/bin/../lib/libTranslators.so (0x00007f52d640b000)
        libBase.so => /usr/autodesk/maya2019/bin/../lib/libBase.so (0x00007f52d60fc000)
        libQt5Core.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5Core.so.5 (0x00007f52d5bc6000)
        libQt5X11Extras.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5X11Extras.so.5 (0x00007f52e47b8000)
        libQt5Gui.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5Gui.so.5 (0x00007f52d5603000)
        libQt5Svg.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5Svg.so.5 (0x00007f52e4762000)
        libQt5Widgets.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5Widgets.so.5 (0x00007f52d4f9d000)
        libtbb.so.2 => /usr/autodesk/maya2019/bin/../lib/libtbb.so.2 (0x00007f52d4d43000)
        libtbbmalloc.so.2 => /usr/autodesk/maya2019/bin/../lib/libtbbmalloc.so.2 (0x00007f52d4aed000)
        libGLU.so.1 => /lib64/libGLU.so.1 (0x00007f52d486d000)
        libGL.so.1 => /lib64/libGL.so.1 (0x00007f52d45c4000)
        libstdc++.so.6 => /lib64/libstdc++.so.6 (0x00007f52d42bd000)
        libm.so.6 => /lib64/libm.so.6 (0x00007f52d3fbb000)
        libgomp.so.1 => /lib64/libgomp.so.1 (0x00007f52d3d95000)
        libgcc_s.so.1 => /lib64/libgcc_s.so.1 (0x00007f52d3b7f000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x00007f52d3963000)
        libc.so.6 => /lib64/libc.so.6 (0x00007f52d3596000)
        libQt5OpenGL.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5OpenGL.so.5 (0x00007f52e46ed000)
        libadp_core-6_1.so => /usr/autodesk/maya2019/bin/../lib/libadp_core-6_1.so (0x00007f52d326c000)
        libadp_data-6_1.so => /usr/autodesk/maya2019/bin/../lib/libadp_data-6_1.so (0x00007f52d3020000)
        libadp_service_opczip-6_1.so => /usr/autodesk/maya2019/bin/../lib/libadp_service_opczip-6_1.so (0x00007f52d2c41000)
        libadp_toolkit-6_1.so => /usr/autodesk/maya2019/bin/../lib/libadp_toolkit-6_1.so (0x00007f52d286b000)
        libMgMdfModel.so => /usr/autodesk/maya2019/bin/../lib/libMgMdfModel.so (0x00007f52d25fa000)
        libMgMdfParser.so => /usr/autodesk/maya2019/bin/../lib/libMgMdfParser.so (0x00007f52d231c000)
        libOGSAtilIntegration-16.so => /usr/autodesk/maya2019/bin/../lib/libOGSAtilIntegration-16.so (0x00007f52d1826000)
        libOGSDevices-16.so => /usr/autodesk/maya2019/bin/../lib/libOGSDevices-16.so (0x00007f52d1019000)
        libOGSGraphics-16.so => /usr/autodesk/maya2019/bin/../lib/libOGSGraphics-16.so (0x00007f52d079f000)
        libOGSObjects-16.so => /usr/autodesk/maya2019/bin/../lib/libOGSObjects-16.so (0x00007f52d03f1000)
        libOGSMgStylization-16.so => /usr/autodesk/maya2019/bin/../lib/libOGSMgStylization-16.so (0x00007f52d0146000)
        libOGSDeviceOGL-16.so => /usr/autodesk/maya2019/bin/../lib/libOGSDeviceOGL-16.so (0x00007f52cfee0000)
        libsynHub.so => /usr/autodesk/maya2019/bin/../lib/libsynHub.so (0x00007f52cf91b000)
        libxml2.so.2 => /lib64/libxml2.so.2 (0x00007f52cf5b1000)
        libclmint.so.5 => /usr/autodesk/maya2019/bin/../lib/libclmint.so.5 (0x00007f52cf146000)
        libdl.so.2 => /lib64/libdl.so.2 (0x00007f52cef42000)
        libpython2.7.so.1.0 => /usr/autodesk/maya2019/bin/../lib/libpython2.7.so.1.0 (0x00007f52ceb5b000)
        libz.so.1 => /lib64/libz.so.1 (0x00007f52ce945000)
        libquicktime.so.0 => /usr/autodesk/maya2019/bin/../lib/libquicktime.so.0 (0x00007f52ce678000)
        libawMarkingMenus.so => /usr/autodesk/maya2019/bin/../lib/libawMarkingMenus.so (0x00007f52ce44a000)
        libQt5WebKit.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5WebKit.so.5 (0x00007f52cbfa7000)
        libQt5WebKitWidgets.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5WebKitWidgets.so.5 (0x00007f52e469f000)
        libQt5WebEngine.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5WebEngine.so.5 (0x00007f52e4655000)
        libQt5WebEngineCore.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5WebEngineCore.so.5 (0x00007f52c77c3000)
        libQt5WebEngineWidgets.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5WebEngineWidgets.so.5 (0x00007f52e461e000)
        libQt5Network.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5Network.so.5 (0x00007f52c7654000)
        libQt5Script.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5Script.so.5 (0x00007f52c73c7000)
        libsynColor.so.2018.0.80 => /usr/autodesk/maya2019/bin/../lib/libsynColor.so.2018.0.80 (0x00007f52c46da000)
        libXm.so.3 => /usr/autodesk/maya2019/bin/../lib/libXm.so.3 (0x00007f52c434c000)
        libXp.so.6 => not found
        libXmu.so.6 => /lib64/libXmu.so.6 (0x00007f52c4131000)
        libXpm.so.4 => /lib64/libXpm.so.4 (0x00007f52c3f1f000)
        libXt.so.6 => /lib64/libXt.so.6 (0x00007f52c3cb8000)
        libXi.so.6 => /lib64/libXi.so.6 (0x00007f52c3aa8000)
        libXext.so.6 => /lib64/libXext.so.6 (0x00007f52c3896000)
        libX11.so.6 => /lib64/libX11.so.6 (0x00007f52c3558000)
        libtiff.so.5 => /lib64/libtiff.so.5 (0x00007f52c32e4000)
        libfontconfig.so.1 => /lib64/libfontconfig.so.1 (0x00007f52c30a2000)
        libfreetype.so.6 => /lib64/libfreetype.so.6 (0x00007f52c2de3000)
        libXinerama.so.1 => /lib64/libXinerama.so.1 (0x00007f52c2be0000)
        libufe_1.so => /usr/autodesk/maya2019/bin/../lib/libufe_1.so (0x00007f52e45db000)
        libosdGPU.so => /usr/autodesk/maya2019/bin/../lib/libosdGPU.so (0x00007f52c2993000)
        libosdCPU.so => /usr/autodesk/maya2019/bin/../lib/libosdCPU.so (0x00007f52c2722000)
        libAutoCam.so => /usr/autodesk/maya2019/bin/../lib/libAutoCam.so (0x00007f52c2428000)
        libPtex.so => /usr/autodesk/maya2019/bin/../lib/libPtex.so (0x00007f52c2196000)
        libawCacheShared.so => /usr/autodesk/maya2019/bin/../lib/libawCacheShared.so (0x00007f52c1f79000)
        libQt5Xml.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5Xml.so.5 (0x00007f52c1f3e000)
        libfbxassetscore2.so => /usr/autodesk/maya2019/bin/../lib/libfbxassetscore2.so (0x00007f52c1bb8000)
        libopenal.so.1 => /usr/autodesk/maya2019/bin/../lib/libopenal.so.1 (0x00007f52c1913000)
        libfam.so.0 => not found
        libXp.so.6 => not found
        libawnSolver.so => /usr/autodesk/maya2019/bin/../lib/libawnSolver.so (0x00007f52c1585000)
        libDynSlice.so => /usr/autodesk/maya2019/bin/../lib/libDynSlice.so (0x00007f52c0bdb000)
        libweightXML.so => /usr/autodesk/maya2019/bin/../lib/libweightXML.so (0x00007f52c09c0000)
        libManips.so => /usr/autodesk/maya2019/bin/../lib/libManips.so (0x00007f52c0494000)
        libExplorerSlice.so => /usr/autodesk/maya2019/bin/../lib/libExplorerSlice.so (0x00007f52bfa7c000)
        libImageUI.so => /usr/autodesk/maya2019/bin/../lib/libImageUI.so (0x00007f52bf6da000)
        libUrchinSlice.so => /usr/autodesk/maya2019/bin/../lib/libUrchinSlice.so (0x00007f52bf314000)
        libModifiers.so => /usr/autodesk/maya2019/bin/../lib/libModifiers.so (0x00007f52bedb7000)
        libquadprog.so => /usr/autodesk/maya2019/bin/../lib/libquadprog.so (0x00007f52beb9f000)
        librt.so.1 => /lib64/librt.so.1 (0x00007f52be995000)
        libuuid.so.1 => /lib64/libuuid.so.1 (0x00007f52be790000)
        libpcre16.so.0 => /lib64/libpcre16.so.0 (0x00007f52be537000)
        libgthread-2.0.so.0 => /lib64/libgthread-2.0.so.0 (0x00007f52be334000)
        libglib-2.0.so.0 => /lib64/libglib-2.0.so.0 (0x00007f52be01e000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f52e45af000)
        libpng15.so.15 => /lib64/libpng15.so.15 (0x00007f52bddf2000)
        libgobject-2.0.so.0 => /lib64/libgobject-2.0.so.0 (0x00007f52bdba2000)
        libGLX.so.0 => /lib64/libGLX.so.0 (0x00007f52bd971000)
        libGLdispatch.so.0 => /lib64/libGLdispatch.so.0 (0x00007f52bd69e000)
        libcurl.so.4 => /lib64/libcurl.so.4 (0x00007f52bd434000)
        libxerces-c.so.27 => /usr/autodesk/maya2019/bin/../lib/libxerces-c.so.27 (0x00007f52bce1f000)
        libimf.so => /usr/autodesk/maya2019/bin/../lib/libimf.so (0x00007f52bc932000)
        libsvml.so => /usr/autodesk/maya2019/bin/../lib/libsvml.so (0x00007f52bba27000)
        libintlc.so.5 => /usr/autodesk/maya2019/bin/../lib/libintlc.so.5 (0x00007f52bb7bd000)
        libOGSArchive-16.so => /usr/autodesk/maya2019/bin/../lib/libOGSArchive-16.so (0x00007f52bb4e2000)
        libNsArchive10.so => /usr/autodesk/maya2019/bin/../lib/libNsArchive10.so (0x00007f52bb2dc000)
        libssl.so.10 => /lib64/libssl.so.10 (0x00007f52bb06a000)
        libcrypto.so.10 => /lib64/libcrypto.so.10 (0x00007f52bac09000)
        libCg.so => /usr/autodesk/maya2019/bin/../lib/libCg.so (0x00007f52b972f000)
        libCgGL.so => /usr/autodesk/maya2019/bin/../lib/libCgGL.so (0x00007f52b95ab000)
        liblzma.so.5 => /lib64/liblzma.so.5 (0x00007f52b9384000)
        libutil.so.1 => /lib64/libutil.so.1 (0x00007f52b9181000)
        libawDebugTools.so => /usr/autodesk/maya2019/bin/../lib/libawDebugTools.so (0x00007f52b8f7b000)
        libXrender.so.1 => /lib64/libXrender.so.1 (0x00007f52b8d70000)
        libXcomposite.so.1 => /lib64/libXcomposite.so.1 (0x00007f52b8b6d000)
        libjpeg.so.62 => /lib64/libjpeg.so.62 (0x00007f52b8917000)
        libgio-2.0.so.0 => /lib64/libgio-2.0.so.0 (0x00007f52b8578000)
        libgstreamer-1.0.so.0 => /lib64/libgstreamer-1.0.so.0 (0x00007f52b824b000)
        libgstapp-1.0.so.0 => /lib64/libgstapp-1.0.so.0 (0x00007f52b803c000)
        libgstbase-1.0.so.0 => /lib64/libgstbase-1.0.so.0 (0x00007f52b7ddd000)
        libgstpbutils-1.0.so.0 => /lib64/libgstpbutils-1.0.so.0 (0x00007f52b7ba8000)
        libgstvideo-1.0.so.0 => /lib64/libgstvideo-1.0.so.0 (0x00007f52b791f000)
        libgstaudio-1.0.so.0 => /lib64/libgstaudio-1.0.so.0 (0x00007f52b76b9000)
        libicui18n.so.50 => /usr/autodesk/maya2019/bin/../lib/libicui18n.so.50 (0x00007f52b72ba000)
        libicuuc.so.50 => /usr/autodesk/maya2019/bin/../lib/libicuuc.so.50 (0x00007f52b6f40000)
        libicudata.so.50 => /usr/autodesk/maya2019/bin/../lib/libicudata.so.50 (0x00007f52b596c000)
        libQt5Sensors.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5Sensors.so.5 (0x00007f52b592e000)
        libQt5Positioning.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5Positioning.so.5 (0x00007f52b58ed000)
        libQt5Quick.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5Quick.so.5 (0x00007f52b5515000)
        libQt5Qml.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5Qml.so.5 (0x00007f52b511c000)
        libQt5WebChannel.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5WebChannel.so.5 (0x00007f52b50fd000)
        libQt5Sql.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5Sql.so.5 (0x00007f52b50b6000)
        libQt5PrintSupport.so.5 => /usr/autodesk/maya2019/bin/../lib/libQt5PrintSupport.so.5 (0x00007f52b5044000)
        libsmime3.so => /lib64/libsmime3.so (0x00007f52b4e1d000)
        libnss3.so => /lib64/libnss3.so (0x00007f52b4aef000)
        libnssutil3.so => /lib64/libnssutil3.so (0x00007f52b48c0000)
        libnspr4.so => /lib64/libnspr4.so (0x00007f52b4682000)
        libXcursor.so.1 => /lib64/libXcursor.so.1 (0x00007f52b4476000)
        libXfixes.so.3 => /lib64/libXfixes.so.3 (0x00007f52b4270000)
        libasound.so.2 => /lib64/libasound.so.2 (0x00007f52b3f70000)
        libXdamage.so.1 => /lib64/libXdamage.so.1 (0x00007f52b3d6c000)
        libXtst.so.6 => /lib64/libXtst.so.6 (0x00007f52b3b66000)
        libdbus-1.so.3 => /lib64/libdbus-1.so.3 (0x00007f52b3916000)
        libSM.so.6 => /lib64/libSM.so.6 (0x00007f52b370d000)
        libICE.so.6 => /lib64/libICE.so.6 (0x00007f52b34f1000)
        libXp.so.6 => not found
        libxcb.so.1 => /lib64/libxcb.so.1 (0x00007f52b32c8000)
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
   [test@DEVTOOLS-QA130 ~]$ ldd /usr/autodesk/maya2019/bin/maya.bin |grep "not"
     libXp.so.6 => not found
     libfam.so.0 => not found
     libXp.so.6 => not found
     libXp.so.6 => not found
     libtbbmalloc_proxy.so.2 => not found
     libtbb_preview.so.2 => not found
     libtbbmalloc_proxy.so.2 => not found
     libtbb_preview.so.2 => not found


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
   
#. troubleshoot set -eux, strace
   
   `cmd1 &&  cmd2 && cm3`  = `set -e ;cmd1;cmd2;cmd3`
* set -u  The shell prints a message to stderr when it tries to expand a variable that's is not set.Also it immediately exits.

* set -x print each command in sript to stderr before running it.  

* set -o pipefail Pipelines failed on the first command which failes instead of dying later on down the pipepline.


#. has options to control output format and support  and OR

#. "Exit Traps" Can Make Your Bash Scripts Way More Robust And Reliable
    http://redsymbol.net/articles/bash-exit-traps/




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

https://github.com/Idnan/bash-guide,有大量的例子可以用直接用

https://github.com/asciimoo/drawillj

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
