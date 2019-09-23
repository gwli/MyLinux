********
云
********

是快速达到3A，平台化并且也是灵活性与scale up最佳结合方式。

* 看有什么成熟的新的量产的API可以用调用。
* 从开发测试部署到上线的流程自动化与版本化。


K8S
=====

docker 是虚拟化的基础，而K8S形成一整套的框架，并且解决了从1到N的scale up, 并且把load blance,以及backup 都个都规模化。

node 对应硬件计算资源，在其之上可以 docker各个进程，每一个node的资源的多少可以对应跑多少进程，可以由 k8s来时进行计算。
pod 这个逻辑计算单元，可以包含多个node等具体的计算单元。
deployment,是pod的具体部署的instance.
service 的是逻辑应用接接口，上层对应api-server, 来实现load-blance.
并且在k8s上之内部实现一个虚拟网络，这样的虚拟网络内部实现整体的pod共享一个IP。这样实现热备。通过地址查询这一层转接从而实现各种功能。
同时个网络还得要有独立DNS，相当于硬件那一套框架虚拟化。
并且自己一整套的package 管理 helm. 
并且oracle已经开始了下一代云的框架的设计，K8S直接在裸机上，或者硬件上。实现automonous linux/database的功能。

并且在之上形成workflow 的CI/CD功能。
https://kubernetes.feisky.xyz/


Azure webinars
==================
