#!/usr/bin/env bash

STACK_NAME='app-api-gateway-dynamodb'

APPLICATION='booksvc'
COST_CENTER='fin' # or 'sales', 'sec'
ENV='dev' # or 'prod'

FILE_PATH=$(pwd)/cloudformation/main.yaml

source ../../common/shared-cfm.sh

createMyStack() {
	createStack $STACK_NAME \
		--template-body file:///$FILE_PATH \
		--capabilities CAPABILITY_IAM \
		--parameters ParameterKey=Application,ParameterValue=$APPLICATION \
					ParameterKey=CostCenter,ParameterValue=$COST_CENTER \
					ParameterKey=Environment,ParameterValue=$ENV
}

updateMyStack() {
	updateStack $STACK_NAME \
		--template-body file:///$FILE_PATH \
		--capabilities CAPABILITY_IAM \
		--parameters ParameterKey=Application,ParameterValue=$APPLICATION \
					ParameterKey=CostCenter,ParameterValue=$COST_CENTER \
					ParameterKey=Environment,ParameterValue=$ENV
}

set -e # Terminate script execution when an error occurs
case $1 in
	create)
		createMyStack
		;;
	update)
		updateMyStack
		;;
	delete)
		deleteStack $STACK_NAME
		;;
	describe)
		describeStack $STACK_NAME
		;;
	exists)
		stackExists $STACK_NAME
		;;
	*)
		usage
		;;
esac
set +e # Back to default
