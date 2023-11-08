### create and deploy func
```Bash
cd /tmp
func create -l go demo
cd demo
func build
func deploy --registry docker.io/mfanjie --build=false
```
### test the function
```Bash
k apply -f /Users/jesse/go/src/github.com/cncamp/101/module4/centos-readiness.yaml
kubectl exec -it <centospod> bash
curl http://demo.default.svc.cluster.local
```

