#!/bin/bash

subj=$1
echo $subj

#########	set up		########
indir=/project/3022035.03/LEAP2/data/DWI
outdir=/project/3022035.03/LEAP2/data/probtrackX_atlas
MNI=/opt/fsl/6.0.1/data/standard/MNI152_T1_2mm_brain.nii.gz
T1=/project/3022035.03/LEAP2/data/T1w/T1w_scanfiles/highres_${subj}_brain.nii.gz	#changed
T1nobet=/project/3022035.03/LEAP2/data/T1w/T1w_scanfiles/highres_${subj}.nii	#changed
DKdir=/project/3022035.03/DKatlasROIs2mmMNI
HOdir=/project/3022035.03/HOatlas
targetList=/project/3022035.03/MMPatlas/targetList.txt

#######		 mk sub specific dirs for output	#########
subjdir=${outdir}/${subj}
if [[ ! -d "${subjdir}" ]] ; then
	mkdir ${subjdir}
fi

########	Compute transforms from diff2standard space 	##########
#(where ROIs will be)

outwarp=${subjdir}/standard2diff_warp.nii.gz

if [[ ! -f "${outwarp}" ]] ; then
	fslroi ${indir}/${subj}/data ${subjdir}/B0 0 1
	fslmaths ${subjdir}/B0 -mas ${indir}/${subj}/nodif_brain_mask ${subjdir}/nodif_brain

	flirt -dof 6 -in ${subjdir}/nodif_brain -ref $T1 -omat ${subjdir}/diff2str.mat 

	flirt -dof 12 -in ${T1} -ref ${MNI} -omat ${subjdir}/str2standard.mat 

	#this T1 should be un stripped
	fnirt --ref=$MNI --in=$T1nobet --aff=${subjdir}/str2standard.mat --cout=${subjdir}/str2standard_warp

	convertwarp --ref=$MNI --premat=${subjdir}/diff2str.mat --warp1=${subjdir}/str2standard_warp --out=${subjdir}/diff2standard_warp

	invwarp -w ${subjdir}/diff2standard_warp -o ${subjdir}/standard2diff_warp -r ${subjdir}/nodif_brain

# used this to just check xform/warp
#applywarp --ref=$MNI --in=${subjdir}/nodif_brain --warp=${subjdir}/str2standard_warp --premat=${subjdir}/diff2str.mat --out=${subjdir}/nodif_brain_inMNI
fi


##########	run probtracks for different ROIS	##########

#subcort ROIs
for ROI in R_amygdala L_amygdala R_striatum L_striatum ; do
	subjROIdir=${outdir}/${subj}/${ROI}
	if [[ ! -d "${subjROIdir}" ]] ; then
		mkdir ${subjROIdir}
	fi
	
	outmat=${subjROIdir}/matrix_seeds_to_all_targets

	if [[ ! -f "${outmat}" ]] ; then

		probtrackx2_gpu -s ${indir}/${subj}.bedpostX/merged -m ${indir}/${subj}.bedpostX/nodif_brain_mask -x ${HOdir}/${ROI}.nii.gz --dir=${subjROIdir} --forcedir --xfm=${subjdir}/standard2diff_warp --invxfm=${subjdir}/diff2standard_warp --pd --s2tastext --targetmasks=$targetList --os2t
	fi

done

#cortical ROIs
for ROI in rh.fusiform lh.fusiform rh.rostralanteriorcingulate lh.rostralanteriorcingulate rh.postcentral lh.postcentral ; do
	subjROIdir=${outdir}/${subj}/${ROI}
	if [[ ! -d "${subjROIdir}" ]] ; then
		mkdir ${subjROIdir}
	fi
	
	outmat=${subjROIdir}/matrix_seeds_to_all_targets

	if [[ ! -f "${outmat}" ]] ; then

		probtrackx2_gpu -s ${indir}/${subj}.bedpostX/merged -m ${indir}/${subj}.bedpostX/nodif_brain_mask -x ${DKdir}/${ROI}.label.nii.gz --dir=${subjROIdir} --forcedir --xfm=${subjdir}/standard2diff_warp --invxfm=${subjdir}/diff2standard_warp --pd --s2tastext --targetmasks=$targetList --os2t
	fi
done
	

