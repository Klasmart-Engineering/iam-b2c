# azuread_application.ProxyIdentityExperienceFramework:
resource "azuread_application" "ProxyIdentityExperienceFramework" {
    display_name                   = "ProxyIdentityExperienceFramework"
    fallback_public_client_enabled = true
    sign_in_audience               = "AzureADMyOrg"

    api {
        requested_access_token_version = 1
    }

    public_client {
        redirect_uris = [
            "myapp://auth",
        ]
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
        resource_app_id = "a8e3742c-2fde-441c-a25e-494cf89f5911"

        resource_access {
            id   = "6f33454d-bbef-4fe5-9a63-971bd784424f"
            type = "Scope"
        }
    }

    web {
        redirect_uris = []

        implicit_grant {
            access_token_issuance_enabled = false
            id_token_issuance_enabled     = false
        }
    }
}

resource "azuread_service_principal" "pief_principle" {
  application_id               = azuread_application.ProxyIdentityExperienceFramework.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.main.object_id]
}