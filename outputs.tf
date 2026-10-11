output "zone_id" {
  value       = azurerm_dns_zone.zone.id
  description = "The ID of the DNS zone."
}

output "name_servers" {
  value       = azurerm_dns_zone.zone.name_servers
  description = "The name servers Azure assigned to this zone - point the registrar's NS records here to make Azure authoritative."
}
