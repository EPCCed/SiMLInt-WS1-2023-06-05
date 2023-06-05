# Hasegawa-Wakatani with SmartRedis

Modify `CMakeLists.txt` in hasegawa-wakatani:
```
cmake_minimum_required(VERSION 3.13)

project(hasegawa-wakatani LANGUAGES CXX)

if (NOT TARGET bout++::bout++)
  find_package(bout++ REQUIRED)
endif()

#bout_add_example(hasegawa-wakatani SOURCES hw.cxx)

set(SMARTREDIS_INSTALL_PATH /work/tc045/tc045/shared/bpp_5_0_0_ss_0_4_2/SmartRedis/install/)
find_library(SMARTREDIS_LIBRARY smartredis
             PATHS ${SMARTREDIS_INSTALL_PATH}/lib
             NO_DEFAULT_PATH REQUIRED
)
include_directories(SYSTEM
    ${SMARTREDIS_INSTALL_PATH}/include
)
add_executable(hasegawa-wakatani hw.cxx)
target_link_libraries(hasegawa-wakatani PRIVATE
    bout++::bout++
    ${SMARTREDIS_LIBRARY}
)
```

Copy the example source to a directory `/work` and build
```
cmake . -B build -Dbout++_DIR=/work/tc045/tc045/shared/bpp_5_0_0_ss_0_4_2/BOUT-dev/build -DCMAKE_CXX_FLAGS=-std=c++17 -DCMAKE_BUILD_TYPE=Release

cmake --build build --target hasegawa-wakatani
```
