terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_s3_bucket" "neelaupa_bucket" {

  bucket = "neelaupa-bucket-wenjie-02"
  tags = {
    Name        = "nlp bucket"
    Environment = "dev"
  }
}

resource "aws_dynamodb_table" "my_new_table" {
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  name         = "neelaupa_table"
  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "my_items" {
  table_name = aws_dynamodb_table.my_new_table.name
  hash_key   = aws_dynamodb_table.my_new_table.hash_key
  item       = <<EOF

    {
        "id" : {"S" : "0"},
        "views" : {"N" : "1"}  
    }

EOF   

}

resource "aws_iam_role" "terraform_lambda" {
  name = "terraform_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "iam_policy_for_crc" {

  name        = "aws_iam_policy_for_terraform_resume_project_policy"
  path        = "/"
  description = "AWS IAM Policy for managing the resume project role"
  policy = jsonencode(
    {
      Version : "2012-10-17",
      Statement : [
        {
          Action : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource : "arn:aws:logs:*:*:*",
          Effect : "Allow"
        },
        {
          Effect : "Allow"
          Action : [
            "dynamodb:UpdateItem",
            "dynamodb:GetItem",
            "dynamodb:PutItem"
          ]
          Resource = [aws_dynamodb_table.my_new_table.arn]
        },
      ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  policy_arn = aws_iam_policy.iam_policy_for_crc.arn
  role       = aws_iam_role.terraform_lambda.name
}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_file = "${path.module}/lambda/view_count_neelaupa_table.py"
  output_path = "${path.module}/lambda/view_count_neelaupa_table.zip"
}

resource "aws_lambda_function" "count" {
  filename      = data.archive_file.zip_the_python_code.output_path
  function_name = "view_count_neelaupa_table"
  handler       = "view_count_neelaupa_table.lambda_handler"
  role          = aws_iam_role.terraform_lambda.arn
  runtime       = "python3.9"
}

resource "aws_lambda_function_url" "test_neelaupa" {
  function_name      = aws_lambda_function.count.function_name
  authorization_type = "NONE"

  cors {
    allow_origins = ["https://resume.woshipwj.click"]
  }
}