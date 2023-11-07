### create workload
```Bash
kubectl apply -f serverpod.yaml
```
### create default networkpolicy
```Bash
kubectl apply -f networkpolicy.yaml
```
### check server pod
```Bash
kubectl get po -n calico-demo -owide
```
### start clientpod
```Bash
kubectl apply -f toolbox.yaml
kubectl apply -f toolbox.yaml -n calico-demo
```
### enter toolbox shell
```Bash
kubectl exec -it <podname> bash
```
### test connectivity
```Bash
# ping / curl
curl <calico-pod-ip>
ping <calico-pod-ip>
```
### create global allow policy
```Bash
kubectl create -f allow-icmp-incluster.yaml
```
### test connectivity from two toolbox pod
```Bash
curl <calico-pod-ip>
ping <calico-pod-ip>
```
### create networkpolicy to allow access
```Bash
kubectl create -f access-calico-demo.yaml
```
### test connectivity from two toolbox pod
```Bash
curl <calico-pod-ip>
ping <calico-pod-ip>
```