#!/bin/bash

#LEAP 
indir=/project/3022035.03/LEAP2/data/congrads
SUBJECTS=/project/3022035.03/LEAP2/data/congrads/success_congrads_sbjs.txt

DKdir=/project/3022035.03/DKatlasROIs2mmMNI
HOdir=/project/3022035.03/HOatlas
MNImask=/opt/fsl/6.0.1/data/standard/MNI152_T1_2mm_brain_mask.nii.gz
refdir=/project/3022035.03/HCP/data/congrads/refs #change dir to where the references are

# subcortical
for ROI in L_amygdala R_amygdala L_striatum R_striatum ; do 
	for subj in $(cat ${SUBJECTS}) ; do 

		outdir=${indir}/${subj}/${ROI}
		
		G1=$outdir/G1.nii.gz
		G2=$outdir/G2.nii.gz
		G3=$outdir/G3.nii.gz

		if [[ ! -f "$G1" ]] || [[ ! -f "$G2" ]] || [[ ! -f "$G3" ]] ; then
			echo $subj $ROI
			#change orientation gradient 1 
			fslmaths ${outdir}/grad0000.nii.gz  -add -1 -abs -mul ${HOdir}/${ROI}.nii.gz ${outdir}/grad0000_flipped.nii.gz
			#change orientation gradient 2 
			fslmaths ${outdir}/grad0001.nii.gz  -add -1 -abs -mul ${HOdir}/${ROI}.nii.gz ${outdir}/grad0001_flipped.nii.gz
			#change orientation gradient 3 
			fslmaths ${outdir}/grad0002.nii.gz  -add -1 -abs -mul ${HOdir}/${ROI}.nii.gz ${outdir}/grad0002_flipped.nii.gz


			#set reference
			ref1=${refdir}/ref_${ROI}_grad0000.nii.gz  #ref #average of 20 subs 
			ref2=${refdir}/ref_${ROI}_grad0001.nii.gz
			ref3=${refdir}/ref_${ROI}_grad0002.nii.gz

			#correlations with ref 1 (gradient1)
			fslcc -p 4 $ref1 ${outdir}/grad0000.nii.gz > ${outdir}/G1.txt
			G1_ref1=`cat ${outdir}/G1.txt | awk '{print $3}'`
			rm $outdir/G1.txt 
			if [[ -z "$G1_ref1" ]] ; then
				G1_ref1=0
			fi      

			fslcc -p 4 $ref1 ${outdir}/grad0000_flipped.nii.gz > ${outdir}/G1_flipped.txt
			G1_ref1_flipped=`cat ${outdir}/G1_flipped.txt | awk '{print $3}'`
			rm $outdir/G1_flipped.txt
			if [[ -z "$G1_ref1_flipped" ]] ; then
				G1_ref1_flipped=0
			fi      

			fslcc -p 4 $ref1 ${outdir}/grad0001.nii.gz > ${outdir}/G2.txt
			G2_ref1=`cat ${outdir}/G2.txt | awk '{print $3}'`
			rm $outdir/G2.txt       
			if [[ -z "$G2_ref1" ]] ; then
				G2_ref1=0
			fi      

			fslcc -p 4 $ref1 ${outdir}/grad0001_flipped.nii.gz > ${outdir}/G2_flipped.txt
			G2_ref1_flipped=`cat ${outdir}/G2_flipped.txt | awk '{print $3}'`
			rm $outdir/G2_flipped.txt
			if [[ -z "$G2_ref1_flipped" ]] ; then
				G2_ref1_flipped=0
			fi      

			#correlations with ref 2 (gradient2)
			fslcc -p 4 $ref2 ${outdir}/grad0000.nii.gz > ${outdir}/G1.txt
			G1_ref2=`cat ${outdir}/G1.txt | awk '{print $3}'`
			rm $outdir/G1.txt  
			if [[ -z "$G1_ref2" ]] ; then
				G1_ref2=0
			fi     

			fslcc -p 4 $ref2 ${outdir}/grad0000_flipped.nii.gz > ${outdir}/G1_flipped.txt
			G1_ref2_flipped=`cat ${outdir}/G1_flipped.txt | awk '{print $3}'`
			rm $outdir/G1_flipped.txt
			if [[ -z "$G1_ref2_flipped" ]] ; then
				G1_ref2_flipped=0
			fi

			fslcc -p 4 $ref2 ${outdir}/grad0001.nii.gz > ${outdir}/G2.txt
			G2_ref2=`cat ${outdir}/G2.txt | awk '{print $3}'`
			rm $outdir/G2.txt 
			if [[ -z "$G2_ref2" ]] ; then
				G2_ref2=0
			fi      

			fslcc -p 4 $ref2 ${outdir}/grad0001_flipped.nii.gz > ${outdir}/G2_flipped.txt
			G2_ref2_flipped=`cat ${outdir}/G2_flipped.txt | awk '{print $3}'`
			rm $outdir/G2_flipped.txt
			if [[ -z "$G2_ref2_flipped" ]] ; then
				G2_ref2_flipped=0
			fi

			fslcc -p 4 $ref2 ${outdir}/grad0002.nii.gz > ${outdir}/G3.txt
			G3_ref2=`cat ${outdir}/G3.txt | awk '{print $3}'`
			rm $outdir/G3.txt  
			if [[ -z "$G3_ref2" ]] ; then
				G3_ref2=0
			fi     

			fslcc -p 4 $ref2 ${outdir}/grad0002_flipped.nii.gz > ${outdir}/G3_flipped.txt
			G3_ref2_flipped=`cat ${outdir}/G3_flipped.txt | awk '{print $3}'`
			rm $outdir/G3_flipped.txt
			if [[ -z "$G3_ref2_flipped" ]] ; then
				G3_ref2_flipped=0
			fi

#correlations with ref 3 (gradient3)
			fslcc -p 4 $ref3 ${outdir}/grad0000.nii.gz > ${outdir}/G1.txt
			G1_ref3=`cat ${outdir}/G1.txt | awk '{print $3}'`
			rm $outdir/G1.txt  
			if [[ -z "$G1_ref3" ]] ; then
				G1_ref3=0
			fi     

			fslcc -p 4 $ref3 ${outdir}/grad0000_flipped.nii.gz > ${outdir}/G1_flipped.txt
			G1_ref3_flipped=`cat ${outdir}/G1_flipped.txt | awk '{print $3}'`
			rm $outdir/G1_flipped.txt
			if [[ -z "$G1_ref3_flipped" ]] ; then
				G1_ref3_flipped=0
			fi

			fslcc -p 4 $ref3 ${outdir}/grad0001.nii.gz > ${outdir}/G2.txt
			G2_ref3=`cat ${outdir}/G2.txt | awk '{print $3}'`
			rm $outdir/G2.txt 
			if [[ -z "$G2_ref3" ]] ; then
				G2_ref3=0
			fi      

			fslcc -p 4 $ref3 ${outdir}/grad0001_flipped.nii.gz > ${outdir}/G2_flipped.txt
			G2_ref3_flipped=`cat ${outdir}/G2_flipped.txt | awk '{print $3}'`
			rm $outdir/G2_flipped.txt
			if [[ -z "$G2_ref3_flipped" ]] ; then
				G2_ref3_flipped=0
			fi

			fslcc -p 4 $ref3 ${outdir}/grad0002.nii.gz > ${outdir}/G3.txt
			G3_ref3=`cat ${outdir}/G3.txt | awk '{print $3}'`
			rm $outdir/G3.txt  
			if [[ -z "$G3_ref3" ]] ; then
				G3_ref3=0
			fi     

			fslcc -p 4 $ref3 ${outdir}/grad0002_flipped.nii.gz > ${outdir}/G3_flipped.txt
			G3_ref3_flipped=`cat ${outdir}/G3_flipped.txt | awk '{print $3}'`
			rm $outdir/G3_flipped.txt
			if [[ -z "$G3_ref3_flipped" ]] ; then
				G3_ref3_flipped=0
			fi

	## check which correlations are higher -> select highest and rename it to be used ## grad1
			if [[ ! -f "$G1" ]] ; then
				if [ $G1_ref1 \> $G1_ref1_flipped ] && [ $G1_ref1 \> $G2_ref1 ] && [ $G1_ref1 \> $G2_ref1_flipped ] ; then 
					echo "G1 is best";
					cp $outdir/grad0000.nii.gz $G1
				
				elif [ $G1_ref1_flipped \> $G1_ref1 ] && [ $G1_ref1_flipped \> $G2_ref1 ] && [ $G1_ref1_flipped \> $G2_ref1_flipped ] ; then 
					echo "G1_flipped is best";
					cp $outdir/grad0000_flipped.nii.gz $G1
				
				elif [ $G2_ref1 \> $G1_ref1 ] && [ $G2_ref1 \> $G1_ref1_flipped ] && [ $G2_ref1 \> $G2_ref1_flipped ] ; then 
					echo "G2 is best";
					cp $outdir/grad0001.nii.gz $G1
				
				elif [ $G2_ref1_flipped \> $G1_ref1 ] && [ $G2_ref1_flipped \> $G1_ref1_flipped ] && [ $G2_ref1_flipped \> $G2_ref1 ] ; then 
					echo "G2_flipped is best";
					cp $outdir/grad0001_flipped.nii.gz $G1
				else 
					echo "something's wrong"
				fi;
			fi
	## check which correlations are higher -> select highest and rename it to be used ## grad2
			if [[ ! -f "$G2" ]] ; then
				if [ $G2_ref2 \> $G2_ref2_flipped ] && [ $G2_ref2 \> $G1_ref2 ] && [ $G2_ref2 \> $G1_ref2_flipped ] && [ $G2_ref2 \> $G3_ref2 ] && [ $G2_ref2 \> $G3_ref2_flipped ]; then 
					echo "G2 is best for grad 2";
					cp $outdir/grad0001.nii.gz $G2
				
				elif [ $G2_ref2_flipped \> $G2_ref2 ] && [ $G2_ref2_flipped \> $G1_ref2 ] && [ $G2_ref2_flipped \> $G1_ref2_flipped ] && [ $G2_ref2_flipped \> $G3_ref2 ] && [ $G2_ref2_flipped \> $G3_ref2_flipped ]; then 
					echo "G2_flipped is best for grad 2";
					cp $outdir/grad0001_flipped.nii.gz $G2
				
				elif [ $G1_ref2 \> $G1_ref2_flipped ] && [ $G1_ref2 \> $G2_ref2 ] && [ $G1_ref2 \> $G2_ref2_flipped ] && [ $G1_ref2 \> $G3_ref2 ] && [ $G1_ref2 \> $G3_ref2_flipped ] ; then
					echo "G1 is best for grad 2";
					cp $outdir/grad0001.nii.gz $G2
				
				elif [ $G1_ref2_flipped \> $G1_ref2 ] && [ $G1_ref2_flipped \> $G2_ref2 ] && [ $G1_ref2_flipped \> $G2_ref2_flipped ] && [ $G1_ref2_flipped \> $G3_ref2 ] && [ $G1_ref2_flipped \> $G3_ref2_flipped ] ; then
					echo "G1_flipped is best for grad 2";
					cp $outdir/grad0001_flipped.nii.gz $G2

				elif [ $G3_ref2 \> $G3_ref2_flipped ] && [ $G3_ref2 \> $G2_ref2 ] && [ $G3_ref2 \> $G2_ref2_flipped ] && [ $G3_ref2 \> $G1_ref2 ] && [ $G3_ref2 \> $G1_ref2_flipped ] ; then
					echo "G3 is best for grad 2";
					cp $outdir/grad0002.nii.gz $G2
				
				elif [ $G3_ref2_flipped \> $G3_ref2 ] && [ $G3_ref2_flipped \> $G2_ref2 ] && [ $G3_ref2_flipped \> $G2_ref2_flipped ] && [ $G3_ref2_flipped \> $G1_ref2 ] && [ $G3_ref2_flipped \> $G1_ref2_flipped ] ; then
					echo "G3_flipped is best for grad 2";
					cp $outdir/grad0002_flipped.nii.gz $G2
				else 
					echo "something's wrong - grad 2"
				fi;
			fi

		


	## check which correlations are higher -> select highest and rename it to be used ## grad3
			if [[ ! -f "$G3" ]] ; then			
				if [ $G3_ref3 \> $G3_ref3_flipped ] && [ $G3_ref3 \> $G2_ref3 ] && [ $G3_ref3 \> $G2_ref3_flipped ] ; then
					echo "G3 is best for grad 3";
					cp $outdir/grad0002.nii.gz $G3
				
				elif [ $G3_ref3_flipped \> $G3_ref3 ] && [ $G3_ref3_flipped \> $G2_ref3 ] && [ $G3_ref3_flipped \> $G2_ref3_flipped ] ; then
					echo "G3_flipped is best for grad 3";
					cp $outdir/grad0002_flipped.nii.gz $G3

				elif [ $G2_ref3 \> $G2_ref3_flipped ] && [ $G2_ref3 \> $G3_ref3 ] && [ $G2_ref3 \> $G3_ref3_flipped ]; then 
					echo "G2 is best for grad 3";
					cp $outdir/grad0001.nii.gz $G3
				
				elif [ $G2_ref3_flipped \> $G2_ref3 ] && [ $G2_ref3_flipped \> $G3_ref3 ] && [ $G2_ref3_flipped \> $G3_ref3_flipped ]; then 
					echo "G2_flipped is best for grad 3";
					cp $outdir/grad0001_flipped.nii.gz $G3

				else 
					echo "something's wrong - grad 3"
				fi;
			fi
		fi
		if [[ -f "$G1" ]] && [[ -f "$G2" ]] && [[ -f "$G3" ]]; then
			rm $outdir/grad*
		fi

	done 
done

#cortical
for ROI in rh.fusiform lh.fusiform rh.rostralanteriorcingulate lh.rostralanteriorcingulate rh.postcentral lh.postcentral ; do 
	for subj in $(cat ${SUBJECTS}) ; do 

		outdir=${indir}/${subj}/${ROI}
		
		G1=$outdir/G1.nii.gz
		G2=$outdir/G2.nii.gz

		if [[ ! -f "$G1" ]] || [[ ! -f "$G2" ]] ; then
			echo $subj $ROI
			#change orientation gradient 1 
			fslmaths ${outdir}/grad0000.nii.gz  -add -1 -abs -mul ${DKdir}/${ROI}.label.nii.gz ${outdir}/grad0000_flipped.nii.gz
			#change orientation gradient 2 
			fslmaths ${outdir}/grad0001.nii.gz  -add -1 -abs -mul ${DKdir}/${ROI}.label.nii.gz ${outdir}/grad0001_flipped.nii.gz
			#change orientation gradient 3 
			fslmaths ${outdir}/grad0002.nii.gz  -add -1 -abs -mul ${DKdir}/${ROI}.label.nii.gz ${outdir}/grad0002_flipped.nii.gz


			#set reference
			ref1=${refdir}/ref_${ROI}_grad0000.nii.gz  #ref #average of 20 subs 
			ref2=${refdir}/ref_${ROI}_grad0001.nii.gz

			#correlations with ref 1 (gradient1)
			fslcc -p 4 $ref1 ${outdir}/grad0000.nii.gz > ${outdir}/G1.txt
			G1_ref1=`cat ${outdir}/G1.txt | awk '{print $3}'`
			rm $outdir/G1.txt 
			if [[ -z "$G1_ref1" ]] ; then
				G1_ref1=0
			fi      

			fslcc -p 4 $ref1 ${outdir}/grad0000_flipped.nii.gz > ${outdir}/G1_flipped.txt
			G1_ref1_flipped=`cat ${outdir}/G1_flipped.txt | awk '{print $3}'`
			rm $outdir/G1_flipped.txt
			if [[ -z "$G1_ref1_flipped" ]] ; then
				G1_ref1_flipped=0
			fi      

			fslcc -p 4 $ref1 ${outdir}/grad0001.nii.gz > ${outdir}/G2.txt
			G2_ref1=`cat ${outdir}/G2.txt | awk '{print $3}'`
			rm $outdir/G2.txt       
			if [[ -z "$G2_ref1" ]] ; then
				G2_ref1=0
			fi      

			fslcc -p 4 $ref1 ${outdir}/grad0001_flipped.nii.gz > ${outdir}/G2_flipped.txt
			G2_ref1_flipped=`cat ${outdir}/G2_flipped.txt | awk '{print $3}'`
			rm $outdir/G2_flipped.txt
			if [[ -z "$G2_ref1_flipped" ]] ; then
				G2_ref1_flipped=0
			fi      

			#correlations with ref 2 (gradient2)
			fslcc -p 4 $ref2 ${outdir}/grad0000.nii.gz > ${outdir}/G1.txt
			G1_ref2=`cat ${outdir}/G1.txt | awk '{print $3}'`
			rm $outdir/G1.txt  
			if [[ -z "$G1_ref2" ]] ; then
				G1_ref2=0
			fi     

			fslcc -p 4 $ref2 ${outdir}/grad0000_flipped.nii.gz > ${outdir}/G1_flipped.txt
			G1_ref2_flipped=`cat ${outdir}/G1_flipped.txt | awk '{print $3}'`
			rm $outdir/G1_flipped.txt
			if [[ -z "$G1_ref2_flipped" ]] ; then
				G1_ref2_flipped=0
			fi

			fslcc -p 4 $ref2 ${outdir}/grad0001.nii.gz > ${outdir}/G2.txt
			G2_ref2=`cat ${outdir}/G2.txt | awk '{print $3}'`
			rm $outdir/G2.txt 
			if [[ -z "$G2_ref2" ]] ; then
				G2_ref2=0
			fi      

			fslcc -p 4 $ref2 ${outdir}/grad0001_flipped.nii.gz > ${outdir}/G2_flipped.txt
			G2_ref2_flipped=`cat ${outdir}/G2_flipped.txt | awk '{print $3}'`
			rm $outdir/G2_flipped.txt
			if [[ -z "$G2_ref2_flipped" ]] ; then
				G2_ref2_flipped=0
			fi

			fslcc -p 4 $ref2 ${outdir}/grad0002.nii.gz > ${outdir}/G3.txt
			G3_ref2=`cat ${outdir}/G3.txt | awk '{print $3}'`
			rm $outdir/G3.txt  
			if [[ -z "$G3_ref2" ]] ; then
				G3_ref2=0
			fi     

			fslcc -p 4 $ref2 ${outdir}/grad0002_flipped.nii.gz > ${outdir}/G3_flipped.txt
			G3_ref2_flipped=`cat ${outdir}/G3_flipped.txt | awk '{print $3}'`
			rm $outdir/G3_flipped.txt
			if [[ -z "$G3_ref2_flipped" ]] ; then
				G3_ref2_flipped=0
			fi

	## check which correlations are higher -> select highest and rename it to be used ## grad1
			if [ $G1_ref1 \> $G1_ref1_flipped ] && [ $G1_ref1 \> $G2_ref1 ] && [ $G1_ref1 \> $G2_ref1_flipped ] ; then 
				echo "G1 is best";
				cp $outdir/grad0000.nii.gz $G1
			
			elif [ $G1_ref1_flipped \> $G1_ref1 ] && [ $G1_ref1_flipped \> $G2_ref1 ] && [ $G1_ref1_flipped \> $G2_ref1_flipped ] ; then 
				echo "G1_flipped is best";
				cp $outdir/grad0000_flipped.nii.gz $G1
			
			elif [ $G2_ref1 \> $G1_ref1 ] && [ $G2_ref1 \> $G1_ref1_flipped ] && [ $G2_ref1 \> $G2_ref1_flipped ] ; then 
				echo "G2 is best";
				cp $outdir/grad0001.nii.gz $G1
			
			elif [ $G2_ref1_flipped \> $G1_ref1 ] && [ $G2_ref1_flipped \> $G1_ref1_flipped ] && [ $G2_ref1_flipped \> $G2_ref1 ] ; then 
				echo "G2_flipped is best";
				cp $outdir/grad0001_flipped.nii.gz $G1
			else 
				echo "something's wrong"
			fi;

	## check which correlations are higher -> select highest and rename it to be used ## grad2
			if [ $G2_ref2 \> $G2_ref2_flipped ] && [ $G2_ref2 \> $G1_ref2 ] && [ $G2_ref2 \> $G1_ref2_flipped ] && [ $G2_ref2 \> $G3_ref2 ] && [ $G2_ref2 \> $G3_ref2_flipped ]; then 
				echo "G2 is best for grad 2";
				cp $outdir/grad0001.nii.gz $G2
			
			elif [ $G2_ref2_flipped \> $G2_ref2 ] && [ $G2_ref2_flipped \> $G1_ref2 ] && [ $G2_ref2_flipped \> $G1_ref2_flipped ] && [ $G2_ref2_flipped \> $G3_ref2 ] && [ $G2_ref2_flipped \> $G3_ref2_flipped ]; then 
				echo "G2_flipped is best for grad 2";
				cp $outdir/grad0001_flipped.nii.gz $G2
			
			elif [ $G1_ref2 \> $G1_ref2_flipped ] && [ $G1_ref2 \> $G2_ref2 ] && [ $G1_ref2 \> $G2_ref2_flipped ] && [ $G1_ref2 \> $G3_ref2 ] && [ $G1_ref2 \> $G3_ref2_flipped ] ; then
				echo "G1 is best for grad 2";
				cp $outdir/grad0001.nii.gz $G2
			
			elif [ $G1_ref2_flipped \> $G1_ref2 ] && [ $G1_ref2_flipped \> $G2_ref2 ] && [ $G1_ref2_flipped \> $G2_ref2_flipped ] && [ $G1_ref2_flipped \> $G3_ref2 ] && [ $G1_ref2_flipped \> $G3_ref2_flipped ] ; then
				echo "G1_flipped is best for grad 2";
				cp $outdir/grad0001_flipped.nii.gz $G2

			elif [ $G3_ref2 \> $G3_ref2_flipped ] && [ $G3_ref2 \> $G2_ref2 ] && [ $G3_ref2 \> $G2_ref2_flipped ] && [ $G3_ref2 \> $G1_ref2 ] && [ $G3_ref2 \> $G1_ref2_flipped ] ; then
				echo "G3 is best for grad 2";
				cp $outdir/grad0002.nii.gz $G2
			
			elif [ $G3_ref2_flipped \> $G3_ref2 ] && [ $G3_ref2_flipped \> $G2_ref2 ] && [ $G3_ref2_flipped \> $G2_ref2_flipped ] && [ $G3_ref2_flipped \> $G1_ref2 ] && [ $G3_ref2_flipped \> $G1_ref2_flipped ] ; then
				echo "G3_flipped is best for grad 2";
				cp $outdir/grad0002_flipped.nii.gz $G2
			else 
				echo "something's wrong - grad 2"
			fi;
		fi
		if [[ -f "$G1" ]] && [[ -f "$G2" ]] ; then
			rm $outdir/grad*
		fi
	done  
done 

