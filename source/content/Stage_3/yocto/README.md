yocto 
======

一整套成熟的从源码到os的定制系统，原来玩gentoo,现在是yocto. 
machine 是对硬件抽象，例如你的CPU/memory以及各种抽象
image 就是最终的操作系统。
https://layers.openembedded.org/layerindex/recipe/37578/  各种recipe 的查询方案，可以直接使用就行了。
并且yocto 有一整套自己 bitbake的编译管理流程来管理依赖。自动生成 package 以及image。
之下那就是各种layers,以及recipe.
bitbake core-image-sato



```
DISTRO_FEATURES:append = " virtualization"
CORE_IMAGE_EXTRA_INSTALL:append = " nvidia-container-toolkit"

# Install all upstream kernel modules. This improves out-of-the-box support
# for additional peripherals such as USB cameras and input devices, but
# should ultimately be replaced with the explicit list of individual kernel
# modules that are actually required.
CORE_IMAGE_EXTRA_INSTALL:append = " kernel-modules"

# Install the Holoscan Embedded SDK (and dependencies) by default
CORE_IMAGE_EXTRA_INSTALL:append = " \
    x11vnc \
    python3-pip \
    holoscan-sdk \
    holohub-apps \
"
```
对于user来说,一般只需要改build/conf, 
