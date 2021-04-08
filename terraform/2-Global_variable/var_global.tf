# Account ID
# VPC(Amazon Virtual Private Cloud)
# IAM(AWS Identity and Access Management)
# WAF(AWS Web Application Firewall)
# KMS(Amazon Key Management Service)


# Atlantis user
variable "atlantis_user" {
  description = "The username that will be triggering atlantis commands. This will be used to name the session when assuming a role. More information - https://github.com/runatlantis/atlantis#assume-role-session-names"
  default     = "atlantis_user"
}

# Account IDs
# Add all account ID to here 
variable "account_id" {
  default = {
    prod = "xxxxxxxxxx"
  }
}

# Remote State that will be used when creating other resources
# You can add any resource here, if you want to refer from others
variable "remote_state" {
  default = {
    # VPC
    vpc = {
      dayonedapne2 = {
        region = "ap-northeast-2"
        bucket = "dayone-prod-apnortheast2-tfstate"
        key    = "dayone/terraform/vpc/dayoned_apnortheast2/terraform.tfstate"
      }

      dayonepapne2 = {
        region = "ap-northeast-2"
        bucket = "dayone-prod-apnortheast2-tfstate"
        key    = "dayone/terraform/vpc/dayonep_apnortheast2/terraform.tfstate"
      }
    }


    # WAF ACL
    waf_web_acl_global = {
      prod = {
        region = ""
        bucket = ""
        key    = ""
      }
    }


    # AWS IAM
    iam = {
      prod = {
        region = "ap-northeast-2"
        bucket = "dayone-prod-apnortheast2-tfstate"
        key    = "dayone/terraform/iam/dayone-prod/terraform.tfstate"
      }
    }


    # AWS KMS
    kms = {
      prod = {
        apne2 = {
          region = ""
          bucket = ""
          key    = ""
        }
      }
    }
  }
}


# Variable related domain

# Route53 Zone ID
# ACM(Amazon Certificate Manager)

#To use the global variable defined in the upper folder, you need to move the file to the directory. At this time, soft link is created and used for efficient code operation.

variable "r53_variables" {
  default = {
    prod = {
      dayone_io_zone_id = ""

      star_dayone_io_acm_arn_apnortheast2 = ""
      star_dayone_io_acm_arn_useast1      = ""
      www_dayone_io_acm_arn_useast1       = ""
    }
  }
}
