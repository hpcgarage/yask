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
For Intel Host

```
make arch=intel64 stencil=iso3dfd -j
```

## Changes to source code to support aarch64
* Updated Makefile to swap flags (-qopenmp for -fopenmp), compilers (mpicc for mpiicc, gcc for icc)
* Removed #include<immintrin.h> from the yask kernel header
    * Note that this header includes support for `_mm_pause`, `_mm_prefetch`, and other x86 intrinsics
    * We replaced `_mm_pause` with `spin_pause` and commented other hints out for now.

### Compile errors

#### All platforms - increment error
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
We fixed this error by going in and editing src/compiler/lib/Yask_kernel.ccp to add the second increment to a new line:

```
    os << " // Specifying SIMD here because there is no explicit vectorization.\n"
                        "#pragma omp simd\n";
                os << " for (idx_t " << idim << " = " << istart << "; " <<
                    idim << " < " << istop << "; " <<
                    idim << " += " << istep << ") {\n";
                os << vp->get_elem_index(idim) << " += " << iestep << ";\n";
		    //Original two lines at ~line 780
	            //idim << " += " << istep << ", " <<
                    //vp->get_elem_index(idim) << " += " << iestep << ") {\n";
```

#### BF2 - libc errors
Mismatch version error for HPC-X and glibc on the Bluefield2 device. The only "supported" HPC-X build is for Ubuntu 20.04 which requires a newer glibc (2.29 versus 2.28 on the BF)
```
compilers/hpcx-v2.9.0-gcc-MLNX_OFED_LINUX-5.4-1.0.3.0-ubuntu20.04-aarch64/ompi/lib/libmpi.so: undefined reference to `log@GLIBC_2.29'
```
We worked around this by pulling the Redhat 8.4 version of HPC-X and symlinking to its ompi lib folder:
```
compilers/hpcx-v2.9.0-gcc-MLNX_OFED_LINUX-5.4-1.0.3.0-ubuntu20.04-aarch64/ompi/$ ln -s ~/compilers/hpcx-v2.9.0-gcc-MLNX_OFED_LINUX-5.4-1.0.3.0-redhat8.4-aarch64/ompi/lib/ lib
```
