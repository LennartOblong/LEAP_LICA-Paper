#!/bin/bash
### script to pull scans of specific group to new location. Needed to merge the scans and take the average ###

### get sbj lists of ASD and non-ASD subjects , always check this!!! ###

######  ASD group t1 and t2   #######
#SUBJECTS=/project/3022035.03/LEAP_long/demogs/ASD_t1_sbjs.txt
#SUBJECTS=/project/3022035.03/LEAP_long/demogs/ASD_t2_sbjs.txt

########  non-ASD group t1 and t2  ########
#SUBJECTS=/project/3022035.03/LEAP_long/demogs/CTRL_t1_sbjs.txt
SUBJECTS=/project/3022035.03/LEAP_long/demogs/CTRL_t2_sbjs.txt

### always check wave ###
#wve="LEAP"
wve="LEAP2"

##########	copy scans to new directory, always check target directory         ##########

#

for wave in  ${wve[@]} ; do

	for subj in $(cat ${SUBJECTS}) ; do

		if [ -d "/project/3022035.03/${wave}/data/congrads/${subj}/rh.fusiform/" ] ; then
        	cd /project/3022035.03/${wave}/data/congrads/${subj}/rh.fusiform/
	
		cp G2.nii.gz /project/3022035.03/LEAP_long/data/fusiform_gradientMaps/Controlt2/${subj}.G2.nii.gz
        	fi
	done
done

