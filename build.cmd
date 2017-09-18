@echo off
echo "Removing old build..."
del /s/q bin include lib
rmdir /s/q bin include lib
echo "Cleaning up..."
del /s/q build
rmdir /s/q build
mkdir build
cd build
cmake -G "NMake Makefiles" ..
nmake install
cd ..


