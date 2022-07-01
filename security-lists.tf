## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


resource "oci_core_security_list" "private_security_list" {
  compartment_id = var.compartment_id
  display_name   = "private_security_list"
  vcn_id         = oci_core_virtual_network.new_vcn[0].id

  # Ingresses
  ingress_security_rules {
    description = "Allow communication inside the subnet"
    source      = var.private_subnet_cidir
    source_type = "CIDR_BLOCK"
    protocol    = local.all_protocols
    stateless   = false
  }
  ingress_security_rules {
    description = "Inbound SSH traffic inside the VCN"
    source      = var.vcn_cidr
    source_type = "CIDR_BLOCK"
    protocol    = local.tcp_protocol_number
    stateless   = false

    tcp_options {
      max = local.ssh_port_number
      min = local.ssh_port_number
    }
  }
  ingress_security_rules {
    description = "Allow Redis communication within the VCN"
    source      = var.vcn_cidr
    source_type = "CIDR_BLOCK"
    protocol    = local.tcp_protocol_number
    stateless   = false

    tcp_options{
      max = local.redis_port
      min = local.redis_port
    }
  }
  
  # Egresses
  egress_security_rules {
    description      = "Allow egress traffic"
    destination      = var.network_cidrs
    destination_type = "CIDR_BLOCK"
    protocol         = local.all_protocols
    stateless        = false
  }

  count        = var.create_new_network ? 1 : 0
}

resource "oci_core_security_list" "public_security_list" {
  compartment_id = var.compartment_id
  display_name   = "public_security_list"
  vcn_id         = oci_core_virtual_network.new_vcn[0].id
  
  #Ingress
  ingress_security_rules {
    description      = "Api Gateway to use the port 443"
    source           = var.network_cidrs
    source_type      = "CIDR_BLOCK"
    protocol         = local.tcp_protocol_number
    stateless        = false

    tcp_options{
      max = local.https_port_number
      min = local.https_port_number
    }
  }

  # Egresses

  egress_security_rules {
    description      = "Allow egress traffic"
    destination      = var.network_cidrs
    destination_type = "CIDR_BLOCK"
    protocol         = local.all_protocols
    stateless        = false
  }
  
  count        = var.create_new_network ? 1 : 0

}


locals {
  https_port_number                       = "443"
  ssh_port_number                         = "22"
  tcp_protocol_number                     = "6"
  all_protocols                           = "all"
  redis_port                              = "6379"
}
