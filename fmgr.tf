terraform {
  required_providers {
    fortimanager = {
      source  = "fortinetdev/fortimanager"
    }
  }
}

variable "password" {
  sensitive = true
  type = string
}

provider "fortimanager" {
  hostname     = "192.168.101.99"
  username     = "admin"
  password     = var.password
  insecure     = "true"

  scopetype = "adom"
  adom      = "Test"
}

variable "testobj" {
  default = {
    test1 = {
        "subnet" = [
          "192.168.2.0",
          "255.255.255.0"
        ]
        "type" = "ipmask"
        "obj_type" = "ip"
        "fqdn" = ""
    }
    test2 = {
        "subnet" = [
          "192.168.101.0",
          "255.255.255.0"
        ]
        "type" = "ipmask"
        "obj_type" = "ip"
        "fqdn" = ""
    }
    }
}

resource "fortimanager_object_firewall_address" "testobj" {
  for_each = var.testobj
  name = each.key
  obj_type = each.value["obj_type"]
  subnet = each.value["subnet"]
  fqdn = each.value["fqdn"]
  type = each.value["type"]
}

resource "fortimanager_object_firewall_addrgrp" "testobj" {
  allow_routing = "disable"
  member        = tolist(keys(var.testobj))
  name          = "test-addrgrp"
  depends_on = [
    fortimanager_object_firewall_address.testobj
  ]
}

output "addresses" {
  value = fortimanager_object_firewall_addrgrp.testobj
}