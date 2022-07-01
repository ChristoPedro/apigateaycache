resource "oci_core_instance" "redis" {
    #Required
    availability_domain  = var.availablity_domain_name
    compartment_id       = var.compartment_id
    shape                = var.instance_shape
    display_name         = "Redis"
    preserve_boot_volume = false
    create_vnic_details {
        assign_public_ip                   = false
        subnet_id = var.redis_subnet_OCID != "" ? var.redis_subnet_OCID : oci_core_subnet.private_subnet[0].id
    }
    shape_config {
        memory_in_gbs = var.instance_shape_config_memory_in_gbs
        ocpus         = var.instance_shape_config_ocpus
    }
    source_details {
        source_id   = data.oci_core_images.osimage.images[0].id
        source_type = "image"
    }

    metadata = {
        ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
    }
}