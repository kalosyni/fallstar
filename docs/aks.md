# Azure Kubernetes Service

## Setup

* Have an [Azure](https://portal.azure.com/) account with admin permissions on a subscription (free tiers example)

* [Azure CLI](azure.md#azure-cli)

* Create a Service Account for Azure sign in

```bash
export MSYS_NO_PATHCONV=1
az login
az ad sp create-for-rbac --name <service_principal_name> --role Contributor --scopes /subscriptions/<subscription_id>
```

Note: we can also use an existing Azure AD application and assign it as a Contributor of the Subscription in its IAM)

## Use Terraform to manager a cluster

### Terraform CLI

```bash
# use the sample files
cd samples/output/aks_terraform

# configure secrets values
cp terraform.tfvars.dist terraform.tfvars
vi terraform.tfvars

# connects to Azure
az login

# applies the change (can take several minutes)
export TF_LOG="INFO"
terraform apply

# checks some outputs
export TF_LOG="WARN"
echo "$(terraform output resource_group_name)"

# configures access to the cluster
echo "$(terraform output kube_config)" > ./azurek8s
export KUBECONFIG=./azurek8s

# makes sure you can access the cluster
kubectl get nodes

# once done, do some clean up
terraform plan -destroy -out main.destroy.tfplan
terraform apply main.destroy.tfplan
```

See [Terraform](./terraform.md) page for more information on the setup and details.

References:

* [Create a Kubernetes cluster with Azure Kubernetes Service using Terraform](https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks)
* [Provision an AKS Cluster (Azure)](https://learn.hashicorp.com/tutorials/terraform/aks) ([GitHub](https://github.com/hashicorp/learn-terraform-provision-aks-cluster))
