#!/usr/bin/env python

import pandas as pd
from Bio import SeqIO
import pysam
import sys

"""
Usage: extract_supplementary_info bam_file output_prefix
"""

# Get input arguments
bam_path = sys.argv[1]
output_prefix = sys.argv[2]

def extract_alignment_error_metrics_from_bam(bam):
    """
    loop over a bam file and get the edit distance to the reference genome
    stored in the NM tag
    scale by aligned read length
    """
    bam_h = pysam.AlignmentFile(bam, "rb")
    return [(read.get_tag("NM"), read.query_alignment_length)
            for read in bam_h.fetch()
            if read.get_tag("tp") == "P"]


def get_alignment_error_metrics_as_data_frame(bam_file):
    """
    Uses the bam_file as input.
    Returns a pandas dataframe of edit distance and alignment length
    """
    metrics = pd.DataFrame(extract_alignment_error_metrics_from_bam(bam_file),
                           columns=["EditDistance", "AlignmentLength"])
    metrics['AlignmentRate'] = metrics.apply(lambda x: 1 - x.EditDistance/x.AlignmentLength, axis='columns')
    return metrics


def get_supplementary_alignment_details(supp, primary):
    """
    Uses the supplementary alignment and primary alignment
    to generate a dataframe to determine concordancy within the alignments.
    Returns a pandas series with the columns as stated below
    """
    columns = ["QueryName",
               "P_ReferenceStart", "P_ReferenceEnd", "P_IsReverse",
               "P_AlignmentLength", "P_AlignmentStart",
               "P_AlignmentEnd", "P_MappingQuality",
               "S_ReferenceStart", "S_ReferenceEnd", "S_IsReverse",
               "S_AlignmentLength", "S_AlignmentStart",
               "S_AlignmentEnd", "S_Mapping Quality"]
    return pd.Series([supp.query_name,
                      primary.reference_start, primary.reference_end, primary.is_reverse,
                      primary.query_alignment_length, primary.query_alignment_start,
                      primary.query_alignment_end, primary.mapping_quality,
                      supp.reference_start, supp.reference_end, supp.is_reverse,
                      supp.query_alignment_length, supp.query_alignment_start,
                      supp.query_alignment_end, supp.mapping_quality],
                     index=columns)


def get_corresponding_primary_alignment(query_name, bam_file):
    """
    Given a query name and a bam file,
    extract the primary alignment in the bam file
    """
    for primary in pysam.AlignmentFile(bam_file, 'rb').fetch():
        if primary.query_name == query_name and not \
                primary.is_supplementary and not primary.is_secondary:
            return primary
    # Could not find the corresponding primary.
    return None


def get_supplementary_alignments_as_data_frame(bam_file):
    """
    For a given bam file return a dataframe of supplementary alignments
    """
    return pd.concat([get_supplementary_alignment_details(supplementary,
                      get_corresponding_primary_alignment(supplementary.query_name, bam_file))
                      for supplementary in pysam.AlignmentFile(bam_file, 'rb').fetch()],
                     axis='columns').transpose()

# Use the get_alignment error metrics function to export the error metrics.
error_df = get_alignment_error_metrics_as_data_frame(bam_path)
error_path = output_prefix + ".error.tsv"
error_df.to_csv(error_path, index=False, header=True, sep="\t")

# Use the get_supplementary_alignments_as_dataframe to export the supp
# metrics to a tsv file
alignments_df = get_supplementary_alignment_details(bam_path)
alignments_path = output_prefix + ".supp.tsv"
alignments_path.to_csv(alignments_path, index=False, header=True, sep="\t")


