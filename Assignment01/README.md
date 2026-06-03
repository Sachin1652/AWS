# Assignment-01: Load Balancer & Auto Scaling Group (Spring 3 Hibernate)

## Objective
This project demonstrates the deployment of a Spring 3 Hibernate application on AWS using a highly available, scalable, and secure infrastructure.  
The application is deployed on private EC2 instances behind an Application Load Balancer (ALB) and is managed using an Auto Scaling Group (ASG).

The application runs on **port 8080**.

---
The infrastructure ensures:

* High Availability using multiple Availability Zones
* Scalability using Auto Scaling Group (ASG)
* Security using private subnets, security groups, and a bastion host

Application Source:

* Spring 3 Hibernate Application: [https://github.com/opstree/spring3hibernate.git](https://github.com/opstree/spring3hibernate.git)

## Architecture Overview

The infrastructure is designed inside a single AWS region (**ap-south-1**) and consists of the following major components:

* **VPC** with public and private subnets
* **Application Load Balancer (ALB)** in public subnets
* **Target Group** to route traffic from ALB to EC2 instances on port **8080**
* **Auto Scaling Group (ASG)** for application servers in private subnets
* **NAT Gateway** for outbound internet access from private subnets
* **Bastion Host** for secure SSH access
* **Security Groups** for controlled network access

## Infra Diagram
<img width="1472" height="964" alt="infra-asg1 drawio" src="https://github.com/user-attachments/assets/178bf4ee-f71c-4e12-979d-6267a44ac672" />
---

The infrastructure is designed with the following components:

- **VPC**: `10.0.0.0/17`
- **Region**: `ap-south-1 (Mumbai)`
- **Availability Zones**:  
  - AZ-1a  
  - AZ-1b  

### Subnets
```ini
|      Type        | CIDR Block   | AZ    |
|------------------|--------------|-------|
| Public Subnet 1  | 10.0.16.0/25 | AZ-1a |
| Public Subnet 2  | 10.0.17.0/25 | AZ-1b |
| Private Subnet 1 | 10.0.0.0/21  | AZ-1a |
| Private Subnet 2 | 10.0.8.0/21  | AZ-1b |
```
---

## Traffic Flow
```ini
User
↓
Application Load Balancer (ALB) [80]
↓
Target Group (HTTP : 8080)
↓
Auto Scaling Group (ASG)
↓
Spring Boot / Spring 3 Hibernate EC2 Instances (Private Subnets)
```
### Outbound traffic from EC2 instances:
```ini
EC2
↓
NAT Gateway
↓
IGW
↓
Internet
```

This ensures:
- No direct public access to application servers  
- Only ALB can communicate with the app  
- Secure and controlled traffic routing  
---

## Security Groups

### ALB-SG
- Inbound:
80 → 0.0.0.0/0
- Outbound:
8080 → APP-SG
### APP-SG
- Inbound:
8080 → ALB-SG
- Outbound:
All traffic → 0.0.0.0/0
### Bastion-SG
- Inbound:
22 → My Public IP

---
## Target Group Configuration

- **Target Type:** Instance  
- **Protocol:** HTTP  
- **Port:** 8080  
- **Health Check Path:** `/`  
- **Purpose:**
  - Performs health checks  
  - Routes traffic only to healthy EC2 instances  
  - Acts as a bridge between ALB and ASG  

---

## Load Balancer

- Type: Application Load Balancer  
- Scheme: Internet-facing  
- Subnets:
  - Public Subnet 1
  - Public Subnet 2  
- Listener:
HTTP 80 → Forward to Target Group (8080)
---

## Auto Scaling Group (ASG)

- **Subnets:** Private Subnet 1 & Private Subnet 2  
- **Launch Template Includes:**
  - Spring3-linux AMI
  - Java Installed
  - Spring 3 Hibernate Application running on port `8080`
  - Security Group: `APP-SG`
- **Scaling Policy:**
```bash
Min: 2
Desired: 2
Max: 4
```

Ensures:
- Fault tolerance  
- Automatic scaling during high traffic  
- Zero downtime  


## DNS & Testing

### ALB DNS Name
<img width="1920" height="936" alt="2" src="https://github.com/user-attachments/assets/daece935-572d-4086-85a8-a08e7bb86a49" />

---

AWS provides a DNS name for ALB:
-  http://spring3loadbalancer-353300400.ap-south-1.elb.amazonaws.com/

### For easier testing:
#### Find ALB-IP
```
dig http://spring3loadbalancer-353300400.ap-south-1.elb.amazonaws.com/
```
<img width="1920" height="598" alt="3" src="https://github.com/user-attachments/assets/eb805a51-8042-4122-9b7a-00446b41c3bf" />

```
vi /etc/hosts
<ALB-IP> spring3.com
```
<img width="1920" height="651" alt="3 1" src="https://github.com/user-attachments/assets/487dbdcc-d357-4d42-a8e0-c8c01a3c1488" />


#### Then access
```
http://spring3.com/
```
---

## Outputs Section

### Browser Output
<img width="1920" height="993" alt="4" src="https://github.com/user-attachments/assets/bf247ccf-41fc-4a20-9c54-e6ebb41dc803" />

<img width="1920" height="993" alt="4 1" src="https://github.com/user-attachments/assets/bd383dce-1d38-4c1a-a688-fb9a1ae52c4c" />

<img width="1920" height="993" alt="4 2" src="https://github.com/user-attachments/assets/4357fa71-aa89-4251-87f3-41dd05b55979" />


---
### Target Group Health Status
<img width="1920" height="936" alt="5" src="https://github.com/user-attachments/assets/eeae437b-a90e-428c-9f8e-9cb8ec2ef557" />


---
### Auto Scaling Group Instances
<img width="1920" height="936" alt="6" src="https://github.com/user-attachments/assets/9e2a4ae5-73b0-4a21-960f-cb00e067b51b" />


---
## Final Outcome

- ✔ Spring 3 Hibernate application running on private EC2 instances
- ✔ Load balanced traffic via ALB
- ✔ Auto Scaling based on demand
- ✔ Secure architecture using private subnets and security groups
- ✔ Highly available across multiple AZs
## **Author:** 

**Sachin Rajput**


