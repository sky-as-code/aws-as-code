# Challenge: Create a CodeCommit repository

## Problem description

Create a CodeCommit repository.
The solution must abide by following [Common context](../../../README.md#common-context):
  * Single account compliance.
  * Resource tagging compliance.
    * In this special case, only "Name" and "CostCenter" tags are required.

The solution must be generic enough to be reused.

## Solutions

- Cloudformation
- AWS CDK
- Terraform

Refer to [solution.md](/docs/solution.md) for how to run the solutions.

## What we learn

We create CodeCommit credentials in each AWS User detail page.

CodeCommit repository only has basic Git features, it may disappoint those who have used Github, Gitlab or Bitbucket.
