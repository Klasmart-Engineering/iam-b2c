# azuread_application.klkr-alpha-deployment:
resource "azuread_application" "klkr-alpha-deployment" {
    display_name                   = "klkr-alpha-deployment"
    sign_in_audience               = "AzureADMyOrg"

    api {
        requested_access_token_version = 1

        oauth2_permission_scope {
            admin_consent_description  = "Allow the application to access klkr-alpha-deployment on behalf of the signed-in user."
            admin_consent_display_name = "Access klkr-alpha-deployment"
            enabled                    = true
            id                         = "b103966e-8bd7-4e32-9e37-9512ec00e699"
            type                       = "User"
            user_consent_description   = "Allow the application to access klkr-alpha-deployment on your behalf."
            user_consent_display_name  = "Access klkr-alpha-deployment"
            value                      = "user_impersonation"
        }
    }

    required_resource_access {
        resource_app_id = "00000003-0000-0000-c000-000000000000"

        resource_access {
            id   = "79a677f7-b79d-40d0-a36a-3e6f8688dd7a"
            type = "Role"
        }
    }

    web {
        implicit_grant {
            access_token_issuance_enabled = false
            id_token_issuance_enabled     = true
        }
    }
}

resource "azuread_service_principal" "klkr-alpha-deployment_principle" {
  application_id               = azuread_application.klkr-alpha-deployment.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.main.object_id]
}

resource "azuread_application_password" "klkr-alpha-deployment_bitbucket-password" {
  application_object_id = azuread_application.klkr-alpha-deployment.object_id
  display_name = "BitBucket New"
}
resource "azuread_application_password" "klkr-alpha-deployment_github-password" {
  application_object_id = azuread_application.klkr-alpha-deployment.object_id
  display_name = "Github"
}