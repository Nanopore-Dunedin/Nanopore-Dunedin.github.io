#!/bin/bash

# USAGE
run_basecaller <input_tar> <output_folder

# Get arguments
INPUT_TAR=$1 # First command line argument
OUTPUT_DIR=$2 # Second command line argument

SUBFOLDER_NAME=$(basename ${INPUT_TAR%.tar.gz})

# Create a /tmp directory where we will extract our tar ball to.
"Use the mktemp with the -d parameter to create a tmp directory."
"Save this as the variable TMP_EXT"

# Create a /tmp directory where albacore will write to.
"Use the mktemp with the -d parameter to create a tmp directory."
"Save this as the variable TMP_SAVE"

# Extract the tarballs into TMP_EXT.
"Use the tar -xf with the -C parameter to state where you would like to write the files to."

# Set the read fast5 basecall parameters
"Use the read_fast5_basecaller.py command with the required options"
"The run information can be found in the readme file"
"Use the --help parameter for guidance"

# Run the read fast5 basecaller on the tmp data.
# Identify fastq data and the summary logs from tmp.
"Create a pass folder and a fail folder under the OUTPUT_DIR using mkdir -p"

# Concatenate the fastq files from the workspace and pipe into gzip.
"The pass fastq files are in TMP_SAVE/workspace/pass"
"Use the cat command to pipe the fastq as stdout into gzip ."
"which can be written into each of the folders stated above with the .fastq.gz suffix"

# Create the summary logs and pipeline directories
"Use mkdir -p to create OUTPUT_DIR/log/summaries  and OUTPUT_DIR/log/pipelines"

# Move albacore log files to log directories
"Use the mv command to move TMP_SAVE/pipeline.log and TMP_SAVE/sequencing_summary.txt"
"To the directories we've just created"

# Remove the /tmp directories
"Use rm -rf to clear up the /tmp folder for more albacore jobs"
