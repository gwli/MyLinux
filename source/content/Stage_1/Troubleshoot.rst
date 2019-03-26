Troubleshot 的能力
******************

一个是直接google, 如果得到最好，如果不能，怎么办就可以查其官网的bug,以及测试用例。 就知道这个软件的测试都做了哪些，看看是不是已经问题。

在编译的时候经常文件或者库找不到 可以用 :command:`apt-file` 查找。

bug就要查其官网了，特别是开源的。
例如

https://code.google.com/p/android/issues/detail?id=23894

Test:
看其本地的测试。

run 32-bit run on ubuntu 14.04 64 bit
=====================================

.. code-block:: bash

   dpkg --print-foreign-architectures
   sudo dpkg --add-architecture i386
   sudo apt-get update
   sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386
   sudo apt-get install lib32z1 lib32ncurses5 lib32bz2-1.0


final restore
=============

#. chroot with a livecd.
#. compire with the standard OS configuration. 
#. step by step fix dependency.

解决的难点在于依赖，由于各种依赖关系，你删除一个包，可能相依赖的包也就删除了，也就造了其他的包。不能用。

.. code-block:: bash
   
   dpkg -l |grep "xserver-xorg"
   xserver-xorg
   xserver-input-all 键鼠不能用，安装就是这些出了问题。
   xserver-video-all 管理显示。
   ubuntu-desktop 安装窗口管理器
   
   
