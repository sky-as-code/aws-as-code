# AWS-as-code
A collection of AWS hands-on challenges.

Each challenge has a description and solutions in Cloudformation, AWS CLI and Terraform. You should try to solve the described problem yourself before looking at solutions.

We are aware of our imperfection, so this repository is supposed to bring about a mutual-learning community where everybody can [create tickets](https://github.com/sky-as-code/aws-as-code/issues) or, even better, [raise pull requests](https://github.com/sky-as-code/aws-as-code/pulls) to contribute challenge ideas or solution improvements. 

## Getting started

1. This repository is organized in [atomic design](https://bradfrost.com/blog/post/atomic-web-design/) structure:

    * **Atoms**: Challenges involving only 1 AWS service.
    * **Molecules**: Involving 2, up to 3 AWS services.
    * **Organisms**: Involving more than 3 AWS services.

2. Read the description in README.md file in each challenge folder *carefully*. Note down the resources required to be created and inputs, outputs of the solution. Mandatory or optional inputs may considerably take more effort to implement.

3. You can peek at the script files `*.sh` in challenge folders to see how your solution is invoked.

4. You can reuse the code of solved challenges in later challenge, using [Cloudformation Module](https://aws.amazon.com/blogs/mt/share-reusable-infrastructure-code-aws-cloudformation-modules-and-stacksets/) or Terraform Module.

## Common context

As we aim to design as close to real-life scenarios as possible, all of the challenges share this common context, except when overriden explicitly in one's own description:

You are tasked to implement the infrastructure for an organization with the following details:

> Organization name: **Sky-As-Code corp.**<br>
> Organization code: `sac`<br>

> #1 department name: **Financial**<br>
> #1 department code: `fin`<br>

> #2 department name: **Sales**<br>
> #2 department code: `sales`<br>

> #3 department name: **Security**<br>
> #3 department code: `sec`<br>

> Each department has a separate AWS Account, each has two deployment environments: `dev` and `prod`.

> All department AWS Accounts are under an AWS Organization whose management account belongs to Security department.

> The organization wants to manage [AWS cost allocation using tags](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/cost-alloc-tags.html), so all AWS resources must have these 3 tags:<br>
  * `Application`: Name of the application using this AWS resource.
  * `CostCenter`: The department code
  * `Environment`: The deployment environment

## How to contribute

Kindly refer to [CONTRIBUTING.md](./CONTRIBUTING.md).

## FAQ

**Q:** *Why does the organization name (Sky-As-Code) have hyphen between words?*<br>
**A:** Because of the same reason why Batman one word, Iron Man two words and Spider-Man two words with a hyphen in between.

**Q:** *What if I find one of the solutions not following best practices?*<br>
**A:** You are welcomed to [create a ticket](https://github.com/sky-as-code/aws-as-code/issues) giving links to the best practices, or [raise a pull request](https://github.com/sky-as-code/aws-as-code/pulls) if you have free time, just make sure to include links to sources where you base your opinion on. And don't forget to read [CONTRIBUTING.md](./CONTRIBUTING.md).

**Q:** *Are the solutions safe to use in my company's production environment?*<br>
**A:** You are safe to use source code in this repository for your company's commercial purpose under MIT licence. However, about security and best practice aspects, although we are trying to make them as safe for real-life use as possible, you had better enrich yourself knowledge to decide how to apply the solutions in this repository to your company's production.

## Challenge index (by AWS service name)

*Note:* Some challenges are indexed multiple times because it involves many AWS services.

**ASG**
  - [auto-scaling-group-simple](./atoms/compute/auto-scaling-group-simple)
  - auto-scaling-group-step
  - auto-scaling-group-targettracking

**EC2**
  - [ec2-instance](./atoms/compute/ec2-instance)
  - ec2-instance-ebs-attached-single
  - ec2-instance-ebs-attached-multi
  - ec2-instance-ebs-based
  - ec2-instance-ebs-create-ami
  - ec2-instance-ebs-kms-encrypted
  - ec2-instance-ebs-unencrypted-kms-encrypted
  - ec2-instance-instancestore-based

**EBS**
  - ebs-volume
  - ebs-volume-data-lifecycle-manager
  - ec2-instance-ebs-attached-single
  - ec2-instance-ebs-attached-multi
  - ec2-instance-ebs-based
  - ec2-instance-ebs-create-ami
  - ec2-instance-ebs-kms-encrypted
  - ec2-instance-ebs-unencrypted-kms-encrypted

**KMS**
  - ec2-instance-ebs-kms-encrypted
  - ec2-instance-ebs-unencrypted-kms-encrypted
  - kms-asymmetric-key
  - kms-asymmetric-datakey
  - kms-symmetric-key
  - kms-symmetric-datakey
  - s3-bucket-sse-kms

**S3**
  - [s3-bucket](./atoms/storage/s3-bucket)
  - s3-bucket-lifecycle-policy
  - s3-bucket-sse-s3
  - s3-bucket-sse-kms
  - s3-bucket-web-hosting
