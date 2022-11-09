#!/bin/bash


#set up
indir=/project/3022035.03/LEAP2/data/DWI # wave 2 DWI scans
outdir=/project/3022035.03/LEAP2/data/DWI # output to same dir, but create files with ".dtifit" extension
SUBJECTS=/project/3022035.03/LEAP2/data/DWI/dwi_subjectlist.txt

# run dtifit
#for subj in $(cat ${SUBJECTS}) ; do
#	
#	cd ${indir}/${subj}
#	dtifit --data=${subj}.nii.gz --mask=${subj}_mask.nii.gz --bvecs=${subj}.bvec --bvals=${subj}.bval --out=${subj}.dtifit --sse 
	

#done

# move to Ting's dir (can be handy to move data around later, for now don't move to Tings dir)
#for subj in $(cat ${SUBJECTS}) ; do
#	subjdir=${outdir}/${subj}
#	if [[ ! -d "${subjdir}" ]] ; then
#		mkdir $subjdir
#	fi
#	mv ${indir}/${subj}/${subj}_dtifit* $subjdir/
#done

# making QC stuff
#for subj in $(cat ${SUBJECTS}) ; do
	
#	echo /project/3022035.03/LEAP2/data/DWI/${subj}.dtifit/${subj}.dtifit_FA.nii.gz /project/3022035.03/LEAP2/data/DWI/${subj}/${subj}_mask.nii.gz
#done >> /project/3022035.03/LEAP2/data/DWI/QC_list.txt

#cd /project/3022035.03/LEAP2/data/DWI
#slicesdir -o $(cat QC_list.txt)


for subj in $(cat ${SUBJECTS}) ; do
	
	echo /project/3022035.03/LEAP2/data/DWI/${subj}.dtifit/${subj}.dtifit_sse.nii.gz
done >> /project/3022035.03/LEAP2/data/DWI/QC_list_sse.txt

#cd /project/3022035.03/LEAP2/data/DWI
#slicesdir -e 3 $(cat QC_list_sse.txt)
#slicesdir -e 5 $(cat QC_list_sse.txt)
slicesdir -e 7 $(cat QC_list_sse.txt)
