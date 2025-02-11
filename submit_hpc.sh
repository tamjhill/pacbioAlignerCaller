#!/bin/bash -l
# Batch script to run an OpenMP threaded job under SGE.
#$ -l h_rt=7:0:0
#$ -l mem=8G
#$ -l tmpfs=35G
#$ -N PacBioTrial
#$ -pe smp 36
# Set the working directory to somewhere in your scratch space.
# Replace "<your_UCL_id>" with your UCL user ID
#$ -wd /home/skgtth3/Scratch/cromwell_output

echo "Loading modules..."
source /etc/profile.d/modules.sh
module load singularity-env/1.0.0
module load java/temurin-11/11.0.14.1_1

BACKEND_CONFIG="/home/skgtth3/longreads/singularity_only_backend.conf"
CROMWELL_PATH="/home/skgtth3/longreads/pacbio_WGS_pipeline_singleton/cromwell-87.jar"
SING_WORKFLOW_PATH="/home/skgtth3/longreads/pacbio_WGS_pipeline_singleton/hifi-human-wgs-singleton/singleton.wdl"
INPUTS_FILE="/home/skgtth3/longreads/pacbio_WGS_pipeline_singleton/hifi-human-wgs-singleton/singleton.hpc.inputs.json"

java -Dconfig.file=$BACKEND_CONFIG -jar $CROMWELL_PATH run $SING_WORKFLOW_PATH  -i $INPUTS_FILE