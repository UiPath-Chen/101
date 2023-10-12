### iptables
```bash
iptables -nL
iptables -nL -t nat
iptables-save -t nat > nat.rules
```


------
`kubectl get po -owide`
NAME                               READY   STATUS    RESTARTS   AGE     IP              NODE              NOMINATED NODE   READINESS GATES
nginx-deployment-99dcc9d8d-jjhqc   1/1     Running   0          7m55s   192.168.0.234   wsl-ubuntu20.04   <none>           <none>
nginx-deployment-99dcc9d8d-kgsx7   1/1     Running   0          7m55s   192.168.0.250   wsl-ubuntu20.04   <none>           <none>
nginx-deployment-99dcc9d8d-n6w9z   1/1     Running   0          14m     192.168.0.253   wsl-ubuntu20.04   <none>           <none>

---------------
`kubectl get svc`
虚IP - 没有真实设备的IP，无法ping通，只能curl，接收一个数据包
nginx-basic   ClusterIP   10.96.223.96   <none>        80/TCP    14m   app=nginx

---------
`kubectl get ep`
nginx-basic   192.168.0.234:80,192.168.0.250:80,192.168.0.253:80   14m

--------------------
`iptables-save -t nat > nat.iptables`

把KUBE-SERVICE链加入默认的PREROUTING和OUTPUT链
-A PREROUTING -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A OUTPUT -m comment --comment "kubernetes service portals" -j KUBE-SERVICES


-A KUBE-SERVICES -d 10.96.223.96/32 -p tcp -m comment --comment "default/nginx-basic:http cluster IP" -m tcp --dport 80 -j KUBE-SVC-WWRFY3PZ7W3FGMQW

-A KUBE-SVC-WWRFY3PZ7W3FGMQW -m comment --comment "default/nginx-basic:http" -m statistic --mode random --probability 0.33333333349 -j KUBE-SEP-XOWOQU3MY3K64EQH
-A KUBE-SVC-WWRFY3PZ7W3FGMQW -m comment --comment "default/nginx-basic:http" -m statistic --mode random --probability 0.50000000000 -j KUBE-SEP-QBIF2YXJYZUGPYDY
-A KUBE-SVC-WWRFY3PZ7W3FGMQW -m comment --comment "default/nginx-basic:http" -j KUBE-SEP-TECZZF6LGKDFTKGL

-A KUBE-SEP-XOWOQU3MY3K64EQH -p tcp -m comment --comment "default/nginx-basic:http" -m tcp -j DNAT --to-destination 192.168.0.234:80
-A KUBE-SEP-QBIF2YXJYZUGPYDY -p tcp -m comment --comment "default/nginx-basic:http" -m tcp -j DNAT --to-destination 192.168.0.250:80
-A KUBE-SEP-TECZZF6LGKDFTKGL -p tcp -m comment --comment "default/nginx-basic:http" -m tcp -j DNAT --to-destination 192.168.0.253:80
