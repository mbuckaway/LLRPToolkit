# LLRPToolkit
LLRP Toolkit (from Sourceforge CVS with modifications)

This version of the LLRP Toolkit is C++ only as it is all we need for our project. The XSD was fixed so the
code will compile. Further, the original Makefiles were removed and cmake implemented to support building on
multiple platforms. This also means that the Windows specific project/solution files were removed because
they are now unnecessary.  This version of the library is specific to the Lap Project for the Forest City
Velodrome but should work anywhere.

CMake 3.6 or better is required to build. Current the build has been tested on Mac OSX, should work on
Linux, and will require some changes for Windows.

The cmakefiles assume LIBXML2 and LIBXLST are installed on the platform for MacOSX and Linux.

To build, do the following:
1) mkdir build
2) cd build
3) cmake ..
4) make
5) make install

This will create a lib and include directory in the top level containing the files required to use the
libraries in other projects.

Send any updated/changes to mark at buckaway dot ca.

