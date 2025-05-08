provider "aws" {
  alias   = "legacy"
  region  = var.region
  profile = "np-devops-deploy-user-legacy"
}

provider "aws" {
  alias   = "prod"
  region  = var.region
  profile = "np-devops-deploy-user-prod"
}