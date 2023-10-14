### HCL
https://github.com/hashicorp/hcl

一切HCL最终都渲染成JSON，也就是说它是专门为了简化JSON来的，最终跟云厂商联调都是JSON

### Provider
https://registry.terraform.io/browse/providers


### 常用
```bash
export TF_LOG=debug
terraform init
terraform graph | dot -Tsvg > graph.svg
terraform plan
terraform apply --auto-approve
terraform state list
terraform destroy --auto-approve
<<<<<<< HEAD
```









=======
```
>>>>>>> 0a44f80 (feat: fix)
