# Description

This package contains common functions used thoughout the building of various tools with cmake. 
It also defines a set of compilers rules optimized for ECCC's many platforms and compilers

# Usage
This package can be included as a submodule or used through the CMAKE_MODULE_PATH environment variable

## functions

* include(ec_init)
  * Initialises some variables and the compiler suite. if the compiler suite is not defined (cmake -COMPILER_SUITE=[gnu|intel|xlf], it will be determined by the compiler which is loaded on the platform. default is gnu
* include(ec_parse_manifest)
  * Parse a MANIFEST file defining package information, and dependencies and defines the variables NAME, VERSION, BUILD, DESCRITPTION, MAINTAINER, URL and for each dependencies [dependency]_REQ_VERSION, [dependency]_REQ_VERSION_MAJOR, [dependency]_REQ_VERSION_MINOR, [dependency]_REQ_VERSION_PATCH. ex:
```shell
NAME       : libgeoref
VERSION    : 0.1.0
BUILD      : Debug
DESCRIPTION: ECCC-CCMEP Geo reference manipulation library
SUMMARY    : This library allows for reprojection, coordinate transform and interpolation in between various type of geo reference (RPN,WTK,meshes,...)
MAINTAINER : Jean-Philipe Gauthier - Jean-Philipep.Gauthier@canada.ca 
URL        : https://gitlab.science.gc.ca/RPN-SI/libgeoref

# Dependencies 
#    =,<,<=,>,>= : Version rules
#    ~           : Optional

RMN  ~>= 19.7.0
VGRID ~= 6.5.0
GDAL ~>= 2.0
```

* include(ec_build_info)
  * Produces an include file (build_info.h) with build information (BUILD_TIMESTAMP,BUILD_INFO,BUILD_ARCH,BUILD_USER,VERSION,DESCRIPTION) and an associated target (build_info) that will updated the timestamp on call to make.

* include(doxygen) 
  * Provides a Doxygen target to build the documentation

* include(compiler_presets)
  * Loads predefined compiler settings optimized per compiler and platform

* include(ec_bin_config)
  * Parse a file named "config.in" in the trunk to produce a configuration information script "[NAME]-config" giving information on how the package was built (compiler, rmn_version, ...):

* include(git_version)
  * Extracts the version from git information into variable VERSION

* dump_cmake_variables :
  * Dumps all of the cmake variables sorted

* find_package(RMN [RMN_REQ_VERSION] COMPONENTS [SHARED|THREADED] [OPTIONAL|REQUIRED])
* find_package(VGRID [VGRID_REQ_VERSION] COMPONENTS [SHARED] [OPTIONAL|REQUIRED])
* find_package(ECCODES [ECCODES_REQ_VERSION] [OPTIONAL|REQUIRED])
* find_package(ECBUFR [ECBUFR_REQ_VERSION] [OPTIONAL|REQUIRED])
* find_package(FLT [FLT_REQ_VERSION] [OPTIONAL|REQUIRED])
* find_package(URP [URP_REQ_VERSION] [OPTIONAL|REQUIRED])
* find_package(GDB [OPTIONAL|REQUIRED])
* find_package(R [OPTIONAL|REQUIRED])

## Example usage

```cmake
...

#----- Append EC specific module path
foreach(PATH $ENV{EC_CMAKE_MODULE_PATH})
   list(APPEND CMAKE_MODULE_PATH ${PATH})
endforeach()

include(ec_init)           # Initialize compilers and ECCC specific functions
include(ec_parse_manifest) # Parse MANIFEST file (optional)
include(ec_build_info)     # Generate build include file (optional)

include(doxygen)           # Doxygen target (optional)

project("SomeProject" VERSION 0.0.0 DESCRIPTION "Does something")
option(BUILD_SHARED_LIBS "Build shared libraries instead of static ones." TRUE)

set(CMAKE_INSTALL_PREFIX "" CACHE PATH "..." FORCE)

#----- Enable language before sourcing the compiler presets
enable_language(C)
enable_language(Fortran)
enable_testing()

include(compiler_presets)

find_package(RMN ${RMN_REQ_VERSION} COMPONENTS SHARED OPTIONAL)
find_package(VGRID ${VGRID_REQ_VERSION} COMPONENTS SHARED OPTIONAL)
find_package(GDB)
find_package(ECCODES ${ECCODES_REQ_VERSION})
find_package(ECBUFR ${ECBUFR_REQ_VERSION})
find_package(FLT ${FLT_REQ_VERSION})
find_package(URP ${URP_REQ_VERSION})

...
```
