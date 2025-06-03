resource "aws_iam_role" "source_replication_role" {
  provider = aws.source
  name     = "${var.source_bucket_name}_replication_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "s3.amazonaws.com",
          "batchoperations.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "source_replication_policy" {
  provider = aws.source
  name     = "${var.source_bucket_name}_replication_policy"

  policy = data.aws_iam_policy_document.replication_iam_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_replication_policy" {
  provider   = aws.source
  role       = aws_iam_role.source_replication_role.name
  policy_arn = aws_iam_policy.source_replication_policy.arn
}

resource "aws_s3_bucket" "source_bucket" {
  provider      = aws.source
  bucket        = var.source_bucket_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "source_bucket_sse" {
  provider      = aws.source
  bucket = aws_s3_bucket.source_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.source_kms_key_arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
  depends_on = [aws_s3_bucket.source_bucket]
}

resource "aws_s3_bucket_versioning" "source_bucket_versioning" {
  provider = aws.source

  bucket = aws_s3_bucket.source_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "bucket_replication_config" {
  provider = aws.source
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.source_bucket_versioning]

  role   = aws_iam_role.source_replication_role.arn
  bucket = aws_s3_bucket.source_bucket.id

  rule {
    id = "cross-replication"
    delete_marker_replication {
      status = "Enabled"
    }
    source_selection_criteria {
      replica_modifications {
        status = "Enabled"
      }

      sse_kms_encrypted_objects {
        status = "Enabled"
      }

    }

    filter {
      prefix = ""
    }

    status = "Enabled"

    destination {
      bucket = aws_s3_bucket.destination_bucket.arn
      metrics {
        status = "Enabled"
        event_threshold {
          minutes = 15
        }
      }
      encryption_configuration {
        replica_kms_key_id = "arn:aws:kms:eu-west-1:283196072391:key/e07f5f5e-ace9-4d84-80e8-2b07d30f5891"
      }
      replication_time {
        status = "Enabled"
        time {
          minutes = 15
        }
      }
    }
  }
}


resource "aws_s3_bucket_public_access_block" "source_public_access_block" {
  provider = aws.source
  bucket   = aws_s3_bucket.source_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "destination_bucket" {
  provider      = aws.dest
  bucket        = var.dest_bucket_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "destination_bucket_sse" {
  provider = aws.dest
  bucket = aws_s3_bucket.destination_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.source_kms_key_arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
  depends_on = [aws_s3_bucket.source_bucket]
}

resource "aws_s3_bucket_policy" "destination_bucket_policy" {
  provider = aws.dest
  bucket = aws_s3_bucket.destination_bucket.bucket
  policy = data.aws_iam_policy_document.allow_replication_destination_s3_access.json
}


resource "aws_s3_bucket_versioning" "destination_bucket_versioning" {
  provider = aws.dest
  bucket   = aws_s3_bucket.destination_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "destination_public_access_block" {
  provider = aws.dest
  bucket   = aws_s3_bucket.destination_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}