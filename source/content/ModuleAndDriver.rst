==============
Module与driver 
==============


linux下driver的安装还是很有挑战的，会遇到各种的不兼合，并且会无法适从。但是明白其加载原理之后，自然一切都了然于心了。

driver起的就是逻辑设备，要想到一个linux中使用一个设备，就为其建立一个逻辑设备也就是driver,正是因为这一层逻辑设备，我们才可以各种虚拟设备。以及实现虚拟化的。

这个映射关心是由udev来做实现的，而driver本身的管理是由modeprobe.conf来管理的。
module的依赖，以及alias,以及blacklist机制,还可以配制module的参数。并且还可以不用加载直接执行就可以直接执行的。每一个module,driver的管理配置都可以放在 `etc/moduleprobe.d/` 下面。

`kernel modules <https://wiki.archlinux.org/index.php/kernel_modules>`_ 







