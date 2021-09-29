
# Run g=16,64,256,1024

for global in {16 64 256 1024}
do
	./bin/yask.sh -mpi_cmd 'mpirun -np 8 --hostfile bf2hosts -mca btl vader,self' -g $global -no-use_shm -stencil iso3dfd -arch aarch64
done
