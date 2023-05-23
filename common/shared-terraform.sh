
usage() {
	echo "Usage: $(basename "$0") [action]
where action is one of:
   plan      Plan the infrascture changes
   apply     Make real changes to the infrastructure
   destroy   Delete all resources in the infrastructure
"
}
