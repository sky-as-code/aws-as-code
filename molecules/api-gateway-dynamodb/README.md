# Challenge: Create REST API by integrating AWS API Gateway directly with DynamoDB

## Table of content
* [Problem description](#problem-description)
* [Solutions](#solutions)
* [What we learnt](#what-we-learnt)

## Problem description

Create REST API by integrating AWS API Gateway directly with DynamoDB.
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

## Solutions

**WARNING** The solution creates a DynamoDB table, you will be billed for the data stored in table and database operations.

### **Cloudformation**

To run this solution:
  - `cd` to this directory
  - `./run-cfm.sh create` or `./run-cfm.sh` for help menu

To clean up all resource:
  - `./run-cfm.sh delete`

### **AWS CDK**

Before running this solution:
  - Install NodeJS >= v18
  - `cd` to this directory
  - `cd ./cdk`
  - Install depedencies: `npm install`

To run this solution:
  - `cd` to this directory (NOT `./cdk`)
  - `./run-cdk.sh deploy` or `./run-cdk.sh` for help menu

To clean up all resource:
  - `./run-cdk.sh destroy`

### **Terraform**

Before running this solution:
  - Install Terraform CLI
  - `cd` to this directory
  - Run this command only once:
    ```bash
    ./run-terraform.sh init
    ```

To run this solution:
  - `cd` to this directory
  - To preview the changes: `./run-terraform.sh plan`
  - To make real changes: `./run-terraform.sh apply`
    - Type `yes` when prompted to apply changes.
  - Show help menu: `./run-terraform.sh`

To clean up all resource:
  - `./run-terraform.sh destroy`

## What we learnt

API Gateway lets our client applications read/write directly from/to DynamoDB.