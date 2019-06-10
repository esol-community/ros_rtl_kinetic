#!/bin/bash
set -e

PATH=/opt/aarch64_mcos/bin/:${PATH}
BUILD_TOOLCHAIN_PATH=/opt/aarch64_mcos/aarch64-elf-mcos/cmake/aarch64_elf_mcos_ros_toolchain.cmake
ARC_DIR=/work/share/archives/kinetic

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)"
REPO_BASE=${SCRIPT_DIR}/../../ros_rtl_kinetic
SRC_DIR_KINETIC=${REPO_BASE}/source/ros_kinetic

echo "building the ros kinetic."
if [ -e ${SRC_DIR_KINETIC}/src ]; then
    rm -rf ${SRC_DIR_KINETIC}/src
fi
mkdir -p ${SRC_DIR_KINETIC}

cp -af ${REPO_BASE}/patch/* ${SRC_DIR_KINETIC}

pushd ${SRC_DIR_KINETIC} > /dev/null
tar xf ${ARC_DIR}/ros_kinetic_source.tar.xz
../../script/_set_catkin_ignore.sh
patch -u -N -t -p0 < patch_ros_kinetic_emcos.patch
rm -rf build_isolated/ install_isolated/ devel_isolated/
./src/catkin/bin/catkin_make_isolated --install --cmake-args -DCMAKE_FIND_DEBUG_MODE=1 -DCMAKE_TOOLCHAIN_FILE=${BUILD_TOOLCHAIN_PATH} -D_CMAKE_MCOS_ROS_RTL=1 > ${SRC_DIR_KINETIC}/log_ros_catkinmake.log 2>&1
popd
echo "building the ros kinetic is complete."
