# Setup ####
# packages
library(here)
library(tidyverse)
library(lubridate)
library(pins)

# read pin board 
substance_abuse <- board_folder("")

# list the pins located on the pin board ####
substance_abuse %>%
  pin_list()

# list the pins located on the pin board ####
substance_abuse %>%
  pin_meta("azdhs_mortality_extract")

# read from pin board 
mortality_data <- substance_abuse %>%
  pin_read("azdhs_mortality_extract")

# inspect 
glimpse(mortality_data)

# rename for pin board 
azdhs_mortality_extract <- mortality_data

substance_abuse <- board_folder("")

# write mortality data to pin board ####
substance_abuse %>%
  pin_write(
    x = azdhs_mortality_extract,
    type = "rds",
    title = "AZDHS Mortality Extract, tidy and transformed",
    description = "The tidy and transformed version of the original AZDHS mortality extract."
  )
