#!/bin/bash

#module load cuda/10 and fsl/6.0.3 #before running

outdir=/project/3022035.03/LEAP2/data/probtrackX_atlas
SUBJECTS=/project/3022035.03/LEAP2/data/DWI/dwi_subjectlist.txt

#for subj in $(cat $SUBJECTS) ; do for ROI in R_amygdala L_amygdala R_striatum L_striatum lh.fusiform rh.fusiform lh.rostralanteriorcingulate rh.rostralanteriorcingulate lh.postcentral rh.postcentral; do outmat=${outdir}/${subj}/${ROI}/matrix_seeds_to_all_targets; if [[ ! -f "${outmat}" ]] ; then echo $subj $ROI; fi; done  ; done >> /project/3022035.03/LEAP/data/redo_subs.txt


##########	mk outdir if it's not there yet		##################

if [[ ! -d "${outdir}" ]] ; then
	mkdir ${outdir}
fi

###########	copy targets from HCP probtracks ##############

# can copy from the LEAP 1 (LEAP/data/probtrackX_atlas). only need to do once and then can comment out
cp /project/3022035.03/LEAP/data/probtrackX_atlas/*6mm.nii.gz ${outdir}/

####################	submit probtrackX job for each subject	###############

chmod 744 /project/3022035.03/lenobl/scripts/DWI/LEAP_probtrackX.sh
for subj in $(cat ${SUBJECTS}) ; do
	echo "/project/3022035.03/lenobl/scripts/DWI/LEAP_probtrackX.sh $subj" | qsub -N "probtrackX${subj}" -l 'nodes=1:gpus=1, feature=cuda, walltime=1:00:00, mem=8gb, reqattr=cudacap=6.0' -o /project/3022035.03/lenobl/scripts/DWI/log/o_probtrackX${subj}.txt -e /project/3022035.03/lenobl/scripts/DWI/log/e_probtrackX${subj}.txt 
done 
