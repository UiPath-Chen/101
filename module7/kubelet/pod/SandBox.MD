### kubelet 启动Pod，一个Pod包括多个容器，是启动多个容器，而不是一个

```bash
kubelet get po -o=name
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-7cf7d6dbc8-8wpgn   1/1     Running   0          3m20s

# 虽然看到READY 1/1, 显示只有一个容器

docker ps |grep nginx-deployment-7cf7d6dbc8-8wpgn
0370270c846c   61395b4c586d                                        "/docker-entrypoint.…"   2 minutes ago    Up 2 minutes              k8s_nginx_nginx-deployment-7cf7d6dbc8-8wpgn_default_294a049a-8197-4e3d-92a5-e095fb0cfab1_0
48e575412208   registry.aliyuncs.com/google_containers/pause:3.5   "/pause"                 2 minutes ago    Up 2 minutes              k8s_POD_nginx-deployment-7cf7d6dbc8-8wpgn_default_294a049a-8197-4e3d-92a5-e095fb0cfab1_0

# 容器1：nginx
# 容器2：k8s.gcr.io/pause:3.5, 此容器实例叫SandboxContainer
``````
### SandboxContainer 容器环境配置
容器技术
namespace
比如，容器进程放到某个网络ns，可以使得容器具有独立的网络配置
但是，如果把容器直接放入网络ns的问题：
1. 容器进程是否可靠，出错，OOM，空指针
2. 保留环境:当容器报错，退出，网络NS也清理了，容器进程跟网络NS的绑定关系消失了，如果重新创建容器，是否需要重新配置网络NS，重新配置网络，是系统级的命令，效率低；对OS是一种压力；
3. 所以，想到，是否可以有一种基于OS的底座，让容器退出后，这些网络NS不消失，等待给新创建的容器使用，整个底座就是SandoxContainer；
4. 预先配置环境：此外，很多应用启动需要环境就绪，比如数据库、初始化系统；话句话说，在当前容器进程启动之前，需要网络就绪，缓存就绪，就是网络等需要在容器进程创建之前就绪；但是网络加载很慢，是否可以先加载网络，后启动容器，这时就需要一个额外容器进程
5. 这个容器进程叫pause, 这个pause就是sleep infinity(一个永远不会退出，不消耗资源，稳定的进行)；网络就可以挂接在这个进程上；当有应用容器启动时候，只要共享pause容器进程的网络NS就可以了；在应用进程出错后，虽然容器别down掉，但是由于网络NS中还存在pause容器进程，所以网络NS没有清理，所以可以一直存在到永久；
