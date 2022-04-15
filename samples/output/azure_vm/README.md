# Create a VM in Azure with Terraform

## Quick start

```bash
# (only once) generates .terraform.lock.hcl file
terraform init

# formats the Terraform files
terraform fmt

# (optional) sets proxy variables
export HTTP_PROXY="http://<username>:<password>@<proxy>:<port>"
export HTTPS_PROXY="http://<username>:<password>@<proxy>:<port>"

# logs in Azure
az login

# reviews available vm skus
 az vm list-skus --location westeurope --size Standard_D --all --output table

# plans the changes
terraform plan

# applies the changes
terraform apply --auto-approve
```

## References

* [SUSE/ha-sap-terraform-deployments](https://github.com/SUSE/ha-sap-terraform-deployments)
