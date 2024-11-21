# AWS Terraform Infrastructure Setup

## Overview
This project uses Terraform to create an advanced AWS infrastructure spanning two Availability Zones (AZs). The infrastructure includes both public and private subnets, an internet gateway, NAT gateway, and an Application Load Balancer (ALB) to manage traffic across an Auto Scaling Group (ASG) of Nginx web servers. A Bastion Host is also created to facilitate secure access to instances in the private subnets.

### Components:
1. **VPC and Subnets**: A Virtual Private Cloud (VPC) is created with both public and private subnets across two Availability Zones.
2. **Internet Gateway and NAT Gateway**: Used to enable internet access for public subnets and outbound internet access for private subnets.
3. **Route Tables**: Public and private route tables are configured to manage traffic flow.
4. **Bastion Host**: A Bastion Host is deployed in a public subnet to allow SSH access to instances in private subnets.
5. **Application Load Balancer (ALB)**: Load balances HTTP traffic across instances in the private subnet.
6. **Auto Scaling Group (ASG)**: Automatically manages the Nginx web servers to ensure scalability and resilience.

## Project Structure
```
├── ec2.userdata         # User data script for configuring EC2 instances (e.g., Nginx setup)
├── main.tf              # Main Terraform configuration for AWS resources
├── outputs.tf           # Output definitions for important information, such as public IPs
├── terraform.tfvars     # Terraform variables (user-defined values for configuration)
├── variables.tf         # Variable definitions used in the Terraform project
```

## Prerequisites
- **Terraform**: Install Terraform on your local machine to deploy the infrastructure.
- **AWS CLI**: Install and configure the AWS CLI, including authentication with your AWS account.
- **AWS IAM Permissions**: Ensure you have the necessary IAM permissions to create AWS resources such as VPC, EC2, Load Balancers, etc.

## Getting Started
1. **Clone the repository**:
   ```sh
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Initialize Terraform**:
   Run the following command to initialize the Terraform workspace and download the necessary provider plugins:
   ```sh
   terraform init
   ```

3. **Define Variables**:
   Update `terraform.tfvars` with appropriate values such as `key_name` for SSH access.

4. **Review and Apply Configuration**:
   Review the configuration with:
   ```sh
   terraform plan
   ```
   If everything looks good, apply the configuration with:
   ```sh
   terraform apply
   ```

5. **Access the Bastion Host**:
   Use the SSH key (`bastion_ssh_key.pem`) to SSH into the Bastion Host:
   ```sh
   ssh -i bastion_ssh_key.pem ec2-user@<Bastion_Public_IP>
   ```
   Once connected, use the same key to SSH into Nginx servers in the private subnet.

## Important Notes
- **Security Groups**: The Bastion Host security group allows SSH access from anywhere (`0.0.0.0/0`). For a more secure deployment, restrict access to your specific IP address.
- **SSH Key Management**: The private SSH key (`bastion_ssh_key.pem`) is uploaded to the Bastion Host automatically via a user data script. Ensure this file has restricted permissions (`chmod 400 bastion_ssh_key.pem`).
- **Resource Cleanup**: To prevent ongoing costs, destroy the infrastructure when not in use:
   ```sh
   terraform destroy
   ```

## Outputs
- **Bastion Host Public IP**: The public IP of the Bastion Host, which you use for SSH access.
- **ALB DNS Name**: The DNS name for the Application Load Balancer to access the web application.

## Troubleshooting
- **Provider Errors**: If you encounter inconsistent plans or tagging errors, ensure you are using a compatible AWS provider version.
- **SSH Issues**: Ensure the key has the correct permissions and that the Bastion Host security group allows SSH access.

## Author
- Created by: Harald Dellwo 
