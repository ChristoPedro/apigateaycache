output "generated_ssh_private_key" {
  value = tls_private_key.public_private_key_pair.private_key_pem
}

output "redis_password" {
  value = random_string.redis_password.result
}

output "redis_ip" {
  value = oci_core_instance.redis.private_ip
}

output "redis_port" {
  value = 6379
}