#!/usr/bin/env bash
set -e


# Environment ------------------------------------------------------------------
# Load software modules
# TODO
# module load ...

# These should be set:
echo "BOOST_ROOT     : $BOOST_ROOT"
echo "HDF5_ROOT      : $HDF5_ROOT"
echo "GDAL_ROOT      : $GDAL_ROOT"

# This one should not point to directories containing shared libraries
# for Boost, HDF5, .... There is no need for LD_LIBRARY_PATH.
echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"


# Pathnames --------------------------------------------------------------------
tmp_prefix=$(mktemp --directory --tmpdir hello_eejit-XXXX)
build_prefix="$tmp_prefix/build"
install_prefix="$tmp_prefix/install"
echo "All files will be stored in $tmp_prefix"


# Configure, build, install ----------------------------------------------------
cmake -S . -B $build_prefix -DCMAKE_INSTALL_PREFIX:PATH=$install_prefix
cmake --build $build_prefix
cmake --install $build_prefix


# Tests ------------------------------------------------------------------------
# Show dependencies of installed target on shared libraries (Boost, HDF5, ...).
# All of them should be resolved. There is no need for LD_LIBRARY_PATH.
ldd $install_prefix/bin/say_hello_to_eejit

# Make sure target works. There is no need for LD_LIBRARY_PATH.
$install_prefix/bin/say_hello_to_eejit
