#!/bin/bash

for mod in VBM G1 G2 G3 

do

cd /project/3022035.03/HCP/data/flica_output/allmods3G/${mod}
	
	for j in 8 13 14 # IC number -1 
	do
		echo $j
		fslroi Renormalized_all_${mod}.nii.gz Renormalized_all_${mod}_${j}.nii.gz $j 1
		tmpimg=Renormalized_all_${mod}_${j}.nii.gz

		overlay 0 0 -c $FSLDIR/data/standard/MNI152_T1_1mm.nii.gz -a $tmpimg 2 6 $tmpimg -2.3 -6 ${tmpimg}
				
		fslroi $tmpimg ${tmpimg} 0 -1 0 -1 30 120 #10 70 12 85 20 50

		slicer ${tmpimg} -n -u -S 15 100000 ${mod}_$j.ppm 

		convert ${mod}_${j}.ppm lightbox_${mod}_$j.png
		rm ${mod}_${j}.ppm
		#rm $tmpimg 
	done
done
