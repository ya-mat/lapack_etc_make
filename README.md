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

```
git clone https://github.com/ya-mat/lapack_etc_make.git
cd lapack_etc_make
sh make.sh
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
