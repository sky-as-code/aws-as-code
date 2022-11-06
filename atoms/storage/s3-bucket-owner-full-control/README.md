# Challenge: Create a single S3 Bucket whose owner has full control

## Table of content
* [Problem description](#problem-description)
* [Solutions](#solutions)
* [What we learnt](#what-we-learnt)

## Problem description

Create a single S3 Bucket abided by following [Common context](../../../README.md#common-context):
  * Single account compliance.
  * Resource tagging compliance.
  * AWS Region compliance.

The bucket owner must automatically own every object uploaded to the bucket.

The solution must be generic enough to be reused by whatever department.

**Bonus:**
  * Upload sample data to the created S3 Bucket.
  * Write script to delete the created S3 Bucket.

**Input:**
  * `BucketName`<br>
    Last part of S3 Bucket. The full name must be built with this format
    `{costCenter}-{application}-{environment}-{BucketName}`. For example: sales-ecommerce-dev-avatars, fin-trend-analytics-prod-reports...

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
  * `BucketName`<br>
    Full name of the created S3 Bucket

## Solutions

**WARNING** The solution creates a single S3 Bucket which is free of charge if you execute the code.
However you will be BILLED for the uploaded sample data resources. If you don't want to be charged, remove or comment out the uploading
command in execution shell script.

### **Cloudformation**

You can start with this template and modify it to satisfy this challenge: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-attribute-deletionpolicy.html#aws-attribute-deletionpolicy-example.yaml

S3 commands to upload objects and empty bucket: https://docs.aws.amazon.com/cli/latest/userguide/cli-services-s3-commands.html

To run this solution:
  - `cd` to this directory
  - `./run-cfm.sh create` or `./run-cfm.sh` for help menu

To destroy the stack: `./run-cfm.sh delete [bucket_full_name]`, where `bucket_full_name` is the bucket name you copy from AWS Console.

## What we learnt

* To delete a S3 Bucket, or to destroy a Cloudformation stack containing a S3 Bucket, we must first empty the Bucket. Otherwise we'll have error.
