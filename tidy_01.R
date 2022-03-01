
library(tidyverse)
library(janitor)
library(lubridate)
library(knitr)

hdd_2020 <- read_csv(file = "S:/HIPAA Compliance/Hospital Discharge Data/HDD_Updated-05042021/2018_to_2020/coconino_2018_to_2020.csv",
                     col_types = cols(.default = "c")) %>%
  clean_names()

glimpse(hdd_2020)
str(hdd_2020)

hdd_2020 %>%
  distinct(hospital_npi) %>%
  arrange(hospital_npi)

# only hospitals in coconino county 
coco_hospitals <- read_rds("../coconino_county_medical_list.rds")

coco_hospitals_list <- coco_hospitals %>%
  filter(str_detect(subtype, "HOSPITAL"),
         county == "COCONINO") %>%
  select(facid, legalname)

# discharge date 
hdd_2020 <- hdd_2020 %>%
  mutate(discharge_date = ymd(discharge_date),
         discharge_year = year(discharge_date),
         discharge_month = month(discharge_date))

# show only hdd where az_fac_id matches facid 
hdd_coco <- inner_join(x = hdd_2020,
           y = coco_hospitals_list,
           by = c("az_fac_id" = "facid"))

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

# # from Jake's SAS code 
# # S:\HIPAA Compliance\SAS Files\Hojnacki-Data\Data-Requests\Opioids-Overdose\HOPE_analysis_hdd.sas
# c("Y90",
#   "T400",
#   "T401",
#   "T402",
#   "T")
# 
# opioid_icd10_codes <- str_to_upper(c(
#   "x40",
#   "x41",
#   "x42",
#   "x43",
#   "x44",
#   "x60",
#   "x61",
#   "x62",
#   "x63",
#   "x64",
#   "x85",
#   "y10",
#   "y11",
#   "y12",
#   "y13",
#   "y14",
#   "T400",
#   "T401",
#   "T402",
#   "T403",
#   "T404",
#   "F11"
# )) %>% paste(collapse = "|")
# 
# opioid_icd10_codes <- c(
#   "T400",
#   "T401",
#   "T402",
#   "T403",
#   "T404",
#   "T405",
#   "T406"
# ) %>%
#   paste(collapse = "|")
# 
# icd10_codes <- c(
#   "t40.0",
#   "t40.1"
# )

# # variables of interest 
# var_of_interest <- c("discharge_",)

var_of_interest <- hdd_2020 %>%
  select(contains("discharge_") | contains(c("diag")) & !contains("_poa")) %>%
  names()
# 
# sample_data <- hdd_2020 %>%
#   sample_n(size = 1000)

# hdd_2020 <- hdd_2020 %>%
#   filter(discharge_year == 2020) %>%
#   filter(str_detect(principal_diagnosis, icd_10_cm) |
#            str_detect(admitting_diagnosis, icd_10_cm) |
#            str_detect(diagnosis_2, icd_10_cm) |
#            str_detect(diagnosis_3, icd_10_cm) |
#            str_detect(diagnosis_4, icd_10_cm) |
#            str_detect(diagnosis_5, icd_10_cm) |
#            str_detect(diagnosis_6, icd_10_cm) |
#            str_detect(diagnosis_7, icd_10_cm) |
#            str_detect(diagnosis_8, icd_10_cm) |
#            str_detect(diagnosis_9, icd_10_cm) |
#            str_detect(diagnosis_10, icd_10_cm) |
#            str_detect(diagnosis_11, icd_10_cm) |
#            str_detect(diagnosis_12, icd_10_cm) |
#            str_detect(diagnosis_13, icd_10_cm) |
#            str_detect(diagnosis_14, icd_10_cm) |
#            str_detect(diagnosis_15, icd_10_cm) |
#            str_detect(diagnosis_16, icd_10_cm) |
#            str_detect(diagnosis_17, icd_10_cm) |
#            str_detect(diagnosis_18, icd_10_cm) |
#            str_detect(diagnosis_19, icd_10_cm) |
#            str_detect(diagnosis_20, icd_10_cm) |
#            str_detect(diagnosis_21, icd_10_cm) |
#            str_detect(diagnosis_22, icd_10_cm) |
#            str_detect(diagnosis_23, icd_10_cm) |
#            str_detect(diagnosis_24, icd_10_cm) |
#            str_detect(diagnosis_25, icd_10_cm)) %>%
#   select(contains(c("discharge_", "diag"))) %>%
#   arrange(principal_diagnosis, 
#           diagnosis_2, 
#           diagnosis_3)
#   
# total_opioid_hospitalizations <- hdd_2020 %>%
#   count() %>%
#   as.numeric()
# 
# table_caption <- str_c("Sourced from Coconino County Hospital Discharge Data for year 2020. Total opioid related hospitalizations = ",
#       total_opioid_hospitalizations,
#       sep = "")
# 
# hdd_2020 %>%
#   group_by(discharge_month) %>%
#   count() %>%
#   knitr::kable(col.names = c("Month", "Count"),
#                caption = table_caption)
# 
# output <- tibble()
# for(i in (var_dx)) {
#   output[[i]] <- sample_data %>%
#     filter(str_detect(i, icd_10_cm))
# }
# output
# 
# sample_data %>%
#   map_chr()
#   
# 
# hdd_2020_subset <- hdd_2020 %>%
#   filter(discharge_year == 2020) %>%
#   filter(str_detect(principal_diagnosis, icd_10_cm) |
#            ) %>%
#   select(contains(c("discharge_", "diag"))) %>%
#   arrange(principal_diagnosis, diagnosis_2)
# 
# glimpse(hdd_2020_subset)
# 
# filter(str_detect(hdd_2020$principal_diagnosis, opioid_icd10_codes))
# 
# 
# hdd_2020_subset <- hdd_2020 %>%
#   str_subset(hdd_2020$principal_diagnosis, opioid_icd10_codes)
# 
# hdd_2020 %>%
#   filter(grepl(opioid_icd10_codes, principal_diagnosis))
# 
# output <- 
#   for(i in opioid_icd10_codes) {
#     output <- hdd_2020 %>%
#       filter(str_detect(principal_diagnosis, i))
#   }
# output

# 
hdd_2020_opioid <- hdd_coco %>%
  filter(discharge_year == 2020) %>%
  filter(if_any(contains("diagnosis"), ~str_detect(.x, icd_10_cm))) %>%
  select(all_of(var_of_interest)) 

# 
glimpse(hdd_2020_opioid)
var_dx <- as_tibble(var_of_interest) %>%
  filter(str_detect(value, "diagnosis"))

as.list(var_dx)

v_admit_dx <- hdd_2020_opioid %>%
  filter(str_detect(admitting_diagnosis, icd_10_cm)) %>%
  distinct(admitting_diagnosis)  

v_principle_dx <- hdd_2020_opioid %>%
  filter(str_detect(principal_diagnosis, icd_10_cm)) %>%
  distinct(principal_diagnosis)  

v_dx_2 <- hdd_2020_opioid %>%
  filter(str_detect(diagnosis_2, icd_10_cm)) %>%
  distinct(diagnosis_2)  

list_function <- map(
  hdd_2020_opioid, .f = function(COL){
    tmp <- unique(COL)
    tmp[grepl(icd_10_cm, tmp)]
  }
)
reported_icd_10_codes <- unique(unlist(list_function))

tibble((reported_icd_10_codes)) %>%
  arrange(reported_icd_10_codes)

  function(x){
  
  z <- hdd_2020_opioid %>%
  filter(str_detect(x, icd_10_cm))
  z
}
  
count_icd_codes("admitting_diagnosis")

library(tidyverse)

# criteria to include in list
target <- c("f11", "t40") %>% # either/or
  paste(collapse = "|")

target

# data
my_data <- tribble(
  ~p_dx, ~dx_1, ~dx_2, ~dx_3,
  "f11", "t401", NA, NA,
  "f11", "t402", "f12", "t41",
  "f01", "t01", "f111", "t401",
  "f02", "t402", NA, NA,
  "t40", "f111", NA, NA
)

my_data

LIST <- map(my_data,.f=function(COL){
  tmp <- unique(COL)
  tmp[grepl(target,tmp)]
})

unique(unlist(LIST))
#> [1] "f11"  "t40"  "t401" "t402" "f111"

# if I want to see which target value is present one variable at a time
p_dx_list <- my_data %>%
  filter(str_detect(p_dx, target)) %>%
  distinct(p_dx)

p_dx_list

dx_1_list <- my_data %>%
  filter(str_detect(dx_1, target)) %>%
  distinct(dx_1)

dx_2_list <- my_data %>%
  filter(str_detect(dx_2, target)) %>%
  distinct(dx_2)

# and so on
# then bind the rows together 
my_list <- bind_rows(p_dx_list,
                     dx_1_list,
                     dx_2_list) %>%
  pivot_longer(everything()) %>% # make long
  drop_na(value) %>%
  distinct(value) %>%
  arrange(value)

# I want to see (as a list) what my str_detect filtered
my_list