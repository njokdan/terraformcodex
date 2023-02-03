provider "azuredevops" {
  version = "1.0.0"
  organization_url = "https://dev.azure.com/oluseunismaila/"
}

module "pipeline" {
  source = "./pipeline-module"
  app_names = var.app_names
  repos     = var.repos
}
