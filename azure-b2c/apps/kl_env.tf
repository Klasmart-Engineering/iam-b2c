variable "spa_web_redirect_urls" {
  type    = list(string)
  default = []
}
variable "spa_redirect_uris" {
  type    = list(string)
  default = []
}

# azuread_application.kl_alpha_dev:
resource "azuread_application" "kl_alpha_dev" {
    display_name                   = var.display_name
    sign_in_audience               = "AzureADandPersonalMicrosoftAccount"
    tags                           = [
        "apiConsumer",
        "singlePageApp",
    ]

    api {
        requested_access_token_version = 2
    }

    required_resource_access {
        resource_app_id = "63a170f9-9d0c-4198-b587-8c63ab59ebdf"

        resource_access {
            id   = "13d81dfa-1cf9-4df7-93d7-7bb6ef0cc08d"
            type = "Scope"
        }
    }
    required_resource_access {
        resource_app_id = "00000003-0000-0000-c000-000000000000"

        resource_access {
            id   = "37f7f235-527c-4136-accd-4a02d197296e"
            type = "Scope"
        }
        resource_access {
            id   = "7427e0e9-2fba-42fe-b0c0-848c9e6a8182"
            type = "Scope"
        }
    }
    required_resource_access {
        resource_app_id = azuread_application.kl_alpha_dev-auth_service.application_id

        dynamic resource_access {
            for_each = azuread_application.kl_alpha_dev-auth_service.api.0.oauth2_permission_scope
            iterator = scope

            content {
                id   = scope.value.id
                type = "Scope"
            }
        }
    }

    single_page_application {
        redirect_uris = var.spa_redirect_uris
    }

    web {
        redirect_uris = var.spa_web_redirect_urls

        implicit_grant {
            access_token_issuance_enabled = false
            id_token_issuance_enabled     = false
        }
    }
}

resource "azuread_application_pre_authorized" "pre_authorized" {
  application_object_id = azuread_application.kl_alpha_dev-auth_service.object_id
  authorized_app_id     = azuread_application.kl_alpha_dev.application_id
  permission_ids        = [random_uuid.api_scope_id.result]
}

resource "azuread_service_principal" "kl_alpha_dev_principle" {
  application_id               = azuread_application.kl_alpha_dev.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.main.object_id]
#   login_url = "http://localhost:3000/"    // not sure if this is needed yet
}