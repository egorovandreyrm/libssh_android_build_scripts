The corret paths have to be set in build_libssh_linux.sh

To build libssh, make sure that boringssl and libssh sources are downloaded, 
which could be done, for example, by clonning with --recurse-submodules flag
i.e.
git clone --recurse-submodules https://github.com/egorovandreyrm/libssh_android_build_scripts.git

Linking libssh/boringssl libs can be done by the following way if cmake is used in the project.

target_link_libraries(yourproject
        ${PROJECT_SOURCE_DIR}/ext_libs/${ANDROID_ABI}/libssh.a
        ${PROJECT_SOURCE_DIR}/ext_libs/${ANDROID_ABI}/libssl.a
        ${PROJECT_SOURCE_DIR}/ext_libs/${ANDROID_ABI}/libcrypto.a
        ${PROJECT_SOURCE_DIR}/ext_libs/${ANDROID_ABI}/libdecrepit.a
        ${PROJECT_SOURCE_DIR}/ext_libs/${ANDROID_ABI}/libssh-boringssl-compat.a
        ${z-lib})
