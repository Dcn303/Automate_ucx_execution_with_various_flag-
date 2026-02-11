#! /bin/bash
array_ucx_flag=( 'rc'  'cuda_copy'  'cuda_ipc' 'sm' \
        'rc,cuda_copy' 'rc,cuda_ipc' 'rc,sm' \
        'cuda_copy,cuda_ipc' 'cuda_copy,sm' \
        'cuda_ipc,sm' \
        'rc,cuda_copy,cuda_ipc' 'rc,cuda_copy,sm' \
        'cuda_copy,cuda_ipc,sm' \
        'rc,cuda_copy,cuda_ipc,sm' )
        for(( i=0; i< ${#array_ucx_flag[@]} ;i++ ));
        do
                cd osu_bw_${array_ucx_flag[${i}]}
                        if [ -f ${array_ucx_flag[${i}]}.sh ]; then
			echo "sbatch ${array_ucx_flag[${i}]}.sh"
                        sbatch ${array_ucx_flag[${i}]}.sh
			fi
                cd ..

        done
