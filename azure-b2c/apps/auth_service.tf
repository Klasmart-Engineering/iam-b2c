# azuread_application.kl_alpha_dev-auth_service:
resource "azuread_application" "kl_alpha_dev-auth_service" {
    display_name                   = "KL Alpha Dev - Auth Service"
    sign_in_audience               = "AzureADandPersonalMicrosoftAccount"
    identifier_uris                = ["api://kl-auth-service"]

    api {
        requested_access_token_version = 2

        oauth2_permission_scope {
            admin_consent_description  = "Allows write access to tasks API"
            admin_consent_display_name = "Allows write access to tasks API"
            enabled                    = true
            id                         = random_uuid.api_scope_id.result
            type                       = "Admin"
            value                      = "tasks.write"
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

resource "azuread_service_principal" "kl_alpha_dev-auth_service_principle" {
  application_id               = azuread_application.kl_alpha_dev-auth_service.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.main.object_id]
#   login_url = "http://localhost:3000/"    // not sure if this is needed yet
}