#!/bin/bash
#fsl/6.0.3 with no python mod loaded works 

#LEAP2
outdir=/project/3022035.03/LEAP_long/data/fusiform_TSM
#outdir=/project/3022035.03/LEAP2/data/congrads
SUBJECTS=/project/3022035.03/LEAP2/data/rs_sub_list.txt
#SUBJECTS=/project/3022035.03/LEAP2/data/congrads/redo_congrads_sbjs.txt

##########	mk outdir if it's not there yet		##################

if [[ ! -d "${outdir}" ]] ; then
	mkdir ${outdir}
fi

####################	submit congrads job for each subject	###############
chmod 744 /project/3022035.03/lenobl/scripts/fMRI/fusiform_TSM.sh
for subj in $(cat ${SUBJECTS}) ; do
	echo "/project/3022035.03/lenobl/scripts/fMRI/fusiform_TSM.sh $subj" | qsub -N "congrads${subj}" -l 'nodes=1:ppn=4, mem=24gb,walltime=16:00:00' -o /project/3022035.03/lenobl/scripts/fMRI/log/output${subj}.txt -e /project/3022035.03/lenobl/scripts/fMRI/log/error${subj}.txt

done 


# to find which subjects failed
#for subj in $(cat $SUBJECTS) ; do  for ROI in L_amygdala R_amygdala L_striatum R_striatum ; do  outfile=${outdir}/${subj}/${ROI}/${ROI}.cmaps.nii.gz; if [[ ! -f "${outfile}" ]] ; then   echo $subj $ROI; fi; done; done >> /project/3022035.03/LEAP2/data/congrads/redo_congrads_sbjs.txt

# to find which subjects that were successfull and print only the sbj_nmbrs to a txt file
#for subj in $(cat $SUBJECTS) ; do  for ROI in L_amygdala ; do  outfile=${outdir}/${subj}/${ROI}/${ROI}.cmaps.nii.gz; if [[ -f "${outfile}" ]] ; then   echo $subj; fi; done; done >> /project/3022035.03/LEAP2/data/congrads/success_congrads_sbjs.txt

#$ROI R_amygdala L_striatum R_striatum


# the following ROIs where excluded from the original code: R_hippocampus L_hippocampus R_thalamus L_thalamus R_pallidum L_pallidum

#for subj in $(cat $SUBJECTS) ; do  for ROI in lh.fusiform rh.fusiform lh.rostralanteriorcingulate rh.rostralanteriorcingulate lh.postcentral rh.postcentral ; do  outfile=${outdir}/${subj}/${ROI}/${ROI}.label.cmaps.nii.gz; if [[ ! -f "${outfile}" ]] ; then   echo $subj $ROI; fi; done; done >> /project/3022035.03/LEAP2/data/congrads/redo_congrads.txt




