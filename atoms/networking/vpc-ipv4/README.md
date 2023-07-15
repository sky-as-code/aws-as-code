# Challenge: Create a single VPC with IPv4 CIDR block

## Problem description

Create a VPC with IPv4 CIDR block, abided by following [Common context](/README.md#common-context):
  * Single account compliance.
  * Resource tagging compliance.
  * AWS Region compliance.

The solution must be generic enough to be reused.

## Solutions

- Cloudformation

Refer to [solution.md](/docs/solution.md) for how to run the solutions.

## What we learn

Since this is a basic challenge without using AWS Organization Service Control Policy to enforce the AWS Region compliance, we take advantage of `Conditions` block to do validation. The create CLI will fail with error "Template error: Unable to get mapping" if we configure AWS CLI to run with disallowed Regions.
