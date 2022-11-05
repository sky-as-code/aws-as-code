# CONTRIBUTION GUIDELINES

## Project structure

This repository is organized in [atomic design](https://bradfrost.com/blog/post/atomic-web-design/) structure:

* **Atoms**: Challenges involving only 1 AWS service, not counting its subordinate resources.
  For example 1 VPC with 1 subnet, route table, route entry, subnet-route table association, NACL, NACL entry, subnet-NACL association...
* **Molecules**: Involving 2, up to 3 AWS services, not counting their subordinate resources.
* **Organisms**: Involving more than 3 AWS services, not counting their subordinate resources.

## Solution rules

* All solutions not involving AWS Organization must use Cost Center `fin`, Environment `dev` and EnvironmentType `nonprod` in execution Bash script for consistency and predictable Region-wide Cloudformation exported values.
* Execution scripts must be Bash-compatible.
