export EXECUTABLE_NAME = SwagGen
VERSION = 4.6.0

PREFIX = /usr/local
INSTALL_PATH = $(PREFIX)/bin/$(EXECUTABLE_NAME)
SHARE_PATH = $(PREFIX)/share/$(EXECUTABLE_NAME)
BUILD_PATH = .build/release/$(EXECUTABLE_NAME)
CURRENT_PATH = $(PWD)
REPO = https://github.com/yonaskolb/$(EXECUTABLE_NAME)
RELEASE_TAR = $(REPO)/archive/$(VERSION).tar.gz
SWIFT_BUILD_FLAGS = --disable-sandbox -c release --arch arm64 --arch x86_64
SHA = $(shell curl -L -s $(RELEASE_TAR) | shasum -a 256 | sed 's/ .*//')
EXECUTABLE_PATH = $(shell swift build $(SWIFT_BUILD_FLAGS) --show-bin-path)/$(EXECUTABLE_NAME)

build:
	swift build $(SWIFT_BUILD_FLAGS)

install: build
	mkdir -p $(PREFIX)/bin
	cp -f $(EXECUTABLE_PATH) $(INSTALL_PATH)
	mkdir -p $(SHARE_PATH)
	cp -R $(CURRENT_PATH)/Templates $(SHARE_PATH)/Templates

uninstall:
	rm -f $(INSTALL_PATH)
	rm -f $(SHARE_PATH)

format_code:
	swiftformat Tests --wraparguments beforefirst --stripunusedargs closure-only --header strip --disable blankLinesAtStartOfScope
	swiftformat Sources --wraparguments beforefirst --stripunusedargs closure-only --header strip --disable blankLinesAtStartOfScope

update_brew:
	sed -i '' 's|\(url ".*/archive/\)\(.*\)\(.tar\)|\1$(VERSION)\3|' Formula/SwagGen.rb
	sed -i '' 's|\(sha256 "\)\(.*\)\("\)|\1$(SHA)\3|' Formula/SwagGen.rb

	git add .
	git commit -m "Update brew to $(VERSION)"

release:
	sed -i '' 's|\(let version = "\)\(.*\)\("\)|\1$(VERSION)\3|' Sources/SwagGen/main.swift

	git add .
	git commit -m "Update to $(VERSION)"
	#git tag $(VERSION)
