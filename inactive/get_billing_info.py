#pip install azure-identity azure-mgmt-billing

import subprocess
import json

# PowerShell script
ps_script = '''
$displayName = 'Andrew McLaughlin'
$billingDisplayName = 'Andrew McLaughlin Billing Profile'
$billing_account = az billing account list --query "[?displayName=='$displayName'].name | [0]"
$billing_profile = az billing profile list --account-name $billing_account --query "[?displayName=='$billingDisplayName'].name | [0]"
$invoice_section = az billing invoice section list --account-name $billing_account --profile-name $billing_profile --query "[].name | [0]"

$data = @{
    billing_account = $billing_account.Trim('"')
    billing_profile = $billing_profile.Trim('"')
    invoice_section = $invoice_section.Trim('"')
}

$data | ConvertTo-Json
'''

# Execute PowerShell script
result = subprocess.run(['powershell', '-command', ps_script], capture_output=True, text=True)
billing_data = json.loads(result.stdout)

billing_account = billing_data['billing_account']
billing_profile = billing_data['billing_profile']
invoice_section = billing_data['invoice_section']

# Create a dictionary with the data
data = {
    "billing_account": billing_account,
    "billing_profile": billing_profile,
    "invoice_section": invoice_section,
}

# Print the data as JSON
print(json.dumps(data))