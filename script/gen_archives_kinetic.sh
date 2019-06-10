#!/bin/bash
set -e

ARC_DIR=/work/share/archives
SRC_ARC_DIR=${ARC_DIR}/kinetic
SRC_DIR=../source/ros_kinetic/src
ARC_NAME=ros_kinetic_source.tar.xz


rm -rf ${SRC_DIR}
mkdir -p ${SRC_DIR}

rm -rf ${SRC_ARC_DIR}
mkdir -p ${SRC_ARC_DIR}

wstool init ${SRC_DIR} kinetic-ros_comm-wet.rosinstall

tar -Jcf ${ARC_NAME} -C ${SRC_DIR%/*} ${SRC_DIR##*/}
mv ${ARC_NAME} ${SRC_ARC_DIR}
