module "legacy_to_prod_sql_db_s3_replication" {
  source = "./s3-car-module"
  dest_bucket_name = "npl-sql-server-prod-landing"
  source_bucket_name = "npl-sql-server-legacy-landing"
  destination_profile = "np-devops-deploy-user-legacy"
  source_profile = "np-devops-deploy-user-prod"
  destination_kms_key_arn = "arn:aws:kms:eu-west-1:582427785884:key/6b1487f6-a609-404a-b7fa-9294edf994d7"
  source_kms_key_arn = "arn:aws:kms:eu-west-1:913088952181:key/a350b8e0-70e7-4f4c-ad6a-004407d2659b"
}