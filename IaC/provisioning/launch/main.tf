module "logic" {
  source      = "../logic"
  location    = "East US"
  environment = "dev"
  service     = "exman1"
}
