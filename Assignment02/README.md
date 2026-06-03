# Assignment 02 – Deployment Strategies using AWS & Amazon S3

### Name: Sachin Rajput

This README covers the work completed so far for Assignment 02.
Currently implemented strategies:

✅ Recreate Deployment

✅ Rolling Deployment

✅ Blue-Green Deployment

✅ Canary Deployment

Amazon S3 is used for:

Storing static assets (CSS, JS, Images)

Storing deployment artifacts (application ZIP files)

## 1. Recreate Deployment

In Recreate deployment, the old application is stopped and the new version is deployed. It causes downtime but is simple to implement.

### Services Used:

- EC2
- Amazon S3
- AMI

### Implementation:

Created S3 bucket for assets:
- sachin-assignment2

Uploaded:

- images/logo.png  
- css/style.css  
- js/app.js  

Launched EC2 and installed Nginx

Linked S3 assets in index.html

Created AMI:

recreate-app-ami-v1
create new ec2 using <recreate-app-ami-v1>

### Advantages:
- Simple
- Easy to understand
- Disadvantages:
- Downtime
- Not suitable for production

### Output:

S3 bucket structure 
<img width="1919" height="993" alt="1" src="https://github.com/user-attachments/assets/a66ac51d-ca58-46e6-8cc6-715444149f05" />

old version
<img width="1919" height="993" alt="2" src="https://github.com/user-attachments/assets/75dfd07c-573b-48a3-becc-b8d2e322f697" />

new version
<img width="1919" height="993" alt="3" src="https://github.com/user-attachments/assets/01d89123-3054-491e-8d85-ced9f4f3a571" />

AMI created
<img width="1919" height="905" alt="4" src="https://github.com/user-attachments/assets/910ed964-d104-46f4-a9c4-0ac1cfb6da56" />


## 2. Rolling Deployment
In Rolling deployment, instances are updated one by one without downtime.

### Services Used:
- EC2
- Auto Scaling Group (ASG)
- Application Load Balancer (ALB)
- Amazon S3
### Implementation:
- Created S3 bucket:
- sachin-rolling-artifacts
#### Uploaded:
- app-v1.zip  
- app-v2.zip  

#### Created IAM Role:
- ec2-s3-role


#### Created Launch Template:

- rolling-launch-template

#### Created:

- rolling-alb  
- rolling-tg  
- rolling-asg  

#### Updated launch template with app-v2

#### Started Instance Refresh to trigger rolling update

### Advantages:
- No downtime
- Safe deployment
- Disadvantages:
- Setup is complex
- Needs more AWS services

### Output:

S3 artifacts bucket
<img width="1919" height="905" alt="5" src="https://github.com/user-attachments/assets/7c5b9364-daf8-46f0-a36e-629379ea4bf1" />

Launch Template versions
<img width="1919" height="996" alt="6 1" src="https://github.com/user-attachments/assets/4e690d6a-3472-4c06-835d-73d6720898f7" />
<img width="1919" height="996" alt="6 2" src="https://github.com/user-attachments/assets/ea41320a-f142-4df4-822a-b5332e4b8cee" />

ASG Instance Refresh
<img width="1919" height="905" alt="7" src="https://github.com/user-attachments/assets/15e03bf9-24e8-4c0a-9d8d-63e33c415da8" />

Browser showing Version 1
<img width="1919" height="996" alt="8" src="https://github.com/user-attachments/assets/a476396f-2435-403f-bc34-4f4c32205874" />

Browser showing Version 2 
<img width="1919" height="996" alt="9" src="https://github.com/user-attachments/assets/0bc22d24-d718-485b-adf3-610b903099c3" />


## 3. Blue-Green Deployment
**Description:**  
In Blue-Green deployment, two identical environments are created:
- Blue → Current production
- Green → New version  
Traffic is switched from Blue to Green using an Application Load Balancer, allowing the new version to go live without any downtime.

**Services Used:**
- EC2
- Application Load Balancer (ALB)
- Target Groups
- Amazon S3

### Advantages of Blue-Green Deployment:

- Zero downtime deployment
- Instant rollback possible (just switch back to Blue)
- Very safe for production releases
- New version can be fully tested before going live
- No impact on users during deployment
- Easy traffic management using Load Balancer
- Reduces deployment risk
- Improves reliability and confidence in releases
- Clear separation between old and new versions

### Output:

Environment
<img width="1919" height="999" alt="10" src="https://github.com/user-attachments/assets/76aa0a7f-d2ce-4622-bf6e-82870e002c05" />

Target groups
<img width="1919" height="999" alt="11" src="https://github.com/user-attachments/assets/41704d02-a566-488b-aab4-0387fe576f78" />

Application Load Balancer
<img width="1919" height="999" alt="12" src="https://github.com/user-attachments/assets/a521b9b5-d330-4944-8afa-f6c104e6f187" />

<img width="1648" height="464" alt="Screenshot from 2026-01-23 12-10-23" src="https://github.com/user-attachments/assets/21c982e1-8080-4b7e-8eaf-0b167b947255" />

ALB DNS showing Blue output
<img width="1919" height="999" alt="10 1" src="https://github.com/user-attachments/assets/bbe876f9-927b-45b9-97ed-bbad6a443fb0" />

<img width="1648" height="464" alt="Screenshot from 2026-01-23 12-09-35" src="https://github.com/user-attachments/assets/79963a02-6e1a-46f3-a7f4-ca684bec0ace" />
ALB DNS showing green output
<img width="1919" height="999" alt="10 2" src="https://github.com/user-attachments/assets/f4834357-b795-4277-b803-6a3e3f03f6cc" />

## 4. Canary Deployment

**Description:**  
In Canary deployment, a new version of the application is released to a small percentage of users first. The remaining users continue to use the old version. This helps in testing the new version in production with minimal risk.

**Services Used:**
- Application Load Balancer (ALB)
- Target Groups
- EC2 Instances

**Implementation:**
- Used the existing Blue-Green setup.
- Configured the ALB listener to forward traffic to two target groups:
  - `prod` → Old version
  - `green-tg` → New version
- Applied weighted routing:
  - 90% traffic → `prod`
  - 10% traffic → `green-tg`
- Monitored the application behavior by refreshing the ALB DNS URL and observing both versions.

**Result:**
The new version was successfully deployed to a small portion of users without affecting the majority of traffic.

**Output:**
Alb weight routing
<img width="1919" height="943" alt="13" src="https://github.com/user-attachments/assets/fb16c66a-e45e-4560-91b8-418aae9f1bef" />

Browser Output
<img width="1919" height="994" alt="14" src="https://github.com/user-attachments/assets/9525987e-20b0-4b9d-9130-6c63967062b2" />

### Observation

- Issues can be detected at an early stage
- Minimal impact on end users

---

### Pros & Cons

**Pros**

- Safest deployment strategy
- Uses real user traffic for testing
- Reduces the risk of full-scale failures

**Cons**

- Complex to manage
- Requires proper monitoring and alerting
---

## Final Comparison Summary

| Strategy   | Downtime | Cost   | Risk     | Complexity |
| ---------- | -------- | ------ | -------- | ---------- |
| Recreate   | Yes      | Low    | High     | Low        |
| Rolling    | No       | Medium | Medium   | Medium     |
| Blue–Green | No       | High   | Low      | Medium     |
| Canary     | No       | Medium | Very Low | High       |
---

## Conclusion

This assignment demonstrates the practical implementation of multiple deployment strategies on AWS.
Each strategy was tested under real infrastructure conditions using EC2, ALB, ASG, and Amazon S3.

It clearly shows:

- How downtime differs across strategies
- How risk is reduced as deployment methods become more advanced
- How modern DevOps practices focus on reliability, scalability, and safe production releases

---

## Author

**Sachin Rajput**
