### 创建Deployment
```bash
kubectl create -f nginx-without-resource.yaml
``````

### 查看apiserver创建的更详细Deployment
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

### 查看deployment-controller 创建的replicaSet
```bash
kubectl get rs <replicas name> -o=yaml
``````

```yml
# 发现比deployment简单多了
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
      pod-template-hash: 7cf7d6dbc8
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: nginx
        pod-template-hash: 7cf7d6dbc8
    spec:
      containers:
        - name: nginx
          image: nginx
          resources: {}
          terminationMessagePath: /dev/termination-log
          terminationMessagePolicy: File
          imagePullPolicy: IfNotPresent
      restartPolicy: Always
      terminationGracePeriodSeconds: 30
      dnsPolicy: ClusterFirst
      securityContext: {}
      schedulerName: default-scheduler
``````

### 查看replicaset-controller创建的pod，且经过default-scheduller绑定节点后的Pod
```bash
kubectl get po <pod name> -o=wide
``````
>NAME                                READY   STATUS    RESTARTS   AGE   IP              NODE              NOMINATED NODE   READINESS GATES
nginx-deployment-7cf7d6dbc8-s9ttb   1/1     Running   0          23m   192.168.0.242   wsl-ubuntu20.04   <none>           <none>


### kubelet 监听跟本节点绑定的Pod
> 比如kubelet通过监听所有节点，发现有Pod绑定了本节点，通过上一个命令;
> kubelet调用
> - CRI: 启动容器
> - CNI: 配置网络
> - CSI: 配置存储、Volume

