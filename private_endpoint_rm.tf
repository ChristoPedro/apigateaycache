resource "oci_resourcemanager_private_endpoint" "rms_private_endpoint" {
  compartment_id = var.compartment_id
  display_name   = "rms_private_endpoint"
  description    = "rms_private_endpoint_description"
  vcn_id         = var.vcnDeployment != "" ? var.vcnDeployment : oci_core_virtual_network.new_vcn[0].id
  subnet_id      = var.redis_subnet_OCID != "" ? var.redis_subnet_OCID : oci_core_subnet.private_subnet[0].id
  count          = var.create_private_endpoint ? 1 : 0
}
