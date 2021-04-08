#!/usr/bin/env bash
set -e


# Environment ------------------------------------------------------------------
# Load software modules
module purge
module load userspace/all opt/all
module load libraries/zstd/1.3.7
module load gcc/10.2.0
module load openmpi/gcc-10.2.0/4.0.4
module load cmake/3.20.0
module load libraries/libboost/1.75.0
module load hdf5/1.12.0parIO
module load libraries/GDAL/3.2.2parIO


# TODO CC and CXX are set. Different projects provide different compiler
#      wrappers (mpi, hdf5, hpx, ...). I prefer to use the plain compiler
#      and manage things myself, on all platforms. Resetting CC and CXX.
export CC=gcc
export CXX=g++


# These should be set:
echo "BOOST_ROOT       : $BOOST_ROOT"
echo "HDF5_ROOT        : $HDF5_ROOT"
echo "GDAL_ROOT        : $GDAL_ROOT"

# This one should not point to directories containing shared libraries
# for Boost, HDF5, .... There is no need for LD_LIBRARY_PATH.
echo "LD_LIBRARY_PATH  : $LD_LIBRARY_PATH"

# This one should only point to directories containing CMake modules
# not available in CMake >= 3.20.
# TODO It currently points to Boost and HDF5, which is not necessary,
#      I think.
echo "CMAKE_MODULE_PATH: $CMAKE_MODULE_PATH"


# Pathnames --------------------------------------------------------------------
tmp_prefix=$(mktemp --directory --tmpdir hello_eejit-XXXX)
build_prefix="$tmp_prefix/build"
install_prefix="$tmp_prefix/install"
echo "All files will be stored in $tmp_prefix"


# Configure, build, install ----------------------------------------------------
# https://gitlab.kitware.com/cmake/community/-/wikis/doc/cmake/RPATH-handling
# export VERBOSE=1
# TODO For some reason we need to add the location of the boost shared
#      library to the rpath ourselves. This is not needed for hdf5.
cmake -S . -B $build_prefix \
    -DCMAKE_INSTALL_PREFIX:PATH=$install_prefix \
    -DCMAKE_BUILD_RPATH:PATH=$BOOST_ROOT/stage/lib \
    -DCMAKE_INSTALL_RPATH:PATH=$BOOST_ROOT/stage/lib \
    -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=TRUE
cmake --build $build_prefix
cmake --install $build_prefix


# Tests ------------------------------------------------------------------------
# Show dependencies of *built* target on shared libraries (Boost, HDF5, ...).
# All of them should be resolved. There is no need for LD_LIBRARY_PATH.
readelf -d $build_prefix/say_hello_to_eejit | grep RPATH
ldd $build_prefix/say_hello_to_eejit | grep "not found" || true

# Make sure target works. There is no need for LD_LIBRARY_PATH.
$build_prefix/say_hello_to_eejit


# Show dependencies of *installed* target on shared libraries (Boost, HDF5, ...).
# All of them should be resolved. There is no need for LD_LIBRARY_PATH.
readelf -d $install_prefix/bin/say_hello_to_eejit | grep RPATH
ldd $install_prefix/bin/say_hello_to_eejit | grep "not found" || true

# Make sure target works. There is no need for LD_LIBRARY_PATH.
$install_prefix/bin/say_hello_to_eejit
