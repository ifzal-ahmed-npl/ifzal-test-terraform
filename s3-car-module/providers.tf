provider "aws" {
  region = var.source_region
  alias = "source"
  profile = var.source_profile
}

provider "aws" {
  region = var.dest_region
  alias = "dest"
  profile = var.destination_profile
}