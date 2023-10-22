output "public_ip_0" {
  description = "vm public ip address"
  value       = tencentcloud_instance.kubernetes_master_nodes[0].public_ip
}

output "password" {
  description = "vm password"
  value       = var.password
}