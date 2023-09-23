### 查询fs
```bash
kubectl get flowschema
kubectl get flowschema system-leader-election -o=yaml
```
> matching precedence: 匹配优先级，数值越小，优先级越高


### 调试
```bash
# 查看所有优先级及其当前状态的列表
kubectl get --raw /debug/api_priority_and_fairness/dump_priority_levels

# 查看所有队列及其当前状态的列表
kubectl get --raw /debug/api_priority_and_fairness/dump_queues

# 当前正在队列中等待的所有请求的列表
kubectl get --raw /debug/api_priority_and_fairness/dump_requests
```