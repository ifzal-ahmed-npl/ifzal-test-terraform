data "aws_iam_policy_document" "replication_iam_policy" {
  statement {
    sid = "ListBucketGetRepConfPermissions"
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.source_bucket.arn
    ]
  }
  statement {
    sid = "GetObjectVersionPermissions"
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging"
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.source_bucket.arn}/*"
    ]
  }
  statement {
    sid = "ReplicatePermissions"
    actions = [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.destination_bucket.arn}/*"
    ]
  }
  statement {
    sid = "KMSDestPermissions"
    actions = [
      "kms:Encrypt",
      "kms:GenerateDataKey"
    ]
    effect = "Allow"
    resources = [
      var.destination_kms_key_arn
    ]
  }
  statement {
    sid = "KMSSourcePermissions"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = [
      var.source_kms_key_arn
    ]
  }
}

data "aws_iam_policy_document" "allow_replication_destination_s3_access" {
  statement {
    sid = "AllowReplicateS3Access"
    principals {
      identifiers = [aws_iam_role.source_replication_role.arn]
      type = "AWS"
    }
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags"
    ]
    resources = [
      "${aws_s3_bucket.destination_bucket.arn}/*"
    ]
  }
}