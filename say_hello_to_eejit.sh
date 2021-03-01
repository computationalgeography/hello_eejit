#!/usr/bin/env bash
set -e


# Load software modules
# TODO
# module load ...


# These should be set:
echo "BOOST_ROOT     : $BOOST_ROOT"
echo "HDF5_ROOT      : $HDF5_ROOT"
echo "GDAL_ROOT      : $GDAL_ROOT"

# This one should not point to boost, hdf5, ...:
echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"


tmp_prefix=$(mktemp --directory --tmpdir hello_eejit-XXXX)
build_prefix="$tmp_prefix/build"
install_prefix="$tmp_prefix/install"
echo "All files will be stored in $tmp_prefix"

# Generate build scripts
cmake -S . -B $build_prefix -DCMAKE_INSTALL_PREFIX:PATH=$install_prefix

# Build software
cmake --build $build_prefix

# Install software
cmake --install $build_prefix

# Show dependencies of installed target on shared libraries
# All of them should be resolved
ldd $install_prefix/bin/say_hello_to_eejit

# Make sure target works, without having to expand LD_LIBRARY_PATH
$install_prefix/bin/say_hello_to_eejit
