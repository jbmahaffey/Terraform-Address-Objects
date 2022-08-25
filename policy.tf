resource "fortimanager_packages_pkg" "terrapackage" {
  name = "terr-pkg"
  type = "pkg"
  adom = "Test"
}

resource "fortimanager_object_webfilter_profile" "tf_webfilter" {
  comment = "This is a Terraform example"
  name = "terr-webfilter-profile"
  feature_set = "proxy"
  log_all_url = "disable"
  https_replacemsg = "enable"
}

resource "fortimanager_packages_firewall_policy" "tf_policy" {
    action = "accept"
    srcaddr = ["${fortimanager_object_firewall_addrgrp.testobj.name}"]
    dstaddr = ["all"]
    srcintf = ["any"]
    dstintf = ["any"]
    service = ["ALL"]
    name = "test_policy"
    schedule = "always"
    adom = "Test"
    pkg = fortimanager_packages_pkg.terrapackage.name
    depends_on = [
        fortimanager_object_firewall_address.testobj,
        fortimanager_packages_pkg.terrapackage
  ]
}