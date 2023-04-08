module "grafana" {
  source = "../../../modules/grafana"

  grafana_workspace_name = var.grafana_workspace_name

}