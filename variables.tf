variable "default_tags" {
  type        = map(string)
  description = "Map of default tags to apply to resources"
  default = {
    project = "terraform-aws-microservices"
  }
}

variable "region" {
  type        = string
  description = "The region to deploy resources to"
}

# DynamoDB Table Name
variable "dynamo_table_name" {
  type        = string
  description = "DynamoDB Table Name"
  default = "GameScores"
}
