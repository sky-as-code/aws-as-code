# How to run solution source code

## Prerequisite

* You must install AWS CLI tool and run `aws configure` to have a working `~/.aws/credentials` file. Almost all solutions rely on this configuration to work, except some challenges generate itself temporary AWS credentials.

* The `.sh` files are utility Bash scripts which save us from typing a lot. You must execute them only in supported environments:
   - MacOS terminal
   - Any Linux distro terminal that supports Bash
      - Windows Subsystem for Linux (WSL) is also a supported distro
   - Any Linux distro Docker image that has Bash installed, for example: [ubuntu](https://hub.docker.com/_/ubuntu), [debian](https://hub.docker.com/_/debian) etc.

Some examples of UNsupported environments:
   - Docker [Alpine image](https://hub.docker.com/_/alpine), which doesn't have Bash installed
   - Git Bash on Windows

## For CloudFormation (CFM)

To run a CFM solution:
  - `cd` to the challenge directory
  - `./run-cfm.sh create` to deploy solution or `./run-cfm.sh` for help menu

To clean up all resource:
  - `./run-cfm.sh delete`
  - Some challenges may require **manual resource deletion**. Don't forget to read the README.md of each challenge for specific instructions to **avoid unexpected cost**.

## For AWS CDK

You must bootstrap the Cloudformation "CDKToolkit" stack that AWS CDK requires:
  - Standing at this repository root
  - `cd ./common/cdk-bootstrap`
  - `./gen-bootstrap.sh`

Visit this official document to learn more: [AWS CDK Bootstrapping](https://docs.aws.amazon.com/cdk/v2/guide/bootstrapping.html).

Before running a CDK solution:
  - Install NodeJS >= v18
  - `cd` to the challenge directory
  - `cd ./cdk`
  - Install depedencies: `npm install`

To run a CDK solution:
  - `cd` to the challenge directory
  - `./run-cdk.sh deploy` to deploy solution or `./run-cdk.sh` for help menu

To clean up all resource:
  - `./run-cdk.sh destroy`
  - `rm -rf ./cdk/node_modules` to save disk space.
  - Some challenges may require **manual resource deletion**. Don't forget to read the README.md of each challenge for specific instructions to **avoid unexpected cost**.

## Terraform

Before running a Terraform solution:
  - Install Terraform CLI, which requires AWS CLI. Make sure you have followed the [Prerequisite](#prerequisite) section.
  - `cd` to the challenge directory
  - Run this command only once: `./run-terraform.sh init`

To run a Terraform solution:
  - `cd` to the challenge directory
  - To preview changes: `./run-terraform.sh plan`
  - To make real changes: `./run-terraform.sh apply`
    - Type `yes` when prompted to apply changes.
  - Show help menu: `./run-terraform.sh`

To clean up all resource:
  - `./run-terraform.sh destroy`
  - Some challenges may require **manual resource deletion**. Don't forget to read the README.md of each challenge for specific instructions to **avoid unexpected cost**.
