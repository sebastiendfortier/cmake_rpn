# Default configuration for the GNU compiler suite
# Input:
#  LANGUAGES List of languages to enable for the project
#  EXTRA_CHECKS Enable extra checking.  This will make the execution slower.

# The full path of the compiler for <LANG> must be set in CMAKE_<LANG>_COMPILER
# before calling enable_language(<LANG>)
find_program(CMAKE_C_COMPILER "icc")
find_program(CMAKE_Fortran_COMPILER "ifort")

# Do these need to be here if we don't use MPI?  Are there any adverse effect to
# having them?
find_program(MPI_C_COMPILER "mpicc")
find_program(MPI_Fortran_COMPILER "mpif90")

# I don't know why, but enable_language empties CMAKE_BUILD_TYPE!
# We therefore have to back it up and restore it after enable_language
message(STATUS "CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}")
set(TMP_BUILD_TYPE ${CMAKE_BUILD_TYPE})

foreach(LANGUAGE ${LANGUAGES})
   enable_language(${LANGUAGE})
endforeach()

# Reset CMAKE_BUILD_TYPE
set(CMAKE_BUILD_TYPE ${TMP_BUILD_TYPE})
unset(TMP_BUILD_TYPE)
message(STATUS "CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}")

# find_package() commands can only be called after the languages have been 
# eneabled or they will fail

add_definitions(-DLittle_Endian)

set(LAPACK_LIBRARIES "lapack")
message(STATUS "LAPACK_LIBRARIES=${LAPACK_LIBRARIES}")

set(BLAS_LIBRARIES "blas")
message(STATUS "BLAS_LIBRARIES=${BLAS_LIBRARIES}")

# Intel compiler diag codes (Use icc or ifort -diag-dump to get the full list) :
#    5140: Unrecognized directive
#    6182: Fortran @@ does not allow this edit descriptor.
#    7416: Fortran @@ does not allow this intrinsic procedure.
#    7713: This statement function has not been used.
#   10212: xxxx%sprecise evaluates in source precision with Fortran.

# When we will want to have flags different from the compiler rules, we should add
#   -ip To enable additional interprocedural optimizations
#   -threads The linker searches for unresolved references in a library that supports enabling thread-safe operation.

set(CMAKE_C_FLAGS_DEBUG "-g -ftrapuv -DDEBUG")
set(CMAKE_C_FLAGS_RELEASE "-O2")
set(CMAKE_C_FLAGS "-fp-model precise -mkl -traceback -Wtrigraphs" CACHE STRING "C compiler flags" FORCE)

# The impact of -align array32byte is not well known or documented
set(CMAKE_Fortran_FLAGS_DEBUG "-g -ftrapuv -DDEBUG")
set(CMAKE_Fortran_FLAGS_RELEASE "-O2")
set(CMAKE_Fortran_FLAGS "-align array32byte -assume byterecl -convert big_endian -fp-model source -fpe0 -mkl -traceback -stand f08 -diag-disable 5140 -diag-disable 7713 -diag-disable 10212" CACHE STRING "Fortran compiler flags" FORCE)

# --allow-shlib-undefined Does not look like this is actually necessary, but there might be
# use case that I don't know about
set(CMAKE_EXE_LINKER_FLAGS_INIT "-mkl -static-intel")


# There might be extra OpenMP and OpenACC flags which are specific to each compiler,
# that are not added the find_package(OpenACC)
# It doesn't matter if we defined them even if OpenACC isn't used because the
# OpenACC_extra_FLAGS variable just won't be used
set(OpenACC_extra_FLAGS "-fopt-info-optimized-omp")

# Set the target architecture
if(NOT TARGET_PROC)
    set(TARGET_PROC "sse3")
endif()
message(STATUS "Target architecture: ${TARGET_PROC}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m${TARGET_PROC}")
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -m${TARGET_PROC}")


if (EXTRA_CHECKS)
   set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -warn all -check all")
   set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -warn all -check all")
   set(CMAKE_EXE_LINKER_FLAGS_INIT "${CMAKE_EXE_LINKER_FLAGS_INIT} -warn all -check all")
endif()