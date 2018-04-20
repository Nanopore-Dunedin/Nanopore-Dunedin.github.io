#!/usr/bin/env bash

# Usage
alignment.sh <input_fastq> <reference_genome> <output_bam> <minimap2_index> <log_dir>

# Read in arguments
INPUT_FASTQ_PATH=$1
REFERENCE_PATH=$2
OUTPUT_BAM_PATH=$3
MINIMAP_INDEX=$4
LOG_DIR=$5

# Get folder names from path name
SUBFOLDER_NAME=$(basename ${INPUT_FASTQ_PATH%.fastq.gz})

# Running minimap2
eval $({
      # Trim the reads with porechop
      "porechop command" 2> ${LOG_DIR}/${SUBFOLDER_NAME}.porechop.log
      } | {
      # Run  the minimap2 command
      "minimap2 command"- 2> ${LOG_DIR}/${SUBFOLDER_NAME}.minimap2.log
      } | {
      # Convert the output from SAM to bam
      "Use samtools view to convert sam into bam"
      } | {
      # Add in the md tag into the bam file
      "use samtools calmd to add in the  md tag into the bam file"
      } | {
      # Sort the bam file
      "sort the bam file, because this is samtools 1 not samtools 0"
      "specify the output bam file using the -o option"
      })

# Generate an index for the bam file
OUTPUT_BAM_INDEX=${OUTPUT_BAM_PATH%.bam}.bai
"use the samtools index command to generate the index"
