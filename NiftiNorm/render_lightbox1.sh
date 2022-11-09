#!/bin/bash


#GATHER DATAS AND UPSAMPLE TO 1MM FOR NICE VISUALIZATION.
datadir=/project/3022035.03/LEAP_long/data/flica_output/VBM_DWI_congrads
#datadir=/project/3022035.03/Ting_ICA_LICA/ICA_VBM
#datadir=/project/3022035.03/Ting_ICA_LICA/linkedICA_VBM_DTI


for mod in G2
do
    
    mkdir ${datadir}/${mod}
    savedir=${datadir}/${mod}
    
	if [ "$mod" = "VBM" ];
	then
		#val=3
		#val=melodic_IC
		val=VBM
	fi
	if [ "$mod" = "G1" ];
	then
		val=1
	fi
	if [ "$mod" = "G2" ];
	then
		val=7
	fi
	if [ "$mod" = "G3" ];
	then
		val=3
	fi

	for j in {0..79}
	do
		echo $j
		#fslroi $datadir/niftiOut_mi${val}.nii.gz $datadir/${mod}_$j.nii.gz $j 1
		#fslroi $datadir/${val}.nii.gz $datadir/${mod}_$j.nii.gz $j 1
		fslroi $datadir/niftiOut_${val}.nii.gz $datadir/${mod}_$j.nii.gz $j 1
		tmpimg=${datadir}/${mod}_$j.nii.gz

		flirt -interp nearestneighbour -in $tmpimg -ref $FSLDIR/data/standard/MNI152_T1_1mm_brain.nii.gz -applyisoxfm 1 -out $tmpimg
		
		if [ "$mod" = "VBM" ];
		then
		fslmaths $tmpimg -mul $FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz $tmpimg
		else 	
		fslmaths $tmpimg -mul /project/3022035.03/HOatlas/subcortical_mask_1mm.nii.gz $tmpimg
		fi
	done

	mv ${datadir}/${mod}_* ${savedir}
	cd ${savedir}

	#fslmerge -t all_${mod}.nii.gz ${mod}_0.nii.gz ${mod}_1.nii.gz ${mod}_2.nii.gz ${mod}_3.nii.gz ${mod}_4.nii.gz ${mod}_5.nii.gz ${mod}_6.nii.gz ${mod}_7.nii.gz ${mod}_8.nii.gz ${mod}_9.nii.gz ${mod}_10.nii.gz ${mod}_11.nii.gz ${mod}_12.nii.gz ${mod}_13.nii.gz ${mod}_14.nii.gz ${mod}_15.nii.gz ${mod}_16.nii.gz ${mod}_17.nii.gz ${mod}_18.nii.gz ${mod}_19.nii.gz ${mod}_20.nii.gz ${mod}_21.nii.gz ${mod}_22.nii.gz ${mod}_23.nii.gz ${mod}_24.nii.gz ${mod}_25.nii.gz ${mod}_26.nii.gz ${mod}_27.nii.gz ${mod}_28.nii.gz ${mod}_29.nii.gz 

	for j in {0..79} ; do
		echo ${savedir}/${mod}_$j.nii.gz >> ${savedir}/merge_all.txt
	done

	echo fslmerge -t ${savedir}/all_${mod}_1mm.nii.gz `cat merge_all.txt` >>  ${savedir}/merge_all.sh

	chmod 744 ${savedir}/merge_all.sh
	qsub -l 'walltime=00:10:00,mem=32gb' ${savedir}/merge_all.sh	
	

#	rm ${mod}_* merge_all*
done

