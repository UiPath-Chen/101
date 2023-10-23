### 查看CRD
```bash
kubectl get crd

kubectl get crd ippools.crd.projectcalico.org -o=yaml > CRD/crd-ippools.crd.projectcalico.org.yaml
```

### 查看根据CRD定义的具体资源
```bash
kubectl get ippools.crd.projectcalico.org -o=yaml>CRD/ippools.crd.projectcalico.org.yaml
```