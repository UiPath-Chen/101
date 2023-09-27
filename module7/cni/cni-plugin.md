### /etc/cni/net.d/
* cri Pod network config -> cni: containerd as runtime
* kubelet Pod network config -> cni: docker as runtime

做什么样的网络工作，调用什么样的命令
不同的type就是不同的命令，对应不同的可执行文件

```bash
cd /etc/cni/net.d/
``````
-rw-r--r-- 1 root root  804 Sep 27 01:17 10-calico.conflist
-rw------- 1 root root 2717 Sep 27 01:18 calico-kubeconfig

### 10-calico.conflist
```json
{
  "name": "k8s-pod-network",
  "cniVersion": "0.3.1",            # version
  "plugins": [
    # plugin0
    # 搭建网络栈
    # calico - 主插件（给容器配置网络）；calic-ipam - 辅助插件（分配IP）
    {
      "type": "calico",
      "datastore_type": "kubernetes",
      "mtu": 0,
      "nodename_file_optional": false,
      "log_level": "Info",
      "log_file_path": "/var/log/calico/cni/cni.log",
      "ipam": { "type": "calico-ipam", "assign_ipv4" : "true", "assign_ipv6" : "false"},
      "container_settings": {
          "allow_ip_forwarding": false
      },
      "policy": {
          "type": "k8s"
      },
      "kubernetes": { # calico怎么跟apiserver通信
          "k8s_api_root":"https://10.96.0.1:443",
          "kubeconfig": "/etc/cni/net.d/calico-kubeconfig"
      }
    },
    # plugin1
    # 限流
    # bandwidth belong to Meta plugin - 利用 Linex Traffic Control 限流
    {
      "type": "bandwidth",
      "capabilities": {"bandwidth": true}
    },
    # plugin2
    # 端口映射
    # portmap - 设置主机端口和容器端口映射
    {"type": "portmap", "snat": true, "capabilities": {"portMappings": true}}
  ]
}
``````

### /opt/cni/bin/
cni executable file path

```bash
cd /opt/cni/bin/
``````
`bandwidth`  `calico`       dhcp   firewall  host-device  install  loopback  portmap  sbr     tuning  vrf
bridge    `calico-ipam`   dummy  flannel   host-local   ipvlan   macvlan   ptp      static  vlan

### check network of container
```bash
crictl ps |grep nginx
``````
**28d59c71882d2**       61395b4c586da       15 hours ago        Running             nginx                       1                   6bf5918459e92       nginx-deployment-7cf7d6dbc8-h9vpk

```bash
crictl inspect 28d59c71882d2 |grep pid
``````
 "pid": 8955,
            "pid": 1
            "type": "pid"

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

> lo interface created by standar CNI plugin to call executable file **loopback**


