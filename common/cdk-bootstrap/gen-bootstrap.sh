#!/usr/bin/env bash

source ../../common/shared-cfm.sh

generateTemplate() {
	echo "Generating bootstrap template ..."
	npx --yes cdk bootstrap --show-template | cat > bootstrap-template.yaml
	echo "Bootstrap template saved to bootstrap-template.yaml"
}

myUsage() {
	usage
	echo '   gen        Generate bootstrap template\n'
}

set -e # Terminate script execution when an error occurs
case $1 in
	gen)
		generateTemplate
		;;
	create)
		createStack CDKToolkit --template-body file://bootstrap-template.yaml
		;;
	update)
		updateStack CDKToolkit --template-body file://bootstrap-template.yaml
		;;
	delete)
		deleteStack CDKToolkit
		;;
	describe)
		describeStack CDKToolkit
		;;
	exists)
		stackExists CDKToolkit
		;;
	*)
		myUsage
		;;
esac
set +e # Back to default