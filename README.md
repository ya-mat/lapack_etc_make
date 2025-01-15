# lapack_etc_make

This is the shell script to make (static) libraries below using gfortran and gcc.

for gfortran and g++

- lapack-3.9.0
- lapack95
- slatec-bessel-cpp
- dfftpack
- libcerf
- ACM 782 RRQR

for g++

- Eigen 3.4.0

## How to use

Clone this repo.

```
git clone https://github.com/ya-mat/lapack_etc_make.git
```

Make lib in linux system.
```
cd lapack_etc_make \
&& chmod u+x make.sh \
&& ulimit -s unlimited \
&& env CC=gcc CXX=g++ FC=gfortran F90=gfortran F77=gfortran ./make.sh
```

If you use mac OS and homebrew, next command is useful.

```
git clone https://github.com/ya-mat/lapack_etc_make.git \
&& cd lapack_etc_make \
&& chmod u+x make.sh \
&& ulimit -s unlimited \
&& env CC=gcc-14 CXX=g++-14 FC=gfortran-14 F90=gfortran-14 F77=gfortran-14 ./make.sh
```

You can get these libraries below.

for gfortran and g++

- librefblas.a
- liblapack.a
- libtmglib.a
- libslatec.a
- libdfftpack.a
- libcerf.a
- (use_libcerf_mod.f90)

for g++

- header files of Eigen (in 'Eigen' and 'unsupported' directory)

## Dependency

You must have already installed these softwares below.

- gfortran
- gcc
- g++
- make
- libtool
- wget
- sed
- cmake
