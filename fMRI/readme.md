__congrads_master__ was downloaded from https://github.com/koenhaak/congrads  
  
Order of use:  
1. __congrads_submit.sh__ - a wrapper for smooth_congrads to submit to the queue  
	__smooth_congrads.sh__ - for individual sub smooths RS data & runs congrads  

2. __split_grads.sh__ - splits cmaps into into n separate maps. Also has a chunk to generate ref gradients to compare with (commented out)  

3. __grad_check_order.sh__ - flips grads and finds closest match to ref (i.e. grad1, grad1flipped, grad2, grad2flipped vs G1_ref). renames the one with the highest correlation  

4. __merge_grads.sh__ - concatenates grads per sub into one file for input to flica (per ROI/per grad)  

The above is for HCP data. Scripts prefaced with LEAP_ are the LEAP data versions


