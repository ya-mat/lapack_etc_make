# lapack_etc_make

This is the shell script to make (static) libraries below using gfortran and gcc.

- lapack-3.8.0
- slatec
- dfftpack
- libcerf-1.5

## How to use

```
git clone https://github.com/ya-mat/lapack_etc_make.git
cd lapack_etc_make
sh make.sh
```

You can get these libraries below.

- librefblas.a
- liblapack.a
- libtmglib.a
- libslatec.a
- libdfftpack.a
- libcerf.a
- (use_libcerf_mod.f90)

## Dependency

You must have already installed these softwares below.

- gfortran
- gcc
- make
- libtool
- wget
- sed

