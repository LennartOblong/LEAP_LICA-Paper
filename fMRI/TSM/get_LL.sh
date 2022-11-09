#Lennart Oblong
#Code to extract the negative log likelihood estimated by the bayesian linear regression of TSM. This is done to then calculate the BIC to determine the best model order.
#It is a one-liner that has to be run in the directory in which the files are contained, even in sub-directories. very useful for other applications.
#find is king

# Always check directories

#LEAP1
SUBJECTS=/project/3022035.03/LEAP/clinical/final_overlapping_subs.txt

#LEAP2
SUBJECTS2=/project/3022035.03/LEAP2/data/final_overlapping_subs.txt

indir=/project/3022035.03/LEAP/data/congrads
indir2=/project/3022035.03/LEAP2/data/congrads
outdir=/project/3022035.03/LEAP/data/congrads/TSM_rh.fusiformG2
outdir2=/project/3022035.03/LEAP2/data/congrads/TSM_rh.fusiformG2

####################    extract LL according to list of sbjs    ###############

for subj in $(cat ${SUBJECTS}) ; do
        
	awk '{print}' ${indir}/${subj}/rh.fusiform/G2.tsm.negloglik.txt >> ${outdir}/G2_negLL_modorderx10.txt

done

for subj in $(cat ${SUBJECTS2}) ; do

        awk '{print}' ${indir2}/${subj}/rh.fusiform/G2.tsm.negloglik.txt >> ${outdir2}/G2_negLL_modorderx10.txt

done

