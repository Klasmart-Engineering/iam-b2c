data "azuread_client_config" "main" {}

resource "random_uuid" "api_scope_id" {}