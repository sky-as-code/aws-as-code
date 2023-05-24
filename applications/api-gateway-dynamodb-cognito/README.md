# Challenge: Create REST API by integrating AWS API Gateway directly with DynamoDB

## Table of content
* [Problem description](#problem-description)
* [Solutions](#solutions)
* [What we learnt](#what-we-learnt)

## Problem description

Create REST API by integrating AWS API Gateway directly with DynamoDB, authenticated with AWS Cognito.
The solution abides by following Common context [Common context](../../../README.md#common-context):
  * Single account compliance.
  * Resource tagging compliance.

The solution must be generic enough to be reused by whatever department.

**Input:**
  * `Application`<br>
    Name of the application using this AWS resource.

    *Required*: Yes

    *Type*: String

  * `CostCenter`<br>
    The department code.

    *Required*: Yes

    *Type*: String

  * `Environment`<br>
    The deployment environment

    *Required*: Yes

    *Type*: String

**Output:**
  * `ApiRootUrl`<br>
    Root Url of the API, excluding the resource path.

    *Type*: String

  * `ApiClientId`<br>
    Client ID used for authentication with Cognito.

    *Type*: String

  * `AuthUrl`<br>
    URL to send authentication request to Cognito.

    *Type*: String

## Solutions

**WARNING** The solution creates a DynamoDB table, you will be billed for the data stored in table and database operations.

### **Cloudformation**

To run this solution:
  - `cd` to this directory
  - `./run-cfm.sh create` or `./run-cfm.sh` for help menu

To clean up all resource:
  - `./run-cfm.sh delete`

### **Terraform**

Before running this solution:
  - Install Terraform CLI
  - `cd` to this directory
  - `cd ./terraform`
  - `terraform init`

To change deployment environment:
  - Edit file `run-terraform.sh` and change variable `ENV`.
  - `cd ./terraform`
  - `terraform workspace new dev`<br>
     (replace `dev` with your environment name).

To run this solution:
  - `cd` to this directory (NOT "terraform" directory)
  - To preview the changes: `./run-terraform.sh plan`
  - To make real changes: `./run-terraform.sh apply`
    - Type `yes` when prompted to apply changes.
  - Show help menu: `./run-terraform.sh`

To clean up all resource:
  - `./run-terraform.sh destroy`

### **Postman**

Import API Collection and Environment files from directory `./postman`

## What we learnt

Cognito provides convenient log-in and sign-up UI.
