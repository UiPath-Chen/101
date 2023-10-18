https://github.com/kubernetes-sigs/kubespray
https://dev.to/admantium/kubernetes-installation-tutorial-kubespray-46ek

## Prepare k8s vm
1. 方案一
使用terraform生成2个vm
[two VMs Prepare](./two-nodes/two-nodes.tf)

```bash
password = "password123"
public_ip_0 = "101.33.116.194"
public_ip_1 = "43.129.192.121"
```

```bash
terraform init
terraform plan
terraform apply --auto-approve
terraform state list
terraform destroy --auto-approve
```

2. 方案二
### Install 2 ubuntu20.04 vm

### Set network adapter

### Add a host only adaptor and add the following settings

node1

```sh
cat /etc/netplan/00-installer-config.yaml
network:
  ethernets:
    enp0s3:
      dhcp4: true
    enp0s8:
      dhcp4: no
      addresses:
        - 43.135.112.53/24
  version: 2
```

```sh
netplan apply
```

node2

```sh
cat /etc/netplan/00-installer-config.yaml

network:
  ethernets:
    enp0s3:
      dhcp4: true
    enp0s8:
      dhcp4: no
      addresses:
        - 150.109.159.92/24
  version: 2
```

```sh
netplan apply
```

## Start k8s by kubespary

### Download kubespary docker image

```sh
docker pull quay.io/kubespray/kubespray:v2.23.0
```

### Clone kubespary source code

```sh
cd /tmp/
git clone https://github.com/kubernetes-sigs/kubespray.git
```

### Start kubespray

### Prepare no password login for server
```bash
ssh-keygen -t rsa
ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@101.33.116.194
ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@43.129.192.121

ssh ubuntu@101.33.116.194
ssh ubuntu@43.129.192.121
```

### start & go into container
```sh
cd kubespray/


docker run \
--net host \
--rm \
-it \
--name kubespray \
--mount type=bind,source="$(pwd)"/inventory/sample,dst=/inventory \
--mount type=bind,source="$HOME"/.ssh/id_rsa,dst=/root/.ssh/id_rsa \
quay.io/kubespray/kubespray:v2.23.0 bash
```

### Build ansible inventory

```bash
Usage: inventory.py ip1 [ip2 ...]
Examples: inventory.py 10.10.1.3 10.10.1.4 10.10.1.5

Available commands:
help - Display this message
print_cfg - Write inventory file to stdout
print_ips - Write a space-delimited list of IPs from "all" group
print_hostnames - Write a space-delimited list of Hostnames from "all" group

Advanced usage:
Add another host after initial creation: inventory.py 10.10.1.5
Add range of hosts: inventory.py 10.10.1.3-10.10.1.5
Add hosts with different ip and access ip: inventory.py 10.0.0.1,192.168.10.1 10.0.0.2,192.168.10.2 10.0.0.3,192.168.10.3
Add hosts with a specific hostname, ip, and optional access ip: first,10.0.0.1,192.168.10.1 second,10.0.0.2 last,10.0.0.3
Delete a host: inventory.py -10.10.1.3
Delete a host by id: inventory.py -node1

Configurable env vars:
DEBUG                   Enable debug printing. Default: True
CONFIG_FILE             File to write config to Default: ./inventory/sample/hosts.yaml
HOST_PREFIX             Host prefix for generated hosts. Default: node
KUBE_CONTROL_HOSTS      Set the number of kube-control-planes. Default: 2
SCALE_THRESHOLD         Separate ETCD role if # of nodes >= 50
MASSIVE_SCALE_THRESHOLD Separate K8s control-plane and ETCD if # of nodes >= 200
```

```bash
cp -rfp inventory/sample inventory/mycluster


# 格式1：(ip1 ip2)
# 格式2：(ip1,access-ip1 ip2,access-ip2)
# 格式3：(name1,ip1,access-ip1 name2,ip2,access-ip2)
declare -a IPS=(172.19.0.5,101.33.116.194 172.19.0.12,43.129.192.121)


CONFIG_FILE=inventory/mycluster/hosts.yml \
python3 contrib/inventory_builder/inventory.py ${IPS[@]}


cat inventory/mycluster/hosts.yml
```

### Change gcr.io to mirror
若可以正常访问外网，可以不修改
```sh
cat  > inventory/mycluster/group_vars/k8s_cluster/vars.yml << EOF
gcr_image_repo: "registry.aliyuncs.com/google_containers"
kube_image_repo: "registry.aliyuncs.com/google_containers"
etcd_download_url: "https://ghproxy.com/https://github.com/coreos/etcd/releases/download/{{ etcd_version }}/etcd-{{ etcd_version }}-linux-{{ image_arch }}.tar.gz"
cni_download_url: "https://ghproxy.com/https://github.com/containernetworking/plugins/releases/download/{{ cni_version }}/cni-plugins-linux-{{ image_arch }}-{{ cni_version }}.tgz"
calicoctl_download_url: "https://ghproxy.com/https://github.com/projectcalico/calicoctl/releases/download/{{ calico_ctl_version }}/calicoctl-linux-{{ image_arch }}"
calico_crds_download_url: "https://ghproxy.com/https://github.com/projectcalico/calico/archive/{{ calico_version }}.tar.gz"
crictl_download_url: "https://ghproxy.com/https://github.com/kubernetes-sigs/cri-tools/releases/download/{{ crictl_version }}/crictl-{{ crictl_version }}-{{ ansible_system | lower }}-{{ image_arch }}.tar.gz"
nodelocaldns_image_repo: "cncamp/k8s-dns-node-cache"
dnsautoscaler_image_repo: "cncamp/cluster-proportional-autoscaler-amd64"
EOF
```
#### On host src folder

```sh
# Change remote user
# cat ansible.cfg |grep remote_user

# nano ansible.cfg
# add remote_user=ubuntu to [defaults] section
# force_valid_group_names = ignore
# remote_user=ubuntu
# host_key_checking=False
# docker cp ansible.cfg kubespray:/kubespray/ansible.cfg

# error: python-apt
# cat roles/kubernetes/preinstall/vars/ubuntu.yml

# nano roles/kubernetes/preinstall/vars/ubuntu.yml
# ---
# required_pkgs:
#   - python3-apt
#   - aufs-tools
#   - apt-transport-https
#   - software-properties-common
#   - conntrack
# docker cp roles/kubernetes/preinstall/vars/ubuntu.yml kubespray:/kubespray/roles/kubernetes/preinstall/vars/ubuntu.yml


ansible-playbook cluster.yml \
-i inventory/mycluster/hosts.yml \
-u ubuntu
--become \
-v \
--private-key=~/.ssh/id_rsa
```

### Troubleshooting

#### Error, the following error cause by slow network in China

```
Data could not be sent to remote host \"150.109.159.92\". Make sure this host can be reached over ssh:
```

> If you meet the same error when downloading image, you can pull the image before retry

#### dpkg: error: dpkg frontend lock is locked by another process

```sh
rm /var/lib/dpkg/lock
rm /var/lib/dpkg/lock-frontend
rm /var/cache/apt/archives/lock
```


