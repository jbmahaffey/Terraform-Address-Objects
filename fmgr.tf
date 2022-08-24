terraform {
  required_providers {
    fortimanager = {
      source  = "fortinetdev/fortimanager"
    }
  }
}

provider "fortimanager" {
  hostname     = "192.168.101.99"
  username     = "admin"
  password     = "$3cr3t$3cr3t"
  insecure     = "true"

  scopetype = "adom"
  adom      = "Test"
}

variable "testobj" {
  default = {
    test1 = [
        "192.168.0.0",
        "255.255.255.0"
      ]
    test2 = [
        "192.168.101.0",
        "255.255.255.0"
      ]
    }
}
  

resource "fortimanager_object_firewall_address" "testobj" {
  for_each = var.testobj
  name = each.key
  obj_type = "ip"
  subnet = each.value
  type = "ipmask"
}

resource "fortimanager_object_firewall_addrgrp" "testobj" {
  allow_routing = "disable"
  member        = tolist(keys(var.testobj))
  name          = "test-addrgrp"
  depends_on = [
    fortimanager_object_firewall_address.testobj
  ]
}