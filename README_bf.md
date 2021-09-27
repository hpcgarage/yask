## README BlueField

This fork of YASK was modified to run across a Bluefield2 Arm device and an Intel server. 

Compilers used: HPC-X 2.9.0 - supports gcc 8.4.1 and OpenMPI 4.1

## Compilation Instructions (tested on HPC Advisory Council Thor cluster)



```
$ module use hpcx-bf2/modulefiles/
$ module load hpcx-mt-ompi
$ which mpicc
~/compilers/hpcx-v2.9.0-gcc-MLNX_OFED_LINUX-5.4-1.0.3.0-ubuntu20.04-aarch64/ompi/bin/mpicc 
```

## Changes to source code to support aarch64
* Updated Makefile to swap flags (-qopenmp for -fopenmp), compilers (mpicc for mpiicc, gcc for icc)
* Removed #include<immintrin.h> from the yask kernel header
    * Note that this header includes support for `_mm_pause`, `_mm_prefetch`, and other x86 intrinsics
    * We replaced `_mm_pause` with `spin_pause` and commented other hints out for now.

### Compile errors

Increment error - the generated for loop has two separate statements that can be separated onto separate lines. In theory, this code should compile but is considered "less readable".
```
yask/build/kernel/yask_kernel.iso3dfd.intel64/gen/yask_stencil_code.hpp:1392:49: error: invalid increment expression
  for (idx_t z = start_z; z < stop_z; z += step_z, z_elem += step_z_elem) {
                                      ~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~
In file included from /yask/src/kernel/lib/factory.cpp:31:
/yask/build/kernel/yask_kernel.iso3dfd.intel64/gen/yask_stencil_code.hpp: In member function ‘virtual void yask::StencilBundle_stencil_bundle_0::calc_loop_of_clusters(int, int, const yask::Indices&, yask::idx_t)’:
/global/home/users/jyoung/git_repos/yask_bf/yask/build/kernel/yask_kernel.iso3dfd.intel64/gen/yask_stencil_code.hpp:3357:49: error: invalid increment expression
  for (idx_t z = start_z; z < stop_z; z += step_z, z_elem += step_z_elem) {
```


