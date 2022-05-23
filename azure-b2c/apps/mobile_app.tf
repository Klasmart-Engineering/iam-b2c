# azuread_application.mobile_app:
resource "azuread_application" "mobile_app" {
    display_name                   = "KidsLoop Mobile App"
    fallback_public_client_enabled = true
    # owners                         = [
    #     "1fc1645e-b694-4d05-b10d-748add197824",
    # ]
    sign_in_audience               = "AzureADandPersonalMicrosoftAccount"

    api {
        requested_access_token_version = 2
    }
    public_client {
        redirect_uris = [
            "live.kidsloop.sso.kidsloop-android://oauth/redirect",
            "msauth://uk.co.kidsloop/VzSiQcXRmi2kyjzcA%2BmYLEtbGVs%3D",
        ]
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

    web {
        implicit_grant {
            access_token_issuance_enabled = false
            id_token_issuance_enabled     = false
        }
    }
}

resource "azuread_service_principal" "mobile_app_principle" {
  application_id               = azuread_application.mobile_app.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.main.object_id]
}