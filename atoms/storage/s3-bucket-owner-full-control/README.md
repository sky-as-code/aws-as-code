# Challenge: Create a single S3 Bucket whose owner has full control

## Problem description

Create a single S3 Bucket abided by following [Common context](/README.md#common-context):
  * Single account compliance.
  * Resource tagging compliance.
  * AWS Region compliance.

The bucket owner must automatically own every object uploaded to the bucket.

The solution must be generic enough to be reused.

**Bonus:**
  * Upload sample data to the created S3 Bucket.
  * Write script to delete the created S3 Bucket.

## Solutions

**WARNING** The solution creates a single S3 Bucket which is free of charge if you execute the code. However you will be BILLED for the uploaded sample data.

- Cloudformation

Refer to [solution.md](/docs/solution.md) for how to run the solutions.

- To upload sample data: `./run-cfm.sh uploadData`
- To destroy the stack: `./run-cfm.sh delete [bucket_full_name]`, where `bucket_full_name` is the bucket name you copy from AWS Console.

## What we learn

* To delete a S3 Bucket, or to destroy a Cloudformation stack containing a S3 Bucket, we must first empty the Bucket. Otherwise we'll have an error.
