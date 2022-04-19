# Azure

## Azure CLI

```bash
# checks version
az --version

# installs on Ubuntu
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

→ [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

## Azure Virtual Machines (VM)

```bash
# updates user password
az vm user update \
  --resource-group <resource_group_name> \
  --name <vm_resource_name> \
  --username <username> \
  --password <password>
```
