TOOL_NAME = SwagGen

INSTALL_PATH = /usr/local/bin/$(TOOL_NAME)
SHARE_PATH = /usr/local/share/$(TOOL_NAME)
BUILD_PATH = .build/release/$(TOOL_NAME)
CURRENT_PATH = $(PWD)

format_code:
	swiftformat Tests --wraparguments beforefirst --stripunusedargs closure-only --header strip --disable blankLinesAtStartOfScope
	swiftformat Sources --wraparguments beforefirst --stripunusedargs closure-only --header strip --disable blankLinesAtStartOfScope

install:
	swift build -c release -Xswiftc -static-stdlib
	cp -f $(BUILD_PATH) $(INSTALL_PATH)
	mkdir -p $(SHARE_PATH)
	cp -R $(CURRENT_PATH)/Templates $(SHARE_PATH)/Templates

uninstall:
	rm -f $(INSTALL_PATH)
	rm -f $(SHARE_PATH)
