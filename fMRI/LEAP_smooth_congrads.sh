#!/bin/bash

subj=$1
echo $subj

#########	set up		########
indir=/project/3022036.01/wave2 
outdir=/project/3022035.03/LEAP2/data/congrads
DKdir=/project/3022035.03/DKatlasROIs2mmMNI
HOdir=/project/3022035.03/HOatlas
MNImask=/opt/fsl/6.0.1/data/standard/MNI152_T1_2mm_brain_mask.nii.gz

#######		 mk subj specific dirs for output	#########
subjdir=${outdir}/${subj}
if [[ ! -d "${subjdir}" ]] ; then
	mkdir ${subjdir}
fi

########	find and smooth		########
# for sigma divide FWHM (mm) by 2.3548 (e.g. FWHM 4 mm = 1.698658 sigma)
# using sigma 2.5 for consistency with Dori and across samples

RS_smooth=${subjdir}/RS_smooth.nii.gz
if [[ ! -f "${RS_smooth}" ]] ; then
	fslmaths ${indir}/${subj}/BOLD/task006/echocombined/preprocessing/RS_FMRI_4D.ica_aroma/nr_wm_csf/highpassfilter/denoised_func_data_nonaggr_res_pp2MNI152.nii.gz -s 2.5 ${RS_smooth}
fi

##########	run congrads for different ROIS		##########
#subcortical ROIs
for ROI in R_amygdala L_amygdala R_striatum L_striatum; do
	subjROIdir=${subjdir}/${ROI}
	if [[ ! -d "${subjROIdir}" ]] ; then
		mkdir ${subjROIdir}
	fi
	
	outgrad=${subjROIdir}/${ROI}.cmaps.nii.gz

	if [[ ! -f "${outgrad}" ]] ; then
		cd /project/3022035.03/lenobl/scripts/fMRI/congrads_master
		./congrads -i $RS_smooth -r ${HOdir}/${ROI}.nii.gz -m ${MNImask} -n 3 -z -o ${subjROIdir} #-p to see gradient connectivity across the brain in final nifti file
	fi
done

#cortical ROIs
for ROI in rh.fusiform lh.fusiform rh.rostralanteriorcingulate lh.rostralanteriorcingulate rh.postcentral lh.postcentral ; do
	subjROIdir=${subjdir}/${ROI}
	if [[ ! -d "${subjROIdir}" ]] ; then
		mkdir ${subjROIdir}
	fi
	
	outgrad=${subjROIdir}/${ROI}.label.cmaps.nii.gz

	if [[ ! -f "${outgrad}" ]] ; then
		cd /project/3022035.03/lenobl/scripts/fMRI/congrads_master
		./congrads -i $RS_smooth -r ${DKdir}/${ROI}.label.nii.gz -m ${MNImask} -n 3 -z -o ${subjROIdir} #-p to see gradient connectivity across the brain in final nifti file
	fi
done


#clean up to remove smoothed intermediate data
out_Lamyg=${subjdir}/L_amygdala/L_amygdala.cmaps.nii.gz
out_Ramyg=${subjdir}/R_amygdala/R_amygdala.cmaps.nii.gz
out_Lstr=${subjdir}/L_striatum/L_striatum.cmaps.nii.gz
out_Rstr=${subjdir}/R_striatum/R_striatum.cmaps.nii.gz
out_Lff=${subjdir}/lh.fusiform/lh.fusiform.label.cmaps.nii.gz
out_Rff=${subjdir}/rh.fusiform/rh.fusiform.label.cmaps.nii.gz
out_Lacc=${subjdir}/lh.rostralanteriorcingulate/lh.rostralanteriorcingulate.label.cmaps.nii.gz
out_Racc=${subjdir}/rh.rostralanteriorcingulate/rh.rostralanteriorcingulate.label.cmaps.nii.gz
out_Lpc=${subjdir}/lh.postcentral/lh.postcentral.label.cmaps.nii.gz
out_Rpc=${subjdir}/rh.postcentral/rh.postcentral.label.cmaps.nii.gz

if [[ -f "$out_Lamyg" ]] && [[ -f "$out_Ramyg" ]] && [[ -f "$out_Lstr" ]] && [[ -f "$out_Rstr" ]] && [[ -f "$out_Lff" ]] && [[ -f "$out_Rff" ]] && [[ -f "$out_Lacc" ]] && [[ -f "$out_Racc" ]] && [[ -f "$out_Lpc" ]] && [[ -f "$out_Lpc" ]] ; then
	 rm $RS_smooth
fi 

