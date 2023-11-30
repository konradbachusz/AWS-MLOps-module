#########################################
# Sagemaker
#########################################

variable "sagemaker_execution_role_arn" {}

variable "tags" {}

variable "data_location_s3" {}

variable "model_target_variable" {}

variable "config_bucket_id" {}

variable "algorithm_choice" {}

variable "endpoint_name" {}

variable "model_name" {}

variable "pycaret_ecr_name" {}

variable "sagemaker_instance_type" {}

variable "region_name" {

}