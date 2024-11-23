# Terraform Infrastructure for Nginx AMI with Bastion Host

## Overview

This Terraform project sets up an AWS infrastructure for testing a custom Nginx setup. It includes:

- A **custom Nginx AMI** for Auto Scaling Group (ASG) instances.
- A **bastion host** for secure access to the ASG instances.
- **Automatic key pair generation** for secure SSH access.
- A Virtual Private Cloud (VPC) with both public and private subnets, a NAT gateway, and an Internet Gateway (IGW).

## Features

- **Custom Nginx AMI**: The ASG instances use a pre-configured AMI that has Nginx installed. This allows easy deployment of Nginx web servers within the infrastructure.
- **Bastion Host Setup**: A bastion host is deployed in a public subnet to provide SSH access to instances in the private subnets.
- **Automatic Key Generation**: TLS private keys are generated automatically by Terraform for both the bastion host and ASG instances, ensuring secure SSH access without manual key handling.
- **Automated Key Management**: After the key is uploaded to the bastion host for secure access to the ASG instances, it is automatically deleted from the local system to enhance security.

## Infrastructure Components

- **VPC with Subnets**: A VPC with two availability zones, each having a public and a private subnet.
- **NAT Gateway and IGW**: A NAT gateway to enable private instances to access the internet and an Internet Gateway for public instances.
- **Auto Scaling Group (ASG)**: Launches instances using the custom Nginx AMI and distributes them across private subnets for high availability.
- **Application Load Balancer (ALB)**: A public ALB distributes HTTP traffic to the Nginx instances.

## Key Features Explained

### Custom Nginx AMI

The ASG instances use a custom AMI (`ami-03893e668ac36fad3`) with Nginx pre-installed. This reduces setup time and ensures all instances in the ASG serve the same Nginx-based content.

### Bastion Host Access

- A bastion host is deployed in a **public subnet** to securely SSH into instances in the **private subnet**.
- The bastion uses **Amazon Linux 2** and allows you to access the private ASG instances using SSH.

### Automatic Key Pair Generation

- **Bastion Key**: A key pair is automatically generated for the bastion host using the **`tls_private_key`** resource. The public key is uploaded to AWS, while the private key (`bastion-key.pem`) is stored locally.
- **ASG Key**: Similarly, a key pair for the ASG instances (`asg-key.pem`) is automatically generated and stored locally for SSH access.
- After the ASG key is uploaded to the bastion host, the key is **removed from the local system** using Terraform's `local-exec` provisioner for security purposes.

## How to Use

### Prerequisites

- **Terraform**: Version >= 1.0.0.
- **AWS CLI**: Set up AWS credentials with access to create resources in your preferred region.

### Steps to Deploy

1. **Initialize Terraform**:
   ```sh
   terraform init
   ```
2. **Plan the Changes**:
   ```sh
   terraform plan
   ```
   This allows you to review the resources that will be created.
3. **Apply the Plan**:
   ```sh
   terraform apply tfplan
   ```
4. **Access Bastion Host**:
   - Use the bastion key (`bastion-key.pem`) to SSH into the bastion host:
     ```sh
     ssh -i bastion-key.pem ec2-user@<bastion_public_ip>
     ```
5. **Access ASG Instances via Bastion**:
   - Once inside the bastion host, use the ASG key (`asg-key.pem`) to SSH into the private ASG instances:
     ```sh
     ssh -i /home/ec2-user/asg-key.pem ec2-user@<asg_private_ip>
     ```

## Cleanup

- After deploying, Terraform will automatically remove the local ASG key (`asg-key.pem`) from the local folder for added security.
- To destroy all resources, run:
  ```sh
  terraform destroy
  ```


## Security Considerations

- Keys are generated automatically and used only during the provisioning process.
- The ASG private key is deleted after being uploaded to the bastion host to reduce the risk of unauthorized access.
- Security groups are configured to only allow SSH from trusted sources and HTTP traffic through the ALB.

## License

This project is licensed under the MIT License.

