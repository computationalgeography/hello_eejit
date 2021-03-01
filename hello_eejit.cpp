#include <boost/filesystem.hpp>
#include <hdf5.h>
#include <cstdlib>
#include <iostream>
#include <string>


int main()
{
    // HDF5
    {
        // Ask HDF5 for its version
        unsigned int hdf5_major_version;
        unsigned int hdf5_minor_version;
        unsigned int hdf5_release_version;
        H5get_libversion(&hdf5_major_version, &hdf5_minor_version, &hdf5_release_version);

        std::string const hdf5_version{
            std::to_string(hdf5_major_version) + "." +
            std::to_string(hdf5_minor_version) + "." +
            std::to_string(hdf5_release_version)};

        std::cout << "HDF5 library " << hdf5_version << " on eejit says Hello World!" << std::endl;
    }

    // Boost
    {
        boost::filesystem::path hello{"Hello"};
        boost::filesystem::path world{"World"};
        std::cout
            << "The Boost filesystem library says " << (hello / world) << " as well!" << std::endl;
    }

    return EXIT_SUCCESS;
}
