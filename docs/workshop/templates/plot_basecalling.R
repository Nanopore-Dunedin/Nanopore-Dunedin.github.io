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

# Generate a list of dataframes

# Use readr to import the csv file in a forloop

# Concatenate the summary logs.

# The start_time is stored in seconds since the start of sequencing
# Create a function to convert the seconds to HH:MM
seconds_to_period <- function(seconds){
  # Use lubridate
}

# Generate a yield plot
summary_dfs %>% 
  # Select appropriate columns
  # Arrange by start time
  # Generate cumulative sum
  # Pipe into ggplot

# Save file  
ggsave("yield_plot.sample_name.png")


# Generate a yield plot by pass/fail
# Same as before but groupby run

# Save file
ggsave("yield_plot_by_quality.sample_name.png")

# Generate a histogram
# Remember to use the weights parameter
ggsave("hist_by_quality.sample_name.png")


# Create a 2D histogram
# geom_hex is useful here.
ggsave("histogram_2d.sample_name.png")
