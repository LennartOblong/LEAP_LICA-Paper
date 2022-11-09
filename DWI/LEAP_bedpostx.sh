#!/bin/bash
#module load cuda/9.1 #before running
#set up
indir=/project/3022035.03/LEAP2/data/DWI
outdir=/project/3022035.03/LEAP2/data/DWI
SUBJECTS=/project/3022035.03/LEAP2/data/DWI/dwi_subjectlist.txt


for subj in $(cat ${SUBJECTS}) ; do
	outfile=${indir}/${subj}.bedpostX/merged_th3samples.nii.gz
	if [[ ! -f "${outfile}" ]] ; then
		echo "bedpostx_gpu ${indir}/${subj}" | qsub -N "bedpostx_${subj}" -l 'nodes=1:gpus=1, feature=cuda, walltime=1:00:00, mem=4gb, reqattr=cudacap>=5.0' -o /project/3022035.03/lenobl/scripts/DWI/log/o_bedpost_${subj}.txt -e /project/3022035.03/lenobl/scripts/DWI/log/e_bedpost_${subj}.txt
	fi
done


