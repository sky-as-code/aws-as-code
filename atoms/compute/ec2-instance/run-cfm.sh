#!/usr/bin/env bash

STACK_NAME='ec2-instance'
INSTANCE_NAME='webserver'
INSTANCE_TYPE='t3.micro'

APPLICATION='compute-challenge'
COST_CENTER='fin' # or 'sales', 'sec'
ENV='dev' # or 'prod'

FILE_PATH=$(pwd)/cloudformation/main.yaml

source ../../../common/shared-script.sh

createMyStack() {
	createStack $STACK_NAME \
		--template-body file:///$FILE_PATH \
		--parameters ParameterKey=InstanceType,ParameterValue=$INSTANCE_TYPE \
					ParameterKey=InstanceName,ParameterValue=$INSTANCE_NAME \
					ParameterKey=Application,ParameterValue=$APPLICATION \
					ParameterKey=CostCenter,ParameterValue=$COST_CENTER \
					ParameterKey=Environment,ParameterValue=$ENV
					# ParameterKey=AmiId,ParameterValue='/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-ebs'
					# ParameterKey=AvailabilityZone,ParameterValue='ap-southeast-1c'
}

updateMyStack() {
	updateStack  $STACK_NAME \
		--template-body file:///$FILE_PATH \
		--parameters ParameterKey=InstanceType,ParameterValue=$INSTANCE_TYPE \
					ParameterKey=InstanceName,ParameterValue=$INSTANCE_NAME \
					ParameterKey=Application,ParameterValue=$APPLICATION \
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
      deleteStack
      ;;
   describe)
      describeStack
      ;;
   exists)
      stackExists
      ;;
   *)
     usage
     ;;
esac
set +e # Back to default
