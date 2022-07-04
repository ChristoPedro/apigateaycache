resource oci_apigateway_gateway devops_gateway {

compartment_id = var.compartment_id
endpoint_type  = var.api-gateway-type
subnet_id      = var.api_gateway_subnec_OCID != "" ? var.api_gateway_subnec_OCID : oci_core_subnet.public_subnet[0].id
display_name   = var.api-gateway-name

response_cache_details {
        
        type = "EXTERNAL_RESP_CACHE"
        authentication_secret_id             = oci_vault_secret.redis_secret.id
        authentication_secret_version_number = oci_vault_secret.redis_secret.current_version_number
        connect_timeout_in_ms                = "1000"
        is_ssl_enabled                       = "false"
        is_ssl_verify_disabled               = "false"
        read_timeout_in_ms                   = "1000"
        send_timeout_in_ms                   = "1000"
        
        servers {
            host = oci_core_instance.redis.private_ip
            port = 6379
        }
    }

count = var.create_api_gw ? 1 : 0

}
