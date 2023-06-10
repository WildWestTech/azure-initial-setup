from azure.identity import DefaultAzureCredential
from azure.mgmt.subscription import SubscriptionClient

# Authenticate using the default Azure credentials
credential = DefaultAzureCredential()

# Create a SubscriptionClient instance
subscription_client = SubscriptionClient(credential)

# Retrieve a list of subscriptions
subscriptions = subscription_client.subscriptions.list()

# Iterate over the subscriptions and print their details
for subscription in subscriptions:
    print("Subscription ID:", subscription.subscription_id)
    print("Subscription Name:", subscription.display_name)
    print("Subscription State:", subscription.state)
    print("-" * 30)
