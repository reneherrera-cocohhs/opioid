
library(tidyverse)
library(janitor)
library(lubridate)
library(knitr)

hdd <- read_csv(file = "S:/HIPAA Compliance/Hospital Discharge Data/HDD_Updated-05042021/2018_to_2020/coconino_2018_to_2020.csv",
                col_types = cols(.default = "c")) %>%
  clean_names()

glimpse(hdd)

# only hospitals in coconino county 
coco_hospitals <- read_rds("../coconino_county_medical_list.rds")

coco_hospitals_list <- coco_hospitals %>%
  filter(str_detect(subtype, "HOSPITAL"),
         county == "COCONINO") %>%
  select(facid, legalname)

# discharge date 
hdd_2020 <- hdd %>%
  mutate(discharge_date = ymd(discharge_date),
         discharge_year = year(discharge_date),
         discharge_month = month(discharge_date)) %>%
  filter(discharge_year == 2019 | discharge_year == 2020)

# select only hospitals in coconino county 
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

# from 
# https://www.livestories.com/statistics/arizona/coconino-county-opioids-deaths-mortality
# About the Data
# 
# The data in this article was queried from CDC Wonder, based on the following parameters:
#   
#   • UCD codes: F11.0, X40-X44, X60-X64, X85, Y10-Y14
# 
# • MCD codes: T40.0-T40.4, T40.6


# The data table below shows the number of opioid related hospital visits in 2019 and 2020.
hdd_2020_opioid <- hdd_coco %>%
  filter(if_any(contains("diagnosis"), ~str_detect(.x, icd_10_cm))) %>%
  select(az_fac_id, legalname, contains(c("discharge_", "diag"))) 

total_opioid_hospitalizations <- hdd_2020_opioid %>%
  group_by(discharge_year) %>%
  count() %>%
  ungroup() 

table_caption <- str_c("Opioid related hospitalizations in Coconino County for years 2019 and 2020.",
                       # total_opioid_hospitalizations,
                       sep = "")

total_opioid_hospitalizations %>%
  knitr::kable(col.names = c("Year", "Count"),
               caption = table_caption)

plot_ul <- total_opioid_hospitalizations  %>%
  summarise(max = (max(n)*1.25)) %>%
  as.numeric()

total_opioid_hospitalizations %>%
  ggplot(mapping = aes(x = discharge_year, y = n)) +
  geom_col() +
  ylim(0, plot_ul) +
  scale_x_continuous(breaks = seq(2019, 2020, 1),
                     labels = c("2019",
                                "2020")) +
  labs(title = "Opioid Related Hospital Visits in Coconino County (2019-2020)",
       caption = table_caption,
       x = "Year",
       y = "Count") +
  theme_light()


# Opioid related ICD-10 codes described by:
# Moore , BJ, and ML Barrett. “Case Study: Exploring How Opioid-Related Diagnosis Codes Translate From ICD-9-CM to ICD-10-CM.” U.S. Agency for Healthcare Research and Quality, April 24, 2017. https://www.hcup-us.ahrq.gov/datainnovations/icd10_resources.jsp.
## List of ICD-10 Codes Counted
list_function <- map(
  hdd_2020_opioid, .f = function(COL){
    tmp <- unique(COL)
    tmp[grepl(icd_10_cm, tmp)]
  }
)

reported_icd_10_codes <- unique(unlist(list_function))

tibble(reported_icd_10_codes) %>%
  arrange(reported_icd_10_codes) %>%
  kable(col.names = "List of ICD-10 codes included in count")


## List of Facilities Included
hdd_2020_opioid %>%
  group_by(discharge_year, legalname) %>%
  count() %>%
  pivot_wider(names_from = discharge_year,
              values_from = n) %>%
  kable(col.names = c("Facility Name",
                      "2019",
                      "2020"),
        caption = "Opioid related hospital visits in Coconino County")


## death due to opioid overdose?
# where discharge status == "expired"
death <- hdd_coco %>%
mutate(discharge_date = ymd(discharge_date),
       discharge_year = year(discharge_date),
       discharge_month = month(discharge_date)) %>%
  filter(discharge_year == 2020) %>%
  filter(if_any(contains("diagnosis"), ~str_detect(.x, icd_10_cm))) %>%
  # select(birth_date, 
  #        pt_medical_rec_number, 
  #        az_fac_id, 
  #        legalname, 
  #        contains(c("discharge_", "diag"))) %>%
  filter(discharge_status == "20") %>%
  mutate(birth_date = ymd(birth_date))

