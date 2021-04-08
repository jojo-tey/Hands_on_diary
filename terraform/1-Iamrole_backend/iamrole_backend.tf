# vim ~/.aws/credentials

# [default]
# aws_access_key_id = < Your Access Key ID >
# aws_secret_access_key = < Your Secret Access Key >

# check:
# aws s3 ls



provider "aws" {
  region  = "ap-northeast-2" # Please use the default region ID
  version = "~> 2.49.0"      # Please choose any version or delete this line if you want the latest version
}

# S3 bucket for backend
resource "aws_s3_bucket" "tfstate" {
  bucket = "${var.account_id}-apnortheast2-tfstate"

  versioning {
    enabled = true # Prevent from deleting tfstate file
  }
}

# DynamoDB for terraform state lock
resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform-lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}

variable "account_id" {
  default = "dayone-id" # Please use the account alias for id
}

# command
# terraform init
# terraform apply -parallelism=30



# vim terraform/iam/dayone-id/backend.tf

terraform {
  required_version = "= 0.12.18" # Terraform Version 
​
  backend "s3" {
    bucket         = "dayone-id-apnortheast2-tfstate" # Set bucket name 
    key            = "dayone/terraform/iam/dayone-id/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "terraform-lock" # Set DynamoDB Table
  }
}

# vim provider.tf
provider "aws" {
  region = "us-east-1" # IAM is global
}


# Permission

#### Permission to rotate key
resource "aws_iam_policy" "RotateKeys" {
  name        = "RotateKeys"
  description = "allow users to change their aws keys, and passwords."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:*LoginProfile",
                "iam:*AccessKey*",
                "iam:*SSHPublicKey*"
            ],
            "Resource": "arn:aws:iam::${var.account_id}:user/$${aws:username}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:ListAccount*",
                "iam:GetAccountSummary",
                "iam:GetAccountPasswordPolicy",
                "iam:ListUsers"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

#### Permission to self managed MFA
resource "aws_iam_policy" "SelfManageMFA" {
  name        = "SelfManageMFA"
  description = "allow a user to manage their own MFA device."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowUsersToCreateDeleteTheirOwnVirtualMFADevices",
            "Effect": "Allow",
            "Action": [
                "iam:*VirtualMFADevice"
            ],
            "Resource": [
                "arn:aws:iam::${var.account_id}:mfa/$${aws:username}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "iam:GetAccountPasswordPolicy",
            "Resource": "*"
        },
        {
            "Sid": "AllowUsersToManageTheirOwnPassword",
            "Effect": "Allow",
            "Action": [
                "iam:ChangePassword"
            ],
            "Resource": [
                "arn:aws:iam::${var.account_id}:user/$${aws:username}"
            ]
        },
        {
            "Sid": "AllowUsersToEnableSyncDisableTheirOwnMFADevices",
            "Effect": "Allow",
            "Action": [
                "iam:DeactivateMFADevice",
                "iam:EnableMFADevice",
                "iam:ListMFADevices",
                "iam:ResyncMFADevice"
            ],
            "Resource": [
                "arn:aws:iam::${var.account_id}:user/$${aws:username}"
            ]
        },
        {
            "Sid": "AllowUsersToListVirtualMFADevices",
            "Effect": "Allow",
            "Action": [
                "iam:ListVirtualMFADevices"
            ],
            "Resource": [
                "arn:aws:iam::${var.account_id}:mfa/*"
            ]
        },
        {
            "Sid": "AllowUsersToListUsersInConsole",
            "Effect": "Allow",
            "Action": [
                "iam:ListUsers"
            ],
            "Resource": [
                "arn:aws:iam::${var.account_id}:user/*"
            ]
        }
    ]
}
EOF
}

#### Force user to use MFA for security issue
resource "aws_iam_policy" "ForceMFA" {
  name        = "ForceMFA"
  description = "disallow a user anything unless MFA enabled"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DoNotAllowAnythingOtherThanAboveUnlessMFAd",
            "Effect": "Deny",
            "NotAction": [
                "iam:*",
                "sts:AssumeRole",
                "s3:*",
                "dynamodb:*",
                "*"
            ],
            "Resource": "*",
            "Condition": {
                "Null": {
                    "aws:MultiFactorAuthAge": "true"
                }
            }
        }
    ]
}
EOF
}


# Setting Module

# vim terraform/iam/dayone-id/_module_assume_policy/main.tf

resource "aws_iam_policy" "policy" {
  name        = "assume-${var.aws_account}-${var.subject}-policy"
  path        = "/"
  description = "${var.aws_account}-${var.subject}-policy"
  policy      = data.aws_iam_policy_document.policy-document.json
}

data "aws_iam_policy_document" "policy-document" {
  statement {
    effect = "Allow"

    resources = var.resources

    actions = [
      "sts:AssumeRole",
    ]
  }
}


### Create policies for allowing user to assume the role in the production account
### You can copy this file and change `prod` to other environment if you have any other account

# Admin Access policy 
# If this policy is applied, then you will be able to assume role in the production account with admin permission
module "dayone_prod_admin" {
  source      = "./_module_assume_policy/"
  aws_account = "dayone-prod"
  subject     = "admin"
  resources   = ["arn:aws:iam::${var.prod_account_id}:role/assume-dayone-prod-admin"]
}

output "assume_dayone_prod_admin_policy_arn" {
  value = module.dayone_prod_admin.assume_policy_arn
}

# Poweruser Access policy 
# If this policy is applied, then you will be able to assume role in the production account with poweruser permission
module "dayone_prod_poweruser" {
  source      = "./_module_assume_policy/"
  aws_account = "dayone-prod"
  subject     = "poweruser"
  resources   = ["arn:aws:iam::${var.prod_account_id}:role/assume-dayone-prod-poweruser"]
}

output "assume_dayone_prod_poweruser_policy_arn" {
  value = module.dayone_prod_poweruser.assume_policy_arn
}


# ReadOnly Access policy 
# If this policy is applied, then you will be able to assume role in the production account with readonly permission
module "dayone_prod_readonly" {
  source      = "./_module_assume_policy/"
  aws_account = "dayone-prod"
  subject     = "readonly"
  resources   = ["arn:aws:iam::${var.prod_account_id}:role/assume-dayone-prod-readonly"]
}

output "assume_dayone_prod_readonly_policy_arn" {
  value = module.dayone_prod_readonly.assume_policy_arn
}



# Create Each team group and user 

# group_dayone_devops_black 
# User group for ADMIN in all account
# 모든 계정에서 ADMIN 권한을 사용할 수 있는 사용자의 그룹

# group_dayone_devops_white
# User group for READ-ONLY in all account
# 모든 계정에서 READ-ONLY 권한을 사용할 수 있는 사용자의 그룹

############## Dayone DevOps Group ##################
resource "aws_iam_group" "dayone_devops_black" {
  name = "dayone_devops_black"
}

resource "aws_iam_group_membership" "dayone_devops_black" {
  name = aws_iam_group.dayone_devops_black.name

  users = [
    aws_iam_user.admin_dayone.name
  ]

  group = aws_iam_group.dayone_devops_black.name
}

#######################################################

########### Dayone DevOps users #####################

resource "aws_iam_user" "admin_dayone" {  
  name = "admin@dayone.com"       # Edit this value to the username you want to use 
}

#######################################################

############### DevOps Basic Policy ##################
######################################################

########### DevOps Assume Policies ####################
resource "aws_iam_group_policy_attachment" "dayone_devops_black" {
  count      = length(var.userassume_policy_dayone_devops_black)
  group      = aws_iam_group.dayone_devops_black.name
  policy_arn = var.userassume_policy_dayone_devops_black[count.index]
}

variable "userassume_policy_dayone_devops_black" {
  description = "IAM Policy to be attached to user"
  type        = list(string)

  default = [
    # Please change <account_id> to the real account id number of id account 
    "arn:aws:iam::<account_id>:policy/assume-dayone-prod-admin-policy", # Add admin policy to black group user 
  ]
}

#######################################################


############### MFA Manager ###########################
resource "aws_iam_group_policy_attachment" "dayone_devops_black_rotatekeys" {
  group      = aws_iam_group.dayone_devops_black.name
  policy_arn = aws_iam_policy.RotateKeys.arn
}

resource "aws_iam_group_policy_attachment" "dayone_devops_black_selfmanagemfa" {
  group      = aws_iam_group.dayone_devops_black.name
  policy_arn = aws_iam_policy.SelfManageMFA.arn
}

resource "aws_iam_group_policy_attachment" "dayone_devops_black_forcemfa" {
  group      = aws_iam_group.dayone_devops_black.name
  policy_arn = aws_iam_policy.ForceMFA.arn
}

#######################################################

