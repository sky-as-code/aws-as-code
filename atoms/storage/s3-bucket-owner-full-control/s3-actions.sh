
emptyBucket() {
	BUCKET_FULL_NAME=$1
	echo "Deleting all files in S3 Bucket $BUCKET_FULL_NAME ..."
	aws s3 rm s3://$BUCKET_FULL_NAME --recursive
}

uploadData() {
	FILE_PATH=$1
	BUCKET_FULL_NAME=$2
	echo "Uploading $FILE_PATH to S3 Bucket $BUCKET_FULL_NAME ..."
	# Reference: https://docs.aws.amazon.com/cli/latest/userguide/cli-services-s3-commands.html#using-s3-commands-managing-objects-copy
	aws s3 cp $FILE_PATH s3://$BUCKET_FULL_NAME
}
