#!/usr/bin/env RScript

# Ensure that the following packages are installed
require(dplyr)
require(tibble)
require(ggplot2)
require(gridExtra)
require(readr)
library(magrittr)
library(ggplot2)
require(hexbin)

options(bitmapType="cairo")

# Use readr to import the csv file
table <- readr::read_delim("../Vagrant/nanopore_xenial/2681_sequencing_run_64063.sequencing_summary.txt",
                           delim="\t")

# Concatenate the summary logs.

# The start_time is stored in seconds since the start of sequencing
# Create a function to convert the seconds to HH:MM
seconds_to_period <- function(seconds){
  lubridate::seconds_to_period(seconds)
}

# Generate a yield plot
table %>% 
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
table %>%
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

# Generate a histogram
table %>%
  dplyr::select(sequence_length_template) %>%
  ggplot(aes(x=sequence_length_template, weights=sequence_length_template)) +
  geom_histogram() +
  ggtitle("Histogram of read length") + 
  xlab("Sequence length") +
  ylab("") + 
  theme(plot.title = element_text(hjust = 0.5),
        axis.text.y=element_blank())
ggsave("hist_by_quality.sample_name.png")


# Create a 2D histogram
table %>%
  dplyr::select(sequence_length_template, mean_qscore_template) %>%
  ggplot(aes(x=sequence_length_template, y=mean_qscore_template)) +
    geom_hex() +
    xlab("Sequence Length") +
    ylab("Quality Value") +
    ggtitle("Quality Score by Sequencing Length") +
    theme(plot.title = element_text(hjust=0.5))
ggsave("histogram_2d.sample_name.png")
