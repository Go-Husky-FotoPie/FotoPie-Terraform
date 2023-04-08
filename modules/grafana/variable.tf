variable "grafana_workspace_name" {
    description  = "workspace name for grafana"
    default      = "fotopie-grafana"
}


variable "aws_user_id" {
    description  = "IAM user SSO"
    default      = ["892e04d8-b051-7039-9ea8-c0d930e9747a"]
}

variable "aws_group_id" {
    description  = "IAM group for grafana workspace"
    default      = ["897e24a8-7021-700f-5a24-bb259095601b"]
}