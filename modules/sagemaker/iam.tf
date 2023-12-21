locals {
  s3_buckets   = [var.config_s3_bucket, var.model_s3_bucket, var.data_s3_bucket]
  kms_key_arns = compact([var.config_bucket_key_arn, var.data_bucket_key_arn, var.model_bucket_key_arn])
}

resource "aws_iam_role" "sagemaker" {
  name               = aws_sagemaker_notebook_instance.notebook.name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "sagemaker.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags               = var.tags
}

data "aws_iam_policy_document" "sagemaker" {
  statement {
    sid = "SagemakerAccess"
    actions = [
      "sagemaker:*"
    ]
    resources = ["*"]
  }

  statement {
    sid = "CloudwatchLogGroupAccess"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    sid = "S3Access"
    actions = [
      "s3:ListBucket"
    ]
    resources = [for bucket in local.s3_buckets : "arn:aws:s3:::${bucket}"]
  }

  statement {
    sid = "S3ObjectAccess"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]

    resources = [for bucket in local.s3_buckets : "arn:aws:s3:::${bucket}/*"]
  }

  statement {
    sid = "KMSAccess"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]

    resources = local.kms_key_arns
  }
}

resource "aws_iam_policy" "sagemaker" {
  name   = "${aws_sagemaker_notebook_instance.notebook.name}-policy"
  policy = data.aws_iam_policy_document.sagemaker.json
  tags   = var.tags
}


resource "aws_iam_role_policy_attachment" "sagemaker_custom" {
  role       = aws_iam_role.sagemaker.name
  policy_arn = aws_iam_policy.sagemaker.arn
}

resource "aws_iam_role_policy_attachment" "AmazonSageMakerFullAccess" {
  role       = aws_iam_role.sagemaker.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}
