#!/bin/bash

subj=$1
wave=$2
echo $subj

#########	set up          ########
indir=/project/3022035.03/${wave}/data/congrads/${subj}/rh.fusiform
#outdir=/project/3022035.03/LEAP_long/data/fusiform_TSM/
DKdir=/project/3022035.03/DKatlasROIs2mmMNI

##########	run congrads for different ROIS         ##########

#cortical ROIs
for ROI in rh.fusiform ; do

        cd /project/3022035.03/lenobl/scripts/fMRI/congrads_master
        ./congrads -i ${indir}/G2.nii.gz -r ${DKdir}/${ROI}.label.nii.gz -o ${indir} -p -F 10
done

