# Makefile for Flutter project

.PHONY: build
build:
	@echo "clean the repository" #printing this log on console
	fvm use && fvm flutter clean

	@echo "getting dependencies"
	fvm flutter pub get

	@echo "Running build runner"
	fvm flutter pub run build_runner build --delete-conflicting-outputs

.PHONY: watch
watch:
	@echo "Running build runner"
	fvm flutter pub run build_runner watch --delete-conflicting-outputs

.PHONY: install_macos
install_macos: build
	fvm flutter build macos
	cp -a build/macos/Build/Products/Release/barko.app /Applications/

.PHONY: install_windows
install_windows: build
	fvm flutter build windows
	start build\windows\x64\runner\Release\

.PHONY: install_windows
install_linux: build
	fvm flutter build linux
