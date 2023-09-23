## 目标
> 任何人在创建自定义的Namespace时候，对自己创建的Namespace自动拥有全部权限，且不同的Namespace，相互隔离

## 方案
### 创建自定义 ns admission controller
* 当namespace 创建请求被处理时，获取当前用户信息并annotate到namespace

### 创建自定义 RBAC controller
* Watch namespace 的创建事件
* 获取当前namespace 的创建者信息
* 在当前namespace 创建rolebinding 对象，并将namespace-creator角色和用户绑定


