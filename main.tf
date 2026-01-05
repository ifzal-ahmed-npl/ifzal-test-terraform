resource "aws_s3_bucket" "test_bucket" {
  bucket = "${var.environment}-ifzal-test-bucket-2k25"
}