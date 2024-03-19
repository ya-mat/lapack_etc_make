#!/bin/sh

# before
#sudo apt install gcc
#sudo apt install g++
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
#git clone https://github.com/xianyi/OpenBLAS.git \
#&& cd OpenBLAS \
#&& make USE_THREAD=0 USE_LOCKING=1 \
#&& cd ../ \
#&& ln -s OpenBLAS/libopenblas_*.a ./libopenblas.a

# lapack95 version 3.0
wget https://netlib.org/lapack95/lapack95.tgz \
&& tar zxvf lapack95.tgz \
&& cd LAPACK95 \
&& mkdir lapack95_modules \
&& sed -i -e 's/= f95 -free/=gfortran/g' ./make.inc \
&& sed -i -e 's/FC1      = f95 -fixed/FC1=gfortran/g' ./make.inc \
&& sed -i -e 's/OPTS0    = -u -V -dcfuns -dusty -ieee=full/OPTS0=-O2/g' ./make.inc \
&& sed -i -e 's/LAPACK_PATH = \/usr\/local\/lib\/LAPACK3\//LAPACK_PATH=$(LIBRARY_PATH)/g' ./make.inc \
&& sed -i -e 's/LAPACK77 = $(LAPACK_PATH)\/lapack.a/LAPACK77=$(LAPACK_PATH)\/liblapack.a/g' ./make.inc \
&& sed -i -e 's/TMG77	 = $(LAPACK_PATH)\/tmglib.a/TMG77=$(LAPACK_PATH)\/libtmglib.a/g' ./make.inc \
&& sed -i -e 's/BLAS	 = $(LAPACK_PATH)\/blas.a/BLAS=$(LAPACK_PATH)\/librefblas.a/g' ./make.inc \
&& cd SRC \
&& rm f77_lapack_single_double_complex_dcomplex.f90
&& wget https://raw.githubusercontent.com/ya-mat/lapack95_fixed_patch/main/f77_lapack_single_double_complex_dcomplex.f90
&& rm f95_lapack_single_double_complex_dcomplex.f90
&& wget https://raw.githubusercontent.com/ya-mat/lapack95_fixed_patch/main/f95_lapack_single_double_complex_dcomplex.f90
&& ulimit -s unlimited \
&& make single_double_complex_dcomplex \
&& cd ../ \
&& cd ../ \
&& ln -s LAPACK95/lapack95.a ./liblapack95.a \
&& ln -s LAPACK95/lapack95_modules ./lapack95_include

## slatec
#wget https://netlib.org/slatec/slatec_src.tgz \
#&& tar zxvf slatec_src.tgz \
#&& cd src \
#&& wget http://www.netlib.org/slatec/slatec4linux.tgz \
#&& tar zxvf slatec4linux.tgz \
#&& env FC="gfortran -std=legacy" make \
#&& cd ../ \
#&& ln -s src/static/libslatec.a ./libslatec.a

# slatec-bessel-cpp
git clone https://github.com/lloda/slatec-bessel-cpp.git \
&& cd slatec-bessel-cpp \
&& env CXX=g++ make libslatec-f2c.a \
&& cd ../ \
&& ln -s slatec-bessel-cpp/libslatec-f2c.a ./libslatec-f2c.a

# librefsol2Dhel.a
git clone https://github.com/ya-mat/reference_solution_2d_helmholtz_scattering.git \
&& cd reference_solution_2d_helmholtz_scattering \
&& mkdir build \
&& cd build \
&& cmake .. \
&& make \
&& cd ../ \
&& cd ../ \
&& ln -s reference_solution_2d_helmholtz_scattering/build/librefsol2Dhel.a ./librefsol2Dhel.a

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
