#!/usr/bin/env bash

APPLICATION='booksvc'
COST_CENTER='fin' # or 'sales', 'sec'
ENV='dev' # or 'prod'

TF_DIR=./terraform
source ../../common/shared-terraform.sh

initTerraform() {
	terraform -chdir=$TF_DIR init
}

planStack() {
	terraform  -chdir=$TF_DIR plan \
		-var "app_name=${APPLICATION}" \
		-var "cost_center=${COST_CENTER}" \
		-var "environment_name=${ENV}"
}

applyStack() {
	terraform  -chdir=$TF_DIR apply \
		-var "app_name=${APPLICATION}" \
		-var "cost_center=${COST_CENTER}" \
		-var "environment_name=${ENV}"
}

destroyStack() {
	terraform -chdir=$TF_DIR destroy \
		-var "app_name=${APPLICATION}" \
		-var "cost_center=${COST_CENTER}" \
		-var "environment_name=${ENV}"
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
