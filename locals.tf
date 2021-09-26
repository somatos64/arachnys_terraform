locals {
#   gh_repo = "somatos64/arachnys_terraform"
    gh_repo = "somatos64/ac_terraform"

  environment                 = "${lower(terraform.workspace)}"
#   terraform_project         = "arachnys/take_home_test"
    terraform_project         = "ac/tht"

  application               = "sentry"
  aws_region = "eu-west-1"

  instance_type = "t2.medium"

  tags = {
    owner                = "devops"
    created_by           = "terraform"
    environment          = local.environment
    application          = local.application
    created_at           = "${timestamp()}"
    # Name = local.application
  }

}