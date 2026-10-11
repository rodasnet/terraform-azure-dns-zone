locals {
  record_keys = distinct([for r in var.records : "${r.type}|${r.name}"])

  grouped_records = {
    for key in local.record_keys : key => [
      for r in var.records : r if "${r.type}|${r.name}" == key
    ]
  }

  a_records     = { for k, recs in local.grouped_records : k => recs if recs[0].type == "A" }
  aaaa_records  = { for k, recs in local.grouped_records : k => recs if recs[0].type == "AAAA" }
  cname_records = { for k, recs in local.grouped_records : k => recs if recs[0].type == "CNAME" }
  mx_records    = { for k, recs in local.grouped_records : k => recs if recs[0].type == "MX" }
  txt_records   = { for k, recs in local.grouped_records : k => recs if recs[0].type == "TXT" }
  ns_records    = { for k, recs in local.grouped_records : k => recs if recs[0].type == "NS" }
}

resource "azurerm_dns_a_record" "record" {
  for_each = local.a_records

  name                = each.value[0].name
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = azurerm_dns_zone.zone.resource_group_name
  ttl                 = each.value[0].ttl
  records             = [for r in each.value : r.value]
}

resource "azurerm_dns_aaaa_record" "record" {
  for_each = local.aaaa_records

  name                = each.value[0].name
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = azurerm_dns_zone.zone.resource_group_name
  ttl                 = each.value[0].ttl
  records             = [for r in each.value : r.value]
}

resource "azurerm_dns_cname_record" "record" {
  for_each = local.cname_records

  name                = each.value[0].name
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = azurerm_dns_zone.zone.resource_group_name
  ttl                 = each.value[0].ttl
  record              = each.value[0].value

  lifecycle {
    precondition {
      condition     = length(each.value) == 1
      error_message = "CNAME record \"${each.value[0].name}\" has ${length(each.value)} values - Azure allows only one CNAME target per name."
    }
  }
}

resource "azurerm_dns_mx_record" "record" {
  for_each = local.mx_records

  name                = each.value[0].name
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = azurerm_dns_zone.zone.resource_group_name
  ttl                 = each.value[0].ttl

  dynamic "record" {
    for_each = each.value
    content {
      preference = record.value.priority
      exchange   = record.value.value
    }
  }
}

resource "azurerm_dns_txt_record" "record" {
  for_each = local.txt_records

  name                = each.value[0].name
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = azurerm_dns_zone.zone.resource_group_name
  ttl                 = each.value[0].ttl

  dynamic "record" {
    for_each = each.value
    content {
      value = record.value.value
    }
  }
}

resource "azurerm_dns_ns_record" "record" {
  for_each = local.ns_records

  name                = each.value[0].name
  zone_name           = azurerm_dns_zone.zone.name
  resource_group_name = azurerm_dns_zone.zone.resource_group_name
  ttl                 = each.value[0].ttl
  records             = [for r in each.value : r.value]
}
