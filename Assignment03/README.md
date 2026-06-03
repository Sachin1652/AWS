# AWS DevOps Assignment  
## High Availability, Auto Scaling, Secure S3 Access & CloudFront CDN

This project demonstrates a complete end-to-end AWS DevOps architecture using Nginx, EC2, ALB, Auto Scaling, IAM, S3, and CloudFront with security best practices.

---

## Project Overview

The goal of this project is to build a production-ready infrastructure that is:

- Highly available  
- Scalable  
- Secure  
- Cost optimized  
- CDN enabled  

---

## Day-wise Implementation Summary

### Day 1–2
- Installed and configured Nginx
- Hosted basic web application
- Created AMI from configured instance
- Tested instance launch from AMI

### Day 3
- Created Application Load Balancer (ALB)
- Attached EC2 instances via Target Groups
- Verified load balancing

### Day 4
- Implemented Auto Scaling Group
- Tested scaling policies
- Verified self-healing behavior

### Day 5
- Created secure S3 bucket for assets
- Structured folders:
```
s3://day5-secure-assets-sachin/
├── prod/
└── nonprod/
```
- Created IAM roles with least privilege
- Attached IAM role to EC2
- Tested S3 access from EC2

### Day 6
- Created CloudFront distribution
- Configured Origin Access Control (OAC)
- Connected CloudFront to private S3
- Applied bucket policy for CloudFront only access
- Disabled public access to S3
- Verified asset access through CloudFront

---

# Day-1

### Nginx HA Setup using AMI, ASG and ALB

### Objective

Set up Nginx as a middleware with High Availability and Auto Scaling on AWS.
Implement version control using AMIs and support upgrade and rollback.

### What We Did
**1**. Created two AMIs:

* AMI-V1 → Nginx stable version

* AMI-V2 → Nginx upgraded version

**2**. Created a Launch Template:

* Version 1 → uses AMI-V1

* Version 2 → uses AMI-V2

**3**. Created:

* Target Group

* Application Load Balancer (ALB)

* Auto Scaling Group (ASG)

**4**. Attached ASG to ALB.

**5**. Configured Scaling Policies:

* Average CPU Utilization

* ALB Request Count per Target

* Network Bytes In/Out

**6**. Performed load testing using:

* stress

* ab (Apache Benchmark)

**7**. Verified:

ASG automatically launches new instances under load

Instances become healthy in target group

Traffic is distributed through ALB

**8**. Performed Rolling Upgrade:

Changed Launch Template to AMI-V2

Started Instance Refresh

Old instances replaced by new V2 instances

**9**. Performed Rollback:

Changed Launch Template back to AMI-V1

Started Instance Refresh

System reverted safely without downtime

### Architecture Flow
```
User → ALB → ASG → Nginx EC2 (AMI-V1 / AMI-V2)

```
## Outputs

Auto Scaling Group successfully launched new instances when CPU utilization crossed the defined threshold.
<img width="1919" height="962" alt="1 1" src="https://github.com/user-attachments/assets/6103ce67-5f7e-4567-8340-4af46c879d5a" />
<img width="1918" height="1007" alt="1 2" src="https://github.com/user-attachments/assets/250715c3-75be-4d7c-86ff-911f63e48c1c" />
<img width="1919" height="962" alt="1 3" src="https://github.com/user-attachments/assets/dd337428-81b3-43e7-9312-ac52798adf0f" />

ASG scaled out based on ALB request count per target during high traffic.
<img width="1918" height="1007" alt="2" src="https://github.com/user-attachments/assets/6732ad7a-6c7b-43f7-8e54-355777ec1097" />

Network-based scaling was triggered when network throughput increased.
<img width="1918" height="1007" alt="3" src="https://github.com/user-attachments/assets/1d50c539-d123-4dfa-980e-b2c10f9160e6" />


Rolling deployment upgraded Nginx from Version-1 to Version-2 without downtime.
<img width="1919" height="962" alt="4 1" src="https://github.com/user-attachments/assets/d8fc7994-8b89-4d49-a357-5cb500fb659d" />
<img width="1918" height="957" alt="4 2" src="https://github.com/user-attachments/assets/7092c03c-cebd-4627-a7ed-35c673fbb01b" />
<img width="1920" height="1080" alt="4 3" src="https://github.com/user-attachments/assets/873d0ea1-560c-4a02-8c68-6b502a9fe27a" />
<img width="1920" height="1080" alt="4 4" src="https://github.com/user-attachments/assets/15899f09-1128-4d74-bc2f-c7ce84c16944" />


Rollback was successfully performed by reverting the Launch Template to AMI-V1.
<img width="1918" height="1007" alt="5 1" src="https://github.com/user-attachments/assets/30fa3f59-ee77-4b4c-95f6-9424c786e5be" />
<img width="1918" height="1007" alt="5 2" src="https://github.com/user-attachments/assets/f6016a7a-b68c-4cee-9150-2e73e620cb61" />
<img width="1920" height="1080" alt="5 3" src="https://github.com/user-attachments/assets/543d5590-83c0-41d2-a883-eec8746e3c55" />


High Availability was achieved using ALB and ASG.
<img width="1918" height="1007" alt="6 1" src="https://github.com/user-attachments/assets/0c39256a-aab6-4cde-842a-00d4a5fc321f" />

# Day-2 : Nginx Web Hosting using Git, S3 and IAM Role

## Project Title  
Secure Web Hosting with Nginx using Git, S3 and IAM Role (No Access Keys)

---

## Objective  

The goal of Day-2 is to use Nginx as a web hosting server and serve static images from an S3 bucket.  
All operations must be performed from the AWS environment (EC2) and AWS access should be managed only through IAM Roles (no secret keys or access keys).

---

## Architecture Overview  
```
Git Repository → EC2 Instance → S3 Bucket
User → ALB → ASG → Nginx
Browser → S3 (for images)
```

- Git is used to manage frontend code  
- EC2 pulls code from Git  
- EC2 uploads images to S3 using IAM Role  
- Nginx serves HTML and fetches images directly from S3  
- ALB and ASG provide high availability  

---

## Steps Performed  

1. Created an S3 bucket for storing static images.  

2. Created a custom IAM policy following least privilege:
   - Allow listing only the required bucket  
   - Allow uploading objects  
   - Allow reading objects  

3. Created an IAM Role for EC2 and attached the minimal S3 policy.

4. Attached the IAM Role to the Launch Template and refreshed the Auto Scaling Group instances.

5. Created a Git repository containing:
   - `index.html`
   - `images/` folder with sample images  

6. Pulled the Git repository inside EC2:
   ```bash
   git clone <https://github.com/Sachin1652/s3-data.git>
   ```
7. Uploaded images to S3 using aws-cli from EC2:
```
aws s3 cp images/ s3://nginx-day2-assets-sachin/images/ --recursive
```
8. Updated Nginx web page to load images from S3 URLs:
```
<img src="https://nginx-day2-assets-sachin.s3.amazonaws.com/images/image1.jpg">
```
9. Added an S3 bucket policy to allow public read access for images so that browsers can fetch them.
10. Verified:
- Webpage loads through ALB
- Images load directly from S3
- No access keys are used anywhere

### Security Implementation
- IAM Role was used instead of access keys
- Least privilege principle was followed
- EC2 had access only to one specific S3 bucket
- Only read access was provided publicly to S3 objects

## Outputs

Frontend code was successfully pulled from Git inside EC2.
<img width="801" height="271" alt="7" src="https://github.com/user-attachments/assets/ca7bd1ba-7b0f-4bc5-b1de-15c935c1174c" />

Images were uploaded to S3 using aws-cli through IAM Role.
<img width="1848" height="122" alt="8" src="https://github.com/user-attachments/assets/b2d07f1b-d490-4cab-916e-ad8aedd87799" />

Nginx served the webpage and fetched images directly from S3.
<img width="1916" height="1010" alt="9" src="https://github.com/user-attachments/assets/0187afa4-cf94-4c87-984e-493948152463" />

No access keys were used; IAM Role handled all AWS authentication.
<img width="1916" height="1010" alt="10 1" src="https://github.com/user-attachments/assets/72e3c0af-9980-4933-a479-1fc57f01d020" />
<img width="1916" height="1010" alt="10 2" src="https://github.com/user-attachments/assets/8f08244f-37ca-4f6b-bba3-5dcaa6535da5" />

S3 bucket policy enabled secure public access to static images
<img width="1916" height="1010" alt="11" src="https://github.com/user-attachments/assets/5c2f22a5-f3ea-492f-883b-0fce95a17b64" />


# Day-3 : ASG Self-Healing Test

### Objective  
To test whether Auto Scaling Group automatically replaces an unhealthy server and maintains the desired capacity.

---

### What We Did  

#### Changed Auto Scaling Group health check type from:
```
EC2 → ELB
```
Auto Scaling Group can detect unhealthy servers using ELB health checks
<img width="1916" height="1010" alt="12" src="https://github.com/user-attachments/assets/3b8ff8e6-e709-42f6-a131-821c1ba152e0" />

#### Logged into one running Nginx instance.

#### Made the server unhealthy by stopping Nginx:
```bash
sudo systemctl stop nginx
```
<img width="1916" height="1010" alt="13" src="https://github.com/user-attachments/assets/ceaca611-66f1-4caf-9185-7e7ee8862215" />

Target Group
<img width="1916" height="1010" alt="13 1" src="https://github.com/user-attachments/assets/d65493c7-a712-4011-a1ea-70509b5d7e80" />

#### Observed:
- Target Group marked the instance as Unhealthy
- ASG terminated the unhealthy instance
- ASG launched a new EC2 instance automatically
- New instance became:

#### unning
- Healthy in Target Group
- Started serving traffic without manual intervention

## Output
ASG automatically replaces failed instances
<img width="1916" height="1010" alt="14 1" src="https://github.com/user-attachments/assets/d7adb277-9271-4eba-8acd-5f8a12f05a7d" />
<img width="1916" height="1010" alt="14 2" src="https://github.com/user-attachments/assets/62b464a8-4101-4110-b40e-41518332a940" />
<img width="1916" height="1010" alt="14 3" src="https://github.com/user-attachments/assets/dbcabe2c-1cd9-4d3b-9cce-ae7585b26fbc" />

# Blue–Green Deployment & CloudFront Integration 
Highly Available Nginx Infrastructure with Blue–Green Deployment and Multi-Layer CloudFront CDN

---

## Objective  

The main objective of this phase was to:
- Implement **Blue–Green Deployment** for zero-downtime releases  
- Add **CloudFront in front of ALB** for faster website delivery  
- Add **CloudFront in front of S3** for optimized image delivery  
- Build a highly available, scalable and production-ready architecture  

---

## Final Architecture  

```
User
↓
CloudFront (Website CDN)
↓
Application Load Balancer (ALB)
↓
Blue ASG (V1) OR Green ASG (V2)
↓
Nginx Server
↓
HTML Page
↓
CloudFront (Images CDN)
↓
S3 Bucket (Images)
```

---

## Blue–Green Deployment Setup  

Two separate environments were created:

| Environment | ASG Name        | Target Group     | AMI Version |
|------------|----------------|------------------|-------------|
| Blue       | nginx-asg-blue  | nginx-tg-blue    | AMI-V1      |
| Green      | nginx-asg-green | nginx-tg-green   | AMI-V2      |

- ALB listener rule controls which environment receives traffic.
- Only one target group is active at a time.
- Switching traffic is done instantly from the ALB without downtime.

### Traffic Switch  
```
ALB Listener:
Forward → nginx-tg-green
```

### Rollback  
```
ALB Listener:
Forward → nginx-tg-blue
```

This allows:
- Zero downtime deployments  
- Instant rollback if a version fails  

---

## CloudFront in Front of ALB (Website CDN)

A CloudFront distribution was created with:

| Setting | Value |
|------|------|
Origin | ALB DNS Name  
Origin Type | Custom  
Viewer Protocol Policy | Redirect HTTP to HTTPS  
Cache Policy | Managed-CachingOptimized  

This enables:
```
User → CloudFront → ALB → ASG → Nginx
```

Benefits:
- Lower latency  
- Global content delivery  
- Faster website response  

---

## CloudFront in Front of S3 (Images CDN)

A second CloudFront distribution was created with:

| Setting | Value |
|------|------|
Origin | S3 Bucket (nginx-day2-assets-sachin)  
Origin Type | S3  
Viewer Protocol Policy | Redirect HTTP to HTTPS  
Cache Policy | Managed-CachingOptimized  

flow becomes
```
Nginx HTML → CloudFront (Images CDN) → S3
```

This removes direct S3 access from browsers and improves performance.

---

## Cache Invalidation Handling  

CloudFront caches content.  
After any deployment or version switch, old content may appear until cache is cleared.

To fix this:
```
CloudFront → Distribution → Invalidations → Create Invalidation
Path: /*
```

This ensures the latest backend version is served immediately.

---

## Security & Best Practices  

- IAM Roles used instead of access keys  
- Least privilege policies applied  
- S3 used only as object storage  
- CDN used for both web and image delivery  
- ALB controls Blue–Green traffic routing  

---

## Output

- Blue–Green deployment was implemented using two Auto Scaling Groups and Target Groups.
<img width="1767" height="932" alt="15 1" src="https://github.com/user-attachments/assets/bf5f3e63-df8b-4870-962a-7643593cda52" />
<img width="1916" height="1010" alt="15 2" src="https://github.com/user-attachments/assets/d0d9506d-c36e-40ed-ba03-ee0debf77ed6" />

- Traffic switching was achieved using ALB listener rules with zero downtime.
<img width="1917" height="418" alt="15 3" src="https://github.com/user-attachments/assets/bb79b61b-eb54-4ca0-8d4f-56af698d6ed8" />

- CloudFront was integrated in front of the ALB for faster content delivery.
<img width="1916" height="1010" alt="16 1" src="https://github.com/user-attachments/assets/1b8ada25-88aa-46ec-ae70-452ffba11f46" />

- Another CloudFront distribution was used in front of S3 for image acceleration. 
<img width="1917" height="1007" alt="16 2" src="https://github.com/user-attachments/assets/1b32b76b-36a8-40ad-a5e7-e594c964e7ff" />

- Nginx was configured to fetch images through CloudFront instead of directly from S3.
<img width="1916" height="993" alt="17" src="https://github.com/user-attachments/assets/0b915033-d678-4224-ba6e-cfb76f327539" />

- CloudFront cache invalidation was used to refresh content after deployments.  
<img width="1917" height="1007" alt="18" src="https://github.com/user-attachments/assets/98b21980-d50e-45be-80c0-edf6342fe906" />

---

## Conclusion  

This setup represents a real-world production-grade architecture:

- Zero-Downtime Deployment  
- Instant Rollback  
- High Availability  
- Multi-Layer CDN Architecture  
- Secure AWS Access using IAM Roles  
- Improved Performance using CloudFront  

# Day-4 : Path Based Routing using ALB

## Objective  
Use a single Application Load Balancer (ALB) to route traffic to two different Nginx servers using different paths.

- `/ninja1` → Nginx Server 1  
- `/ninja2` → Nginx Server 2  

Both servers are in private subnets and accessed only through ALB.  
A Bastion host is used for secure SSH access.

---

## Architecture

```
User
↓
Application Load Balancer
├── /ninja1 → tg-ninja1 → nginx-1 (Private Subnet)
└── /ninja2 → tg-ninja2 → nginx-2 (Private Subnet)
```
---
```
Bastion Host (Public Subnet)
↓
SSH Access to Private Nginx Servers
```

---

## Components Used

- 1 VPC  
- 1 Public Subnet  
- 2 Private Subnets  
- 1 Bastion Host  
- 2 Nginx EC2 Instances  
- 1 Application Load Balancer  
- 2 Target Groups  

---

## Security Design

| Resource      | Port | Allowed From           |
|---------------|------|------------------------|
| Bastion Host  | 22   | My Public IP only      |
| Nginx Servers | 22   | Bastion Security Group |
| Nginx Servers | 80   | ALB Security Group     |
| ALB           | 80   | 0.0.0.0/0              |


---

## Target Groups

| Target Group | Health Check Path |
|------------|---------------------|
| tg-ninja1  |     /ninja1/        |
| tg-ninja2  |     /ninja2/        |

---

## ALB Listener Rules

| Priority | Path Pattern | Action |
|--------|-------------|-------|
| 1 | /ninja1* | Forward → tg-ninja1 |
| 2 | /ninja2* | Forward → tg-ninja2 |
| Default | /* | Forward → tg-ninja1/tg-ninja2 |

(Default rule represents `/*`)

---

## Testing
VPC
<img width="1646" height="424" alt="19 1" src="https://github.com/user-attachments/assets/a9b9ab23-a1ac-4ad6-af32-58b4021187b8" />

Defaul
![mygif](https://github.com/user-attachments/assets/a2a4a346-2ca8-4835-9350-61d00e853fbb)

http://day4-alb-321330937.ap-south-1.elb.amazonaws.com/ninja1/
<img width="1919" height="993" alt="19 2" src="https://github.com/user-attachments/assets/5c09b808-e39a-4647-83d8-3b85d9974dd9" />

http://day4-alb-321330937.ap-south-1.elb.amazonaws.com/ninja2/
<img width="1919" height="993" alt="19 3" src="https://github.com/user-attachments/assets/f9ed0d70-fa2d-4168-a247-15ba641e9d5a" />

# Day-5 : S3, IAM and Folder Level Access Control

## Objective  
To create a secure S3 setup where:
- S3 bucket is deployed in **us-east-1**
- Bucket contains two folders: `prod` and `nonprod`
- IAM User can access only `nonprod`
- Nginx application (EC2 via IAM Role) can access the full bucket
- Bucket is private and not accessible publicly
- Access from private EC2 to S3 is done using a NAT Gateway

---

## Architecture

```
Private EC2 (Nginx)
↓
NAT Gateway
↓
Internet
↓
S3 Bucket (us-east-1)
```

---

## S3 Configuration

- Bucket Name: `day5-secure-assets-sachin`
- Region: `us-east-1`
- Public Access: Blocked
- Encryption: Enabled (SSE-S3)

Folder Structure:

```
day5-secure-assets-sachin/
├── prod/
└── nonprod/
```

---

## IAM User Setup

IAM User:
```
s3-nonprod-user
```

Permissions:
- Allowed:
  - List and manage objects inside `nonprod/`
- Denied:
  - Access to `prod/`
  - Listing all buckets

---

## IAM Role for Nginx (Least Privilege)

Role Name:
```
nginx-s3-role
```

Permissions:
- List only this specific bucket
- Get, Put, Delete objects inside this bucket

Used by:
- nginx-1
- nginx-2

---

## Networking Requirement

Because:
- VPC is in `ap-south-1`
- S3 is in `us-east-1`

A **NAT Gateway** was created to allow private EC2 instances to access S3.

---

## Testing – IAM User

Login as:
```
s3-nonprod-user
```

Test Results:

## Output 
 Open nonprod folder
![20](https://github.com/user-attachments/assets/48982fd6-174e-47b7-9993-d8466b58f74c)

Upload file in nonprod
![21](https://github.com/user-attachments/assets/d59583c0-dacf-4024-8c6d-7263d5b0cbc4)

---

## Testing – Nginx EC2 (IAM Role)

Run on EC2:

```bash
aws sts get-caller-identity
```
<img width="1919" height="364" alt="22" src="https://github.com/user-attachments/assets/62c93c24-acbc-4e67-a22b-33d3871d8c3f" />


### Final Result
- IAM User is restricted to nonprod folder only
- Nginx application can access the entire bucket
- S3 bucket is private and secure
- Cross-region access is enabled using NAT Gateway
- Least privilege principle is followed

### Conclusion
- This setup ensures:
- Strong security using IAM and bucket isolation
- Controlled access for different environments
- Real-world production grade S3 and IAM architecture
- Safe cross-region communication between EC2 and S3

# Day-6 : CloudFront CDN with Secure S3 Access (Using OAC)

## Objective  
To deliver S3 content securely and faster using CloudFront while keeping the S3 bucket private.  
Only CloudFront should be able to access the S3 bucket, not the public.

---

## Architecture
```
User
↓
CloudFront (CDN)
↓
Origin Access Control (OAC - Signed Requests)
↓
Private S3 Bucket (us-east-1)
```
## Components Used

- Amazon S3 (us-east-1)
- Amazon CloudFront
- Origin Access Control (OAC)
- Bucket Policy (Service Principal: cloudfront.amazonaws.com)

---
## CloudFront Testing

CloudFront Domain:


Test URLs:

Output

prod image 
- https://<cloudfront-domain>/prod/img2.png

nonprod image
- https://<cloudfront-domain>/nonprod/img1.png 
![23 1](https://github.com/user-attachments/assets/8ee387fd-68fd-4726-ae0c-4262baec18fc)

---

## Direct S3 Access Test (Should Fail)

Output
- https://day5-secure-assets-sachin.s3.us-east-1.amazonaws.com/prod/img2.png
- https://day5-secure-assets-sachin.s3.us-east-1.amazonaws.com/nonprod/img1.png
![23 2](https://github.com/user-attachments/assets/2b643220-3b82-4069-bfae-653f1eed1870)

Expected:  
```
AccessDenied
```

---

## Security Validation

| Access Method | Result |
|-------------|-------|
| Direct S3 URL | ❌ Denied |
| CloudFront URL | ✅ Allowed |
| Bucket Public Access | ❌ Blocked |
| CloudFront → S3 | ✅ Allowed via OAC |

---

## Final Result

- S3 bucket is fully private.
- Content is served only via CloudFront.
- CloudFront requests are signed using OAC.
- No public or direct access to S3 objects.
- Secure and production-grade CDN architecture implemented.

---

## Conclusion

This setup ensures:
- High performance using CloudFront CDN
- Strong security using Origin Access Control
- Private S3 access without exposing data
- Proper trust relationship between CloudFront and S3

## Conclusion

This project successfully implements a complete production-grade AWS DevOps architecture.  
It covers the full lifecycle of application deployment, from infrastructure setup to security and performance optimization.

Through this assignment, we achieved:

- High availability using Auto Scaling Groups and Load Balancers  
- Zero downtime deployment strategies and self-healing infrastructure  
- Secure access control using IAM roles and least privilege policies  
- Private S3 bucket access using CloudFront with Origin Access Control (OAC)  
- Fast and global content delivery using CloudFront CDN  
- Proper separation of environments using `prod` and `nonprod` folders  
- End-to-end secure communication between users, servers, and storage  

This architecture reflects real-world enterprise practices where scalability, security, and performance are equally important.  
It demonstrates how AWS services can be combined to build a reliable, secure, and highly optimized cloud infrastructure.

Overall, this project provides a strong foundation in AWS DevOps concepts and showcases practical experience in building and managing modern cloud-native systems.

---

## Author

**Sachin Rajput**
