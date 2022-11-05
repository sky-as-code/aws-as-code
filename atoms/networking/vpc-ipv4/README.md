# Challenge: VPC with one public subnet and one private subnet

## Description

Create a VPC abided by following [Common context](../../../README.md#common-context):
  * Resource tagging compliance.
  * AWS Region compliance.

The solution must be generic enough to be reused by whatever department.

**Input:**
  * `VPCName`<br>
    Last part of VPC instance. The full instance name must be built with this format
    `{costCenter}-{environmentType}-{VPCName`}. For example: fin-nonprod-services-v1, sec-prod-tooling-v123...

    *Required*: Yes

    *Type*: String

  * `NetworkAddressIpV4`<br>
    The IP address part of the CIDR, before slash (/). E.g: 10.0.0.0

    *Required*: Yes

    *Type*: String

  * `SubnetBitsIpV4`<br>
    The bits part of the CIDR, after slash (/). E.g: 8, 16, 24<br>
    Valid values are from `8` to `30`.

    *Required*: Yes

    *Type*: Number

  * `CostCenter`<br>
    The department code.

    *Required*: Yes

    *Type*: String

  * `EnvironmentType`<br>
    The deployment environment type.

    *Required*: Yes

    *Type*: String

**Output:**
  * `VPCId`<br>
    ID of the created VPC. It must be exported for region-wide reuse.

    *Type*: String

  * `NetworkAddressIpV4`<br>
    Value of the parameter `NetworkAddressIpV4` but exported for region-wide reuse.

    *Type*: String

  * `SubnetBitsIpV4`<br>
    Value of the parameter `SubnetBitsIpV4` but exported for region-wide reuse.

    *Type*: String

## Solution

### **Cloudformation**

You can start with this template and modify it to satisfy this challenge: https://github.com/awslabs/aws-cloudformation-templates/blob/master/aws/services/VPC/VPC_With_Managed_NAT_And_Private_Subnet.yaml

To run this solution:
  - `cd` to this directory
  - `./run-cfm.sh create` or `./run-cfm.sh` for help menu

## What we learnt

Since this is a basic challenge without using AWS Organization Service Control Policy to enforce
the AWS Region compliance, we take advantage of `Conditions` block to do validation. The create CLI
will fail with error "Template error: Unable to get mapping" if we configure AWS CLI to run with
disallowed Regions.
