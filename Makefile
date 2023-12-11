fmt:
	swift-format -i Sources/ -r

build:
	swift build -c release --arch arm64 --arch x86_64
