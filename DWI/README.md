Data preprocessing is done at the KCL site  
1. LEAP_dtifit.sh  
	fits tensor model and outputs htmls for QC  
2. QC data  
3. LEAP_bedpostx.sh  	
4. LEAP_probtrackX_wrapper.sh (calls LEAP_probtrackX.sh)  
5. matrix_wrangling.Rmd  
	requires lots of memory
	will PCA the probtrackX data and write out data for flica

