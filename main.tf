module "s3" {
  source     = "./modules/s3"
  model_name = var.model_name
  tags       = var.tags
}


module "sagemaker" {
  source                          = "./modules/sagemaker"
  tags                            = var.tags
  sagemaker_execution_role_arn    = module.iam.sagemaker_role_arn
  model_target_variable           = var.model_target_variable
  algorithm_choice                = var.algorithm_choice
  s3_bucket_id                    = module.s3.config_bucket_id
  data_location_s3                = var.data_location_s3
  depends_on                      = [module.s3]
}


module "iam" {
  source           = "./modules/iam"
  tags             = var.tags
  region           = var.region
  account_id       = var.account_id
  model_name       = var.model_name
}


module "retraining_job" {
  count               = var.retrain_model_bool ? 1 : 0
  source              = "./modules/glue"
  model_name          = var.model_name
  tags                = var.tags
  config_bucket_id    = module.s3.config_bucket_id
  data_location_s3    = var.data_location_s3
  retraining_schedule = var.retraining_schedule
}


module "ecr" {
  source           = "./modules/ecr"
  pycaret_ecr_name = var.pycaret_ecr_name
}
