variable "spa_redirect_uris" {
  type    = list(string)
  default = []
}
variable "spa_web_redirect_urls" {
  type    = list(string)
  default = []
}
variable "ief_redirect_uris" {
  type    = list(string)
  default = []
}

resource "random_uuid" "api_scope_id" {}

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

    single_page_application {
        redirect_uris = []
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

    single_page_application {
        redirect_uris = []
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

    single_page_application {
        redirect_uris = []
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

# azuread_application.kl_alpha_dev:
resource "azuread_application" "kl_alpha_dev" {
    display_name                   = "KL Alpha Dev"
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

resource "azuread_service_principal" "kl_alpha_dev_principle" {
  application_id               = azuread_application.kl_alpha_dev.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.main.object_id]
#   login_url = "http://localhost:3000/"    // not sure if this is needed yet
}

# azuread_application.kl_alpha_dev-auth_service:
resource "azuread_application" "kl_alpha_dev-auth_service" {
    display_name                   = "KL Alpha Dev - Auth Service"
    sign_in_audience               = "AzureADandPersonalMicrosoftAccount"

    api {
        requested_access_token_version = 2

        oauth2_permission_scope {
            admin_consent_description  = "Allows write access to tasks API"
            admin_consent_display_name = "Allows write access to tasks API"
            enabled                    = true
            id                         = "13d81dfa-1cf9-4df7-93d7-7bb6ef0cc08d"
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

    single_page_application {
        redirect_uris = []
    }

    web {
        redirect_uris = []

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