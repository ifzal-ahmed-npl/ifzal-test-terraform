output "source_bucket_arn" {
  value = aws_s3_bucket.source_bucket.arn
}

output "dest_bucket_arn" {
  value = aws_s3_bucket.destination_bucket.arn
}