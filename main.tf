module "legacy_to_prod_sql_db_s3_replication" {
  source = "./s3-car-module"
  dest_bucket_name = "sql-server-prod-landing"
  source_bucket_name = "sql-server-legacy-landing"
  destination_profile = "np-devops-deploy-user-prod"
  source_profile = "np-devops-deploy-user-legacy"
  destination_kms_key_arn = "arn:aws:kms:eu-west-1:582427785884:key/6b1487f6-a609-404a-b7fa-9294edf994d7"
  source_kms_key_arn = "arn:aws:kms:eu-west-1:913088952181:key/5cfdd896-2b6d-4ac0-98f9-2ef130012557"
}