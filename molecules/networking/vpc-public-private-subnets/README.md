# Challenge: Create a VPC with 1 public and 2 private subnets

## Table of content
* [Problem description](#problem-description)
* [Solutions](#solutions)
* [What we learnt](#what-we-learnt)

## Problem description

Create a VPC with IPv4 CIDR block, and 1 public, 2 private subnets. All of them are abided by following [Common context](../../../README.md#common-context):
  * Single account compliance.
  * Resource tagging compliance.
  * AWS Region compliance.

The public subnet are accessible to Internet while private subnets are not.

The solution must be generic enough to be reused by whatever department.

The solution may decide the CIDR blocks itself, or it may accept parameters for VPC's, public subnet's and 2 private subnets' CIDR blocks.

**Input:**
  * `VpcName`<br>
    Last part of VPC instance. The full name must be built with this format
    `{costCenter}-{environmentType}-{VpcName`}. For example: fin-nonprod-services-v1, sec-prod-tooling-v123...

    *Required*: Yes

    *Type*: String

  * `NetworkAddressIpV4`<br>
    The IP address part of the VPC CIDR block, before slash (/). E.g: 10.0.0.0

    *Required*: Yes

    *Type*: String

  * `CidrBlockSizeIpV4`<br>
    The bits part of the VPC CIDR block, after slash (/). E.g: 8, 16, 24<br>
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
  * `VpcId`<br>
    ID of the created VPC. It must be exported for region-wide reuse.

    *Type*: String

  * `PublicSubnetId`<br>
    ID of created public subnet. It must be exported for region-wide reuse.

    *Type*: String

  * `PrivateSubnetId0`<br>
    ID of created private subnet #1. It must be exported for region-wide reuse.

    *Type*: String

  * `PrivateSubnetId1`<br>
    ID of created private subnet #2. It must be exported for region-wide reuse.

    *Type*: String

## Solutions

**NOTICE** The solution creates a VPC, an Internet gateway, 3 subnets and their corresponding Route tables, Network NACLs, all of which are free of charge.
You won't be billed for the created resources if you execute the code.

### **Cloudformation**

You can start with this template and modify it to satisfy this challenge: https://github.com/awslabs/aws-cloudformation-templates/blob/master/aws/services/VPC/VPC_With_Managed_NAT_And_Private_Subnet.yaml

To run this solution:
  - `cd` to this directory
  - `./run-cfm.sh create` or `./run-cfm.sh` for help menu

## What we learnt

* If a subnet is not explicitly associated with a Network ACL, it will be automatically associated with the default NACL of the VPC.

* Since this is a basic challenge without using AWS Organization Service Control Policy to enforce
the AWS Region compliance, we take advantage of `Conditions` block to do validation. The create CLI
will fail with error "Template error: Unable to get mapping" if we configure AWS CLI to run with
disallowed Regions.
