#!/usr/bin/env bash

COST_CENTER='fin' # or 'sales', 'sec'
REPOSITORY_NAME='book-service'
REPOSITORY_DESC='A microservice to manage books'
STACK_NAME='codecommit'
source ../../../common/shared-cdk.sh

synthStack() {
	npm run --prefix ./cdk cdk synth -- --stackName $STACK_NAME --verbose \
		-c costcenter=$COST_CENTER -c repositoryname="$REPOSITORY_NAME" -c repositorydesc="$REPOSITORY_DESC"
}

deployStack() {
	npm run --prefix ./cdk cdk deploy  -- --stackName $STACK_NAME --verbose \
		-c costcenter=$COST_CENTER -c repositoryname="$REPOSITORY_NAME" -c repositorydesc="$REPOSITORY_DESC"
}

destroyStack() {
	npm run --prefix ./cdk cdk destroy -- --stackName $STACK_NAME --verbose \
		-c costcenter=$COST_CENTER -c repositoryname="$REPOSITORY_NAME" -c repositorydesc="$REPOSITORY_DESC"
}


set -e # Terminate script execution when an error occurs
case $1 in
	synth)
		synthStack
		;;
	deploy)
		deployStack
		;;
	destroy)
		destroyStack
		;;
	*)
		usage
		;;
esac
set +e # Back to default
