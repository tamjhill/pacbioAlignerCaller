# pacbioAlignerCaller
Runs PacBio's HiFi-human-WGS-WDL pipeline on Myriad using Cromwell and singularity - currently just for un-aligned singleton BAM files.

1) 	Obtain PacBio's pipeline from github:

  ```
  wget https://github.com/PacificBiosciences/HiFi-human-WGS-WDL/releases/download/v2.1.0/hifi-human-wgs-singleton.zip
  unzip hifi-human-wgs-singleton.zip -d hifi-human-wgs-singleton
  ```

2) 	Retrieve Cromwell from the Broad Institute:

  ```
  wget https://github.com/broadinstitute/cromwell/releases/download/87/cromwell-87.jar
  ```

3) 	Optional - can test Cromwell's use of singularity on small test run first (see section at the end of this page).


4) 	Download the reference bundle from Zenodo which contains all the static input files to support alignment, variant calling, filtering, and annotation:

  ```
  wget https://zenodo.org/records/14027047/files/hifi-wdl-resources-v2.0.0.tar?download=1
  
  tar -xf hifi-wdl-resources-v2.0.0.tar
  ```
  
  All of the <prefix> strings must be updated with local prefixes for both of the tsv index files - note that some lines list multiple paths [could automate this in future but not too many lines to just change manually for now]

  (Alternatively - keep the paths to my reference files and I'll change the permissions.)

  5)	Copy backend HPC input json file and update each field with the specific sample(s) info and local paths to the reference files retrieved from the bundle in step 3:

```
{
  "humanwgs_singleton.sample_id": "String",   											#unique ID for the sample
  "humanwgs_singleton.sex": "String? (optional, ['MALE', 'FEMALE', null])",  			#used for genotypng
  "humanwgs_singleton.hifi_reads": [
    "/rdss/rd01/ritd-ag-project-rd01is-rdspi25/LongReads/path/to/bam/file.bam"  ],    	#Array of paths to HiFi reads in unaligned BAM format.
  "humanwgs_singleton.phenotypes": "String? (optional)", 								#csv list of HPO terms, if omitted, tertiary analysis skipped.
  "humanwgs_singleton.ref_map_file": "/path/to/reference/file/hifi-wdl-resources-v2.0.0/GRCh38.ref_map.v2p0p0.template.tsv",   		#tsv containing ref genome file paths
  "humanwgs_singleton.tertiary_map_file": "/path/to/reference/file/hifi-wdl-resources-v2.0.0/GRCh38.tertiary_map.v2p0p0.template.tsv", #tsv containing tertiary analysis file paths and thresholds (if omitted, tertiary analysis is skipped);
  "humanwgs_singleton.backend": "HPC",													#leave as HPC
}
```

6)	Copy across the Cromwell config file singularity_only_backend.conf, this updates local settings and ensures that Cromwell uses singularity rather than Docker to retrieve images

7)	Copy job submission file with job attributes to run on Myriad using 1 node, 36 cores (max available on one node) and 10G per core. Loads Java which is needed to run Cromwell (needs to be version 11+ for this Cromwell version) and singularity env. 

Change the paths to local paths:

```
BACKEND_CONFIG="/path/to/singularity_only_backend.conf"
CROMWELL_PATH="/path/to/cromwell-87.jar"
SING_WORKFLOW_PATH="/path/to/pacbio_WGS_pipeline_singleton/hifi-human-wgs-singleton/singleton.wdl"		#this is in pacbio's singlton workflow folder 
INPUTS_FILE="/path/to/singleton.hpc.inputs.json"
```

[If issue with connections and retrieving the singularity images, can all be stored locally first... can add this step if needed in future]

Run with 
```
qsub submit_hpc.sh
```


#Outputs:
Outputs are given in a directory with the format ../cromwell_output/cromwell-executions/humanwgs_singleton/<workflow-id> . Outputs include:

Consolidate stats:
	- overall stats (txt file)

Upstream (intermediate files):
	- merged bam stats:
		- read length and quality stats
	- mos depth stats
	- alignment outputs
		- aligned bam file
	- paraphase outputs
	- hifi cnv outputs
	- hifi sv sig outputs
	- structural variant prep vcfs
	- call coverage dropouts (txt file)
	- deep variant outputs
	- target stats (genotyped count, uncalled count)
	- ped phrank scores (likely only for family mode)

Downstream:
	- structural variant stats:
		- breakend count
		- deletion count (txt file)
		- duplication count (txt file)
		- insertion count (txt file)
		- invertion count (txt file)
	- roh & small variants:
		- small variants stats (txt file)
		- hethom ratio (txt file)
		- indel count (txt file)
		- indel dist graph (png)
		- snv count (txt file)
		- snv dist heatmap (png)
		- Runs of homozygosity (ROH) (bed file)
		- tstv ratio (txt file)
	- cpg pileup:
		- combined hap1 count (txt file)
		- combined hap2 count (txt file)
		- combined overall count (txt file)
		- bed and bw files for each of these
	- hi-phase (haplotype phasing):
		- mapped % (txt file)
		- mapped read count (txt file)
		- mapping stats (txt file)
		- phased basepairs (txt file)
		- phase block (txt file)
		- mg (molecular group) distribution (png)
		- MAPQ distribution (png)
		- hi-phase blocks and haplotags (tsv files)
		- trgt sorted phased vcf
		- vcf files of phased structural variants and small variants
		- haplotagged bam file
	- pbstarphase diplotype
	- pharmacat
		- both relating to pharmcat data inc. mos depth regions, 
			targeted regions for pharmacogenes and vcf files 
			of phased variants for pharmacogenes 

Teriary analysis:
	- slivar small variant analysis:
		- phased norm bcf
		- phased compound hets (tsv and vcf)
		- phased slivar (tsv and vcf) - annotated
	- slivar sv
		- phased sv list (tsv) - annotated
	- slivar sv filtered annotated
		- phased slivar sv (vcf file)


## Testing Cromwell working with singularity:
[add test info here…]

