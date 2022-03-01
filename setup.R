# PROJECT SETUP
# opioid overdose from hospital discharge data 
# rené dario herrera 
# rherrera at coconino dot az dot gov 
# coconino county az
# 27 December 2021 
# Project setup

# install packages 
install.packages("here")
install.packages("tidyverse")
install.packages("janitor")
install.packages("styler")
install.packages("knitr")
install.packages("tidycensus")
install.packages("httr")
install.packages("jsonlite")
install.packages("keyring")
install.packages("devtools")
devtools::install_github("cdcgov/Rnssp")

# load packages 
library(here)

# create directories: scripts, data, 
dir.create("scripts")
dir.create("data")
dir.create("data/raw")
dir.create("data/tidy")
dir.create("data_viz")
dir.create("reports")

# create files 
file.create("README.md")
file.create("scripts/import.R")
file.create("scripts/tidy.R")
