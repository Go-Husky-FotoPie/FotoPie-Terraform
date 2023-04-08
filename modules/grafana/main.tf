#  Create AWS Managed Service for Grafana
module "managed_grafana" {
  source = "terraform-aws-modules/managed-service-grafana/aws"
  version = "1.8.0"

  # Workspace
  name                      = var.grafana_workspace_name
  description               = "grafana for ecs"
  account_access_type       = "CURRENT_ACCOUNT"
  authentication_providers  = ["AWS_SSO"]
  permission_type           = "SERVICE_MANAGED"
  data_sources              = ["SITEWISE","CLOUDWATCH","AMAZON_OPENSEARCH_SERVICE","TIMESTREAM","REDSHIFT","ATHENA","PROMETHEUS","XRAY"]
  notification_destinations = ["SNS"]
  associate_license         = "false"

# Role associations
  role_associations = {
    "ADMIN" = {
      "group_ids" = var.aws_group_id
    }
    "ADMIN" = {
      "user_ids" = var.aws_user_id
    }
  }
}


  
