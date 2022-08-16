# Setup ####
# packages
library(here)
library(tidyverse)
library(lubridate)
library(pins)

substance_abuse <- board_folder("")

# list the pins located on the pin board ####
substance_abuse %>%
  pin_list()

# list the pins located on the pin board ####
substance_abuse %>%
  pin_meta("icd_10_codes")

# read from pin board 
icd_10_codes <- substance_abuse %>%
  pin_read("icd_10_codes")

# list the pins located on the pin board ####
substance_abuse %>%
  pin_meta("azdhs_mortality_extract")

# read from pin board 
mortality_data <- substance_abuse %>%
  pin_read("azdhs_mortality_extract")

# inspect 
glimpse(mortality_data)

# looking for death by opioid overdose 
mortality_data %>%
  count(acme_underlying_cause, sort = TRUE)

# 
mortality_data %>%
  count(cdc_mannerofdeath_desc, sort = TRUE)

# 
mortality_data %>%
  count(cod_a, sort = TRUE)

# 
mortality_data %>%
  count(cod_b, sort = TRUE)

# 
mortality_data %>%
  count(cod_c, sort = TRUE)

# 
mortality_data %>%
  count(cod_d, sort = TRUE)

# criteria 
inclusion_criteria <- c(
  icd_10_codes,
  "t400",
  "t401",
  "t402",
  "t403",
  "t404",
  "t406",
  "opioid",
  "heroin",
  "fentanyl",
  "hydrocodone",
  "buprenorphine",
  "morphine",
  "opiates"
) %>%
  paste(collapse = "|")

# create new variable to indicate if death was drug related 
mortality_data <- mortality_data %>%
  mutate(
    substance_abuse = if_any(everything(), ~str_detect(.x, inclusion_criteria))
  ) 

substance_abuse %>%
  pin_write(
    x = mortality_data,
    type = "rds",
    title = "AZDHS Mortality Data",
    description = "AZDHS mortality data with substance abuse flag"
  )

glimpse(mortality_data)

plot_labels = c("Substance abuse but not suicide", "Suicide with substance abuse", "Suicide but not substance abuse")

mortality_data %>%
  filter(county_resident == "Resident") %>%
  filter(death_book_year %in% c("2016", "2017", "2018", "2019", "2020")) %>%
  filter(age_calc < 19 & age_calc >= 10) %>%
  mutate(suicide = if_else(suicide == "yes", TRUE, FALSE)) %>%
  mutate(substance_abuse = if_else(is.na(substance_abuse), FALSE, TRUE)) %>%
  mutate(suicide_and_substance_abuse = if_else(suicide == TRUE & substance_abuse == TRUE, TRUE, FALSE)) %>%
  mutate(suicide_not_substance_abuse = if_else(suicide == TRUE & substance_abuse == FALSE, TRUE, FALSE)) %>%
  mutate(substance_abuse_not_suicide = if_else(substance_abuse == TRUE & suicide == FALSE, TRUE, FALSE)) %>%
  group_by(suicide_and_substance_abuse, suicide_not_substance_abuse, substance_abuse_not_suicide, suicide, substance_abuse) %>%
  count() %>%
  ungroup() %>%
  select(c(suicide_not_substance_abuse, suicide_and_substance_abuse, substance_abuse_not_suicide, n)) %>%
  pivot_longer(cols = c(suicide_not_substance_abuse, suicide_and_substance_abuse, substance_abuse_not_suicide), names_to = "name", values_to = "value") %>%
  filter(value == TRUE) %>%
  ggplot() +
  geom_col(mapping = aes(x = name, y = n), fill = "#8CBDB8") +
  scale_x_discrete(labels = plot_labels) +
  labs(title = "Death by Suicide and Substance Abuse Among Youth in Coconino County Age 10-18 (2016-2020)",
       y = "Deaths",
       x = "",
       caption = "Substance abuse but not suicide: Death was associated with a poisoning or overdose \n
       Suicie with substance abuse: Death by suicide and associated with a poisoning or overdose \n
       Suicide but not substance abuse: Death by suicide but not associated with a poisoning or overdose") +
  theme_classic()

ggsave(
  filename = "figures/youth-behavior-health-pilot-mortality-2016-2020-coconino-county.png",
  dpi = 300
       )

# # select only deaths related to opioid
# mortality_extract_overdose <- mortality_data %>%
#   filter(residence_county_name == "Coconino") %>% # coconino resident only
#   filter(if_any(everything(), ~str_detect(.x, inclusion_criteria)))
# 
# slice_sample(
#   mortality_extract_overdose,
#   n = 5
# ) %>%
#   view()
