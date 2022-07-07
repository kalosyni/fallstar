namespace Fallstar.Domain.Models
{
    public enum ProviderType
    {
        AWS,
        Azure,
        GCP,
        Rancher,
        None
    }

    public enum ProvisioningType
    {
        Bash,
        Terraform,
        None
    }

    public class ProjectResourceModel
    {
        public string Name { get; set; } = string.Empty;

        public string ResourceType { get; set; } = string.Empty;

        public string ProjectId { get; set; } = string.Empty;

        public string ProjectName { get; set; } = string.Empty;

        public ProviderType ProviderType { get; set; } = ProviderType.None;

        public ProvisioningType ProvisioningType { get; set; } = ProvisioningType.None;
    }
}
