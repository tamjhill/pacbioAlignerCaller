# pacbioAlignerCaller
Run's PacBio's HiFi-human-WGS-WDL pipeline on Myriad using Cromwell and singularity - currently just for un-aligned singleton BAM files.

1) Obtain PacBio's pipeline from github:

  '''
  wget https://github.com/PacificBiosciences/HiFi-human-WGS-WDL/releases/download/v2.1.0/hifi-human-wgs-singleton.zip
  unzip hifi-human-wgs-singleton.zip -d hifi-human-wgs-singleton
  '''

2) Retrieve Cromwell from the Broad Institute:

  '''
  wget https://github.com/broadinstitute/cromwell/releases/download/87/cromwell-87.jar
  '''

3) Optional test to check Cromwell working with singularity:
[add test info here…]


4) Download the reference bundle from Zenodo which contains all the static input files to support alignment, variant calling, filtering, and annotation:

  '''
  wget https://zenodo.org/records/14027047/files/hifi-wdl-resources-v2.0.0.tar?download=1
  
  tar -xf hifi-wdl-resources-v2.0.0.tar
  '''
  
  All of the <prefix> strings must be updated with local prefixes for both of the tsv index files - note that some lines list multiple paths [could automate this in future but not too many lines to just change manually for now]

  5)	Copy backend HPC input json file with the following (update options and local paths to the reference files retrieved from the bundle in step 3, and to the unaligned bam files:
     (see the README for explanations of each [add these here]
    	– GPU cannot be used directly on HPC config settings but will assess if this can be changed now that local config are used instead)
[copy the unaligned bam file to local directory for now – will establish whether can access directly through a mount in the near future]
[double check if the backend here is ok to remain as HPC even though using via local]

6) copy across the Cromwell config file <  > update local settings and ensure that Cromwell uses singularity rather than Docker – found in the file  /home/skgtth3/longreads/singularity_only_backend.conf

7) 7)	Copy job submission file with job attributes to run on Myriad using 1 node, 36 cores (max available on one node) and 10G per core. Loads Java which is needed to run Cromwell (needs to be version 11+ for this Cromwell version) and singularity env. The run relies on a direct internet connection as it downloads images (if this is an issue, can otherwise store images locally first)
Hourse taken?
Run with qsub …

details about the outputs, the location and whats included.
Outputs in a directory with the format ../cromwell_output/cromwell-executions/humanwgs_singleton/dfe06e52-26ff-4ddd-944a-775ac6b8cae3

