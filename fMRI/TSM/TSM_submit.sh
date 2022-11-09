#!/bin/bash
#fsl/6.0.3 with no python mod loaded works

#LEAP1
SUBJECTS=/project/3022035.03/LEAP/clinical/final_overlapping_subs.txt
wave=LEAP

#LEAP2
#SUBJECTS=/project/3022035.03/LEAP2/data/final_overlapping_subs.txt
#wave=LEAP2

####################    submit congrads job for each subject    ###############
chmod 744 /project/3022035.03/lenobl/scripts/fMRI/TSM/fusiform_TSM_NF.sh
for subj in $(cat ${SUBJECTS}) ; do
        echo "/project/3022035.03/lenobl/scripts/fMRI/TSM/fusiform_TSM_NF.sh $subj $wave" | qsub -N "congrads${subj}" -l 'nodes=1:ppn=4, mem=24gb,walltime=16:00:00' -o /project/3022035.03/lenobl/scripts/fMRI/log/error${subj}.txt

done

