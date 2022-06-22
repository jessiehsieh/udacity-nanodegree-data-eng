locals {
  required_tags = {
    repository  = var.repository,
    service     = var.service,
    stage       = var.stage
  }
}