# Challenge: Create a single EC2 Instance

## Table of content
* [Problem description](#problem-description)
* [Solutions](#solutions)
* [What we learnt](#what-we-learnt)

## Problem description

Create a single EC2 Instance abided by following [Common context](../../../README.md#common-context):
  * Single account compliance.
  * Resource tagging compliance.

The solution must be generic enough to be reused by whatever department.

**Input:**
  * `AmiId`<br>
    [A public SSM Parameter path for AMI IDs](https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-public-parameters-ami.html).

    *Required*: No

    *Default*: Latest Amazon Linux 2, gp2 SSD Volume Type, 64-bit (x86)

    *Type*: String

  * `AvailabilityZone`<br>
    The Availability Zone of the instance.<br>
    If not specified, an Availability Zone will be automatically chosen based on
    the load balancing criteria for the Region.

    *Required*: No

    *Type*: String

  * `InstanceName`<br>
    Last part of EC2 instance name. The full instance name must be built with this format
    `{costCenter}-{application}-{environment}-{InstanceName}`. For example: sales-ecommerce-dev-webserver, fin-trend-analytics-prod-reportingserver...

    *Required*: Yes

    *Type*: String

  * `InstanceType`<br>
    EC2 instance type. For wallet safety, only 12-month free-tier eligible instance types are allowed.

    *Required*: Yes

    *Type*: String

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
  * `AvailabilityZone`<br>
    The Availability Zone of the instance.

    *Type*: String

  * `InstanceId`<br>
    InstanceId of the newly created EC2 instance.

    *Type*: String

  * `PublicDNS`<br>
    Public DNS name of the newly created EC2 instance.

    *Type*: String

  * `PublicIP`<br>
    Public IP address of the newly created EC2 instance.

    *Type*: String

## Solutions

**WARNING** The solution creates an EC2 Instance, you will be billed for the created resource if you execute the code
when you have gone out of your 12-month free-tier.

### **Cloudformation**

You can start with this template and modify it to satisfy this challenge: https://github.com/awslabs/aws-cloudformation-templates/blob/master/aws/services/EC2/EC2InstanceWithSecurityGroupSample.yaml

To run this solution:
  - `cd` to this directory
  - `./run-cfm.sh create` or `./run-cfm.sh` for help menu

## What we learnt

If a VPC isn't specified, and if your account is created before 2013-12-04, you have an option to launch EC2-Classic Instance outside VPC. If your account is after 2013-12-04, your new EC2 Instance will automatically be put in default VPC of the Region.

If Availability Zone isn't specified, an Availability Zone will be automatically chosen for your new EC2 Instance based on the balance criteria of the Region.
