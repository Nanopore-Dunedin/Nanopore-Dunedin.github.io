#!/bin/bash

# Run 'nanoplot --help' for a list of all arguments

# Unfortunately our fastq files are split.
# We can use the '*' to select all fastq or use the find command
# in combination with  xargs

find /path/to/fastqs/ -type f -name '*.fastq.gz' | \
xargs -I{} Nanoplot \
[--fastq_rich_file || --fastq] {} \
--title "Title of plots" \
[Other options]