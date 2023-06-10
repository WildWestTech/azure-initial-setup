# Go to Cost Management
# Under the Billing section, choose Billing Profiles
# Choose the correct profile from the list.  In my case, "Andrew McLaughlin"
# Now, on the left, you'll see "Invoice Sections" under Billing
# Choose the correct billing section.  Again, mine is "Andrew McLaughlin"
# Once selected, on the left hand side, under settings, choose properties
# Here, you'll find the Invoice Section ID, Billing Profile ID, and Billing Account ID


provider "azurerm" {
  features {}
}

# execute python script to get billing info required for creating subscriptions
data "external" "billing_info" {
  program = ["python", "get_billing_info.py"]
}

# make sure we have executed the python script before trying to use the variables to create additional resources
resource "null_resource" "dependency" {
  triggers = {
    billing_info = jsonencode(data.external.billing_info.result)
  }
  depends_on = [data.external.billing_info]
}

# get the main billing scope we will use for creating the subscriptions
data "azurerm_billing_mca_account_scope" "main" {
  billing_account_name  = data.external.billing_info.result["billing_account"]
  billing_profile_name  = data.external.billing_info.result["billing_profile"]
  invoice_section_name  = data.external.billing_info.result["invoice_section"]
  depends_on = [null_resource.dependency]
}

# create the dev subscription
resource "azurerm_subscription" "dev" {
  subscription_name  = "tf-subscription-dev"
  billing_scope_id   = data.azurerm_billing_mca_account_scope.main.id
  depends_on         = [data.azurerm_billing_mca_account_scope.main]
}

# create the prod subscription
resource "azurerm_subscription" "prod" {
  subscription_name  = "tf-subscription-prod"
  billing_scope_id   = data.azurerm_billing_mca_account_scope.main.id
  depends_on         = [data.azurerm_billing_mca_account_scope.main]
}