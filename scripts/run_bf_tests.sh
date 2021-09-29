
# Run g=16,64,256,1024

STENCIL=iso3dfd
ARCH=aarch64
MPIRANKS=8
OUTDIR=results/bf2/mpi/
#Put the logs in a temporary place
LOGDIR= logs/yask.$STENCIL.$ARCH.thor-mpi-${MPIRANKS}

mkdir -p $OUTDIR
mkdir -p $LOGDIR

#for global in 16 32 64 128 256 512
for global in 16 512
do
	./bin/yask.sh -mpi_cmd 'mpirun -v -np 8 --hostfile bf2hosts -mca btl vader,self' -g $global -no-use_shm -stencil iso3dfd -arch aarch64
	TESTNAME=yask.$STENCIL.$ARCH.thor-mpi-${MPIRANKS}rnk-g${global}.csv
	./utils/bin/yask_log_to_csv.pl logs/*.log &> $OUTDIR/$TESTNAME	
	 mv logs/* $LOGDIR/.
done
