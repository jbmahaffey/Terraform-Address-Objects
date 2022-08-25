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
        subnet = [
          "192.168.0.0",
          "255.255.255.0"
        ]
        type = "ipmask"
        obj_type = "ip"
    }
    test2 = {
        subnet = [
          "192.168.101.0",
          "255.255.255.0"
        ]
        type = "ipmask"
        obj_type = "ip"
    }
    }
}

resource "fortimanager_object_firewall_address" "testobj" {
  for_each = var.testobj
  name = each.key
  obj_type = "ip"
  subnet = each.value["subnet"]
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

output "addresses" {
  value = fortimanager_object_firewall_addrgrp.testobj
}