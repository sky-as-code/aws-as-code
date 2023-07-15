
usage() {
	echo "Usage: $(basename "$0") [action]
where action is one of:
   init      Initialize Terraform before running any other Terraform commands
   plan      Plan the infrascture changes
   apply     Make real changes to the infrastructure
   destroy   Delete all resources in the infrastructure
"
}
