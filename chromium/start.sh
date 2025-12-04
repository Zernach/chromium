cd /Users/zernach/code/chromium-parent/src
gn gen out/Default
ninja -C out/Default -t clean chrome
autoninja -C out/Default chrome
out/Default/Chromium.app/Contents/MacOS/Chromium