#!/bin/bash
# Build and run Chromium from the parent src directory

# Change to the parent src directory where dependencies are fixed
cd "$(dirname "$0")/.."

# Generate build files
gn gen out/Default --args="is_debug=false"

# Clean and build chrome
ninja -C out/Default -t clean chrome
autoninja -C out/Default chrome

# Run Chromium
out/Default/Chromium.app/Contents/MacOS/Chromium