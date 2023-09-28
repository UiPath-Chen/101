### 1. Get
```bash
kubectl get pods --show-labels
``````
### 2. Watch
```bash
kubectl get pods --show-labels -w
``````

### 3. label a pod
```bash
kubectl label pods <podName> a=b
``````