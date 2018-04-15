#!/bin/bash

# USAGE
run_basecaller <input_tar> <output_folder

# Get arguments
INPUT_TAR=$1 # First command line argument
OUTPUT_DIR=$2 # Second command line argument

SUBFOLDER_NAME=$(basename ${INPUT_TAR%.tar.gz})

# Create a /tmp directory where we will extract our tar ball to.
TMP_EXT=`mktemp -d /tmp/fast5.XXXXX`

# Create a /tmp directory where albacore will write to.
TMP_SAVE=`mktemp -d /tmp/albacore.XXXXX`

# Extract the tarballs.
tar -xf ${INPUT_TAR} -C ${TMP_EXT}

# Set the read fast5 basecall parameters
read_fast5_basecaller.py --input ${TMP_EXT}/${SUBFOLDER_NAME} ...

# Run the read fast5 basecaller on the tmp data.
# Identify fastq data and the summary logs from tmp.
mkdir -p ${OUTPUT_DIR}/pass
mkdir -p ${OUTPUT_DIR}/fail

# Concatenate the fastq files from the workspace and pipe into gzip.
cat ${TMP_SAVE}/workspace/pass/*.fastq | gzip > ${OUTPUT_DIR}/pass/${SUBFOLDER_NAME}.fastq.gz
cat ${TMP_SAVE}/workspace/fail/*.fastq | gzip > ${OUTPUT_DIR}/fail/${SUBFOLDER_NAME}.fastq.gz

# Move the summary logs to a new folder
mkdir -p ${OUTPUT_DIR}/log/summaries
mkdir -p ${OUTPUT_DIR}/log/pipelines

# Move albacore log file to log directory.
mv ${TMP_SAVE}/pipeline.log ${OUTPUT_DIR}/log/pipelines/${SUBFOLDER_NAME}.pipeline.log
mv ${TMP_SAVE}/sequencing_summary.txt ${OUTPUT_DIR}/log/summaries/${SUBFOLDER_NAME}.sequencing_summary.txt

# Remove the /tmp directories
rm -rf ${TMP_EXT} ${TMP_SAVE}