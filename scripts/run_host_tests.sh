
# Run g=16,64,256,1024

STENCIL=iso3dfd
ARCH=intel64
MPIRANKS=8
OUTDIR=results/x86/mpi/
#Put the logs in a temporary place
LOGDIR=logs/yask.$STENCIL.$ARCH.thor-host-mpi-${MPIRANKS}

mkdir -p $OUTDIR
mkdir -p $LOGDIR

#if [ 1 -eq 0 ]; then

for global in 16 32 64 128 256 512
do
	./bin/yask.sh -mpi_cmd 'mpirun -v -np 8 --hostfile thorhosts -mca btl vader,self' -g $global -no-use_shm -stencil iso3dfd -arch $ARCH
	TESTNAME=yask.$STENCIL.$ARCH.thor-mpi-${MPIRANKS}rnk-g${global}.csv
	./utils/bin/yask_log_to_csv.pl logs/*.log &> $OUTDIR/$TESTNAME	
	#Just save logs in a separate folder 
	mv logs/* $LOGDIR/.
done

#fi


OUTDIR=results/x86/openmp/
LOGDIR=logs/yask.$STENCIL.$ARCH.thor-host

mkdir -p $OUTDIR
mkdir -p $LOGDIR

for global in 16 32 64 128 256 512
do
	./bin/yask.sh -g $global -stencil iso3dfd -arch $ARCH
	TESTNAME=yask.$STENCIL.$ARCH.thor-openmp-${MPIRANKS}thr-g${global}.csv
	./utils/bin/yask_log_to_csv.pl logs/*.log &> $OUTDIR/$TESTNAME	
	#Just save logs in a separate folder 
	mv logs/* $LOGDIR/.
done
