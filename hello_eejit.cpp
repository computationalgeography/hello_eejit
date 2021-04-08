#include <boost/filesystem.hpp>
#include <gdal_priv.h>
#include <hdf5.h>
#include <cstdlib>
#include <iostream>
#include <string>


// #ifndef H5_HAVE_THREADSAFE
// #error "The HDF5 libraries must be compiled with enabled thread safety support."
// #endif


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

    // GDAL
    {
        GDALAllRegister();

        std::cout << "The folowing raster drivers from the GDAL library say hi:";

        GDALDriverManager* driver_manager{GetGDALDriverManager()};

        for(int i = 0; i < driver_manager->GetDriverCount(); ++i)
        {
            std::cout << " " << driver_manager->GetDriver(i)->GetDescription();
        }

        std::cout << std::endl;
    }

    return EXIT_SUCCESS;
}
