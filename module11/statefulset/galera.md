# Galera Operator

(来自之前的一点个人积累)

# 高可用部署

构建Galera cluster，提供多活高可用mysql集群多实例跨集群/跨机架/跨主机

- 持久化存储
需要为每个pod创建PVC并mount
读写性能保证
local dynamic作为数据盘，cephfs作为备份盘
- 有状态应用的复杂配置
与无状态应用不一样，mysql需要复杂配置以完成galara集群的构建 /etc/mysql/conf.d/galera.cnf

# 配置细节

```bash
#Configuration the First Node(Primary Component)
[mysqld]
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
bind-address=0.0.0.0
# Galera Provider Configuration
wsrep_on=ON
wsrep_provider=/usr/lib/galera/libgalera_smm.so
# Galera Cluster Configuration
wsrep_cluster_name="test_cluster"
wsrep_cluster_address="gcomm://First_Node_IP,Second_Node_IP,Third_Node_IP"
# Galera Synchronization Configuration
wsrep_sst_method=rsync
# Configuration on all Galera Nodes
wsrep_node_address="This_Node_IP"
wsrep_node_name="This_Node_Name"
```

# 启动顺序

- 在Primary Component节点上运行
    - mysqld_bootstrap
- 在其他节点上运行
    - systemctl start mysql
- 发生了什么？
    - 当节点第一次启动时，会自动生成UUID以代表当前节点身份
    - 启动后，garala会在数据目录生成 gvwstate.dat文件，该文件内容记录Primary Component的UUID以及连接到当前Primary Component的节点的UUID
    - 如果Primary Component出现故障，则剩余节点会重新选择新的Primary Component
    - 若该文件已经存在，则无需额外执行bootstrap命令启动Primary Compont，可依此规则编写Operator在多个节点构建此文件

```bash
my_uuid: d3124bc8-1605-11e4-aa3d-ab44303c044a
#vwbeg
view_id: 3 0dae1307-1606-11e4-aa94-5255b1455aa0 12
bootstrap: 0
member: 0dae1307-1606-11e4-aa94-5255b1455aa0 1
member: 47bbe2e2-1606-11e4-8593-2a6d8335bc79 1
member: d3124bc8-1605-11e4-aa3d-ab44303c044a 1
#vwend
```

# 健康检查

- Mysql提供健康检查API
    - 检查集群成员是否能接受查询请求
        - SHOW GLOBAL STATUS LIKE 'wsrep_ready’;
    - 检查节点是否与其他节点网络互通
        - SHOW GLOBAL STATUS LIKE 'wsrep_connected’;
    - 检查节点自场次查询结束后接收到的查询请求数量，如果结果为非0，意味着写请求不能立即处理
        - SHOW STATUS LIKE 'wsrep_local_recv_queue_avg’;
- 健康检查应该影响Pod的readiness probe，在进行版本升级时，确保大多数集群节点状态一致

# 数据备份

- 推荐为mysql创建不同类型的volume
    - Local volume用来做数据盘
    - Network volume用来做数据备份
- 创建cronjob，每天将数据备份至backup目录
    - 备份文件为
- 一键恢复能力
    - 导入备份目录的sql file

# 版本发布和故障转移

- 针对配置了Local disk的pod，当发生因版本变更而引发的Pod重建时，新Pod在进行调度时，调度器会查询Pod挂载的volume所在节点，并将新Pod优先调度至该节点，此场景不涉及到数据恢复。其开销与mysql进程重启相差不大
- 如果节点出现故障，如硬件故障，Kubernetes的Evict Manager会将该Pod从故障节点驱逐，Operator应确保新Pod会被重新构建。而新Pod会被调度至新节点，此场景等价于替换mysql中的少数节点。
    - Galera集群中的少数mysql节点替换，不涉及到数据迁移，galera会确保新节点的数据同步
- 若整个mysql集群需要做数据恢复，则应该从backup目录对应的网络volume恢复数据。此时可选择：
    - 只恢复单一节点数据：配置简单
    - 恢复所有节点数据：恢复速度快
- 与基础架构的Contract
    - PodDisruptionBudget

# 可选开源mysql operator

[Untitled Database](https://www.notion.so/1af756911f0c43b8a5d0b7d17230e695?pvs=21)

from https://github.com/operator-framework/awesome-operators