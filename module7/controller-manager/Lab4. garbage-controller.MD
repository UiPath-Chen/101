## GC操作
K8s的对象删除操作是通过控制器Garbage Controller执行的
GC操作是一种级联操作

## 级联GC
### deployment-controller创建rs, 查看rs
```bash
kubectl get rs
``````

```yml
metadata:
ownerReferences:            # owerReferences说明当前rs对象不是孤立存在的，有个父亲
- apiVersion: apps/v1
    blockOwnerDeletion: true
    controller: true
    kind: Deployment
    name: nginx-deployment
    uid: eb594e3b-d772-470f-b240-2db9eab254e4
``````

### 同理，rs-controller创建pod， 查看pod
```bash
kubectl get po
``````

```yml
metadata:
ownerReferences:
- apiVersion: apps/v1
    blockOwnerDeletion: true
    controller: true
    kind: ReplicaSet
    name: nginx-deployment-7cf7d6dbc8
    uid: 11db86d3-a196-4f88-a839-5d15dc5086a4
``````

## 总结
通过ownerReferences，将父对象和其子对象的声明周期紧绑定

当Garbage Controller去扫描所有对象，回去查看对象的ownerReferences，Garbage Controller会通过Graph Builder构建整个一个拓扑图，当发生了删除父对象事件`kubectl delete deployment <deployment name>`, GC监控发现删除事件，就去扫描拓扑图，找是否有对象的owner对象是本对象，为什么要关心这种子对象，因为，如果删除父对象，不管子对象，子对象就变成了孤儿对象，不合理，要删除，就要一起删除，所以，处理GC时候，触发了一种级联GC操作