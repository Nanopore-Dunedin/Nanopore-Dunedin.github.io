library(readr)
library(dplyr)
library(ggplot2)
library(magrittr)

require(hexbin)

options(bitmapType="cairo")

# Import the dataframe from each bam file
error_dir = "/path/to/vagrant"
error_files <- paste(error_dir, list.files(error_dir, pattern="*.error.tsv$"),
                     sep="/")

# Initialise a list of dataframes
error_dfs <- vector(mode="list", length=length(error_files))

# Use readr to import each csv file
for (i in 1:length(error_files)){
  error_dfs[[i]] <- readr::read_delim(error_files[i], delim="\t", col_names=TRUE)
}

# Concatenate the summary dataframes
error_df <- dplyr::bind_rows(error_dfs, .id="df")

# The start_time is stored in seconds since the start of sequencing
# Create a function to convert the seconds to HH:MM
seconds_to_period <- function(seconds){
  lubridate::seconds_to_period(seconds)
}

# Create a histogram of the alignment lengths
error_df %>% 
  dplyr::select(AlignmentLength) %>%
  ggplot(aes(x=AlignmentLength, weights=AlignmentLength)) +
    geom_hist() + 
    ggtitle("Alignment Length Histogram") +
    xlab("Alignment Length") +
    theme(plot.title = element_text(hjust = 0.5),
          axis.text.y=element_blank())

ggsave("hist_plot.sample_name.png")

# Create a 2d plot of the error rate against the alignment length.
error_df %>%
  dplyr::select(EditDistance, AlignmentLength) %>%
  ggplot(aes(x=AlignmentLength, y=AlignmentRate)) +
    geom_hex() +
    ggtitle("Rate by Length - Alignment") +
    xlab("Alignment Lengths") + 
    ylab("Error rate!")

# Import the supp data
supp_dir = "/path/to/vagrant"
supp_files <- paste(supp_dir, list.files(supp_dir, pattern="*.error.tsv$"),
                     sep="/")
supp_dfs = vector(mode="list", length=length(supp_files))

# Use readr to import each csv file
for (i in 1:length(error_files)){
  supp_dfs[[i]] <- readr::read_delim(supp_files[i], delim="\t", col_names=TRUE)
}

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


# Concatenate the summary dataframes
supp_df <- dplyr::bind_rows(supp_dfs, .id="df")

supp_df <- supp_df %>%
  dplyr::mutate(concord=is_concordant)

# Count the number of concordant alignments vs the number of discordant alignments.
df <- df %>%
  dplyr::summarise(concord)

# There are many more discordant alignments. Why is this so?


# Plot the supplementary vs primary across the genome.

