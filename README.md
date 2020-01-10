# Deploying and Appservice with Terraform

## Prerequisites

To correctly maintain the state of our Terraform deployment we will require a few resources upfront:

  * A storage account to act as a backend for Terraform.


### Initiate the Azure provider

```bash
terraform init -backend-config="resource_group_name=AksPrerreq-RG" -backend-config="storage_account_name=jorgemartiterraform" -backend-config="container_name=tfstate"
```

## Run Terraform

```
terraform validate
terraform apply
```

Output will show the credentials to connect to the Local Git generated for this Appservice.


## Clone the Local Git created:

```bash
git clone https://\$appservicetf-14235301366062598665:GPkYlcxE5bh30zjo8p5jEmdtiXbRpi0PqZQkh2fz4AefdvdX2nelDm1ezPAX@appservicetf-14235301366062598665.scm.azurewebsites.net/appservicetf-14235301366062598665.git
```

## Limitations

Using external GIT is still not supported:

https://github.com/terraform-providers/terraform-provider-azurerm/issues/3696
