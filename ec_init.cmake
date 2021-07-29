# Compiler selection
if(NOT DEFINED COMPILER_SUITE)
   if(DEFINED ENV{CRAYPE_VERSION})
      set(CMAKE_SYSTEM_NAME CrayLinuxEnvironment)
      # We have to leave the default compiler on Cray for cmake to be able to find MPI

      # Try to find which PrgEnv is loaded
      string(REGEX MATCH "PrgEnv-(([a-z]|[A-Z])+)/" COMPILER_SUITE $ENV{LOADEDMODULES})
      set(COMPILER_SUITE ${CMAKE_MATCH_1})

      if(NOT COMPILER_SUITE STREQUAL "intel")
         message(FATAL_ERROR "(EC) We only support Intel compilers in the CrayLinuxEnvironment!")
      endif()
   elseif(DEFINED ENV{INTEL_LICENSE_FILE})
      set(COMPILER_SUITE intel)
   else()
      set(COMPILER_SUITE gnu)
   endif()
else()
   string(TOLOWER "${COMPILER_SUITE}" COMPILER_SUITE)
endif()
message(STATUS "(EC) COMPILER_SUITE=${COMPILER_SUITE}")

# Only set compilers if we are not in the CrayLinuxEnvironment
if(NOT CMAKE_SYSTEM_NAME MATCHES CrayLinuxEnvironment)
   if(COMPILER_SUITE MATCHES gnu)
      set(CMAKE_C_COMPILER gcc)
      set(CMAKE_CXX_COMPILER g++)
      set(CMAKE_Fortran_COMPILER gfortran)
#      set(MPI_C_COMPILER mpicc)
#      set(MPI_Fortran_COMPILER mpif90)
   elseif(COMPILER_SUITE MATCHES intel)
      set(CMAKE_C_COMPILER icc)
      set(CMAKE_CXX_COMPILER icpc)
      set(CMAKE_Fortran_COMPILER ifort)
#      set(MPI_C_COMPILER mpicc)
#      set(MPI_Fortran_COMPILER mpif90)
   elseif(COMPILER_SUITE MATCHES pgi)
      set(CMAKE_C_COMPILER pgcc)
      set(CMAKE_CXX_COMPILER pgc++)
      set(CMAKE_Fortran_COMPILER pgfortran)
#      set(MPI_C_COMPILER mpicc)
#      set(MPI_Fortran_COMPILER mpif90)
   elseif(COMPILER_SUITE MATCHES nvhpc)
      set(CMAKE_C_COMPILER nvc)
      set(CMAKE_CXX_COMPILER nvc++)
      set(CMAKE_Fortran_COMPILER nvfortran)
#      set(MPI_C_COMPILER mpicc)
#      set(MPI_Fortran_COMPILER mpif90)
   elseif(COMPILER_SUITE MATCHES llvm)
      set(CMAKE_C_COMPILER "clang")
      set(CMAKE_Fortran_COMPILER "flang")
#      set(MPI_C_COMPILER "mpicc")
#      set(MPI_Fortran_COMPILER "mpif90")
   elseif(COMPILER_SUITE MATCHES xl)
      set(CMAKE_C_COMPILER "xlc")
      set(CMAKE_Fortran_COMPILER "xlf_r")
#      set(MPI_C_COMPILER "xlc")
#      set(MPI_Fortran_COMPILER "xlf_r")
   endif()
endif()

# message(STATUS CMAKE_C_COMPILER=${CMAKE_C_COMPILER})
# message(STATUS CMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER})
# message(STATUS CMAKE_Fortran_COMPILER=${CMAKE_Fortran_CtweaOMPILER})
# message(STATUS MPI_C_COMPILER=${MPI_C_COMPILER})
# message(STATUS MPI_Fortran_COMPILER=${MPI_Fortran_COMPILER})

# Prepare some variables for the search paths
if(DEFINED ENV{EC_INCLUDE_PATH})
   string(REPLACE " " ";" EC_INCLUDE_PATH "$ENV{EC_INCLUDE_PATH}")
endif()
if(DEFINED ENV{EC_LD_LIBRARY_PATH})
   string(REPLACE " " ";" EC_LD_LIBRARY_PATH "$ENV{EC_LD_LIBRARY_PATH}")
endif()

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
   message(WARNING "(EC) CMAKE_INSTALL_PREFIX was not specified!  Emptying default path!")

   set(CMAKE_INSTALL_PREFIX "" CACHE PATH "..." FORCE)
endif()

# Enable DEBUG macro on cmake debug build
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_definitions(-DDEBUG)
endif()

# Include EC defined functions
include(ec_git_version)
include(ec_build_info)
include(ec_build_config)
include(ec_parse_manifest)
include(ec_dump_cmake_variables)
include(ec_install_prefix)
include(ec_prepare_ssm)