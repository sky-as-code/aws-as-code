#!/usr/bin/env bash

AWS_REGION='ap-southeast-1'
COST_CENTER='fin' # or 'sales', 'sec'
REPOSITORY_NAME='book-service'
REPOSITORY_DESC='A microservice to manage books'
REPOSITORY_URL="ssh://git-codecommit.$AWS_REGION.amazonaws.com/v1/repos/$COST_CENTER-$REPOSITORY_NAME"

PROJECT_NAME='book-service-nonprod'
PROJECT_SOURCE_VERSION='main'

TF_DIR=./terraform
source ./functions.sh

initTerraform() {
	terraform -chdir=$TF_DIR init
}

planStack() {
	terraform -chdir=$TF_DIR plan \
		-var "cost_center=$COST_CENTER" \
		-var "repo_name=$REPOSITORY_NAME" \
		-var "repo_desc=$REPOSITORY_DESC" \
		-var "project_name=$PROJECT_NAME" \
		-var "project_source_version=$PROJECT_SOURCE_VERSION"
}

applyStack() {
	terraform -chdir=$TF_DIR apply \
		-var "cost_center=$COST_CENTER" \
		-var "repo_name=$REPOSITORY_NAME" \
		-var "repo_desc=$REPOSITORY_DESC" \
		-var "project_name=$PROJECT_NAME" \
		-var "project_source_version=$PROJECT_SOURCE_VERSION"
}

destroyStack() {
	terraform -chdir=$TF_DIR destroy \
		-var "cost_center=$COST_CENTER" \
		-var "repo_name=$REPOSITORY_NAME" \
		-var "repo_desc=$REPOSITORY_DESC" \
		-var "project_name=$PROJECT_NAME" \
		-var "project_source_version=$PROJECT_SOURCE_VERSION"
}

usage() {
	echo "Usage: $(basename "$0") [action]
where action is one of:
   init          Initialize Terraform before running any other Terraform commands
   plan          Plan the infrascture changes
   apply         Make real changes to the infrastructure
   destroy       Delete all resources in the infrastructure
   prepareRepo   Pull a sample repo and push to new CodeCommit repo
   startBuild    Start CodeBuild project. Must run prepareRepo before this
"
}

set -e # Terminate script execution when an error occurs
case $1 in
	init)
		initTerraform
		;;
	plan)
		planStack
		;;
	apply)
		applyStack
		;;
	destroy)
		destroyStack
		echo '###### WARNING ######'
		echo '# You must MANUALLY delete build history, report group and CloudWatch log group!'
		echo '#####################'
		;;
	prepareRepo)
		prepareRepo $REPOSITORY_URL
		;;
	startBuild)
		startBuild "$COST_CENTER-$PROJECT_NAME"
		;;
	*)
		usage
		;;
esac
set +e # Back to default
