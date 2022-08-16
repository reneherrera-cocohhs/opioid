

azdhs_mortality_extract %>%
  filter(if_any(everything(), ~str_detect(.x, inclusion_criteria))) %>%
  filter(county_resident == "Resident") %>%
  group_by(death_book_year) %>%
  count() %>%
  knitr::kable(col.names = c("Year", "Opioid Overdose Deaths"),
               caption = "Opioid Overdose Deaths Among Coconino County Residents")

azdhs_mortality_extract %>%
  filter(if_any(everything(), ~str_detect(.x, inclusion_criteria))) %>%
  # filter(county_resident == "Resident") %>%
  group_by(death_book_year) %>%
  count() %>%
  knitr::kable(col.names = c("Year", "Opioid Overdose Deaths"),
               caption = "Coconino County Opioid Overdose Deaths")

azdhs_mortality_extract %>%
  filter(if_any(everything(), ~str_detect(.x, inclusion_criteria))) %>%
  filter(county_resident == "Resident") %>%
  select(cod_a, cod_b, cod_c, cod_d, cdc_mannerofdeath_desc) %>%
  sample_n(size = 10)

c(
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
  knitr::kable(col.names = "Inclusion criteria: ICD-10 codes and text search")
