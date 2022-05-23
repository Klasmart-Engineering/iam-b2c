# azuread_application.jwt_ms:
resource "azuread_application" "jwt_ms" {
    display_name                   = "jwt.ms"
    sign_in_audience               = "AzureADandPersonalMicrosoftAccount"
    tags                           = [
        "notApiConsumer",
        "webApp",
    ]

    api {
        requested_access_token_version = 2
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

    web {
        redirect_uris = [
            "https://jwt.ms/",
        ]

        implicit_grant {
            access_token_issuance_enabled = true
            id_token_issuance_enabled     = true
        }
    }
}

resource "azuread_service_principal" "jwt_ms_principle" {
  application_id               = azuread_application.jwt_ms.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.main.object_id]
}