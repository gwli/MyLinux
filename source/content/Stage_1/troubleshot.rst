Troubleshot 的能力
******************

一个是直接google, 如果得到最好，如果不能，怎么办就可以查其官网的bug,以及测试用例。 就知道这个软件的测试都做了哪些，看看是不是已经问题。

在编译的时候经常文件或者库找不到 可以用 :comman:`apt-file` 查找。

bug就要查其官网了，特别是开源的。
例如

https://code.google.com/p/android/issues/detail?id=23894

Test:
看其本地的测试。

run 32-bit run on ubuntu 14.04 64 bit
=====================================

.. code-block::

   dpkg --print-foreign-architectures
   sudo dpkg --add-architecture i386
   sudo apt-get update
   sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386
   sudo apt-get install lib32z1 lib32ncurses5 lib32bz2-1.0
