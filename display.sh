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
                        echo " ${array_ucx_flag[${i}]}.sh"
			cat ${array_ucx_flag[${i}]}.sh
			cd ..

        done
