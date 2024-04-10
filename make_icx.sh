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

# lapack v3.12
wget https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v3.12.0.tar.gz \
&& tar zxvf v3.12.0.tar.gz \
&& cd lapack-3.12.0 \
&& mkdir build \
&& cd build \
&& cmake -DCMAKE_C_COMPILER=icx -DCMAKE_Fortran_COMPILER=ifx .. \
&& ulimit -s unlimited \
&& env VERBOSE=1 make -j \
&& cd ../../ \
&& ln -s lapack-3.12.0/build/lib/libblas.a ./librefblas_icx.a \
&& ln -s lapack-3.12.0/build/lib/liblapack.a ./liblapack_icx.a

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
&& sed -i -e 's/= f95 -free/=ifx/g' ./make.inc \
&& sed -i -e 's/= f95 -fixed/=ifx/g' ./make.inc \
&& sed -i -e 's/= -u -V -dcfuns -dusty -ieee=full/=-O2/g' ./make.inc \
&& sed -i -e 's/LAPACK_PATH = \/usr\/local\/lib\/LAPACK3\//LAPACK_PATH=$(LIBRARY_PATH)/g' ./make.inc \
&& sed -i -e 's/LAPACK77 = $(LAPACK_PATH)\/lapack.a/LAPACK77=$(LAPACK_PATH)\/liblapack_icx.a/g' ./make.inc \
&& sed -i -e 's/= $(LAPACK_PATH)\/tmglib.a/=$(LAPACK_PATH)\/libtmglib_icx.a/g' ./make.inc \
&& sed -i -e 's/ = $(LAPACK_PATH)\/blas.a/=$(LAPACK_PATH)\/librefblas_icx.a/g' ./make.inc \
&& cd SRC \
&& ulimit -s unlimited \
&& make single_double_complex_dcomplex \
&& rm f77_lapack_single_double_complex_dcomplex.f90 \
&& rm f95_lapack_single_double_complex_dcomplex.f90 \
&& git clone https://github.com/ya-mat/lapack95_fixed_patch.git \
&& cp lapack95_fixed_patch/f77_lapack_single_double_complex_dcomplex.f90 ./ \
&& cp lapack95_fixed_patch/f95_lapack_single_double_complex_dcomplex.f90 ./ \
&& make single_double_complex_dcomplex \
&& cd ../ \
&& cd ../ \
&& ln -s LAPACK95/lapack95.a ./liblapack95_icx.a \
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
#git clone https://github.com/lloda/slatec-bessel-cpp.git \
#&& cd slatec-bessel-cpp \
#&& sed -i -e 's/CXXFLAGS = -std=c++20 -Wall -Werror -Wno-parentheses -O2 -fopenmp/CXXFLAGS = -std=c++20 -O2/g' ./Makefile \
#&& sed -i -e 's/LDFLAGS_FORTRAN = -lgfortran -fopenmp/LDFLAGS_FORTRAN = /g' ./Makefile \
#&& sed -i -e 's/LDFLAGS_F2C = -fopenmp/LDFLAGS_F2C =/g' ./Makefile \
#&& env CXX=icx FORTRAN=ifx make libslatec-f2c.a \
#&& cd ../ \
#&& ln -s slatec-bessel-cpp/libslatec-f2c.a ./libslatec-f2c_icx.a
git clone https://github.com/lloda/slatec-bessel-cpp.git \
&& cd slatec-bessel-cpp \
&& sed -i -e 's/-std=c++20/-std=c++2a/g' ./Makefile \
&& sed -i -e 's/-fopenmp/ /g' ./Makefile \
&& env CXX=g++ make libslatec-f2c.a \
&& cd ../ \
&& ln -s slatec-bessel-cpp/libslatec-f2c.a ./libslatec-f2c.a

# librefsol2Dhel.a
#git clone https://github.com/ya-mat/reference_solution_2d_helmholtz_scattering.git \
#&& cd reference_solution_2d_helmholtz_scattering \
#&& mkdir build \
#&& cd build \
#&& cmake .. \
#&& make \
#&& cd ../ \
#&& cd ../ \
#&& ln -s reference_solution_2d_helmholtz_scattering/build/librefsol2Dhel.a ./librefsol2Dhel.a

# dfftpack
wget http://www.netlib.org/fftpack/dp.tgz \
&& tar zxvf dp.tgz \
&& cd dfftpack \
&& sed -e 's/FC=g77/FC=ifx/g' ./Makefile > ./Makefile2 \
&& sed -e 's/FFLAGS=-O2 -funroll-loops -fexpensive-optimizations/FFLAGS=-O2/g' ./Makefile2 > ./Makefile \
&& make \
&& cd ../ \
&& ln -s dfftpack/libdfftpack.a ./libdfftpack_icx.a

# libcerf v1.15
#wget https://jugit.fz-juelich.de/mlz/libcerf/-/archive/v1.15/libcerf-v1.15.tar.gz \
#&& tar zxvf libcerf-v1.15.tar.gz \
#&& cd libcerf-v1.15 \
#&& mkdir build \
#&& cd build \
#&& cmake -D BUILD_SHARED_LIBS=OFF .. \
#&& make \
#&& cd ../ \
#&& cd ../ \
#&& ln -s libcerf-v1.15/build/lib/libcerf.a ./libcerf.a \
#&& cp libcerf-v1.15/fortran/ccerflib_f95_interface/use_libcerf_mod.f90 ./

# ACM 782 RRQR
# "sed -i '1,3d' 782.sh" remove the top 3 lines with the ACM info
# replace all $( and $?in the cat areas for makefiles with \$( and \$?to work with newer versions of sh
# "sh 782.sh" is extracting the rrqr_acm directory
#wget http://www.netlib.org/toms-2014-06-10/782 -O 782.sh \
#&& sed -i '1,3d' 782.sh \
#&& sed -i 's/\$[\(]/\\$\(/g' 782.sh \
#&& sed -i 's/\$[\?]/\\$?/g' 782.sh \
#&& sh 782.sh \
#&& cd rrqr_acm/ \
#&& cd lib/ \
#&& sed -e 's/FORTRAN   = f77/FORTRAN=gfortran/g' ./Makefile > ./Makefile2 \
#&& sed -e 's/OPTS      = -u -g -C/OPTS=-O3/g' ./Makefile2 > ./Makefile \
#&& make \
#&& cd ../ \
#&& cd ../ \
#&& ln -s rrqr_acm/rrqr.a ./rrqr.a

# Eigen 3.4.0
wget https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.tar.gz \
&& tar zxvf eigen-3.4.0.tar.gz \
&& cp -r eigen-3.4.0/Eigen ./ \
&& mkdir unsupported \
&& cp -r eigen-3.4.0/unsupported/Eigen ./unsupported/
