#!/bin/bash
# JSoftFloat is provided as a regular directory at res/jsoftfloat (no submodule).
# Check for that directory instead of using `git submodule` status.
if [ -d res/jsoftfloat ] ; then
    version=$(git describe --tags --match 'v*' --dirty | cut -c2- || echo "unknown")
    echo "Version = $version" > src/Version.properties
    mkdir -p build
    find src -name "*.java" | xargs javac --release 11 -d build
    if [[ "$OSTYPE" == "darwin"* ]]; then
        find src -type f -not -name "*.java" -exec rsync -R {} build \;
    else
        find src -type f -not -name "*.java" -exec cp --parents {} build \;
    fi
    cp -rf build/src/* build
    rm -r build/src
    cp README.md LICENSE build
    cd build
    jar cfm ../rars.jar ./META-INF/MANIFEST.MF *
    chmod +x ../rars.jar
else
    echo "It looks like JSoftFloat is not present in res/jsoftfloat. Ensure the 'res/jsoftfloat' directory exists."
fi
