# This modules loads compiler presets for the current platform and handles
# ECCC's computing environment differently

# Input
#  COMPILER_SUITE : Lower case name of the compiler suite (gnu, intel, ...)
#  LANGUAGES : List of language to enable for the project.  Usually C and Fotran

message(STATUS "CMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}")

add_definitions(-DPROJECT_NAME=${PROJECT_NAME})

option(USE_ECCC_ENV_IF_AVAIL "Use ECCC's custom build environment" TRUE)

if(USE_ECCC_ENV_IF_AVAIL)
    if(DEFINED ENV{EC_ARCH})
        message(STATUS "Using ECCC presets")
        message(STATUS "Ignoring COMPILER_SUITE since using ECCC's custom build environment")
        set(COMPILER_PRESET_PATH "ECCC/$ENV{EC_ARCH}.cmake")
        add_definitions(-DEC_ARCH="$ENV{EC_ARCH}")
    else()
        message(WARNING "EC_ARCH environment variable not found!  Falling back on default presets")
        set(COMPILER_PRESET_PATH "default/${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}/${COMPILER_SUITE}.cmake")
    endif()
else()
    message(STATUS "Using default presets")
    set(COMPILER_PRESET_PATH "default/${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}/${COMPILER_SUITE}.cmake")
endif()

message(STATUS "Loading preset ${COMPILER_PRESET_PATH}")
include("${CMAKE_CURRENT_LIST_DIR}/compiler_presets/${COMPILER_PRESET_PATH}")