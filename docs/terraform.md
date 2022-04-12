# Terraform

## Command line

### Installation

```bash
# installs on Ubuntu
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```

→ [Terraform](https://www.terraform.io/downloads)

### Command line cheat sheet

```bash
# checks version
terraform --version

# formats Terraform files
terraform fmt

# initializes the workspace and updates providers and state
terraform init

# sets environment variables (for other configuration see the troubleshooting paragraph below)
export TF_LOG="INFO"

# creates the plan
terraform plan -out main.tfplan

# displays the plan
terraform graph

# creates a graph image
terraform graph -type=plan | dot -Tpng -o graph.png

# applies the plan (the plan is optional in this command)
terraform apply -auto-approve main.tfplan
```

### Troubleshooting hanging responses

```bash
# https://www.terraform.io/internals/debugging
export TF_LOG="TRACE"

# can fix infinite loop hanging with corporate proxy
export HTTP_PROXY="http://<username>:<password>@<proxy>:<port>"
export HTTPS_PROXY="http://<username>:<password>@<proxy>:<port>"
```

See also [Terraform and WSL2 issues](https://www.cryingcloud.com/blog/2022/2/21/terraform-and-wsl2-issue) referring to [WSL #5420](
https://github.com/microsoft/WSL/issues/5420#issuecomment-646479747)
