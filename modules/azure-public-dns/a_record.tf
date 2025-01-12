# Should either be a list of records or a target_resource_id (Alias)
resource "azurerm_dns_a_record" "this" {
  for_each = { for record in var.a_recordsets :
    record.name => record
  }


  resource_group_name = lower(var.resource_group_name)
  zone_name           = azurerm_dns_zone.zone.name

  name               = lower(each.value.name)
  ttl                = each.value.ttl
  records            = length(lookup(each.value, "record", [])) == 0 ? null : each.value.record
  target_resource_id = length(lookup(each.value, "record", [])) == 0 ? each.value.alias_target_resource_id : null
}