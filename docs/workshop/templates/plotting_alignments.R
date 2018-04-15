library(readr)
library(dplyr)
library(ggplot2)

# Import the dataframe from each bam file
** These need to be .error.tsv
** Import the .supp.tsv laters, run a cbind.
bam_dir <- "/path/to/bam_dir"
bam_paths <- paste(bam_dir, list.files(bam_dir, pattern="*.tsv$"),
                  sep="/")

bam_dfs <- vector(mode="list", length=length(bam_paths))
for (i in  1:length(bam_paths)){
  bam_dfs[[i]] <- readr::read_delim(bam_dfs[i], delim="\t", col_names=TRUE)
}

# Merge each dataframe into a single object.
bam_df <- dplyr::bind_rows(bam_dfs, .id="df")

# Create a histogram of the alignment lengths
bam_df %>%
  dplyr::select(P_AlignmentLength)
  ggplot(aes(x=P_AlignmentLength)) +
    geom_histogram() +
    ggtitle("Histogram of alignment lengths") + 
    xlab("Alignment length") +
    ylab("") + 
    theme(plot.title = element_text(hjust = 0.5),
          axis.text.y=element_blank())
  ggsave("hist.sample_name.png")

# Create a 2d plot of the error rate against the alignment length.
bam_df %>%
  dplyr::select(P_AlignmentLength, )

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
