PROJECT_NAME=CCLRequestReplay
WORKSPACE=Tests/$(PROJECT_NAME).xcworkspace
XCODEBUILD=xcodebuild -workspace $(WORKSPACE) -scheme CCLRequestReplayTests

bootstrap:
	@printf "\e[32m=> Installing pods\033[0m\n"
	@cd Tests && pod install | sed "s/^/ /"

test:
	@printf "\e[32m=> Running OS X Tests\033[0m\n"
	@$(XCODEBUILD) test | xcpretty -cs | sed "s/^/ /" && exit ; exit ${PIPESTATUS[0]}

all: bootstrap test

