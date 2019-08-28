#!/bin/bash

set -e

export ANDROID_NDK_ROOT=/home/andrey/Android/Sdk/ndk-bundle
ANDROID_API="armeabi-v7a"
API_LEVEL=21
NDK_TOOLCHAIN_PATH="/home/andrey/Android/Sdk/ndk-bundle/build/cmake/android.toolchain.cmake"
BUILD_SHARED_LIB=0

if [[ "$BUILD_SHARED_LIB" -eq "1" ]]
then
    libs_files_extension="so"
    build_static_libssh=0
    OUTPUT_LIBS_DIR="libs_${ANDROID_API}_shared"
else
    libs_files_extension="a"
    build_static_libssh=1
    OUTPUT_LIBS_DIR="libs_${ANDROID_API}_static"
fi

rm boringssl_build_dir_${ANDROID_API} -R || true
mkdir boringssl_build_dir_${ANDROID_API}
cd boringssl_build_dir_${ANDROID_API}

cmake -DANDROID_ABI=${ANDROID_API} \
      -DCMAKE_TOOLCHAIN_FILE=/home/andrey/Android/Sdk/ndk-bundle/build/cmake/android.toolchain.cmake \
      -DANDROID_NATIVE_API_LEVEL=${API_LEVEL} \
      -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIB} \
      -GNinja ../boringssl
      
ninja -j4

cd ..

rm ${OUTPUT_LIBS_DIR} -R || true
mkdir ${OUTPUT_LIBS_DIR}

cp boringssl_build_dir_${ANDROID_API}/crypto/libcrypto.${libs_files_extension} ${OUTPUT_LIBS_DIR}
cp boringssl_build_dir_${ANDROID_API}/decrepit/libdecrepit.${libs_files_extension} ${OUTPUT_LIBS_DIR}
    
rm libssh_build_dir_${ANDROID_API} -R || true
mkdir libssh_build_dir_${ANDROID_API}
cd libssh_build_dir_${ANDROID_API}

cmake \
	-DCMAKE_INSTALL_PREFIX=/opt/libssh-android \
	-DWITH_INTERNAL_DOC=OFF \
	-DWITH_GSSAPI=OFF \
	-DWITH_NACL=OFF \
	-DWITH_EXAMPLES=OFF \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_TOOLCHAIN_FILE=${NDK_TOOLCHAIN_PATH} \
	-DANDROID_NDK="$ANDROID_NDK_ROOT" \
	-DANDROID_NATIVE_API_LEVEL=android-${API_LEVEL} \
	-DANDROID_ABI=${ANDROID_API} \
	-DBUILD_STATIC_LIB=${build_static_libssh} \
	-DBUILT_LIBS_DIR=${OUTPUT_LIBS_DIR} \
	..
	
cmake --build .
	
cd ..

cp libssh_build_dir_${ANDROID_API}/libssh-boringssl-compat.a ${OUTPUT_LIBS_DIR}
cp libssh_build_dir_${ANDROID_API}/libssh/src/libssh.${libs_files_extension} ${OUTPUT_LIBS_DIR}
