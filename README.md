# Deploying and Appservice with Terraform

## Resources Deployed in this project

The following Azure resources will be created by this project:

* **Appservice** and **Appservice plan**: Our application will run in this Appservice. As indicated below in _Limitations_, we can only create Appservices with Local Git repositories (appservice-managed git repo).
* **SQL Server** and **Database**: This database is configured in the Connection String of the Appservice. Firewall rule is also defined.

## Prerequisites

### Azure prerequisites

Apart from the obvious *Azure subscription* and *resource group* necessary to deploy the resources specified in this project, we will require some additional resources upfront to correctly maintain the state of our Terraform deployment:

  * A **resource group**: Can be a dedicated one for Terraform prerequisites (for instance `terraform-prereq-RG`) used by other projects, or the same resource group where this project's resources will be deployed.
  * A **container** inside a **storage account** to act as a *backend* for Terraform.

These resources can be created from console:

```bash
# Create storage account
az storage account create -n terraform-prereq-SA -g terraform-prereq-RG -l westeurope
# Create container
az storage container create -n tfstate --account-name terraform-prereq-SA
```

## Deploying resources

### Run Terraform manually

Initiate the Azure provider:

```bash
terraform init -backend-config="resource_group_name=terraform-prereq-RG" -backend-config="storage_account_name=terraform-prereq-SA" -backend-config="container_name=tfstate"
```
Then run terraform:

```
terraform validate
terraform apply
```

Output will show the credentials to connect to the Local Git generated for this Appservice, as well as the URL to correctly access the application.

### Deploying resources using Azure DevOps pipeline

In case we want to deploy these resources in a CI/CD pipeline in Azure Devops, we have two additional prerequisites:

1. **Service Connection to Azure**

A *Service Connection* (or service *endpoint*) stores the credentials used in the pipeline to create Azure resources, which have some credentials with permissions on Azure (a _Service Principal_). The name of the service principal will be passed to the pipeline as a *group variable* in the Library.

![](img/README2020-02-26-12-25-34.png)

A service connection for Azure looks as the following one:

![](img/README2020-02-26-12-28-28.png)

2. **Group variable**

The `azure-pipelines.yml` definition has been configured to make use of a **Variable group** from the pipeline library, named `configurations`, which must include a variable named `azurespn`

![](img/README2020-02-26-12-19-00.png)

Once these two resources have been properly configured in the Azure DevOps project, we can run the pipeline and the resources will be automatically created.

## Limitations

Using external GIT to initialize the Appservice is still not supported:

https://github.com/terraform-providers/terraform-provider-azurerm/issues/3696

For this reason, we have to do some extra steps in order to upload some sample _.Net Core application_ to our newly deployed Appservice:

### Clone the Local Git created:

Use the credentials provided by Terraform. Watch out to escape the **$**:

```bash
git clone https://\$appservicetf-14235301366062598665:GPkYlcxE5bh30zjo8p5jEmdtiXbRpi0PqZQkh2fz4AefdvdX2nelDm1ezPAX@appservicetf-14235301366062598665.scm.azurewebsites.net/appservicetf-14235301366062598665.git
```
### Copy the Sample App contents

In the link below you can find a sample example for **.Net Core running on Azure Webapp service**, which has been modified to make use on the _Connection String_ defined in this project. (original code is [here](https://docs.microsoft.com/en-us/azure/app-service/app-service-web-tutorial-dotnetcore-sqldb)).

https://github.com/jorgemarti/dotnetcore-sqldb-tutorial/archive/master.zip

Download it, uncompress the contents in the **cloned** folder, and commit and push the changes.

```bash
cd appservicetf-15167248704238094624/
git add .
git commit -m "Adding application"
git push
```

The Azure Appservice will provide an exit similar to this one:

```
Counting objects: 91, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (87/87), done.
Writing objects: 100% (91/91), 665.25 KiB | 1.63 MiB/s, done.
Total 91 (delta 16), reused 0 (delta 0)
remote: Updating branch 'master'.
remote: Updating submodules.
remote: Preparing deployment for commit id 'd00e317069'.
remote: Generating deployment script.
remote: Project file path: .\DotNetCoreSqlDb.csproj
remote: Running deployment command...
[...]
remote: Finished successfully.
remote: Running post deployment command(s)...
remote: Triggering recycle (preview mode disabled).
remote: Deployment successful.
To https://appservicetf-15167248704238094624.scm.azurewebsites.net/appservicetf-15167248704238094624.git
 * [new branch]      master -> master
 ```

 After this, we only need to access the project website URL. Ex:

 https://appservicetf-15167248704238094624.azurewebsites.net

If the connection to the database is successful, we can observe the sample _To-do_ application deployed, and can create some test entries:

![](img/README2020-01-13-12-55-21.png)

