resource oci_apigateway_gateway devops_gateway {

compartment_id = var.compartment_id
endpoint_type  = var.api-gateway-type
subnet_id      = var.api_gateway_subnec_OCID != "" ? var.api_gateway_subnec_OCID : oci_core_subnet.public_subnet[0].id
display_name   = var.api-gateway-name

count          = var.create_api_gw ? 1 : 0

}
