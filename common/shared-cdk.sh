
usage() {
	echo "Usage: $(basename "$0") [action]
where action is one of:
   synth     Generate CloudFormation template
   deploy    Make real changes to the infrastructure
   destroy   Delete all resources in the infrastructure
"
}
