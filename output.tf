output "generated_ssh_private_key" {
  value = tls_private_key.public_private_key_pair.private_key_pem
}

output "redis_password" {
  value = random_string.redis_password.result
}

output "redis_script"{
  value = base64encode(data.template_file.redis_bootstrap.rendered)
}