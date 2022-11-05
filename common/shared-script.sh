
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

createStack() {
	STACK_NAME=$1

	echo "Creating stack ..."
	aws cloudformation create-stack --stack-name $STACK_NAME ${@:2}

	echo "Waiting for stack to be created ..."
	aws cloudformation wait stack-create-complete \
		--stack-name $STACK_NAME
}

updateStack() {
	STACK_NAME=$1

	echo "Updating stack ..."
	aws cloudformation update-stack --stack-name $STACK_NAME ${@:2}

	echo "Waiting for stack update to complete ..."
	aws cloudformation wait stack-update-complete \
		--stack-name $STACK_NAME
}

stackExists() {
	STACK_NAME=$1

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

describeStack() {
	STACK_NAME=$1
	echo $(aws cloudformation describe-stacks \
			--stack-name $STACK_NAME 2>&1)
}

deleteStack() {
	STACK_NAME=$1

	echo "Deleting stack ..."
	aws cloudformation delete-stack \
		--stack-name $STACK_NAME

	echo "Waiting for stack to be deleted ..."
	aws cloudformation wait stack-delete-complete \
		--stack-name $STACK_NAME
}
