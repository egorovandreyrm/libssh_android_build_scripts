To build the libs: 

#1: Set the correct paths and adjust the config if needed in build_libssh_linux.sh
ANDROID_API="arm64-v8a"
API_LEVEL=21
ANDROID_SDK_PATH="/home/andrey/Android/Sdk"
BUILD_SHARED_LIB=1

#2: Make sure that boringssl and libssh sources are downloaded, which could be done, for example, by clonning with --recurse-submodules flag:
i.e.
git clone --recurse-submodules https://github.com/egorovandreyrm/libssh_android_build_scripts.git libssh_android_build_scripts

As soon as compiling is done, libs can be found in the libs directory.

Linking libssh/boringssl libs can be done by the following way if cmake is used in the project.

target_link_libraries(yourproject
        ${PROJECT_SOURCE_DIR}/ext_libs/${ANDROID_ABI}/libssh.a
        ${PROJECT_SOURCE_DIR}/ext_libs/${ANDROID_ABI}/libssl.a
        ${PROJECT_SOURCE_DIR}/ext_libs/${ANDROID_ABI}/libcrypto.a
        ${PROJECT_SOURCE_DIR}/ext_libs/${ANDROID_ABI}/libdecrepit.a
        ${PROJECT_SOURCE_DIR}/ext_libs/${ANDROID_ABI}/libssh-boringssl-compat.a
        ${z-lib})

to build all abi, use build_all_abi.sh
