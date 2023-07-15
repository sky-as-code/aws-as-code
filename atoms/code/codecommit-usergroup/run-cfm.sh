#!/usr/bin/env bash

COST_CENTER='fin' # or 'sales', 'sec'
REPOSITORY_NAME='book-service'
REPOSITORY_DESC='A-microservice-to-manage-books' # Must use param JSON file if you want spaces in the string. But I'm too lazy :)
GROUP_FULLACCESS='developers'
GROUP_READONLY='reviewers'
STACK_NAME='codecommit-usergroup'

FILE_PATH=$(pwd)/cloudformation/main.yaml

source ../../../common/shared-cfm.sh

createMyStack() {
	createStack $STACK_NAME \
		--template-body file:///$FILE_PATH \
		--parameters ParameterKey=CostCenter,ParameterValue=$COST_CENTER \
					ParameterKey=RepositoryName,ParameterValue=$REPOSITORY_NAME \
					ParameterKey=RepositoryDesc,ParameterValue=$REPOSITORY_DESC \
					ParameterKey=FullAccessGroupName,ParameterValue=$GROUP_FULLACCESS \
					ParameterKey=ReadOnlyGroupName,ParameterValue=$GROUP_READONLY
}

updateMyStack() {
	updateStack $STACK_NAME \
		--template-body file:///$FILE_PATH \
		--parameters ParameterKey=CostCenter,ParameterValue=$COST_CENTER \
					ParameterKey=RepositoryName,ParameterValue=$REPOSITORY_NAME \
					ParameterKey=RepositoryDesc,ParameterValue=$REPOSITORY_DESC \
					ParameterKey=FullAccessGroupName,ParameterValue=$GROUP_FULLACCESS \
					ParameterKey=ReadOnlyGroupName,ParameterValue=$GROUP_READONLY
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
