region = "eu-west-1"
name = "worth"
vpc_cidr = "10.0.0.0/16"
tags = {
    Blueprint  =  "worth"
    GithubRepo = "github.com/ljenecker/worth"
  }

container_name = "worth"
container_port = 8080


github_token_secret_name   = "ecs-github-token"
postgresdb_master_password = "postgresdb_passwd"
repository_owner           = "ljenecker" // change
repository_name            = "worth-cloud"  // change
repository_branch          = "main"
