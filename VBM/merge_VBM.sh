#!/bin/bash

# read required preprocessed LEAP T1 VBM data and combine as 4D file 

#set up
indir1=/project/3022035.03/LEAP_long/data/VBM/LEAP1/mri  	
indir2=/project/3022035.03/LEAP_long/data/VBM/LEAP2/mri		
outdir=/project/3022035.03/LEAP_long/data/flica_input
SUBJECTS1=/project/3022035.03/LEAP_long/data/VBM/LEAP1/final_overlapping_subs.txt
SUBJECTS2=/project/3022035.03/LEAP_long/data/VBM/LEAP2/final_overlapping_subs.txt

# prep output dirs
#if [[ ! -d "${outdir}" ]] ; then
#	mkdir $outdir
#fi

#cp ${SUBJECTS}/${outdir}
#mkdir ${outdir}/data4d
#mkdir ${outdir}/path2_cluster_data
#mkdir ${outdir}/subscripts

#build files containg the subject files to be concatenated into 4d volumes
for subj in $(cat ${SUBJECTS1}) ; do
	echo ${indir1}/s4mwp1highres_${subj}.nii >> ${outdir}/path2_cluster_data/paths2_VBM.txt
done

for subj in $(cat ${SUBJECTS2}) ; do
	echo ${indir2}/s4mwp1highres_${subj}.nii >> ${outdir}/path2_cluster_data/paths2_VBM.txt 
done

#make modality folder
mkdir ${outdir}/data4d/VBM

#build scripts to concatenate each subject data into 4 dim vols (concat_modality.sh)
echo fslmerge -t ${outdir}/data4d/VBM/VBM2mm.nii.gz `cat ${outdir}/path2_cluster_data/paths2_VBM.txt` >>  ${outdir}/subscripts/concat_VBM.sh

chmod 744 ${outdir}/subscripts/concat_VBM.sh
qsub -l walltime=24:00:00,mem=32gb ${outdir}/subscripts/concat_VBM.sh
	
# need to down sample:
#cd /project/3022035.03/LEAP_long/data/flica_input_n456/data4d/VBM
#flirt -applyisoxfm 2 -in VBM2mm.nii.gz -ref /opt/fsl/6.0.0/data/standard/MNI152_T1_2mm_brain -out VBM2mm.nii.gz

