data "template_file" "redis_bootstrap" {
  template = file("./scripts/redis_bootstrap.sh")

  vars = {
    redis_port        = 6379
    redis_password     = random_string.redis_password.result
  }
}

resource "null_resource" "redis_bootstrap" {
  depends_on = [oci_core_instance.redis]

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_resourcemanager_private_endpoint_reachable_ip.reachable_ip.ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }

    content     = data.template_file.redis_bootstrap.rendered
    destination = "~/redis_bootstrap.sh"
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = data.oci_resourcemanager_private_endpoint_reachable_ip.reachable_ip.ip_address
      private_key = tls_private_key.public_private_key_pair.private_key_pem
      script_path = "/home/opc/myssh.sh"
      agent       = false
      timeout     = "10m"
    }
    inline = [
      "chmod +x ~/redis_bootstrap.sh",
      "sudo ~/redis_bootstrap.sh",
    ]
  }
}