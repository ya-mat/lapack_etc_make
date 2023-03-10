#!/bin/sh

# before
#sudo apt install gcc
#sudo apt install gfortran
#sudo apt install wget
#sudo apt install make
#sudo apt install sed
#sudo apt install libtool
#sudo apt install cmake

set -e

# lapack v3.11
wget https://github.com/Reference-LAPACK/lapack/archive/v3.11.0.tar.gz \
&& tar zxvf v3.11.0.tar.gz \
&& cd lapack-3.11.0 \
&& cp make.inc.example make.inc \
&& ulimit -s unlimited \
&& make \
&& cd ../ \
&& ln -s lapack-3.11.0/librefblas.a ./librefblas.a \
&& ln -s lapack-3.11.0/liblapack.a ./liblapack.a \
&& ln -s lapack-3.11.0/libtmglib.a ./libtmglib.a

# OpneBLAS (main of github)
#wget https://github.com/xianyi/OpenBLAS/releases/download/v0.3.21/OpenBLAS-0.3.21.tar.gz \
#&& tar zxvf OpenBLAS-0.3.21.tar.gz \
#&& cd OpenBLAS-0.3.21 \
git clone https://github.com/xianyi/OpenBLAS.git \
&& cd OpenBLAS \
&& make USE_THREAD=0 USE_LOCKING=1 \
&& cd ../ \
&& ln -s OpenBLAS/libopenblas_*.a ./libopenblas.a

# slatec
#wget http://www.netlib.org/slatec/slatec_src.tgz \
wget https://netlib.org/slatec/slatec_src.tgz \
&& tar zxvf slatec_src.tgz \
&& cd src \
&& wget http://www.netlib.org/slatec/slatec4linux.tgz \
&& tar zxvf slatec4linux.tgz \
&& env FC="gfortran -std=legacy" make \
&& cd ../ \
&& ln -s src/static/libslatec.a ./libslatec.a

# dfftpack
wget http://www.netlib.org/fftpack/dp.tgz \
&& tar zxvf dp.tgz \
&& cd dfftpack \
&& sed -e 's/FC=g77/FC=gfortran/g' ./Makefile > ./Makefile2 \
&& sed -e 's/FFLAGS=-O2 -funroll-loops -fexpensive-optimizations/FFLAGS=-O2/g' ./Makefile2 > ./Makefile \
&& make \
&& cd ../ \
&& ln -s dfftpack/libdfftpack.a ./libdfftpack.a

# libcerf v1.15
wget https://jugit.fz-juelich.de/mlz/libcerf/-/archive/v1.15/libcerf-v1.15.tar.gz \
&& tar zxvf libcerf-v1.15.tar.gz \
&& cd libcerf-v1.15 \
&& mkdir build \
&& cd build \
&& cmake -D BUILD_SHARED_LIBS=OFF .. \
&& make \
&& cd ../ \
&& cd ../ \
&& ln -s libcerf-v1.15/build/lib/libcerf.a ./libcerf.a \
&& cp libcerf-v1.15/fortran/ccerflib_f95_interface/use_libcerf_mod.f90 ./

# ACM 782 RRQR
# "sed -i '1,3d' 782.sh" remove the top 3 lines with the ACM info
# replace all $( and $?in the cat areas for makefiles with \$( and \$?to work with newer versions of sh
# "sh 782.sh" is extracting the rrqr_acm directory
wget http://www.netlib.org/toms-2014-06-10/782 -O 782.sh \
&& sed -i '1,3d' 782.sh \
&& sed -i 's/\$[\(]/\\$\(/g' 782.sh \
&& sed -i 's/\$[\?]/\\$?/g' 782.sh \
&& sh 782.sh \
&& cd rrqr_acm/ \
&& cd lib/ \
&& sed -e 's/FORTRAN   = f77/FORTRAN=gfortran/g' ./Makefile > ./Makefile2 \
&& sed -e 's/OPTS      = -u -g -C/OPTS=-O3/g' ./Makefile2 > ./Makefile \
&& make \
&& cd ../ \
&& cd ../ \
&& ln -s rrqr_acm/rrqr.a ./rrqr.a

# Eigen 3.4.0
wget https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.tar.gz \
&& tar zxvf eigen-3.4.0.tar.gz \
&& cp -r eigen-3.4.0/Eigen ./ \
&& mkdir unsupported \
&& cp -r eigen-3.4.0/unsupported/Eigen ./unsupported/
