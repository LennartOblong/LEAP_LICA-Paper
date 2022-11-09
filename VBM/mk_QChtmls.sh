#!/bin/bash

#set up
indir=/project/3022039.01/Anatomy_timepoint2/raw 
outdir=/project/3022035.03/LEAP2/data/VBM/QC
SUBJECTS=/project/3022035.03/lenobl/subject_ls.txt

# making QC stuff
# sorting all Adni_mprage files into a txt file for easy access
# Adni_mprage files will be marked if used (y) or not (n)
# subjects without Adni_mprage files are sorted into a seperate txt file. Solves slicesdir errors
for subj in $(cat ${SUBJECTS}) ; do

	if 	[ -r "${indir}/${subj}/Adni_mprage_4.nii.gz" ] 
	then 
		echo ${indir}/${subj}/Adni_mprage_4.nii.gz >> ${outdir}/QC_list.txt
		echo ${indir}/${subj}/Adni_mprage_3.nii.gz >> ${outdir}/QC_list.txt
		echo ${indir}/${subj}/Adni_mprage_2.nii.gz >> ${outdir}/QC_list.txt
		echo ${indir}/${subj}/Adni_mprage.nii.gz >> ${outdir}/QC_list.txt

	elif 	[ -r "${indir}/${subj}/Adni_mprage_3.nii.gz" ] 
	then
		echo ${indir}/${subj}/Adni_mprage_3.nii.gz >> ${outdir}/QC_list.txt
		echo ${indir}/${subj}/Adni_mprage_2.nii.gz >> ${outdir}/QC_list.txt
		echo ${indir}/${subj}/Adni_mprage.nii.gz >> ${outdir}/QC_list.txt

	elif	[ -r "${indir}/${subj}/Adni_mprage_2.nii.gz" ]
	then 
		echo ${indir}/${subj}/Adni_mprage_2.nii.gz >> ${outdir}/QC_list.txt
		echo ${indir}/${subj}/Adni_mprage.nii.gz >> ${outdir}/QC_list.txt

	elif	[ -r "${indir}/${subj}/Adni_mprage.nii.gz" ]
	then	
		echo ${indir}/${subj}/Adni_mprage.nii.gz >> ${outdir}/QC_list.txt

	else 
		echo ${indir}/${subj}/NoAdniFile >> ${outdir}/QC_list_NoAdni.txt

	fi		

done #>> ${outdir}/QC_list.txt

cd $outdir
#slicesdir $(cat QC_list.txt)


