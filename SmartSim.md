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

Copy the example source to a directory `/work`
```
cp -r /work/tc045/tc045/shared/bpp_5_0_0_ss_0_4_2/BOUT-dev/examples/hasegawa-wakatani /work/tc045/tc045/<yourusername>
```

Build
```
cmake . -B build -Dbout++_DIR=/work/tc045/tc045/shared/bpp_5_0_0_ss_0_4_2/BOUT-dev/build -DCMAKE_CXX_FLAGS=-std=c++17 -DCMAKE_BUILD_TYPE=Release

cmake --build build --target hasegawa-wakatani
```

The model and database code are stored in `/work/tc045/tc045/shared/model`.

Add the following to a slurm job submission:
```
DB_PORT=6899 # choose a port for the RedisAI db to listen
conda activate /work/tc045/tc045/sharer/bpp_5_0_0_ss_0_4_2

# Start the orchestrator and a new experiment which launches RedisAI for communication
python /work/tc045/tc045/shared/model/start_db.py $DB_PORT

# Only running on one node
export SSDB=127.0.0.1:$DB_PORT
```

In the code:
```
#include <client.h>
...
private:
  SmartRedis::Client *client;
...
protected:
  int init(bool UNUSED(restart)) {
    ...
    // initialise smartredis client
    bool cluster_mode = false; // Set to false if not using a clustered database
    client = new SmartRedis::Client(cluster_mode, __FILE__);
```
