library(readr)
library(dplyr)
library(ggplot2)

# Import the dataframe from each bam file
readr::read_delim(bam_tsv, sep="\t")

# Merge each dataframe into a single object.


# Create a histogram of the alignment lengths


# Create a 2d plot of the error rate against the alignment length.


# Create a 2d plot of the error rate against the average quality score.


# Create a function to determine if an alignment is discordant or concordant
is_concordant <- function(X){
  # x is a row of the bam dataframe
  if (x.P_isReverse == x.S_isReverse){
    return("Concordant")
  }
  else{
    return("Discordant")
  }
}

df <- df %>%
  dplyr::mutate(concord=is_concordant)

# Count the number of concordant alignments vs the number of discordant alignments.
df <- df %>%
  dplyr::summarise(concord)


# There are many more discordant alignments. Why is this so?


# Plot the supplementary vs primary across the genome.
