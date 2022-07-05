resource "oci_identity_dynamic_group" "api_gateway_dg" {
  name           = "Api_Gateway_DG"
  description    = "Api Gateway Dynamic Group"
  compartment_id = var.tenancy_ocid
  matching_rule  = "ANY {ALL {resource.type = 'ApiGateway', resource.compartment.id = '${var.compartment_id}'}}"

  provider       = oci.home_region

  count          = var.create_new_dynamic_group_apigw ? 1 : 0
}

resource "oci_identity_policy" "apigw_dg_policies" {
  name           = "Api_Gateway_DG_Policy"
  description    = "Api Gateway Dynamic Group Policy"
  compartment_id = var.compartment_id
  statements     = local.apigw_statement

  depends_on = [oci_identity_dynamic_group.api_gateway_dg]

  provider = oci.home_region

  count = var.create_dg_policies ? 1 : 0
}

locals {
    apigw_statement = concat(
    local.apigw_statements
  )
}

locals {
  apigw_statements = [
    "Allow dynamic-group Api_Gateway_DG to read secret-bundles in compartment id ${var.compartment_id}"
  ]
}