#resource "aws_iam_role" "lambda_role" {
#  name               = "terraform_aws_lambda_role-${local.name_alias}"
#  assume_role_policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "lambda.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    }
#  ]
#}
#EOF
#}
#
## IAM policy for logging from a lambda
#
#resource "aws_iam_policy" "iam_policy_for_lambda" {
#
#  name        = "aws_iam_policy_for_terraform_aws_lambda_role-${local.name_alias}"
#  path        = "/"
#  description = "AWS IAM Policy for managing aws lambda role"
#  policy      = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": [
#        "logs:CreateLogGroup",
#        "logs:CreateLogStream",
#        "logs:PutLogEvents",
#          "rds:*",
#"s3:PutObject"
#      ],
#      "Resource": "*",
#      "Effect": "Allow"
#    }
#
#  ]
#}
#EOF
#}
#
## Policy Attachment on the role.
#
#resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
#  role       = aws_iam_role.lambda_role.name
#  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
#}
#
## Generates an archive from content, a file, or a directory of files.
#
#data "archive_file" "zip_the_python_code" {
#  type        = "zip"
#  source_dir  = "${path.module}/lambda/"
#  output_path = "${path.module}/lambda/lambda_handler.zip"
#}
#
#resource "aws_lambda_function" "terraform_lambda_func" {
#  filename      = "${path.module}/lambda/lambda_handler.zip"
#  function_name = "Test-Lambda-Function-${local.name_alias}"
#  role          = aws_iam_role.lambda_role.arn
#  handler       = "lambda_handler.lambda_handler"
#  runtime       = "python3.9"
#  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
#  architectures = ["arm64"]
#
#  ephemeral_storage {
#    size = 10240 # Min 512 MB and the Max 10240 MB
#  }
#
#  environment {
#    variables = {
#      S3_IN_BUCKET_NAME = "${aws_s3_bucket.s3_bucket.bucket}",
#      RDS_HOST          = "${aws_db_instance.rds.address}",
#      RDS_password      = "${aws_db_instance.rds.password}",
#    }
#  }
#}
#
#
#output "teraform_aws_role_output" {
#  value = aws_iam_role.lambda_role.name
#}
#
#output "teraform_aws_role_arn_output" {
#  value = aws_iam_role.lambda_role.arn
#}
#
#output "teraform_logging_arn_output" {
#  value = aws_iam_policy.iam_policy_for_lambda.arn
#}