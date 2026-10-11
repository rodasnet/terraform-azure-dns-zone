variable "zone" {
  description = "The DNS zone to manage."
  type = object({
    name                = string
    resource_group_name = string
    tags                = optional(map(string))
  })
}

variable "records" {
  description = <<-EOT
    Flat list of DNS records - one entry per literal record value. Entries
    that share the same type and name are grouped into a single Azure record
    set (e.g. two A entries named "@" become one azurerm_dns_a_record with
    two addresses). CNAME only accepts one value per name; Azure rejects a
    second entry sharing a CNAME's type+name at plan time via the
    precondition below rather than a confusing provider error.
  EOT
  type = list(object({
    type     = string           # A, AAAA, CNAME, MX, TXT, or NS
    name     = string           # record name relative to the zone apex, "@" for apex
    value    = string           # target: IP, CNAME/MX target, TXT content, or NS hostname
    ttl      = optional(number, 3600)
    priority = optional(number) # required for MX, ignored otherwise
  }))
  default = []
}
