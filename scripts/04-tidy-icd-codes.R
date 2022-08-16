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

# ICD codes 
# unintentional drug poisoning 
icd_drug_poisoning_unintentional <- c(
  "x40",
  "x41",
  "x42",
  "x43",
  "x44"
)

# suicide drug poisoning 
icd_drug_poisoning_suicide <- c(
  "x60",
  "x61",
  "x62",
  "x63",
  "x64"
)

# homicide drug poisoning
icd_drug_poisoning_homicide <- c(
  "x85"
)

# undetermined intent 
icd_drug_poisoning_undetermined <- c(
  "y10",
  "y11",
  "y12",
  "y13",
  "y14"
)

# opioids 
icd_opioids <- c(
  "t40.0",
  "t40.1", # heroin
  "t40.2", # natural / semi-synthetic
  "t40.3", # methadone 
  "t40.4", # synthetic 
  "t40.6" 
)

icd_10_codes <- c(
  icd_drug_poisoning_unintentional,
  icd_drug_poisoning_suicide,
  icd_drug_poisoning_homicide,
  icd_drug_poisoning_undetermined,
  icd_opioids
)

# write ICD code data to pin board ####
substance_abuse %>%
  pin_write(
    x = icd_10_codes,
    type = "rds",
    title = "ICD-10 codes for death by drug poisoning",
    description = "ICD-10 codes for death by drug poisoning."
  )
