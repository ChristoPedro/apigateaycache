variable "tenancy_ocid" {}
variable "region" {}
variable "availablity_domain_name" {}
variable "compartment_id" {}
variable "redis_subnet_OCID"{
    default = ""
}
variable "api_gateway_subnec_OCID"{
    default = ""
}

variable "instance_shape" {
    default = "VM.Standard.A1.Flex"
}

variable "instance_shape_config_memory_in_gbs" {
    default = 6
}

variable "instance_shape_config_ocpus"{
    default = 1
}

variable "create_new_network"{
    default = true
}

variable "vcn_cidr"{
    default = "10.0.0.0/16"
}

variable "private_subnet_cidir" {
    default = "10.0.1.0/24"
}

variable "public_subnet_cidir" {
    default = "10.0.0.0/24"
}

variable "network_cidrs"{
    default = "0.0.0.0/0"
}

variable "create_api_gw"{
    default = false
}

variable "api-gateway-name"{
    default = "ApiGW"
}

variable "api-gateway-type"{
    default = "PUBLIC"
}

variable "vault_name" {
  default = "Api Gateway"
}

variable "key_name"{
    default = "Redis Key"
}

variable "secret_name" {
    default = "Redis_Pass"
}

variable "vault_id"{
    default = ""
}

variable "key_id" {
    default = ""
}

variable "create_new_vault"{
    default = true
}

variable "private_endpoint_id" {
    default = ""
}

variable "create_private_endpoint"{
    default = true
}

variable "vcnDeployment"{
    default = ""
}

variable "create_new_dynamic_group_apigw"{
    default = true
}

variable "create_dg_policies"{
    default = true
}