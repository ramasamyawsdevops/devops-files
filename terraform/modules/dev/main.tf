module "instance_provisioning" {
  source      = "../module"
  sgname      = var.sgname
  keyname     = var.keyname
  mytag       = var.mytag
  amiid       = var.amiid
  machinetype = var.machinetype

}