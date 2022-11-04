#!/usr/bin/env bash

STACK_NAME='ec2-instance'
INSTANCE_TYPE='t3.micro'

APPLICATION='compute-challenge'
COST_CENTER='fin' # or 'sales', 'sec'
ENV='dev' # or 'prod'

FILE_PATH=$(pwd)/cloudformation/main.yaml

usage() {
	echo "Usage: $(basename "$0") [action]
where action is one of:
   create     Create stack and wait till done
   update     Update stack and wait till done
   delete     Delete stack and wait till done
   describe   Describe stack
   exists     Check if stack exists
"
}

stackExists() {
	set +e
	update_output=$(aws cloudformation describe-stacks \
		--stack-name $STACK_NAME 2>&1)
	status=$?
	set -e

	if [ $status -eq 0 ] ; then
		echo 'true'
	else
		echo 'false'
	fi
}

createStack() {
	echo -e "Creating stack ..."
	aws cloudformation create-stack \
		--stack-name $STACK_NAME \
		--template-body file:///$FILE_PATH \
		--parameters ParameterKey=InstanceType,ParameterValue=$INSTANCE_TYPE \
					ParameterKey=Application,ParameterValue=$APPLICATION \
					ParameterKey=CostCenter,ParameterValue=$COST_CENTER \
					ParameterKey=Environment,ParameterValue=$ENV \
	&& \
	echo "Waiting for stack to be created ..." && \
	aws cloudformation wait stack-create-complete \
		--stack-name $STACK_NAME
}

updateStack() {
	echo -e "Updating stack ..."
	aws cloudformation update-stack \
		--stack-name $STACK_NAME \
		--template-body file:///$FILE_PATH \
		--parameters ParameterKey=InstanceType,ParameterValue=$INSTANCE_TYPE \
					ParameterKey=Application,ParameterValue=$APPLICATION \
					ParameterKey=CostCenter,ParameterValue=$COST_CENTER \
					ParameterKey=Environment,ParameterValue=$ENV \
	&& \
	echo "Waiting for stack update to complete ..." && \
	aws cloudformation wait stack-update-complete \
		--stack-name $STACK_NAME
}

describeStack() {
	echo -e "Describing stack ..."
	echo $(aws cloudformation describe-stacks \
			--stack-name $STACK_NAME 2>&1)
}

deleteStack() {
	echo -e "Deleting stack ..."
	aws cloudformation delete-stack \
		--stack-name $STACK_NAME \
	&& \
	echo "Waiting for stack to be deleted ..." && \
	aws cloudformation wait stack-delete-complete \
		--stack-name $STACK_NAME
}


case $1 in
   create)
      createStack
      ;;
   update)
      updateStack
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
