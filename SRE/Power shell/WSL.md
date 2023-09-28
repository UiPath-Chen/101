> http://www.taodudu.cc/news/show-3865613.html?action=onClick
>
> https://zhuanlan.zhihu.com/p/622706723?utm_id=0

# WSL2离线安装

> https://www.jianshu.com/p/13217d81cdf8

```Bash
下载安装包 旧版 WSL 的手动安装步骤 | Microsoft Docs
将下载的CanonicalGroupLimited.UbuntuonWindows_2004.2021.825.0.AppxBundle文件名后添加.zip后缀，然后解压。
解压后其中有个Ubuntu_2004.2021.825.0_x64.appx，同理添加.zip后缀，然后再解压，解压到想要的位置。
运行里面的ubuntu.exe。至此基本完成
发现MobaXterm导入的session打不开WSL，打开运行之前下载的CanonicalGroupLimited.UbuntuonWindows_2004.2021.825.0.AppxBundle或者Ubuntu_2004.2021.825.0_x64.appx文件，等待安装完毕，即可解决。打开终端后发现连接的还是之前的那个位置
```

### 配置DNS和systemd启动

```Bash
vim /etc/wsl.conf
[network]
generateResolvConf = false

[boot]
systemd=true 
# 配置WSL代理访问
vim /etc/resolv.conf
# domestic
## 1. 114
# nameserver 114.114.114.114
## 2. tencent
nameserver 119.29.29.29
## 3. ali
# nameserver 223.5.5.5
## 4. baidu
# nameserver 180.76.76.76
# overseas
# nameserver 1.1.1.1
nameserver 8.8.8.8
nameserver 8.8.4.4
```

# 磁盘备份&还原

> 如果我们是通过Windows Store 进行安装的，就会默认安装到C盘，这个对于我们是不允许的，所以我们需要将其迁移到其他非C盘的地方。

```Bash
wsl --shutdown
wsl --export Ubuntu E:\export.tar
wsl --unregister Ubuntu
wsl --import Ubuntu-20.04 E:\wsl\Ubuntu\ E:\export.tar --version 2
del E:\export.tar
```

> 报错：
>
> 正在导入，这可能需要几分钟时间。
>
> Unspecified error
>
> Error code: Wsl/Service/E_FAIL

```PowerShell
# 以管理员身份运行
netsh winsock reset   or netcfg -d
```

# WSL设置代理

> https://zhuanlan.zhihu.com/p/640242841

> 目的：在windows上运行代理软件，让wsl也能够访问外网链接 下面是步骤

![img](https://f0eqwy0ght7.feishu.cn/space/api/box/stream/download/asynccode/?code=YjZhMTFjYzRkYjE1NTM2NWY5YmYwYzY5YzQ1NmMxNTRfM081eG51Z3JRc3JmM2laR1RqUVR4NmU2QlNrYmFDNUJfVG9rZW46U1pkMWJZeEx3b3FkS1V4T1RqSmNIeWhHblFoXzE2OTU4MzQwOTU6MTY5NTgzNzY5NV9WNA)

## 配置防火墙

> 控制面板->系统和安全->Windows Defender 防火墙->允许应用通过 Windows 防火墙中，把你的代理软件的相关项全部打上勾。

## 配置wsl环境

编辑 ~/.bashrc，如果使用的是clash，在文件末尾添加下面的代码。

```Bash
# add proxy
export hostip=$(ip route | grep default | awk '{print $3}')
export socks_hostport=7890
export http_hostport=7890

alias proxy='
    export https_proxy="http://${hostip}:${http_hostport}"
    export http_proxy="http://${hostip}:${http_hostport}"
    export ALL_PROXY="socks5://${hostip}:${socks_hostport}"
    export all_proxy="socks5://${hostip}:${socks_hostport}"
'
alias unproxy='
    unset ALL_PROXY
    unset https_proxy
    unset http_proxy
    unset all_proxy
'
alias echoproxy='
    echo $ALL_PROXY
    echo $all_proxy
    echo $https_proxy
    echo $http_proxy
'
#end proxy
```

# 配置DNS和systemd启动

```Bash
vim /etc/wsl.conf                                                                                                                                         
[boot]                                                                                                                                                      
systemd=true 

[network]                                                                                                                                                   
generateResolvConf = false                                                                                                                                  


# 配置WSL代理访问
vim /etc/resolv.conf

# domestic                                                                                                                                                      
## 1. 114                                                                                                                                                   
# nameserver 114.114.114.114                                                                                                                                
## 2. tencent                                                                                                                                               
nameserver 119.29.29.29                                                                                                                                     
## 3. ali                                                                                                                                                   
# nameserver 223.5.5.5                                                                                                                                      
## 4. baidu                                                                                                                                                 
# nameserver 180.76.76.76                                                                                                                                   
# overseas                                                                                                                                                      
# nameserver 1.1.1.1                                                                                                                                        
nameserver 8.8.8.8                                                                                                                                          
nameserver 8.8.4.4
```

# 配置静态IP

> /etc/netplan/下有个默认文件xx.yaml

```Bash
# 安装常用工具
apt install -y vim net-tools

# 查看网卡,一般是ens33
ip a

# 配置
# ip地址为DHCP分配的IP地址
# 网关为vmware网络配置NAT配置，的网关，可以在vmware中Edit-》Virtual Network Editor-》NAT->NAT Setting中查看
vim /etc/netplan/xx.yaml
# Let NetworkManager manage all devices on this system
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    ens33:
      dhcp4: false
      addresses: [192.168.26.102/24]
      gateway4: 192.168.26.2
      nameservers:
        addresses: [114.114.114.114, 8.8.8.8]
        
# 保存后运行
netplan apply

# 查看
ip a
```

# 配置oh-my-posh

> https://ohmyposh.dev/

```Bash
curl -s https://ohmyposh.dev/install.sh | bash -s

# Add the following to ~/.bashrc (could be ~/.profile or ~/.bash_profile depending on your environment):
eval "$(oh-my-posh init bash)"

exec bash
```

# 配置VIM

暂时无法在飞书文档外展示此内容

# wsl.config / Vemem.wslconfig

> https://learn.microsoft.com/en-us/windows/wsl/wsl-config#configure-global-options-with-wslconfig

## wsl.config

```Bash
# Automatically mount Windows drive when the distribution is launched
[automount]

# Set to true will automount fixed drives (C:/ or D:/) with DrvFs under the root directory set above. Set to false means drives won't be mounted automatically, but need to be mounted manually or with fstab.
# enabled = true

# Sets the directory where fixed drives will be automatically mounted. This example changes the mount location, so your C-drive would be /c, rather than the default /mnt/c. 
# root = /

# DrvFs-specific options can be specified.  
# options = "metadata,uid=1003,gid=1003,umask=077,fmask=11,case=off"

# Sets the `/etc/fstab` file to be processed when a WSL distribution is launched.
# mountFsTab = true

# Network host settings that enable the DNS server used by WSL 2. This example changes the hostname, sets generateHosts to false, preventing WSL from the default behavior of auto-generating /etc/hosts, and sets generateResolvConf to false, preventing WSL from auto-generating /etc/resolv.conf, so that you can create your own (ie. nameserver 1.1.1.1).
[network]
hostname = WSL-Ubuntu_20.04
generateHosts = false
# generateResolvConf = false

# Set whether WSL supports interop process like launching Windows apps and adding path variables. Setting these to false will block the launch of Windows processes and block adding $PATH environment variables.
[interop]
enabled = true
appendWindowsPath = false

# Set the user when launching a distribution with WSL.
[user]
default = root

# Set a command to run when a new WSL instance launches. This example starts the Docker container service.
[boot]
systemd = true
# command = systemctl start docker
```

## .wslconfig

> Win + R输入：
>
> %UserProfile%
>
> 创建文件Wmmem.wslconfig

```Bash
mkdir E:\\WSL\\temp
# Settings apply across all Linux distros running on WSL 2
[wsl2]

# Limits VM memory to use no more than 4 GB, this can be set as whole numbers using GB or MB
memory=6GB

# Sets the VM to use two virtual processors
processors=2

# Specify a custom Linux kernel to use with your installed distros. The default kernel used can be found at https://github.com/microsoft/WSL2-Linux-Kernel
# kernel=E:\\WSL\\temp\\myCustomKernel

# Sets additional kernel parameters, in this case enabling older Linux base images such as Centos 6
kernelCommandLine = vsyscall=emulate

# Sets amount of swap storage space to 8GB, default is 25% of available RAM
swap=0

# Sets swapfile path location, default is %USERPROFILE%\AppData\Local\Temp\swap.vhdx
swapfile=E:\\WSL\\temp\\wsl-swap.vhdx

# Disable page reporting so WSL retains all allocated memory claimed from Windows and releases none back when free
# pageReporting=false

# Turn off default connection to bind WSL 2 localhost to Windows localhost
localhostforwarding=true

# Disables nested virtualization
nestedVirtualization=false

# Turns on output console showing contents of dmesg when opening a WSL 2 distro for debugging
debugConsole=true

# Enable experiemntal features
[experimental]
# sparseVhd=true
```

> wsl 
>
> code . 
>
> exec format error
>
> https://github.com/microsoft/WSL/issues/8952

```Bash
sudo sh -c 'echo :WSLInterop:M::MZ::/init:PF > /usr/lib/binfmt.d/WSLInterop.conf'
sudo systemctl unmask systemd-binfmt.service
sudo systemctl restart systemd-binfmt
sudo systemctl mask systemd-binfmt.service
```

# .bashrc

```Bash
# add alias
alias cc='curl cip.cc'
alias k='kubectl'
alias ks='kubectl -n kube-system'
alias t='terraform'
alias code='/d/Program\ Files\ \(x86\)/Microsoft\ VS\ Code/bin/code'
alias explorer='/c/Windows/explorer.exe'
# end alias
```

# 修改目录颜色：蓝色-》洋红

```Bash
cd ~
dircolors -p >.dircolors

sed -i -e 's/DIR 01;34/DIR 01;35/' .dircolors
"DIR 01;34" -> "DIR 01;35" # 01-高亮； 34-蓝色；35-洋红

source .bashrc
```

# 防火墙设置

https://www.jetbrains.com/help/idea/how-to-use-wsl-development-environment-in-product.html#debugging_system_settings

```Bash
New-NetFirewallRule -DisplayName "WSL" -Direction Inbound  -wInterfaceAlias "vEthernet (WSL)"  -Action Allow
```