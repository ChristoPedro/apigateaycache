resource "oci_kms_vault" "apigw_vault" {
    compartment_id = var.compartment_id
    display_name   = var.vault_name
    vault_type     = "DEFAULT"
    count          = var.create_new_vault ? 1 : 0
}

resource "oci_kms_key" "redis_key" {
    compartment_id = var.compartment_id
    display_name   = var.key_name
    key_shape {
        algorithm = "AES"
        length    = 32
    }
    management_endpoint = data.oci_kms_vault.vault_endpoint.management_endpoint
    protection_mode     = "HSM"
    count               = var.create_new_vault ? 1 : 0
}

resource "oci_vault_secret" "redis_secret" {
    compartment_id = var.compartment_id
    secret_content {
        content_type = "BASE64"
        content      = base64encode(jsonencode({"password":random_string.redis_password.result}))
    }
    secret_name = var.secret_name
    vault_id    = var.vault_id != "" ? var.vault_id : oci_kms_vault.apigw_vault[0].id
    key_id      = var.key_id != "" ? var.key_id :oci_kms_key.redis_key[0].id
}