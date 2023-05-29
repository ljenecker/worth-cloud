variable "region" {
  description = "The region where AWS operations will take place."
  type        = string
}

variable "name" {
  description = "The name of your project."
  type        = string
}

variable "vpc_cidr" {
  description = "The cidr of your VPC."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type = object({
    Blueprint    = string
    GithubRepo = string
  })
}


# variable "app_name" {
#   description = "The name of your app."
#   type        = string
# }

variable "container_name" {
  description = "The name of your container."
  type        = string
}

variable "container_port" {
  description = "The port of your container."
  type        = number
}

variable "repository_owner" {
  description = "The name of the owner of the Github repository"
  type        = string
  default     = "ljenecker"
}

variable "repository_name" {
  description = "The name of the Github repository"
  type        = string
  default     = "worth"
}

variable "repository_branch" {
  description = "The name of branch the Github repository, which is going to trigger a new CodePipeline excecution"
  type        = string
  default     = "main"
}

variable "github_token_secret_name" {
  description = "Name of secret manager secret storing github token for auth"
  type        = string
}

variable "postgresdb_master_password" {
  description = "AWS secrets manager secret name that stores the db master password"
  type        = string
  sensitive   = true
}
