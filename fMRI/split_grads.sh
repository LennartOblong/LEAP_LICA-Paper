#!/bin/bash

# separate gradients into separate niftis 

#set up
indir=/project/3022035.03/LEAP2/data/congrads
SUBJECTS=/project/3022035.03/LEAP2/data/rs_sub_list.txt #correct sbj list

for subj in $(cat ${SUBJECTS}) ; do

	for ROI in R_amygdala L_amygdala R_striatum L_striatum ; do

		fslsplit ${indir}/${subj}/${ROI}/${ROI}.cmaps.nii.gz ${indir}/${subj}/${ROI}/grad
	done

	for ROI in rh.fusiform lh.fusiform rh.rostralanteriorcingulate lh.rostralanteriorcingulate rh.postcentral lh.postcentral ; do

		fslsplit ${indir}/${subj}/${ROI}/${ROI}.label.cmaps.nii.gz ${indir}/${subj}/${ROI}/grad
	done
done


