# Challenge: Create a Lambda function with inline source code

## Problem description

Create a Lambda function with inline source code. The function must abide by following [Common context](/README.md#common-context):
  * Single account compliance.
  * Resource tagging compliance.

When invoked, the function returns information about the deployed environment and department to which it belongs.

The solution must be generic enough to be reused.

## Solutions

- Cloudformation

Refer to [solution.md](/docs/solution.md) for how to run the solutions.

## What we learn

Lambda function default timeout is 3 seconds. The maximum allowed value is 900 seconds (15 minutes), while minimum is 1 second.

Default and minimum memory size is 128 MB. The value can be any multiple of 1 MB. Maximum allowed value is 10,240 MB.

IAM role for Lambda function must have at least these allowed actions for the function to work properly: `logs:CreateLogStream`, `logs:CreateLogGroup`, `logs:PutLogEvents`.

Providing parameter `--capabilities CAPABILITY_NAMED_IAM` to AWS CLI to acknowledge that we want to allow Cloudformation to modify IAM stuff.

When creating IAM Role with CLI, API or Cloudformation, we can provide optional `path` that can be used in IAM policies. Read more in [IAM friendly name and path](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html#identifiers-friendly-names).
