# Azure private networking

[![Source validation](https://github.com/Pmen225/azure-private-networking/actions/workflows/validate.yml/badge.svg?branch=main)](https://github.com/Pmen225/azure-private-networking/actions/workflows/validate.yml)

Terraform configuration for private access to Azure Blob Storage and Key Vault from a Linux VM. Separate subnets contain the workload, private endpoints and Azure Bastion. Public network access is disabled on both data services, while Bastion provides the administrative entry point.

## Architecture

```text
Administrator -> public Azure Bastion endpoint -> SSH -> private Linux VM
                                                        |
                                                        +-> Blob private endpoint
                                                        +-> Key Vault private endpoint

VNet links -> private DNS zones -> service hostname resolution
```

The default VNet uses `10.40.0.0/16` in UK South. The workload subnet is `10.40.1.0/24`, private endpoints use `10.40.2.0/24`, and Bastion uses `10.40.3.0/26`. The Ubuntu 22.04 VM uses Standard_B1s compute and has no public IP.

Private DNS zones for `privatelink.blob.core.windows.net` and `privatelink.vaultcore.azure.net` are linked to the VNet. Each private endpoint has a matching DNS zone group. Outputs expose the service hostnames and private endpoint addresses for inspection.

## Security boundaries

- The workload NSG permits inbound SSH from the Bastion subnet and denies other inbound traffic
- VM password authentication is disabled; provisioning requires an SSH public key
- Basic Bastion has a public IP, with no public IP attached to the VM
- Blob Storage public network access, anonymous access and shared key authentication are disabled
- Key Vault uses Azure RBAC and has public network access disabled
- Default outbound internet access is disabled on the workload and private endpoint subnets

Network connectivity and data authorisation are separate. No application identity, vault secrets, Blob workload or data access role assignments are defined. The Storage private endpoint covers the Blob subresource only.

## Validation

GitHub Actions checks Terraform formatting, locked provider initialisation and schema validation without Azure credentials. The badge reports the latest workflow status on `main`.

The checks cover configuration syntax and provider schemas. DNS resolution, network reachability and data authorisation are distinct layers of the architecture.

## Design and operations

No NAT gateway, general internet egress path, package update service or monitoring workspace is defined. The VM configuration therefore lacks an ongoing patch distribution and observability design. Resource creation depends on subscription permissions, provider registration, VM quota and regional availability.

Terraform uses local state. Git ignores local state and standard plan files. Private keys and other sensitive artefacts require separate protection. Bastion, the VM, disks, private endpoints, Storage and public IP can incur charges. Stopping the VM leaves other resources billable. Key Vault soft deletion can retain a deleted vault, and the provider does not purge it during destruction.

## Source layout

- [`infra/`](infra/): network, VM, data services, private endpoints and DNS
- [`infra/outputs.tf`](infra/outputs.tf): service hostnames and private IP outputs
- [Validation workflow](.github/workflows/validate.yml): automated Terraform checks
