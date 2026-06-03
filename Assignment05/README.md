# Assignment 05 – Implement Infrastructure with Terraform Modules

## Overview

This assignment demonstrates how to design and deploy AWS infrastructure using **Terraform modules**, **remote state management**, and **state locking**. The infrastructure is modular, reusable, and follows Terraform best practices.

The solution provisions a complete AWS setup including:

* VPC
* VPC peering
* Public and private subnets
* Internet Gateway & NAT Gateway
* Route tables
* Security groups
* EC2 instances (Private servers)
* Application Load Balancer (ALB)
* Target groups
* Route 53
* Remote backend using **Amazon S3** with **DynamoDB state locking**

---

## Architecture

**High-level flow:**
```
Client → Route 53 → Application Load Balancer → Private EC2 Instances(Application use)

Devops(Local terminal) → SSH access to Private EC2 Instances
```

**Architecture Diagram Screenshot Placeholder**
```
Terraform AWS Architecture Diagram 
```
<img width="2212" height="1007" alt="tool-infra drawio1" src="https://github.com/user-attachments/assets/0c937362-866f-4fd1-a28c-6973266c5c0b" />

---

**Project Structure**
<img width="1919" height="1009" alt="Screenshot from 2026-02-05 14-47-33" src="https://github.com/user-attachments/assets/7d74e892-706c-4f74-a3fa-2524e03b7f4b" />
---
## Outputs
**terraform apply**
<img width="1919" height="1040" alt="image" src="https://github.com/user-attachments/assets/c92c9380-8dde-462e-95f8-026e779a0402" />
**State Lock by DynamoDB**
<img width="1918" height="645" alt="Screenshot from 2026-02-05 14-23-12" src="https://github.com/user-attachments/assets/7703b70f-c9b2-411a-af99-b8a402fb68c2" />
**S3 Store state file version**
<img width="1919" height="957" alt="image" src="https://github.com/user-attachments/assets/996f3f85-9dc2-43ea-9b4a-a68f03de0dd1" />
**VPC Resource map**
<img width="1919" height="1009" alt="image" src="https://github.com/user-attachments/assets/e4c65eec-93d3-405e-80db-f67081930272" />
**VPC Peering**
<img width="1919" height="1009" alt="image" src="https://github.com/user-attachments/assets/74cf2877-c212-4102-aee9-eeb11dbe8079" />
**Application VMs**
<img width="1919" height="957" alt="image" src="https://github.com/user-attachments/assets/0701238d-25de-4aef-8066-df040c7fd0e2" />
**Application loadbalancer**
<img width="1618" height="242" alt="image" src="https://github.com/user-attachments/assets/59193206-5166-4407-8ace-de5f1590efed" />
**Target Groups**
<img width="1618" height="242" alt="image" src="https://github.com/user-attachments/assets/cab93bef-cc9d-4648-94c7-e1f9d15d885e" />
**Route 53**
<img width="1919" height="965" alt="image" src="https://github.com/user-attachments/assets/d5d81d55-39e0-40bc-b4ad-5f453b4fa00c" />

## Author

**Sachin Rajput**


