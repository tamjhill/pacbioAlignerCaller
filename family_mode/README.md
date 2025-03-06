# pacbioAlignerCaller - Family mode
For running PacBio's HiFi-human-WGS-WDL pipeline on trios.

1) 	Obtain PacBio's family pipeline from github:

  ```
  wget https://github.com/PacificBiosciences/HiFi-human-WGS-WDL/releases/download/v2.1.1/hifi-human-wgs-family.zip
  unzip hifi-human-wgs-singleton.zip -d hifi-human-wgs-family
  ```

This pipeline will rely on the **cromwell jar, resource bundle and HPC backend config file**, which were all downloaded/created for the singleton run and **do not need amending**.
  
2) Copy the family HPC input json file saved within this directory, update each field with the specific samples info and local paths to the reference files. The format is as shown below:

```
  {
    "humanwgs_family.family": {
      "family_id": "",
      "samples": [
        {
          "sample_id": "",
          "hifi_reads": [
            "<file>"
          ],
          "affected": true,
          "sex": "null",
          "father_id": "<to match below>",
          "mother_id": "<to match below>"
        },
        {
          "sample_id": "",
          "hifi_reads": [
            "<file>"
          ],
          "affected": false,
          "sex": "MALE"
        },
        {
          "sample_id": "",
          "hifi_reads": [
            "<file>"
          ],
          "affected": false,
          "sex": "FEMALE"
        }
      ]
    },
    "humanwgs_family.ref_map_file": "path/to/ref/file/GRCh38.ref_map.v2p0p0.template.tsv",
    "humanwgs_family.tertiary_map_file": "path/to/ref/file/GRCh38.ref_map.v2p0p0.template.tsv/GRCh38.tertiary_map.v2p0p0.template.tsv",
    "humanwgs_family.backend": "HPC",
    "humanwgs_family.gpu": false,
    "humanwgs_family.preemptible": true
  }

```
[nb, can also add a comma-delimited list of HPO terms using 'humanwgs_family.phenotypes']

3)	Use same format of job submission file as with singletons but allow for more memory and time. 

Change the paths to local paths:

```
BACKEND_CONFIG="/path/to/singularity_only_backend.conf"
CROMWELL_PATH="/path/to/cromwell-87.jar"
SING_WORKFLOW_PATH="/path/to/pacbio_WGS_pipeline_family/hifi-human-wgs-family/family.wdl"		#this is in pacbio's family workflow folder 
INPUTS_FILE="/path/to/family.hpc.inputs.json"
```

Run with 
```
qsub submit_hpc.sh
```

