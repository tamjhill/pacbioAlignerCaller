This is the version starting from aligned bams - in the ppbm2 workflow it checks for alignment, and if found to already be aligned will skip that process and just remove any tags.
Copy across the whole 'hifi-human-wgs-singleton' directory and name the new directory 'hifi-human-wgs-singleton_alignedBAM'. 
Replace the current pcmm2.wdl file the one stored in this directory (keep all files names the same). 

Run with hcp_aligned_submit.sh
(Keep the same config and cromwell.jar paths. Change the input.json as needed) 
