cmake_minimum_required(VERSION 3.19)
project(hello_eejit VERSION 0.0.0 LANGUAGES C CXX)
include(GNUInstallDirs)


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

# TODO
# GDAL
# find_package(gdal)

# GDAL, GLEW


# Configure our own software ---------------------------------------------------
add_executable(say_hello_to_eejit
    hello_eejit)

target_link_libraries(say_hello_to_eejit
    PRIVATE
        hdf5::hdf5
        Boost::filesystem)

install(
    TARGETS
        say_hello_to_eejit
    RUNTIME DESTINATION
        ${CMAKE_INSTALL_BINDIR})
