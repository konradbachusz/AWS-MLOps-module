# AWS-MLOps-module
This repo contains a terraform module with corresponding AWS resources that enable training, deploying and re-training AWS-hosted machine learning models with corresponding cloud infrastructure.

>  **Warning**: This repo is a basic template for MLOps resources on AWS. Please apply appropriate security enhancements for your project in production.

## High-Level Solution Architecture
![image](https://github.com/konradbachusz/AWS-MLOps-module/assets/104912687/12c4f1a0-573b-44a0-98f2-1256be64d19a)


## Example Usage

 ```
module "MLOps" {
  source  = "github.com/konradbachusz/AWS-MLOps-module
  data_location_s3        = "your_bucket/your_data.csv"
  model_target_variable   = "y"
  model_name              = "your-ml-model"
  account_id              = var.account_id
  region                  = var.region
  retrain_model_bool      = true
  retraining_schedule     = "cron(0 8 1 * ? *)"
  pycaret_ecr_name        = "your-ecr-name"
  algorithm_choice        = "classification"
  endpoint_name           = "classification-model-endpoint"
  sagemaker_instance_type = "ml.m4.xlarge"
  model_instance_count    = 1
  tuning_metric = "AUC"
} 
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | 2.4.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.4 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecr"></a> [ecr](#module\_ecr) | ./modules/ecr | n/a |
| <a name="module_iam"></a> [iam](#module\_iam) | ./modules/iam | n/a |
| <a name="module_retraining_job"></a> [retraining\_job](#module\_retraining\_job) | ./modules/glue | n/a |
| <a name="module_s3"></a> [s3](#module\_s3) | ./modules/s3 | n/a |
| <a name="module_sagemaker"></a> [sagemaker](#module\_sagemaker) | ./modules/sagemaker | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | AWS Account ID | `string` | n/a | yes |
| <a name="input_algorithm_choice"></a> [algorithm\_choice](#input\_algorithm\_choice) | Machine learning problem type e.g classification, regression, clustering, anomaly, time\_series | `string` | n/a | yes |
| <a name="input_data_location_s3"></a> [data\_location\_s3](#input\_data\_location\_s3) | Location of the data in s3 bucket | `string` | n/a | yes |
| <a name="input_endpoint_name"></a> [endpoint\_name](#input\_endpoint\_name) | name of the endpoint for prediction | `string` | n/a | yes |
| <a name="input_model_instance_count"></a> [model\_instance\_count](#input\_model\_instance\_count) | The initial number of instances to run the model | `number` | n/a | yes |
| <a name="input_model_name"></a> [model\_name](#input\_model\_name) | Name of the Sagemaker model | `string` | `""` | no |
| <a name="input_model_target_variable"></a> [model\_target\_variable](#input\_model\_target\_variable) | The dependent variable (or 'label') that the regression model aims to predict. This should be a column name in the dataset. | `string` | n/a | yes |
| <a name="input_pycaret_ecr_name"></a> [pycaret\_ecr\_name](#input\_pycaret\_ecr\_name) | Name of ECR repository that will be storing pycaret's container image for launching model | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS deployment region | `string` | n/a | yes |
| <a name="input_retrain_model_bool"></a> [retrain\_model\_bool](#input\_retrain\_model\_bool) | Boolean to indicate if the retraining pipeline shoud be added | `bool` | `false` | no |
| <a name="input_retraining_schedule"></a> [retraining\_schedule](#input\_retraining\_schedule) | Cron expression of the model retraing frequency | `string` | n/a | yes |
| <a name="input_sagemaker_instance_type"></a> [sagemaker\_instance\_type](#input\_sagemaker\_instance\_type) | the sagemaker instance type that is being created | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to your resources | `map` | `{}` | no |
| <a name="input_tuning_metric"></a> [tuning\_metric](#input\_tuning\_metric) | The metric user want to focus when tuning hyperparameter | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_name"></a> [ecr\_name](#output\_ecr\_name) | The name of the ecr repo |
| <a name="output_sagemaker_algorithm_choice"></a> [sagemaker\_algorithm\_choice](#output\_sagemaker\_algorithm\_choice) | the sagemaker algorithm choice |
| <a name="output_sagemaker_endpoint_name"></a> [sagemaker\_endpoint\_name](#output\_sagemaker\_endpoint\_name) | Model endpoint name |
| <a name="output_sagemaker_model_name"></a> [sagemaker\_model\_name](#output\_sagemaker\_model\_name) | The name of the model |

## Destroying Resources
After creating the resources made using this the module, the resources: 
- Sagemaker model 
- Sagemaker Endpoint  
- Endpoint configuration
  
Will not be tracked by your Terraform state file so if you decide to run "terraform destroy" these resources will not be deleted.

To destroy these resourses we recommend that you add these commands to your CI/CD pipeline:

```bash
aws sagemaker delete-model --model-name < demo-regression-model >
aws sagemaker delete-endpoint-config --endpoint-config-name < demo-regression-model-config >
aws sagemaker delete-endpoint --endpoint-name < demo-regression-model >    
```

But before this you will need to add your AWS credentials to the environment if you have not do already:
```bash
aws-access-key-id: < aws-access-key-id >
aws-secret-access-key: < aws-secret-access-key >
aws-region: < region >
```
<!-- END_TF_DOCS -->
