# Challenge: Create an Auto Scaling Group with scheduled scaling policy

## Table of content
* [Problem description](#problem-description)
* [Solutions](#solutions)
* [What we learnt](#what-we-learnt)

## Problem description

Create an Auto Scaling Group with scheduled scaling policy, abided by following [Common context](../../../README.md#common-context):
  * Single account compliance.
  * Resource tagging compliance.
  * AWS Region compliance.

The solution must be generic enough to be reused by whatever department.

**Input:**
  * `AmiId`<br>
    [A public SSM Parameter path for AMI ID](https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-public-parameters-ami.html).

    *Required*: No

    *Default*: Latest Amazon Linux 2, gp2 SSD Volume Type, 64-bit (x86)

    *Type*: String

  * `AvailabilityZones`<br>
    A comma-separated list of Availability Zones where instances in the Auto Scaling group can be created.<br>
    If not specified, default are all Availability Zone of current Region.

    *Required*: No

    *Type*: String

  * `GroupName`<br>
    Last part of ASG name. The full instance name must be built with this format
    `{costCenter}-{application}-{environment}-{GroupName}`. For example: sales-ecommerce-dev-webservers, fin-trend-analytics-prod-reportingservers...

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
  * `AsgName`<br>
    Full name of the newly created Auto Scaling Group.

    *Type*: String
## Solutions

**WARNING** The solution creates an Auto Scaling Group with running EC2 Instances, you will be billed for the created resource if you execute the code
when you have gone out of your 12-month free-tier.

### **Cloudformation**

To run this solution:
  - `cd` to this directory
  - `./run-cfm.sh create` or `./run-cfm.sh` for help menu

## What we learnt

How to use cfn-signal script together with Autoscaling Group's CreationPolicy's ResourceSignal.

