TOOL_NAME = SwagGen

INSTALL_PATH = /usr/local/bin/$(TOOL_NAME)
SHARE_PATH = /usr/local/share/$(TOOL_NAME)
BUILD_PATH = .build/release/$(TOOL_NAME)
CURRENT_PATH = $(PWD)

install:
	swift build -c release -Xswiftc -static-stdlib
	cp -f $(BUILD_PATH) $(INSTALL_PATH)
uninstall:
	rm -f $(INSTALL_PATH)
