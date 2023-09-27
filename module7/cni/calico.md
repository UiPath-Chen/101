### learn calico
```bash
kubectl get ns
NAME               STATUS   AGE
calico-apiserver   Active   6d
calico-system      Active   6d1h

kubeclt get po -n calico-system
NAME                                       READY   STATUS    RESTARTS        AGE
calico-kube-controllers-5654f7cb84-44wvx   1/1     Running   10 (5h4m ago)   2d13h
calico-node-qlj4f                          1/1     Running   9               6d
calico-typha-fb98d6f48-x26kp               1/1     Running   17 (17h ago)    6d
csi-node-driver-p958q                      2/2     Running   13              2d13h

kubectl get ds -n calico-system
NAME              DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
calico-node       1         1         1       1            1           kubernetes.io/os=linux   6d1h
csi-node-driver   1         1         1       1            1           kubernetes.io/os=linux   6d1h

kubectl get ds -n calico-system calico-node -o=yaml
``````

```yml
apiVersion: apps/v1
kind: DaemonSet
metadata:
spec:
  template:
    metadata:
    spec:
      containers:
      - env:
        readinessProbe:
          exec:
            command:    # 检测是否启动了bird、felix
            - /bin/calico-node
            - -bird-ready
            - -felix-ready
          failureThreshold: 3
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 5
      dnsPolicy: ClusterFirst
      hostNetwork: true
      initContainers:
      - image: docker.io/calico/pod2daemon-flexvol:v3.24.0
        imagePullPolicy: IfNotPresent
        name: flexvol-driver
        resources: {}
        securityContext:
          privileged: true
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /host/driver
          name: flexvol-driver-host
      - command:    # initContainers安装可执行的网络管理文件，一些命令
        - /opt/cni/bin/install
        env:
        - name: CNI_CONF_NAME
          value: 10-calico.conflist
        - name: SLEEP
          value: "false"
        - name: CNI_NET_DIR
          value: /etc/cni/net.d
        - name: CNI_NETWORK_CONFIG
          valueFrom:
            configMapKeyRef:
              key: config
              name: cni-config
        - name: KUBERNETES_SERVICE_HOST
          value: 10.96.0.1
        - name: KUBERNETES_SERVICE_PORT
          value: "443"
        image: docker.io/calico/cni:v3.24.0
        imagePullPolicy: IfNotPresent
        name: install-cni
        resources: {}
        securityContext:
          privileged: true
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:    # 挂载完成，将一些命令，推送到主机目录
        - mountPath: /host/opt/cni/bin
          name: cni-bin-dir
        - mountPath: /host/etc/cni/net.d
          name: cni-net-dir
      volumes:
      - hostPath:
          path: /opt/cni/bin
          type: ""
        name: cni-bin-dir
      - hostPath:
          path: /etc/cni/net.d
          type: ""
        name: cni-net-dir
      - hostPath:
          path: /var/log/calico/cni
          type: ""
        name: cni-log-dir
      - hostPath:
          path: /usr/libexec/kubernetes/kubelet-plugins/volume/exec/nodeagent~uds
          type: DirectoryOrCreate
        name: flexvol-driver-host
``````

### 配置集群的IP段
CRD

```bash
kubectl get crd |grep calico |grep ippools
``````
ippools.crd.projectcalico.org                         2023-09-21T09:11:01Z

```bash
kubectl get ippools.crd.projectcalico.org -o=yaml

# 或

kubectl get ipppool
kubectl get ippool default-ipv4-ippool -o=yaml
``````
```yml
apiVersion: projectcalico.org/v3
kind: IPPool
metadata:
  creationTimestamp: "2023-09-21T09:19:41Z"
  name: default-ipv4-ippool
  resourceVersion: "1991"
  uid: 7cd85571-dce2-48b4-a543-465164b3d881
spec:
  allowedUses:
  - Workload
  - Tunnel
  blockSize: 26        # 划分的子网的子网掩码, 按此标准，每个子网64个主机，共1024个子网
  cidr: 192.168.0.0/16 # 给集群配置总网段
  ipipMode: Never
  natOutgoing: true
  nodeSelector: all()
  vxlanMode: CrossSubnet
``````

### 给每个主机预分配IP
```bash
kubectl get ipamblock
``````
NAME               AGE
192-168-0-192-26   6d1h

```bash
kubectl get ipamblock -o=yaml
``````

```yml
apiVersion: v1
items:
- apiVersion: crd.projectcalico.org/v1
  kind: IPAMBlock
  metadata:
    name: 192-168-0-192-26
  spec:
    affinity: host:wsl-ubuntu20.04    # 说明当预设子网跟哪个主机有亲和关系；也就说要给这个主机分配这个子网的IP
    allocations:
    attributes:
    - handle_id: k8s-pod-network.6bf5918459e920bb5adae8e14a8424dd69dba59383927e68f49c77c49a0d531d
      secondary: # 这个IP被分配给了哪个节点的、哪个ns、哪个pod
        namespace: default
        node: wsl-ubuntu20.04
        pod: nginx-deployment-7cf7d6dbc8-h9vpk
        timestamp: 2023-09-26 17:11:53.923041651 +0000 UTC
    - handle_id: k8s-pod-network.96cf4584a0f7ec99f317ee676c1030b1a6e06d54e859d0f573af392bd393b518
      secondary:
        namespace: calico-apiserver
        node: wsl-ubuntu20.04
        pod: calico-apiserver-8846fd76c-tthc2
        timestamp: 2023-09-26 17:11:53.939408628 +0000 UTC
    cidr: 192.168.0.192/26
    deleted: false
    strictAffinity: false
    unallocated:
    - 57
    - 2
kind: List
metadata:
  resourceVersion: ""
  selfLink: ""
``````

### 记录IP详细分配细节
```bash
kubectl get ipamhandle
kubectl get ipamhandle vxlan-tunnel-addr-wsl-ubuntu20.04 -o=yaml
``````

```yml
apiVersion: crd.projectcalico.org/v1
kind: IPAMHandle
metadata:
  annotations:
    projectcalico.org/metadata: '{"creationTimestamp":null}'
  creationTimestamp: "2023-09-21T09:19:49Z"
  generation: 1
  name: vxlan-tunnel-addr-wsl-ubuntu20.04
  resourceVersion: "2027"
  uid: dcde2d0f-6281-4826-88fa-ac7b33bcda34
spec:
  block:
    192.168.0.192/26: 1 # 从此子网中划分出去一个IP
  deleted: false
  handleID: vxlan-tunnel-addr-wsl-ubuntu20.04
``````

### 查看一个Pod的网络配置

```bash
kubectl get po -o=wide
``````
NAME                                READY   STATUS    RESTARTS   AGE   IP              NODE              NOMINATED NODE   READINESS GATES
nginx-deployment-7cf7d6dbc8-h9vpk   1/1     Running   1          20h   192.168.0.234   wsl-ubuntu20.04   <none>           <none>

```bash
nsenter -t 8955 -n ip a
``````
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
3: eth0@if9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default
    link/ether 52:66:b8:f3:d0:09 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.0.234/32 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::5066:b8ff:fef3:d009/64 scope link
       valid_lft forever preferred_lft forever


### 所有被划分的子网后，所有Pod的路由信息
```bash
nsenter -t 8955 -n ip r
``````
default via 169.254.1.1 dev eth0
169.254.1.1 dev eth0 scope link

```bash
apt install arping -y
nsenter -t 8955 -n arping 169.254.1.1
``````
42 bytes from ee:ee:ee:ee:ee:ee (169.254.1.1): index=0 time=15.100 usec

从上我们看到，默认路由到的网卡MAC为ee:ee:ee:ee:ee:ee

```bash
ifconfig

# or

ip link show
``````
发现所有以cali开头的网卡的MAC地址都是ee:ee:ee:ee:ee:ee
容器网络的原理：通过veth pair, 容器里面的网卡eth0@if9，跟容器的外的网卡cali开头的网卡构成veth-pair.
从上可知，容器里面的任何需要进行跨主机的路由，都会转发到cali开头的网卡设备，再被转发出去，如果是VXLAN模式，此时，需要被VTEP封装一层后，转发出去；

### 查看集群的主机节点的路由器是如何定义的
```bash
kubectl get po -n calico-system
``````

```yml
        readinessProbe:
          exec:
            command:
            - /bin/calico-node
            - -bird-ready            # 查看bird是怎么配置路由协议
            - -felix-ready
          failureThreshold: 3
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 5
``````

```bash
ps -ef|grep bird
bird -R -s /var/run/calico/bird.ctl -d -c /etc/calico/confd/config/bird.cfg

kubectl get po -n calico-system
k exec -it calico-node-qlj4f -n calico-system cat /etc/calico/confd/config/bird.cfg
``````
```
function apply_communities ()
{
}

# Generated by confd
include "bird_aggr.cfg";
include "bird_ipam.cfg";

router id 172.18.27.134; # bird定义了一台路由器，有自己的路由ID；它可以跟其他主机节点上的路由信息彼此交换

# Configure synchronization between routing tables and kernel.
protocol kernel {
  learn;             # Learn all alien routes from the kernel
  persist;           # Don't remove routes on bird shutdown
  scan time 2;       # Scan kernel routing table every 2 seconds
  import all;
  export filter calico_kernel_programming; # Default is export none
  graceful restart;  # Turn on graceful restart to reduce potential flaps in
                     # routes when reloading BIRD configuration.  With a full
                     # automatic mesh, there is no way to prevent BGP from
                     # flapping since multiple nodes update their BGP
                     # configuration at the same time, GR is not guaranteed to
                     # work correctly in this scenario.
  merge paths on;    # Allow export multipath routes (ECMP)
}

# Watch interface up/down events.
protocol device {
  debug { states };
  scan time 2;    # Scan interfaces every 2 seconds
}

protocol direct {
  debug { states };
  interface -"cali*", -"kube-ipvs*", "*"; # Exclude cali* and kube-ipvs* but
                                          # include everything else.  In
                                          # IPVS-mode, kube-proxy creates a
                                          # kube-ipvs0 interface. We exclude
                                          # kube-ipvs0 because this interface
                                          # gets an address for every in use
                                          # cluster IP. We use static routes
                                          # for when we legitimately want to
                                          # export cluster IPs.
}


# Template for all BGP clients # 默认使用BGP协议 - 边界网关协议
template bgp bgp_template {
  debug { states };
  description "Connection to BGP peer";
  local as 64512;
  multihop;
  gateway recursive; # This should be the default, but just in case.
  import all;        # Import all routes, since we don't know what the upstream
                     # topology is and therefore have to trust the ToR/RR.
  export filter calico_export_to_bgp_peers;  # Only want to export routes for workloads.
  add paths on;
  graceful restart;  # See comment in kernel section about graceful restart.
  connect delay time 2;
  connect retry time 5;
  error wait time 5,30;
}

# ------------- Node-to-node mesh -------------





# For peer /host/wsl-ubuntu20.04/ip_addr_v4
# Skipping ourselves (172.18.27.134)



# ------------- Global peers -------------
# No global peers configured.


# ------------- Node-specific peers -------------

# No node-specific peers configured.
``````

通过ipam给本机节点分配了子网
```bash
k get ipamblock
``````


