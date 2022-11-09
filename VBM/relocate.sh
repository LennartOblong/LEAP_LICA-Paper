#!/bin/bash
# This script is made to quickly copy files from 1 directory to another,
# if the filedirectories are contained within a presorted file,
# while retaining the original files


############## 		getting raw W1 data
#indir=/project/3022039.01/VBM_ICA/original_data
#outdir=/project/3022035.03/LEAP_long/data/VBM/LEAP1
#SUBJECTS=/project/3022035.03/LEAP/clinical/final_overlapping_subs.txt

#for subj in $(cat ${SUBJECTS}) ; do
#	cp ${indir}/highres_"$subj".nii.gz ${outdir}/
#done
#
#gunzip $outdir/*

############## 		getting raw (sorted) W2 data
#indir=/project/3022035.03/LEAP2/data/VBM/T1w_raw
#outdir=/project/3022035.03/LEAP_long/data/VBM/LEAP2
#SUBJECTS=/project/3022035.03/LEAP2/data/final_overlapping_subs.txt

#for subj in $(cat ${SUBJECTS}) ; do
#	cp ${indir}/highres_"$subj".nii ${outdir}/
#done

############## 		moving data required for template

indir1=/project/3022035.03/LEAP_long/data/VBM/LEAP1/mri
subjects1=/project/3022035.03/LEAP_long/data/VBM/LEAP1/final_overlapping_subs.txt
indir2=/project/3022035.03/LEAP_long/data/VBM/LEAP2/mri
subjects2=/project/3022035.03/LEAP_long/data/VBM/LEAP2_only_subs.txt
outdir=/project/3022035.03/LEAP_long/data/VBM/batch_for_template

for subj in $(cat ${subjects1}) ; do

	mv ${indir1}/rp1highres_"$subj"_affine.nii ${outdir}/
	mv ${indir1}/rp2highres_"$subj"_affine.nii ${outdir}/
done

for subj in $(cat ${subjects2}) ; do
	mv ${indir2}/rp1highres_"$subj"_affine.nii ${outdir}/
	mv ${indir2}/rp2highres_"$subj"_affine.nii ${outdir}/
done

#while IFS= read -r line
#do
# 	 cp ${the_path}/"$SUBJECTS"/"Adni_mprage.nii.gz"
#               ${tbss_path}/"$subj"/"Adni_mprage.nii.gz"
#
#done < "$SUBJECTS"

#for i in $(cat ${SUBJECTS}) ; do
#	for subj in $(cat ${SUBJECTS}) ; do
#
#	cp ${the_path}/"$subj"/"Adni_mprage.nii.gz" ${tbss_path}/"highres_"$subj".nii.gz"
#
#	done
#
#	for subj in $(cat ${SUBJECTS}) ; do
#
 #       cp ${the_path}/"$subj"/"Adni_mprage_2.nii.gz" ${tbss_path}/"highres2_"$subj".nii.gz"
#
 #       done
#
#	for subj in $(cat ${SUBJECTS}) ; do
#
 #       cp ${the_path}/"$subj"/"Adni_mprage_3.nii.gz" ${tbss_path}/"highres3_"$subj".nii.gz"
#
 #       done


#done

#for subj in $(cat ${SUBJECTS}) ; do 
#
#	for dir in ${the_path} ; do
#
#		if grep -f <(sed 's/.*/\^&\\>/' $COND) 
#			${the_path}/"$subj"
#	then 
#		cp ${the_path}/"$subj"/".nii.gz" 
#		${tbss_path}/"$subj"_highres/".nii.gz"
#	else	
#		:
#		fi
#	done
#done

#qsub -l walltime=01:00:00,mem=32gb cp.sh
