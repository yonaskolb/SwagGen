TOOL_NAME = swaggen
VERSION = 4.2.0

PREFIX = /usr/local
INSTALL_PATH = $(PREFIX)/bin/$(TOOL_NAME)
SHARE_PATH = $(PREFIX)/share/$(TOOL_NAME)
BUILD_PATH = .build/release/$(TOOL_NAME)
CURRENT_PATH = $(PWD)
REPO = https://github.com/yonaskolb/$(TOOL_NAME)
RELEASE_TAR = $(REPO)/archive/$(VERSION).tar.gz
SHA = $(shell curl -L -s $(RELEASE_TAR) | shasum -a 256 | sed 's/ .*//')

build:
	swift build --disable-sandbox -c release

install: build
	mkdir -p $(PREFIX)/bin
	cp -f $(BUILD_PATH) $(INSTALL_PATH)
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
