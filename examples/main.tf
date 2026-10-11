module "example" {
  source = "../"

  zone = {
    name                = "example.com"
    resource_group_name = "rsg-example-dns-zone-01"
  }

  records = [
    { type = "A", name = "@", value = "203.0.113.10" },
    { type = "A", name = "dev", value = "203.0.113.11" },
    { type = "CNAME", name = "www", value = "example.com." },
    { type = "MX", name = "@", value = "mail.example.com.", priority = 10 },
    { type = "TXT", name = "@", value = "v=spf1 -all" },
  ]
}
