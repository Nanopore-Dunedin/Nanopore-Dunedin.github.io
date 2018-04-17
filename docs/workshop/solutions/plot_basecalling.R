#!/usr/bin/env RScript

# Ensure that the following packages are installed
library(magrittr)
library(ggplot2)

require(dplyr)
require(tibble)
require(ggplot2)
require(gridExtra)
require(readr)
require(hexbin)

options(bitmapType="cairo")

# Assign the directory to summary test tiles
summary_dir = "/path/to/vagrant"

# Get the list of summary text files in th
summary_files <- paste(summary_dir, list.files(summary_dir, pattern="*.sequencing_summary.txt$"),
                       sep="/")

# Initialise a list of dataframes
summary_dfs <- vector(mode="list", length=length(summary_files))

# Use readr to import each csv file
for (i in 1:length(summary_files)){
  summary_dfs[[i]] <- readr::read_delim(summary_files[i], delim="\t", col_names=TRUE)
}

# Concatenate the summary dataframes
summary_df <- dplyr::bind_rows(summary_dfs, .id="df")

# The start_time is stored in seconds since the start of sequencing
# Create a function to convert the seconds to HH:MM
seconds_to_period <- function(seconds){
  lubridate::seconds_to_period(seconds)
}

# Generate a yield plot
summary_df %>% 
  dplyr::select(sequence_length_template, start_time) %>%
  dplyr::arrange(start_time) %>%
  dplyr::mutate(yield=cumsum(sequence_length_template)) %>% 
  ggplot2::ggplot(aes(y=yield, x=start_time)) +
  geom_line() +
  scale_x_continuous(labels=seconds_to_period) + 
  ggtitle("Yield over time") + 
  xlab("Start Time") +
  ylab("Yield (Base pairs)") +
  theme(plot.title = element_text(hjust = 0.5))
ggsave("yield_plot.sample_name.png")


# Generate a yield plot by pass/fail
summary_df %>%
  dplyr::select(sequence_length_template, start_time, passes_filtering) %>%
  dplyr::group_by(passes_filtering) %>%
  dplyr::arrange(start_time) %>%
  dplyr::mutate(yield=cumsum(sequence_length_template)) %>%
  ggplot2::ggplot(aes(y=yield, x=start_time, col=passes_filtering)) +
  geom_line() +
  scale_x_continuous(labels=seconds_to_period) + 
  ggtitle("Yield over time") + 
  xlab("Start Time") +
  ylab("Yield (Base pairs)") +
  theme(plot.title = element_text(hjust = 0.5))
ggsave("yield_plot_by_quality.sample_name.png")

# Generate a histogram of read-lengths
summary_df %>%
  dplyr::select(sequence_length_template) %>%
  ggplot(aes(x=sequence_length_template, weights=sequence_length_template)) +
  geom_histogram() +
  ggtitle("Histogram of read length") + 
  xlab("Sequence length") +
  ylab("") + 
  theme(plot.title = element_text(hjust = 0.5),
        axis.text.y=element_blank())
ggsave("read_length.hist.sample_name.png")

# Generate a histogram of read-lengths by pass/fail

# Create a 2D histogram
summary_df %>%
  dplyr::select(sequence_length_template, mean_qscore_template) %>%
  ggplot(aes(x=sequence_length_template, y=mean_qscore_template)) +
    geom_hex() +
    xlab("Sequence Length") +
    ylab("Quality Value") +
    ggtitle("Quality Score by Sequencing Length") +
    theme(plot.title = element_text(hjust=0.5))
ggsave("histogram_2d.sample_name.png")
