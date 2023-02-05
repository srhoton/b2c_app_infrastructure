variable "az_mapping" {
  description = "AZ names to their zones"
  default = {
    "private-1" = "us-west-2a"
    "private-2" = "us-west-2b"
    "private-3" = "us-west-2c"
    "public-1" = "us-west-2a"
    "public-2" = "us-west-2b"
    "public-3" = "us-west-2c"

  }
}

variable "feature" {
    description = "The feature branch we are deploying"
    type = string
    default = ""
}
variable "cluster_identifier" {
    description = "The source arn for RDS cloning"
    type = string
    default = "arn:aws:rds:us-east-1:705740530616:cluster:b2c-rds-cluster"
}

variable "acm_certificate" {
  description = "The ACM certificate ARN to use with Cloudfront"
  type = string
}

variable "route53_zone" {
  description = "The route53 zone to use with Cloudfront"
  type = string
}
