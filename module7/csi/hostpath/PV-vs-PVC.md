### PV、PVC、storageClass的关系

- PV provisioning
  - Static
    storageClassName=manual
  - Dynamic

pv与pvc的关系之前介绍过，pvc好比是接口，它定义了开发需要的存储大小及类型，开发人员无需关注具体的存储细节，而实际的存储由专门的运维人员编写pv来创建。但是，在大规模的生产环境里，这其实是一个非常麻烦的工作。这是因为，一个大规模的 Kubernetes 集群里很可能有成千上万个 PVC，这就意味着运维人员必须得事先创建出成千上万个 PV。更麻烦的是，随着新的 PVC 不断被提交，运维人员就不得不继续添加新的、能满足条件的 PV，否则新的 Pod 就会因为 PVC 绑定不到 PV 而失败。

所以，Kubernetes 为我们提供了一套可以自动创建 PV 的机制，即：Dynamic Provisioning。相比之下，前面人工管理 PV 的方式就叫作 Static Provisioning。

Dynamic Provisioning 机制工作的核心，在于一个名叫 StorageClass 的 API 对象。而 StorageClass 对象的作用，其实就是创建 PV 的模板。具体地说，StorageClass 对象会定义如下两个部分内容：第一，PV 的属性。比如，存储类型、Volume 的大小等等；第二，创建这种 PV 需要用到的存储插件。比如，Ceph 等等。举例如下：

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: nfs-client-storageclass
provisioner: rookieops/nfs

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: test-nfs-pvc2
  annotations:
    volume.beta.kubernetes.io/storage-class: "nfs-client-storageclass"
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Mi
``````



可以看到，我们在这个 PVC 里添加了一个叫作 storageClassName 的字段，用于指定该 PVC 所要使用的 StorageClass 的名字是：nfs-client-storageclass。随后，Kubernetes就会自动创建StorageClass字段值相同的PV出来，也是 nfs-client-storageclass。这是因为，Kubernetes 只会将 StorageClass 相同的 PVC 和 PV 绑定起来。

当然，即使不创建storageclass也没有关系，比如前面我用到的storageClassName=manual。而我的集群里，实际上并没有一个名叫 manual 的 StorageClass 对象。这完全没有问题，这个时候 Kubernetes 进行的是 Static Provisioning，但在做绑定决策的时候，它依然会考虑 PV 和 PVC 的 StorageClass 定义。整个流程简化如下：

![img](image.png)

### PV与PVC体系的强大
PV与PVC的体系强大在于解耦和灵活，它可以根据功能将职责划分，这么做我们可以使用除了Kubernetes 内置的 20 种持久化数据卷实现，还可以定制开发属于自己的存储，在使用自己的存储时，由于PV与PVC的体系的存在，这些改变对Kubernetes 已有用户的影响，几乎可以忽略不计。作为用户，你的 Pod 的 YAML 和 PVC 的 YAML，并没有任何特殊的改变，这个特性所有的实现只会影响到 PV 的处理，也就是由运维人员负责的那部分工作。比如说Kubernetesv1.11中新特性之一就是支持本地存储，比如我们可以使用一块ssd来作为pv，而这个本地存储的实现也是基于PV与PVC体系，其中关键技术就是在StorageClass的字段中新增字段WaitForFirstConsumer：

这代表延迟绑定，即告诉 Kubernetes 里的 Volume 控制循环（“红娘”）：虽然你已经发现这个 StorageClass 关联的 PVC 与 PV 可以绑定在一起，但请不要现在就执行绑定操作（即：设置 PVC 的 VolumeName 字段）。而要等到第一个声明使用该 PVC 的 Pod 出现在调度器之后，调度器再综合考虑所有的调度规则，当然也包括每个 PV 所在的节点位置，来统一决定，这个 Pod 声明的 PVC，到底应该跟哪个 PV 进行绑定。

总结一下，Kubernetes 很多看起来比较“繁琐”的设计（比如“声明式 API”，以及我今天讲解的“PV、PVC 体系”）的主要目的，都是希望为开发者提供更多的“可扩展性”，给使用者带来更多的“稳定性”和“安全感”。这两个能力的高低，是衡量开源基础设施项目水平的重要标准。






### PV是如何做持久化
所谓持久化，指的是挂载在宿主机的目录，具备持久性，这种目录不能是类似于hostPath 和 emptyDir 类型的 Volume，因为它们有可能被 kubelet 清理掉，也能被“迁移”到其他节点上。所以，大多数情况下，持久化 Volume 的实现，往往依赖于一个远程存储服务，比如：远程文件存储（NFS、GlusterFS）、远程块存储（公有云提供的远程磁盘）等等。

因此，Kubernetes 需要做的工作，就是使用这些存储服务，来为容器准备一个持久化的宿主机目录，以供将来进行绑定挂载时使用，这部分工作我们可以用“两阶段处理”来概括。

* 第一阶段：attach
当一个 Pod 调度到一个节点上之后，kubelet(controller-manager) 就要负责为这个 Pod 创建它的 Volume 目录。默认情况下，kubelet 为 Volume 创建的目录是如下的一个宿主机上的路径：

`/var/lib/kubelet/pods/<Pod Id>/volumes/kubernets.io~<Volume type>/<Volume name>`

接下来，kubelet 要做的操作就取决于你的 Volume 类型了。如果你的 Volume 类型是远程块存储，比如 Google Cloud 的 Persistent Disk（GCE 提供的远程磁盘服务），那么 kubelet 就需要先调用 Goolge Cloud 的 API，将它所提供的 Persistent Disk 挂载到 Pod 所在的宿主机上。



* 第二阶段：mount
kubelet 需要作为 client，将远端 NFS 服务器的目录（比如：“/”目录），挂载到 Volume 的宿主机目录上，即相当于执行如下所示的命令：

```bash
mount -t nfs <NFS 服务器地址 >:/ /var/lib/kubelet/pods/<Pod 的 ID>/volumes/kubernetes.io~<Volume 类型 >/<Volume 名字 >
``````

通过这个挂载操作，Volume的宿主机目录就成为了一个远程NFS目录的挂载点，后面你在这个目录里写入的所有文件，都会被保存在远程NFS服务器上。所以，我们也就完成了对这个Volume宿主机目录的“持久化”。

上述关于 PV的“两阶段处理”流程，是靠独立于 kubelet 主控制循环（Kubelet Sync Loop）之外的两个控制循环来实现的。其中，“第一阶段”的 Attach（以及 Dettach）操作，是由 Volume Controller 负责维护的，这个控制循环的名字叫作：AttachDetachController。而它的作用，就是不断地检查每一个 Pod 对应的 PV，和这个 Pod 所在宿主机之间挂载情况。从而决定，是否需要对这个 PV 进行 Attach（或者 Dettach）操作。Volume Controller 自然是 kube-controller-manager 的一部分。所以，AttachDetachController 也一定是运行在 Master 节点上的；“第二阶段”的 Mount（以及 Unmount）操作，必须发生在 Pod 对应的宿主机上，所以它必须是 kubelet 组件的一部分。这个控制循环的名字，叫作：VolumeManagerReconciler，它运行起来之后，是一个独立于 kubelet 主循环的 Goroutine。

通过这样将 Volume 的处理同 kubelet 的主循环解耦，Kubernetes 就避免了这些耗时的远程挂载操作拖慢 kubelet 的主控制循环，进而导致 Pod 的创建效率大幅下降的问题。实际上，kubelet 的一个主要设计原则，就是它的主控制循环绝对不可以被 block。















> 参考
https://zhuanlan.zhihu.com/p/536851171
https://www.zhihu.com/people/whisper-of-the-Koo