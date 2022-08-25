resource "fortimanager_packages_pkg" "terrapackage" {
  name = "terr-pkg"
  type = "pkg"
  adom = "Test"
}

resource "fortimanager_packages_firewall_policy" "labelname" {
    action = "accept"
    srcaddr = ["${fortimanager_object_firewall_addrgrp.testobj.name}"]
    dstaddr = ["all"]
    srcintf = ["any"]
    dstintf = ["any"]
    service = ["ALL"]
    schedule = "always"
    adom = "Test"
    pkg = fortimanager_packages_pkg.terrapackage.name
    depends_on = [
        fortimanager_object_firewall_address.testobj,
        fortimanager_packages_pkg.terrapackage
  ]
}