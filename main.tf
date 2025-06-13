resource "aws_s3_bucket" "test_bucket" {
  name = "${var.environment}-ifzal-test-bucket-2k25"
}