resource "aws_s3_bucket" "test_bucket" {
  bucket = "${var.environment}-ifzal-test-bucket-2k25"
}

module "test-s3-bucket" {
  source = source = "git::https://github.com/NOW-Pensions/npl-global-terraform-modules.git//ecr?ref=DEVOPS-331-ecr-module"
}