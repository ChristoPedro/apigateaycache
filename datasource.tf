data "oci_identity_tenancy" "tenant_details" {
  tenancy_id = var.tenancy_ocid

  provider = oci.current_region
}

data "oci_identity_regions" "home_region" {
  filter {
    name   = "key"
    values = [data.oci_identity_tenancy.tenant_details.home_region_key]
  }

  provider = oci.current_region
}

data "oci_core_images" "osimage" {
    compartment_id = var.compartment_id
    operating_system = "Oracle Linux"
    operating_system_version = 8
    shape = var.instance_shape
}

data "oci_identity_availability_domains" "test_availability_domains" {

    compartment_id = var.tenancy_ocid
}

data "oci_core_services" "all_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

data "oci_resourcemanager_private_endpoint_reachable_ip" "reachable_ip" {
  private_endpoint_id = var.private_endpoint_id != "" ? var.private_endpoint_id : oci_resourcemanager_private_endpoint.rms_private_endpoint[0].id
  private_ip          = oci_core_instance.redis.private_ip
}

data "oci_kms_vault" "vault_endpoint" {
    vault_id = var.vault_id != "" ? var.vault_id : oci_kms_vault.apigw_vault[0].id
}