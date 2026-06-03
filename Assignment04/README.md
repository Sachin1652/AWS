# Project Overview

This project automates the deployment of a highly secure and scalable AWS infrastructure for a custom tool. Using Infrastructure as Code (IaC) via Terraform, the setup implements a multi-tier network architecture, ensuring that application servers remain isolated from the public internet while remaining accessible via an Application Load Balancer (ALB).

- Goal: Deploy a production-ready environment for "Tool-Static."

- Security Focus: Private subnet isolation, Security Group chaining, and VPC Peering for management.

- Compliance: Follows CIS benchmarks for networking and state management best practices.

## Architecture Diagram

### Infra Diagram
<img width="2212" height="1007" alt="tool-infra drawio1" src="https://github.com/user-attachments/assets/1353f0e7-085e-4ed2-a94f-9611cf05a040" />


The architecture consists of a custom VPC spanning multiple Availability Zones for High Availability.
Infrastructure Flow:

- Public Layer: Application Load Balancer (ALB) receives external traffic (Port 80/8080).

- Private Layer: Application servers reside in private subnets, reachable only from the ALB.

- Management Layer: A VPC Peering connection allows secure SSH access from a Bastion host (Default VPC) to the Private instances.

- Egress: Private instances access the internet for updates via a NAT Gateway.
## Technologies Used

    IaC: Terraform

    Cloud: AWS (VPC, EC2, ALB, Route53, S3)

    OS: Ubuntu 22.04 LTS

    State Management: S3 Backend with State Locking

    Networking: VPC Peering, NAT Gateway, Internet Gateway

## Project Structure
```bash
.
├── backend.tf          # S3 Remote State configuration
├── providers.tf        # AWS Provider and Versioning
├── main.tf             # Consolidated Monolithic Infrastructure code
├── variables.tf        # Input variable definitions
├── terraform.tfvars    # Environment-specific values (CIDRs, AMIs)
└── outputs.tf          # Key infrastructure metadata
```
## Network Design
VPC Details

    CIDR: 10.0.0.0/23

    Region: ap-south-1 (Mumbai)

Subnets

    Public Subnets: 2 Subnets across 2 AZs (For ALB).

    Private Subnets: 2 Subnets across 2 AZs (For App Servers).

 Security Configuration
ALB Security Group

    Inbound: Allow HTTP (80) & Custom (8080) from 0.0.0.0/0.

    Outbound: Allow all to Private EC2s.

App Security Group

    Inbound: * Allow traffic from ALB Security Group only.

        Allow SSH (22) from the Peered Default VPC CIDR.

    Outbound: Allow all (via NAT Gateway).

Compute & Load Balancing
```
Instance Name	Instance Type	Subnet	Access
App-Server-1	t3.micro	Private-A	ALB / Peering
App-Server-2	t3.micro	Private-B	ALB / Peering
```

    ALB Type: Internet-facing Application Load Balancer.

    Target Groups: Health checks configured for Port 80/8080.

    DNS: Integrated with Route53 for sachinwork.in.

## Terraform State Management

The state is managed remotely to ensure consistency and team collaboration.

    Storage: AWS S3

    Encryption: AES-256

    Versioning: Enabled on S3 bucket.

## Outputs
<img width="1475" height="961" alt="image" src="https://github.com/user-attachments/assets/0a36b3cc-a4b0-4a3e-94a0-54b2e881ce5b" />
<img width="1915" height="914" alt="image" src="https://github.com/user-attachments/assets/ba82222d-b877-4634-8b87-3f5a59c200f2" />
<img width="1915" height="914" alt="image" src="https://github.com/user-attachments/assets/7d5f8f4e-7fc1-4aa0-9dff-06c247be6f6f" />
<img width="1915" height="914" alt="image" src="https://github.com/user-attachments/assets/4e5aad75-d1b8-4916-bd39-d08edc3505fb" />
<img width="1608" height="226" alt="image" src="https://github.com/user-attachments/assets/5341e161-164b-4dc5-b121-4801e7b50244" />
<img width="1608" height="226" alt="image" src="https://github.com/user-attachments/assets/cdf6a6b3-7901-4a0b-b4bc-9c77231bd83e" />
<img width="1608" height="226" alt="image" src="https://github.com/user-attachments/assets/402c522e-88f4-4007-a924-b4fdd2dcf90b" />
<img width="1027" height="483" alt="image" src="https://github.com/user-attachments/assets/089b8bfa-a32b-4987-9f82-a761e416069e" />


## Key Learning Outcomes
- Implementing Remote State to prevent state corruption.
- Configuring VPC Peering for secure cross-VPC communication.
- Designing Multi-AZ infrastructure for fault tolerance.
- Automating DNS records pointing to dynamic ALB endpoints.
## Author

**Sachin Rajput**
