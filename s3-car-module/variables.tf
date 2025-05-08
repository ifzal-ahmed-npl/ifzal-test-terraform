variable "source_region" {
  description = "AWS Deployment region.."
  default = "eu-west-1"
}

variable "dest_region" {
  description = "AWS Deployment region.."
  default = "eu-west-1"
}

variable "source_bucket_name" {
  description = "Your Source Bucket Name"
}

variable "dest_bucket_name" {
  description = "Your Destination Bucket Name"
}

variable "destination_profile" {
  description = "Your Destination AWS Profile Credentials"
}

variable "source_profile" {
  description = "Your Source AWS Profile Credentials"
}

variable "source_kms_key_arn" {
  description = "KMS Key ARN to be used to decrypt S3 objects in source bucket"
}

variable "destination_kms_key_arn" {
  description = "KMS Key ARN to be used to encrypt S3 objects in destination bucket"
}