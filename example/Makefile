.PHONY: build
build:
	@echo "clean the repository" #printing this log on console
	fvm use && fvm flutter clean

	@echo "getting dependencies"
	fvm flutter pub get

.PHONY: watch
watch:
	@echo "Running build runner"
	fvm flutter pub run build_runner watch --delete-conflicting-outputs