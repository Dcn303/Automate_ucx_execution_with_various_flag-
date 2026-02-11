#! /bin/bash
array_ucx_flag=( 'rc'  'cuda_copy'  'cuda_ipc' 'sm' \
	'rc,cuda_copy' 'rc,cuda_ipc' 'rc,sm' \
	'cuda_copy,cuda_ipc' 'cuda_copy,sm' \
	'cuda_ipc,sm' \
	'rc,cuda_copy,cuda_ipc' 'rc,cuda_copy,sm' \
	'cuda_copy,cuda_ipc,sm' \
	'rc,cuda_copy,cuda_ipc,sm' )
	
        
echo "total array element= ${#array_ucx_flag[@]}"



for(( i=0 ; i< ${#array_ucx_flag[@]} ; i++ ));
do	
mkdir osu_bw_${array_ucx_flag[${i}]}
cp -rf osu_bw osu_bw_${array_ucx_flag[${i}]}
cd osu_bw_${array_ucx_flag[${i}]}
cat<<EOF > ${array_ucx_flag[${i}]}.sh 
#! /bin/bash
#SBATCH -J osu_bw
#SBATCH --gres=gpu:1
#SBATCH --partition=
#SBATCH --account=
#SBATCH --ntasks-per-node=1
#SBATCH -N 2
#SBATCH --exclusive

echo \$SLURM_SUBMIT_HOST > log.host_list 2>&1
## cuda_12.4 installed locally at home directory
export PATH=/home/CUDA_RHEL_collections/cuda_12.4/bin:\$PATH
export LD_LIBRARY_PATH=/home/CUDA_RHEL_collections/cuda_12.4/lib64:\$LD_LIBRARY_PATH

##location of the UCX_1.17.x with support of cuda 12.4 and gdrcopy
export PATH=/home/UCX_collections/UCX_1.17.x_with_home_cuda_12.4_support/ucx-1.17.x/build/bin:\$PATH
export LD_LIBRARY_PATH=/home/UCX_collections/UCX_1.17.x_with_home_cuda_12.4_support/ucx-1.17.x/build/lib:\$LD_LIBRARY_PATH

##location of the OpenMPI-5.0.8 with UCX 1.17 and gdrcopy
export PATH=/home/OpenMPI_5.0.8_Collections/OpenMPI_with_ucx_and_gdrcopy/openmpi-5.0.8/build/bin:\$PATH
export LD_LIBRARY_PATH=/home/OpenMPI_5.0.8_Collections/OpenMPI_with_ucx_and_gdrcopy/openmpi-5.0.8/build/lib:\$LD_LIBRARY_PATH
    mpirun -np 2 \\ 
    --bind-to core \\
    --mca pml ucx --mca osc ucx \\
    -x UCX_NET_DEVICES=mlx5_1:1,mlx5_3:1 \\
    -x UCX_MAX_RNDV_LANES=2 \\
    -x UCX_TLS=${array_ucx_flag[${i}]}  \\
    -x UCX_IB_GPU_DIRECT_RDMA=yes \\
    -x UCX_MEMTYPE_CACHE=y \\
    -x LD_LIBRARY_PATH \\
    ./osu_bw D D > log.osu_bw_D_D_${array_ucx_flag[${i}]} 2>&1
EOF
cd ..
done


