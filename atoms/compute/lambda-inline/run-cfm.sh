#!/usr/bin/env bash

STACK_NAME='lambda-inline'
LAMBDA_NAME='sayHello'
MEMORY_SIZE=256
TIME_OUT=2

APPLICATION='compute-challenge'
COST_CENTER='fin' # or 'sales', 'sec'
ENV='dev' # or 'prod'

FILE_PATH=$(pwd)/cloudformation/main.yaml

source ../../../common/shared-cfm.sh

createMyStack() {
	createStack $STACK_NAME \
		--template-body file:///$FILE_PATH \
		--capabilities CAPABILITY_NAMED_IAM \
		--parameters ParameterKey=Application,ParameterValue=$APPLICATION \
					ParameterKey=CostCenter,ParameterValue=$COST_CENTER \
					ParameterKey=Environment,ParameterValue=$ENV \
					ParameterKey=LambdaName,ParameterValue=$LAMBDA_NAME
					# ParameterKey=MemorySize,ParameterValue=$MEMORY_SIZE \
					# ParameterKey=Timeout,ParameterValue=$TIME_OUT
}

updateMyStack() {
	updateStack $STACK_NAME \
		--template-body file:///$FILE_PATH \
		--capabilities CAPABILITY_NAMED_IAM \
		--parameters ParameterKey=Application,ParameterValue=$APPLICATION \
					ParameterKey=CostCenter,ParameterValue=$COST_CENTER \
					ParameterKey=Environment,ParameterValue=$ENV \
					ParameterKey=LambdaName,ParameterValue=$LAMBDA_NAME \
					ParameterKey=MemorySize,ParameterValue=$MEMORY_SIZE \
					ParameterKey=Timeout,ParameterValue=$TIME_OUT
}

invokeFunction() {
	FULL_LAMBDA_NAME="$COST_CENTER-$APPLICATION-$ENV-$LAMBDA_NAME"
	aws lambda invoke \
		--payload '{"name": "Sky-As-Code"}' \
		--function-name $FULL_LAMBDA_NAME \
		--cli-binary-format raw-in-base64-out \
		/dev/stdout
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
	invoke)
		invokeFunction
		;;
	*)
		usage
		;;
esac
set +e # Back to default
