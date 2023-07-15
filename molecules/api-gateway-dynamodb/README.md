# Challenge: Create REST API by integrating AWS API Gateway directly with DynamoDB

## Problem description

Create REST API by integrating AWS API Gateway directly with DynamoDB.
The solution must abide by following [Common context](../../../README.md#common-context):
  * Single account compliance.
  * Resource tagging compliance.

The solution must be generic enough to be reused.

## Solutions

**WARNING** The solution creates a DynamoDB table, you will be billed for the data stored in table and database operations.

- Cloudformation
- AWS CDK
- Terraform

Refer to [solution.md](/docs/solution.md) for how to run the solutions.

## What we learn

API Gateway supports mapping HTTP/REST requests to a AWS service as well as mapping the response from the AWS service back to HTTP/REST response.
