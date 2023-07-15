#!/usr/bin/env bash

STACK_NAME='s3-bucket-owner-full-control'

# As bucket name must be globally unique, we add a suffix so that
# everybody running this code won't have name collision error.
DIFFERENTIATOR=$(date +%s)
BUCKET_NAME="reports-$DIFFERENTIATOR"

APPLICATION='storage-challenge'
COST_CENTER='fin' # or 'sales', 'sec'
ENV='dev' # or 'prod'
BUCKET_FULL_NAME="${COST_CENTER}-${APPLICATION}-${ENV}-${BUCKET_NAME}"

FILE_PATH=$(pwd)/cloudformation/main.yaml

source ../../../common/shared-cfm.sh
source ./s3-actions.sh

createMyStack() {
	createStack $STACK_NAME \
		--template-body file:///$FILE_PATH \
		--parameters ParameterKey=Application,ParameterValue=$APPLICATION \
					ParameterKey=CostCenter,ParameterValue=$COST_CENTER \
					ParameterKey=Environment,ParameterValue=$ENV \
					ParameterKey=BucketName,ParameterValue=$BUCKET_NAME
}

updateMyStack() {
	updateStack $STACK_NAME \
		--template-body file:///$FILE_PATH \
		--parameters ParameterKey=Application,ParameterValue=$APPLICATION \
					ParameterKey=CostCenter,ParameterValue=$COST_CENTER \
					ParameterKey=Environment,ParameterValue=$ENV \
					ParameterKey=BucketName,ParameterValue=$BUCKET_NAME
}

myUsage() {
	echo "Usage: $(basename "$0") [action]
where action is one of:
   create     Create stack and wait till done
   update     Update stack and wait till done
   delete     Delete stack and wait till done
   describe   Describe stack
   exists     Check if stack exists"
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
		if [ -z "$2" ]; then
			echo 'error: Must specify bucket full name as second parameter'
			exit
		fi
		emptyBucket $2
		deleteStack $STACK_NAME
		;;
	describe)
		describeStack $STACK_NAME
		;;
	exists)
		stackExists $STACK_NAME
		;;
	uploadData)
		uploadData ./sample-data/waiste-drum.jpg $BUCKET_FULL_NAME
		;;
	*)
	myUsage
	;;
esac
set +e # Back to default
