## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


resource "oci_core_virtual_network" "new_vcn" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_id
  display_name   = "VCN-APIGW"
  dns_label      = "apigw"

  count          = var.create_new_network ? 1 : 0
}

resource "oci_core_subnet" "private_subnet" {
  cidr_block                 = var.private_subnet_cidir
  compartment_id             = var.compartment_id
  display_name               = "private_subnet"
  dns_label                  = "privatesubnet"
  vcn_id                     = oci_core_virtual_network.new_vcn[0].id
  route_table_id             = oci_core_route_table.private_route_table[0].id
  dhcp_options_id            = oci_core_virtual_network.new_vcn[0].default_dhcp_options_id
  security_list_ids          = [oci_core_security_list.private_security_list[0].id]
  prohibit_public_ip_on_vnic = true

  count                      = var.create_new_network ? 1 : 0
}

resource "oci_core_subnet" "public_subnet" {
  cidr_block                 = var.public_subnet_cidir
  compartment_id             = var.compartment_id
  display_name               = "public_subnet"
  dns_label                  = "publicsubnet"
  vcn_id                     = oci_core_virtual_network.new_vcn[0].id
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_route_table.public_route_table[0].id
  dhcp_options_id            = oci_core_virtual_network.new_vcn[0].default_dhcp_options_id
  security_list_ids          = [oci_core_security_list.public_security_list[0].id]

  count                      = var.create_new_network ? 1 : 0
}

resource "oci_core_route_table" "private_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.new_vcn[0].id
  display_name   = "private-route-table"

  route_rules {
    description       = "Traffic to the internet"
    destination       = var.network_cidrs
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat_gateway[0].id
  }
  route_rules {
    description       = "Traffic to OCI services"
    destination       = lookup(data.oci_core_services.all_services.services[0], "cidr_block")
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.service_gateway[0].id
  }

  count        = var.create_new_network ? 1 : 0
}
resource "oci_core_route_table" "public_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.new_vcn[0].id
  display_name   = "public-route-table"

  route_rules {
    description       = "Traffic to/from internet"
    destination       = var.network_cidrs
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway[0].id
  }

  count        = var.create_new_network ? 1 : 0
}

resource "oci_core_nat_gateway" "nat_gateway" {
  block_traffic  = "false"
  compartment_id = var.compartment_id
  display_name   = "nat-gateway"
  vcn_id         = oci_core_virtual_network.new_vcn[0].id

  count        = var.create_new_network ? 1 : 0
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_id
  display_name   = "internet-gateway"
  enabled        = true
  vcn_id         = oci_core_virtual_network.new_vcn[0].id

  count        = var.create_new_network ? 1 : 0
}

resource "oci_core_service_gateway" "service_gateway" {
  compartment_id = var.compartment_id
  display_name   = "service-gateway"
  vcn_id         = oci_core_virtual_network.new_vcn[0].id
  services {
    service_id = lookup(data.oci_core_services.all_services.services[0], "id")
  }

  count        = var.create_new_network ? 1 : 0
}
