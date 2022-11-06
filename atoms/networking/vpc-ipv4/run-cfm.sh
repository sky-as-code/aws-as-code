#!/usr/bin/env bash

STACK_NAME='vpc-ipv4'
VPC_NAME='services-v1'
NETWORK_ADDR='10.0.0.0'
NETWORK_BITS=16
COST_CENTER='fin' # or 'sales', 'sec'
ENV_TYPE='nonprod' # or 'prod'

FILE_PATH=$(pwd)/cloudformation/main.yaml

source ../../../common/shared-cfm.sh

createMyStack() {
	createStack $STACK_NAME \
		--template-body file:///$FILE_PATH \
		--parameters ParameterKey=CostCenter,ParameterValue=$COST_CENTER \
					ParameterKey=EnvironmentType,ParameterValue=$ENV_TYPE \
					ParameterKey=VPCName,ParameterValue=$VPC_NAME \
					ParameterKey=NetworkAddressIpV4,ParameterValue=$NETWORK_ADDR \
					ParameterKey=CidrBlockSizeIpV4,ParameterValue=$NETWORK_BITS
}

updateMyStack() {
	updateStack $STACK_NAME \
		--template-body file:///$FILE_PATH \
		--parameters ParameterKey=CostCenter,ParameterValue=$COST_CENTER \
					ParameterKey=EnvironmentType,ParameterValue=$ENV_TYPE \
					ParameterKey=VPCName,ParameterValue=$VPC_NAME \
					ParameterKey=NetworkAddressIpV4,ParameterValue=$NETWORK_ADDR \
					ParameterKey=CidrBlockSizeIpV4,ParameterValue=$NETWORK_BITS
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
