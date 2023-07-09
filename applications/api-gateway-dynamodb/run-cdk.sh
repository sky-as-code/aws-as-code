#!/usr/bin/env bash

APPLICATION='booksvc'
COST_CENTER='fin' # or 'sales', 'sec'
ENV='dev' # or 'prod'
STACK_NAME="app-api-gateway-dynamodb-$ENV"
source ../../common/shared-cdk.sh

synthStack() {
	npm run --prefix ./cdk cdk synth -- --stackName $STACK_NAME --verbose \
		-c environment=$ENV -c application=$APPLICATION -c costcenter=$COST_CENTER
}

deployStack() {
	npm run --prefix ./cdk cdk deploy  -- --stackName $STACK_NAME --verbose \
		-c environment=$ENV -c application=$APPLICATION -c costcenter=$COST_CENTER
}

destroyStack() {
	npm run --prefix ./cdk cdk destroy -- --stackName $STACK_NAME --verbose \
		-c environment=$ENV -c application=$APPLICATION -c costcenter=$COST_CENTER
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
