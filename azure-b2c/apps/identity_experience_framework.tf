variable "ief_redirect_uris" {
  type    = list(string)
  default = []
}

# azuread_application.IdentityExperienceFramework:
resource "azuread_application" "IdentityExperienceFramework" {
    display_name                   = "IdentityExperienceFramework"
    sign_in_audience               = "AzureADMyOrg"

    api {
        requested_access_token_version = 1

        oauth2_permission_scope {
            admin_consent_description  = "Allow the application to access IdentityExperienceFramework on behalf of the signed-in user."
            admin_consent_display_name = "Access IdentityExperienceFramework"
            enabled                    = true
            id                         = "6f33454d-bbef-4fe5-9a63-971bd784424f"
            type                       = "Admin"
            value                      = "user_impersonation"
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
        redirect_uris = var.ief_redirect_uris

        implicit_grant {
            access_token_issuance_enabled = false
            id_token_issuance_enabled     = false
        }
    }
}

resource "azuread_service_principal" "ief_principle" {
  application_id               = azuread_application.IdentityExperienceFramework.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.main.object_id]
}