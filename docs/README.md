----------------------------------------------------------------------------------

# 📦 Secure Cloud File Sharing Infrastructure (Terraform)

This project automates the provisioning of a **secure, serverless file sharing backend on AWS**, leveraging **Terraform modules** to manage S3, Lambda, API Gateway, and Cognito. 
All core infrastructure components are modular, reusable, and follow best practices for: 
    1. security.
    2. scalability.
    3. compliance.

----------------------------------------------------------------------------------

## 📁 Project Structure

The root files orchestrate the deployment of all modules:

| File            | Purpose                                                                 |
|-----------------|-------------------------------------------------------------------------|
| `main.tf`       | Composes and configures all Terraform modules.                          |
| `variables.tf`  | Declares project-wide input variables such as region and name prefixes. |
| `outputs.tf`    | Exposes key resource outputs like API URL, S3 bucket name, and Cognito. |

----------------------------------------------------------------------------------

## 🎯 Solution Overview

This infrastructure deploys:

- A secure S3 bucket for file uploads/downloads.
- Two AWS Lambda functions for handling file I/O.
- An Amazon API Gateway to expose the functions as HTTPS endpoints.
- Amazon Cognito to manage authentication and access control.

----------------------------------------------------------------------------------

## Modules

### ✅ S3 Module

**Purpose:** Provision a secure S3 bucket to store user files.

**Security & Features:**
- ✅ Server-side encryption using AES256.
- ✅ Bucket versioning enabled.
- ✅ Block all public access.
- ✅ Outputs the bucket name for integration.

**Benefits:**
- **Encryption**: Ensures data at rest is protected for compliance.
- **Versioning**: Helps recover from accidental deletes or overwrites.
- **Modularity**: Reusable across different environments or projects.
- **Restricted Access**: Only Lambda functions have permission to access.

----------------------------------------------------------------------------------

### ✅ Lambda Module

**Purpose:** Provision serverless functions that handle file upload and download.

**Resources Created:**
- IAM role with minimum necessary permissions to access S3.
- Two Lambda functions:
  - `upload_file`
  - `download_file`
- Outputs for integration with API Gateway.

**Benefits:**
- **Stateless & Scalable**: Ideal for event-driven file handling.
- **Minimal IAM Privileges**: Follows the principle of least privilege.
- **Reusability**: Easily plug these functions into other services.

----------------------------------------------------------------------------------

### ✅ API Gateway Module

**Purpose:** Expose secure HTTPS endpoints for file operations via API Gateway.

**Features:**
- Routes for `/upload` and `/download`.
- Integrates directly with Lambda using **AWS_PROXY**.
- Authentication enforced via Cognito.

**Benefits:**
- **Security**: Only authenticated users can access endpoints.
- **Separation of Concerns**: API definitions are modular and isolated.
- **Automation**: No manual console configuration required.
- **Extendability**: Easy to add more endpoints or stages.

----------------------------------------------------------------------------------

### Cognito Module

**Purpose:** Manage authentication and user identity via Amazon Cognito.

**Resources Created:**
- User Pool
- User Pool Client
- (Optional) User Group for future policy assignment

**Benefits:**
- **Authentication Backbone**: Handles sign-up, login, and JWT token issuance.
- **Secure by Default**: Password policy enforcement and email verification.
- **OAuth2 Ready**: Integrates with Cognito Hosted UI if needed.
- **Scalable**: Add identity providers, MFA, or role-based access later.

----------------------------------------------------------------------------------

## 🚀 Deployment Instructions

> Prerequisites: [Terraform](https://developer.hashicorp.com/terraform/downloads), AWS CLI, and an active AWS account.

# Initialize Terraform modules
terraform init
# Preview infrastructure plan
terraform plan
# Deploy the infrastructure
terraform apply


After successful deployment, key outputs will be displayed including:

* API Gateway URL
* Cognito User Pool ID
* S3 Bucket Name

----------------------------------------------------------------------------------

## Sample API Usage

> These endpoints require authentication with a valid Cognito ID token.
### Upload a file (POST)
curl -X POST https://<api_id>.execute-api.<region>.amazonaws.com/prod/upload \
  -H "Content-Type: application/json" \
  -H "Authorization: <Cognito_ID_Token>" \
  -d '{"file_name": "test.txt", "content": "SGVsbG8gd29ybGQ="}'


### Download a file (GET)
curl "https://<api_id>.execute-api.<region>.amazonaws.com/prod/download?file_name=test.txt" \
  -H "Authorization: <Cognito_ID_Token>"

----------------------------------------------------------------------------------

## 🔐 Security Highlights

* End-to-end encryption of data at rest (S3) and in transit (API Gateway HTTPS).
* Cognito user authentication and secure token validation.
* IAM roles scoped with least privilege.
* All infrastructure is managed through **Infrastructure as Code (IaC)** for repeatable and auditable deployments.

----------------------------------------------------------------------------------

## 🧱 Built With

* [Terraform](https://terraform.io) — Infrastructure as Code
* [AWS S3](https://aws.amazon.com/s3/) — Secure file storage
* [AWS Lambda](https://aws.amazon.com/lambda/) — Serverless compute
* [Amazon API Gateway](https://aws.amazon.com/api-gateway/) — HTTP interface to Lambda
* [Amazon Cognito](https://aws.amazon.com/cognito/) — Identity and authentication

----------------------------------------------------------------------------------

## 👨‍💻 Author

**Micah Too**
B.A. in Computer Science — New Mexico State University


---


