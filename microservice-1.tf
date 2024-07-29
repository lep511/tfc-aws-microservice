# DynamoDB Table
locals {
  example_data = csvdecode(file("data/example_orders.csv"))
}
resource "random_orders" "table_name" {
  prefix    = "orders"
  separator = "_"
  length    = 4
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = random_orders.table_name.id
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "SourceOrderID"
  range_key      = "SourceItemID"

  attribute {
    name = "SourceOrderID"
    type = "N"
  }

  attribute {
    name = "SourceItemID"
    type = "N"
  }
  tags = {
    "Name"        = "dynamodb-table-1"
    "Environment" = "production"
    "Project"     = "${var.default_tags.project}"
  }
}

resource "aws_dynamodb_table_item" "example" {
  for_each = var.load_example_data ? { for row in local.example_data : row.eventId => row } : {}

  table_name = random_orders.table_name.id
  hash_key   = "SourceOrderID"
  range_key  = "SourceItemID"

  item = <<EOF
{
    "SourceOrderID": {"N": "${each.value.SourceOrderID}"},
    "SourceItemID": {"N": "${each.value.SourceItemID}"},
    "DestinationName": {"S": "${each.value.DestinationName}"},
    "ItemSKU": {"S": "${each.value.ItemSKU}"},
    "ShipToName": {"S": "${each.value.ShipToName}"},
    "ShipToCompany": {"S": "${each.value.ShipToCompany}"},
    "ShipToAddress": {"S": "${each.value.ShipToAddress}"},
    "ShipToTown": {"S": "${each.value.ShipToTown}"},
    "CarrierCode": {"S": "${each.value.CarrierCode}"},
    "CarrierService": {"S": "${each.value.CarrierService}"},
}
EOF

  lifecycle {
    ignore_changes = [item]
  }
}