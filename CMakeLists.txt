# This is the main CMake script. It should be as plain and simple as
# possible. No platform specific stuff in here. Tweaks for platforms should
# be handled by the caller (toolchain files, cmake command arguments,
# environment variables).
cmake_minimum_required(VERSION 3.19)
project(hello_eejit VERSION 0.0.0 LANGUAGES C CXX)
include(GNUInstallDirs)
include(CheckCXXSymbolExists)


# Configure and find 3rd party software ----------------------------------------
# Boost
# Just ask for a selection of popular components
find_package(Boost REQUIRED
    COMPONENTS filesystem system unit_test_framework)

# HDF5
# We currently don't use the C++ and HL APIs
set(HDF5_PREFER_PARALLEL TRUE)
find_package(HDF5 REQUIRED
    COMPONENTS C)

if(NOT HDF5_IS_PARALLEL)
    message(NOTICE "HDF5 is not built with support for parallel I/O")
endif()

set(CMAKE_REQUIRED_INCLUDES ${HDF5_INCLUDE_DIRS})
check_cxx_symbol_exists(H5_HAVE_THREADSAFE "hdf5.h" have_h5_have_threadsafe)

if(NOT have_h5_have_threadsafe)
    message(SEND_ERROR "HDF5 is not built with support for thread safety")
endif()

find_package(GDAL REQUIRED)


# Configure our own software ---------------------------------------------------
add_executable(say_hello_to_eejit
    hello_eejit.cpp)

target_link_libraries(say_hello_to_eejit
    PRIVATE
        GDAL::GDAL
        hdf5::hdf5
        Boost::filesystem)

install(
    TARGETS
        say_hello_to_eejit
    RUNTIME DESTINATION
        ${CMAKE_INSTALL_BINDIR})
