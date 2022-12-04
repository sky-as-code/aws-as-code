# Challenge: Create a Lambda function with inline source code

## Table of content
* [Problem description](#problem-description)
* [Solutions](#solutions)
* [What we learnt](#what-we-learnt)

## Problem description

Create a Lambda function with inline source code. The function must abide by following [Common context](../../../README.md#common-context):
  * Single account compliance.
  * Resource tagging compliance.

When invoked, the function returns information about the deployed environment and department to which it belongs.

The solution must be generic enough to be reused by whatever department.

**Input:**
  * `LambdaName`<br>
    Last part of Lambda function name. The full instance name must be built with this format
    `{costCenter}-{application}-{environment}-{FunctionName}`. For example: sales-ecommerce-dev-process, fin-trend-analytics-prod-report...

    *Required*: Yes

    *Type*: String

  * `MemorySize`<br>
    The amount of memory available to the function at runtime. Increasing the function memory also increases its CPU allocation.

    *Required*: No

    *Type*: Number

  * `Timeout`<br>
    The amount of time (in seconds) that Lambda allows a function to run before stopping it.

    *Required*: No

    *Type*: Number

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
  * `LambdaFullName`<br>
    Full name of the newly created Lambda function.
  * `LambdaArn`<br>
    ARN of the newly created Lambda function.

## Solutions

**WARNING** The solution creates a Lambda function, you will be billed for the created resource if you execute the code.

### **Cloudformation**

You can start with this template and modify it to satisfy this challenge: https://github.com/awslabs/aws-cloudformation-templates/blob/master/aws/services/EC2/EC2InstanceWithSecurityGroupSample.yaml

To run this solution:
  - `cd` to this directory
  - `./run-cfm.sh create` or `./run-cfm.sh` for help menu

To invoke the created Lambda:
  - `./run-cfm.sh invoke`

## What we learnt

Lambda function default timeout is 3 seconds. The maximum allowed value is 900 seconds (15 minutes), while minimum is 1 second.

Default and minimum memory size is 128 MB. The value can be any multiple of 1 MB. Maximum allowed value is 10240 MB.

IAM role for Lambda function must have at least these allowed actions for the function to work properly: `logs:CreateLogStream`, `logs:CreateLogGroup`, `logs:PutLogEvents`.

Providing parameter `--capabilities CAPABILITY_NAMED_IAM` to AWS CLI to acknowledge that we want to allow Cloudformation to modify IAM stuff.

When creating IAM Role with CLI, API or Cloudformation, we can provide optional `path` that can be used in IAM policies. Read more in [IAM friendly name and path](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html#identifiers-friendly-names).