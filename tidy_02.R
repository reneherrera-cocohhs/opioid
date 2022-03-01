my_filter_goal <- c("b", "d")

my_data <- tribble(
  ~col1, ~col2, ~col3,
  "aaa", "aaa", "aaa",
  "bbb", "bbb", "bbb",
  "ccc", "ccc", "ccc",
  "ddd", "ddd", "ddd",
  "eee", "eee", "eee",
  "fff", "fff", "fff"
)

my_filtered_data <- data.frame()
for (i in unique(my_filter_goal)){
  my_filtered_data <- my_data %>%
    filter(str_detect(cola, i))
  my_filtered_data
}
my_filtered_data

my_data %>%
  filter(str_detect(cola, my_filter_goal))

my_filtered_data <- data.frame()
for (i in seq_along(my_filter_goal)){
  my_filtered_data <- my_data %>%
    filter(str_detect(cola, i))
  my_filtered_data
}

my_filtered_data <- my_data %>%
  Vectorize(filter(grepl(my_filter_goal, cola)), )

df <- my_data

target <- c("b", "c")
index <- str_detect(df$col1, target)
df[index, ]

my_data %>%
  filter(str_detect(col1, "a") | str_detect(col1, "b") )

library(tidyverse)

# target criteria
target <- c("b", "d") %>% paste(collapse = "|")

target

# my data 
my_data <- tribble(
  ~col1, ~col2, ~col3, ~col4, ~col5,
  "aaa", "aaa", "aaa", "aaa", "eee",
  "aaa", "bbb", "bbb", "bbb", "eee",
  "bbb", "ccc", "ccc", "ccc", "eee",
  "aaa", "ddd", "ddd", "ddd", "eee",
  "aaa", "eee", "eee", "eee", "ddd",
  "aaa", "fff", "fff", "fff", "eee"
)

# filter becomes vulerable to copy and paste errors if I have many variables
my_filtered_data <- my_data %>%
  filter(str_detect(col1, target) |
           str_detect(col3, target) |
           str_detect(col5, target))

my_filtered_data
