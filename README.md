
# iam-b2c
Currently using as a testing ground for setting up IAM AzureB2C resources with Terraform.

### switching to a new Tenant for importing state
Change the Tenant ID in provider
```
terraform init -migrate-state
```

### importing manually created resources from the web
```
terraform import azuread_application.kl_alpha_dev-auth_service 9d4abf48-6955-4326-9ffc-308c12175118 // object_id in the case of azure apps
```

### generate a tcl format of the terraform.tfstate resources
```
terraform show ./terraform.tfstate
```


### notes
I took out the 'owners' block from the jwt_ms application. It had Tom's ID set as the Owner. This is probably not a step we'll automate so I'll leave it out.
