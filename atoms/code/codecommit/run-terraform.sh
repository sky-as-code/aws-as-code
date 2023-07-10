#!/usr/bin/env bash

COST_CENTER='fin' # or 'sales', 'sec'
REPOSITORY_NAME='book-service'
REPOSITORY_DESC='A microservice to manage books'

TF_DIR=./terraform
source ../../../common/shared-terraform.sh

initTerraform() {
	terraform -chdir=$TF_DIR init
}

planStack() {
	terraform -chdir=$TF_DIR plan \
		-var "cost_center=$COST_CENTER" \
		-var "repo_name=$REPOSITORY_NAME" \
		-var "repo_desc=$REPOSITORY_DESC"
}

applyStack() {
	terraform -chdir=$TF_DIR apply \
		-var "cost_center=$COST_CENTER" \
		-var "repo_name=$REPOSITORY_NAME" \
		-var "repo_desc=$REPOSITORY_DESC"
}

destroyStack() {
	terraform -chdir=$TF_DIR destroy \
		-var "cost_center=$COST_CENTER" \
		-var "repo_name=$REPOSITORY_NAME" \
		-var "repo_desc=$REPOSITORY_DESC"
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
		;;
	*)
		usage
		;;
esac
set +e # Back to default
