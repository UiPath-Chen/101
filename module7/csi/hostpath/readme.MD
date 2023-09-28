### Create a host folder

```sh
sudo mkdir /mnt/data
```

### Create a file in the folder

```sh
sudo sh -c "echo 'Hello from Kubernetes storage' > /mnt/data/index.html"
```

### Check the file

```sh
cat /mnt/data/index.html
```

### Create a pv
将/mnt/data/映射到k8s中，声明为一个PV
真实Volume在K8S中的映射

```sh
kubectl apply -f pv.yaml
kubectl get pv
```

### Create a pvc


```sh
kubectl apply -f pvc.yaml
kubectl get pvc
```



### Create a pod
创建容器时候，使用指定的PVC
PVC声明了，向谁/模板（storageClassName）申请,申请多少；
先去检查storageClassName所指定的storageClass, 向其申请100Mi；
正好找到所指定的storageClass，存在一个PV，大小为100Mi；
最后，PVC跟其产生绑定关系；

PVC只会跟storageClassName相同的PV产生绑定关系

```sh
kubectl apply -f pod.yaml
```

### 访问
```bash
kubectl get po -o=wide
curl IP
``````