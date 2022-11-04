# Challenge: Single EC2 Instance

## Description

Create a single EC2 Instance abided by the [Common context](../../../README.MD#common-context).
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

  * `InstanceType`<br>
    EC2 instance type. For wallet safety, only free-tier eligible instance types are allowed.

    *Required*: Yes

    *Type*: String

  * `Application`<br>
    Name of the application using this AWS resource. For tag value.

    *Required*: Yes

    *Type*: String

  * `CostCenter`<br>
    The department code. For tag value.

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

## Solution

### **Cloudformation**

You can start with this template and modify it to satisfy this challenge: https://github.com/awslabs/aws-cloudformation-templates/blob/master/aws/services/EC2/EC2InstanceWithSecurityGroupSample.yaml

To run this solution:
  - `cd` to this directory
  - `./run-cfm.sh create` or `./run-cfm.sh` for help menu