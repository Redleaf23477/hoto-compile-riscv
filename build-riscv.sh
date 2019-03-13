#!/bin/bash
# author: redleaf23477
# a simple script to compile riscv on your computer

export PATH=/opt/riscv/bin:$PATH
export RISCV=/opt/riscv

MYHOST=riscv64-unknown-linux-gnu

# compile riscv-gnu-toolchain

cd ../riscv-gnu-toolchain
./configure --prefix=$RISCV
make linux

# compile riscv-fesvr

cd ../riscv-fesvr
export CPLUS_INCLUDE_PATH=$(pwd)
mkdir build
cd build
../configure --prefix=$RISCV --target=$MYHOST
make clean
make 
make install
cd ..

# compile riscv-pk

cd ../riscv-pk
mkdir build
cd build
echo $PATH
../configure --prefix=$RISCV --host=$MYHOST
make 
make install
cd ..

# compile riscv-isa-sim

cd ../riscv-isa-sim
mkdir build
cd build
../configure --prefix=$RISCV --host=$MYHOST
make clean
make 
make install

