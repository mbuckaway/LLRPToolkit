#!/bin/bash
if [ -d bin ]
then
	echo "Removing old build..."
	rm -rf bin include lib
fi
if [ -d build ]
then
	echo "Cleaning up..."
	rm -rf build
fi
mkdir -p build
pushd build
cmake ..
make install
popd

