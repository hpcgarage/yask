#!/bin/bash
set -x
#mpirun -np 2 --hostfile thorhosts -mca btl vader,self ./bin/yask_kernel.iso3dfd.intel64.exe -g 16 -no-use_shm : -np 2 --hostfile bf2hosts_thor18 -mca btl vader,self ./bin/yask_kernel.iso3dfd.aarch64.exe -g 16 -no-use_shm
mpirun -np 2 --hostfile bf2hosts_thor18 ./bin/yask_kernel.iso3dfd.aarch64.exe -g 16 -no-use_shm : -np 2 --hostfile thorhosts ./bin/yask_kernel.iso3dfd.intel64.exe -g 16 -no-use_shm
