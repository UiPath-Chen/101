
### 滚动升级

> deployment的namespace和name不变
> 修改deployment的镜像
> image: nginx 变成 image: nginx:latest

```bash
kubectl edit deploy
``````

### 部署deployment的配置
```bash
kubectl get deploy <deployment name> -o=yaml
``````
```yml
spec:
  replicas: 1 # relicas + template: 创建副本集所需
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        imagePullPolicy: IfNotPresent
      strategy:                 # 策略
        type: RollingUpdate     # 滚动升级策略：批次升级；只要保证业务高可用，就可以在白天升级，不用夜晚升级
        rollingUpdate:
          maxUnavailable: 25%   # 如果25%的Pod不Ready，部署暂停，那么就不升级
          maxSurge: 25%         # Pod启动时候，先启动25%新的Pods
      revisionHistoryLimit: 10
``````

### 查看事件
```bash
kubectl get deploy -o=yaml
``````
> Events:
>  Type    Reason             Age    From                   Message
>  ----    ------             ----   ----                   -------
>  Normal  ScalingReplicaSet  41m    deployment-controller  Scaled up replica set nginx-deployment-7cf7d6dbc8 to 1
  Normal  ScalingReplicaSet  8m21s  deployment-controller  Scaled up replica set nginx-deployment-bb957bbb5 to 1
  Normal  ScalingReplicaSet  8m7s   deployment-controller  Scaled down replica set nginx-deployment-7cf7d6dbc8 to 0

从上可以看出，滚动升级的过程：
1. 当修改了镜像，而不改变对象的key(namespace+name),那么就发生了滚动升级；
2. 由于deployment的template改变了，所以需要创建新的replicaset，从上面的事件结果发现，老的nginx-deployment-7cf7d6dbc8被scaled down，而新的nginx-deployment-bb957bbb5被scaled up；这里面额名称后面是一个hash值，是对deployment的template计算的hash值；
3. 所以，当deployment-controller发现对象的配置template的hash值发生了变化，对deployment-controller来说，就是客户想重新去做一次部署，即使nginx和nginx:latest本质都是同一个镜像，但是字符串发生了变化；
4. 先创建新的rs,在关闭旧的rs;
5. 注意：就的rs依然存在；


### 查看rs中的template的hash值

```bash
kubectl get rs <rs name> -o=yaml
``````

```yml
metadata:
  labels:
    # rs会记录下创建pod的template的hash值
    pod-template-hash: 7cf7d6dbc8
  # 发现rs名称的后缀就是pod的template的HASH值，前缀是deployment的名字
  name: nginx-deployment-7cf7d6dbc8
``````
只要pod的template不变，hash值就不变，那么，replicas的名称也不会变；
所以如果只是修改deployment的replicas的副本数，name其实就是仅仅修改整个deployment名称对应生成的replicaset的的副本数；但不会产生新的replicaset对象

同一个rs创建pods的命名规律

```bash
kubectl get po <pod name> -o=yaml
``````

```yml
metadata:
generateName: nginx-deployment-bb957bbb5- # 所有pod的名字以整个为前缀
name: nginx-deployment-bb957bbb5-ltk52 # pod名字在generateName基础上追加一个随机字符串，可以保证pod名字唯一
``````