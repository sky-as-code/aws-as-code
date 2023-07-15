
prepareRepo() {
	CODECOMMIT_REPO=$1
	rm -rf ./sample-rest-helloworld
	git clone --progress https://github.com/sky-as-code/sample-rest-helloworld.git temp-sample-rest-helloworld \
		&& pushd ./temp-sample-rest-helloworld \
		&& git remote add codecommit $CODECOMMIT_REPO \
		&& git push codecommit -f;
	popd
}

startBuild() {
	PROJECT_NAME=$1
	aws codebuild start-build --project-name $PROJECT_NAME | cat
}
