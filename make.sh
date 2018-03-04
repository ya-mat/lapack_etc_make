#!/bin/sh

# before
#sudo apt install gcc
#sudo apt install gfortran

# lapack
wget http://www.netlib.org/lapack/lapack-3.8.0.tar.gz
tar zxvf lapack-3.8.0.tar.gz
cd lapack-3.8.0
cp make.inc.example make.inc
ulimit -s unlimited
make
cd ../
ln -s lapack-3.8.0/librefblas.a librefblas.a
ln -s lapack-3.8.0/liblapack.a liblapack.a
ln -s lapack-3.8.0/libtmglib.a libtmglib.a

# slatec
wget http://www.netlib.org/slatec/slatec_src.tgz
tar zxvf slatec_src.tgz
cd src
wget http://www.netlib.org/slatec/slatec4linux.tgz
tar zxvf slatec4linux.tgz
env FC=gfortran make
cd ../
ln -s src/static/libslatec.a libslatec.a

# dfftpack
wget http://www.netlib.org/fftpack/dp.tgz
tar zxvf dp.tgz
cd dfftpack
sed -e 's/FC=g77/FC=gfortran/g' ./Makefile > ./Makefile2
sed -e 's/FFLAGS=-O2 -funroll-loops -fexpensive-optimizations/FFLAGS=-O2/g' ./Makefile2 > ./Makefile
make
cd ../
ln -s dfftpack/libdfftpack.a libdfftpack.a

# libcerf
wget http://apps.jcns.fz-juelich.de/src/libcerf/libcerf-1.5.tgz
tar zxvf libcerf-1.5.tgz
cd libcerf-1.5/
mkdir build
path=$(cd build && pwd) && ./configure --enable-static --prefix=$path
make
make install
cd ../
ln -s libcerf-1.5/build/lib/libcerf.a ./libcerf.a
cp libcerf-1.5/fortran/ccerflib_f95_interface/use_libcerf_mod.f90 ./

