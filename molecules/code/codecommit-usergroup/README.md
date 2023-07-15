# Challenge: Create a CodeCommit repository and grant permissions through AWS User Group

## Problem description

Create a CodeCommit repository and 2 AWS User Group. One group has full access to this repository while the other has readonly access.

The solution must abide by following [Common context](../../../README.md#common-context):
  * Single account compliance.
  * Resource tagging compliance.
    * For CodeCommit repository, only "Name" and "CostCenter" tags are required.

The solution must be generic enough to be reused.

## Solutions

- Cloudformation
- Terraform

Refer to [solution.md](/docs/solution.md) for how to run the solutions.

## What we learn

We manage permissions for CodeCommit repository with IAM policy just like we do with other AWS resources.
