# lapack_etc_make

This is the shell script to make (static) libraries below using gfortran and gcc.

### for gfortran and g++

- lapack-3.9.0
- slatec
- dfftpack
- libcerf
- ACM 782 RRQR

### for g++

- Eigen 3.3.7
- OpenCV-4.4.0

## How to use

```
git clone https://github.com/ya-mat/lapack_etc_make.git
cd lapack_etc_make
sh make.sh
```

You can get these libraries below.

### for gfortran and g++

- librefblas.a
- liblapack.a
- libtmglib.a
- libslatec.a
- libdfftpack.a
- libcerf.a
- (use_libcerf_mod.f90)

### for g++

- header files of Eigen (in 'Eigen' directory)
- libraries of OpenCV

## Dependency

You must have already installed these softwares below.

- gfortran
- gcc
- make
- libtool
- wget
- sed
- cmake

And, OpenCV need these softwares below.

- libgtk2.0-dev
- pkg-config
- libavcodec-dev
- libavformat-dev
- libswscale-dev
