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
      porechop -v0 -i ${INPUT_FASTQ} 2> ${LOG_DIR}/${SUBFOLDER_NAME}.porechop.log
      } | {
      # Write the minimap2 command
      minimap2 -ax map-ont ${MINIMAP_INDEX} - 2> ${LOG_DIR}/${SUBFOLDER_NAME}.minimap2.log 
      } | {
      # Convert the output from SAM to bam
      samtools view -b -
      } | {
      # Add in the md tag into the bam file
      samtools calmd - ${REFERENCE_PATH}
      } | {
      # Sort the bam file
      samtools sort -o ${OUTPUT_BAM_PATH} -
      })
      
# Generate an index for the bam file
OUTPUT_BAM_INDEX=${OUTPUT_BAM_PATH%.bam}.bai
samtools index ${OUTPUT_BAM_PATH} ${OUTPUT_BAM_INDEX}