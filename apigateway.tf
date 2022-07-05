resource oci_apigateway_gateway devops_gateway {

compartment_id = var.compartment_id
endpoint_type  = var.api-gateway-type
subnet_id      = var.api_gateway_subnec_OCID != "" ? var.api_gateway_subnec_OCID : oci_core_subnet.public_subnet[0].id
display_name   = var.api-gateway-name

response_cache_details {
        
        type = "EXTERNAL_RESP_CACHE"
        authentication_secret_id             = oci_vault_secret.redis_secret.id
        authentication_secret_version_number = oci_vault_secret.redis_secret.current_version_number
        connect_timeout_in_ms                = 1000
        is_ssl_enabled                       = false
        is_ssl_verify_disabled               = false
        read_timeout_in_ms                   = 1000
        send_timeout_in_ms                   = 1000
        
        servers {
            host = oci_core_instance.redis.private_ip
            port = 6379
        }
    }

count = var.create_api_gw ? 1 : 0

}

resource oci_apigateway_deployment Deployment-Cache {
  compartment_id = var.compartment_id
  display_name   = "Deployment_Cache"
  gateway_id     = oci_apigateway_gateway.devops_gateway[0].id
  path_prefix    = "/cache"
  specification {
    logging_policies {
      execution_log {
        is_enabled = true
        log_level  = "INFO"
      }
    }
    routes {
      backend {
        connect_timeout_in_seconds = 60
        is_ssl_verify_disabled     = false
        read_timeout_in_seconds    = 10
        send_timeout_in_seconds    = 10
        type                       = "HTTP_BACKEND"
        url                        = "https://viacep.com.br/ws/$${request.query[cep]}/json/"
      }
      methods = ["GET"]
      path    = "/cep"
      request_policies {
        response_cache_lookup {
          cache_key_additions        = ["request.query[cep]"]
          is_enabled                 = true
          is_private_caching_enabled = false
          type                       = "SIMPLE_LOOKUP_POLICY"
        }
      }
      response_policies {
        response_cache_store {
          time_to_live_in_seconds = 200
          type                    = "FIXED_TTL_STORE_POLICY"
        }
      }
    }
  }
}