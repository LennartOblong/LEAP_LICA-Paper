#!/bin/bash
# need to load FSL module 6.0.1

outdir=/project/3022035.03/LEAP_long/data/flica_output/congrads
indir=/project/3022035.03/LEAP_long/data/flica_input/data4d_congrads

##########	mk outdir if it's not there yet		##################

if [[ ! -d "${outdir}" ]] ; then
	mkdir ${outdir}
fi

####################	submit LICA	###############

echo "fslpython /project/3022035.03/lenobl/scripts/LICA/fsl_flica-master/flica/flica.py -nICAs 80 -maxits 3000 -output_dir $outdir $indir" | qsub -N "LICA" -l 'nodes=1:ppn=4,mem=50gb,walltime=48:00:00' -o /project/3022035.03/lenobl/scripts/LICA/log/oLICA_LEAPlong_congrads.txt -e /project/3022035.03/lenobl/scripts/LICA/log/eLICA_LEAPlong_congrads.txt 
#-lambda_dims 'R'
#-tol 0.000001 -lambda_dims 'o' 

