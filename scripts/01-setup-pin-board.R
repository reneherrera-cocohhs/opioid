# Setup ####
# load packages
library(here) # project oriented workflow
library(pins) # data access

# Pins ####
# The pins package helps you publish data sets, models, and other R objects, making it easy to share them across projects and with your colleagues.
# create a pin board ####
# here for now, need to consider where the best place for this should really be
substance_abuse <- board_folder("")

# list the pins located on the pin board ####
substance_abuse %>%
  pin_list()

