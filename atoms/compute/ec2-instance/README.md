# Challenge: Create a single EC2 Instance

## Problem description

Create a single EC2 Instance abided by following [Common context](/README.md#common-context):
  * Single account compliance.
  * Resource tagging compliance.

The solution must be generic enough to be reused.

## Solutions

**WARNING** The solution creates an EC2 Instance, you will be billed for the created resource if you execute the code when you have gone out of your 12-month free-tier.

- Cloudformation

Refer to [solution.md](/docs/solution.md) for how to run the solutions.

## What we learn

If a VPC isn't specified, and if your account is created before 2013-12-04, you have an option to launch EC2-Classic Instance outside VPC. If your account is after 2013-12-04, your new EC2 Instance will automatically be put in default VPC of the Region.

If Availability Zone isn't specified, an Availability Zone will be automatically chosen for your new EC2 Instance based on the balance criteria of the Region.
