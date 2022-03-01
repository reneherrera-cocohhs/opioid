# Mortality Extract 

# load packages
library(here)
library(tidyverse)
library(lubridate)
library(haven)
library(janitor)

# read data
# year to date 
deaths_ytd <- read_sas(data = "S:/HIPAA Compliance/SAS Files/Coconino Deaths/All Death/coconino2021ytddeaths.sas7bdat") %>%
  clean_names()

glimpse(deaths_ytd)

deaths_ytd %>%
  select(contains("death")) %>%
  glimpse()

# from 
# Moore , BJ, and ML Barrett. “Case Study: Exploring How Opioid-Related Diagnosis Codes Translate From ICD-9-CM to ICD-10-CM.” U.S. Agency for Healthcare Research and Quality, April 24, 2017. https://www.hcup-us.ahrq.gov/datainnovations/icd10_resources.jsp.
icd_10_cm <- c("F112",
               "F119",
               "T400",
               "T401",
               "T402",
               "T403",
               "T404",
               "T406") %>%
  paste(collapse = "|")

# icd-10 codes ####
(var_icd <- deaths_ytd %>%
  select(contains("record_axis")) %>%
  names())

var_icd <- c("acme_underlying_cause",
             var_icd
     )

# select variables 
var_of_interest <- c(
  "date_of_death",
  "decedent_dob",
  "death_book_year",
  "decedent_years",
  "death_county_name",
  "residence_county_name",
  "death_city_name",
  "residence_city_name",
  "residence_zip",
  "birth_country",
  "race_vsims",
  "race_desc",
  "race_phs",
  "hispanic_desc",
  "cdc_mannerofdeath_desc",
  "cod_a",
  "cod_b",
  "cod_c",
  "cod_d",
  "decedent_gender_desc",
  "military_service",
  "funeral_home",
  "education_desc",
  "occupation_description",
  "industry_description",
  "years_in_arizona",
  "marital_desc",
  "death_status_desc",
  "death_place_type_other",
  "resident_address_system_code_de1",
  "birth_country",
  "birth_country2",
  "death_certificate_number",
  var_icd
)

mortality_data <- deaths_ytd %>%
  select(all_of(var_of_interest))

# calculate age for age group
# convert to date
mortality_data$decedent_dob <- ymd(mortality_data$decedent_dob)
mortality_data$date_of_death <- ymd(mortality_data$date_of_death)

# save calculated variable to data
mortality_data <- mortality_data %>%
  mutate(age_calc = time_length(x = difftime(mortality_data$date_of_death, mortality_data$decedent_dob), unit = "years"))

# extract month of death to plot on a time series 
mortality_data <- mortality_data %>%
  mutate(date_of_death_month = month(date_of_death),
         date_of_death_year = year(date_of_death))

# add a new variable to show if the decedent is a coconino county resident
mortality_data <- mortality_data %>%
  mutate(county_resident = if_else(str_detect(
    mortality_data$residence_county_name, "Coconino"
  ), "yes", "no"))

# filter to find opioid overdose 
opioid_related_death <- mortality_data %>%
  filter(if_any(all_of(var_icd), ~str_detect(.x, icd_10_cm)))

