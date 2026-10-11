resource "azurerm_dns_zone" "zone" {
  name                = var.zone.name
  resource_group_name = var.zone.resource_group_name
  tags                = var.zone.tags
}
