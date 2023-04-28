# Setup ####
# load packages
library(here) # project oriented workflow
library(pins) # data access
library(scales) # color palette visualization 

# source setup pin board script 
source(file = "scripts/01-setup-pin-board.R")

# # load pin board 
substance_abuse <- board_folder("S:/HIPAA Compliance/SAS Files/Coconino Deaths/Suicide/data-raw")

# list the pins located on the pin board ####
substance_abuse %>%
  pin_list()

# load color palette
color_palette_coco_4 <- substance_abuse %>%
  pin_read("color_palette_coco_4")

# view color palette 
color_palette_coco_4
show_col(color_palette_coco_4)

# load color palette
color_palette_gray_7 <- substance_abuse %>%
  pin_read("color_palette_gray_7")

# view color palette 
color_palette_gray_7
show_col(color_palette_gray_7)

# create Coconino Color Palette 
color_palette_coco_7 <- c(
  "#545234", # rifle-green 
  "#979482", # grullo
  "#d9d6d0", # timberwolf
  "#8cbdb8", # opal
  "#b4947c", # antique-brass
  "#d7bc88", # burlywood 
  "#fae493" # buff 
)

# view color palette 
color_palette_coco_7
show_col(color_palette_coco_7)

# Save to correct pin board 
substance_abuse <- board_folder("S:/HIPAA Compliance/SAS Files/Coconino Deaths/Substance Abuse/data-raw")

# save color palette to pin board 
substance_abuse %>%
  pin_write(
    x = color_palette_coco_7,
    type = "rds",
    title = "Color Palette: Coconino",
    description = "Seven value color palette. Rifle green, grullo, opal, antique-brass, burlywood, and buff. https://coolors.co/545234-979482-d9d6d0-8cbdb8-b4947c-d7bc88-fae493"
  )

substance_abuse %>%
  pin_write(
    x = color_palette_coco_4,
    type = "rds",
    title = "Color Palette: Coconino",
    description = "Four value color palette. "
  )

substance_abuse %>%
  pin_write(
    x = color_palette_gray_7,
    type = "rds",
    title = "Color Palette: Gray",
    description = "Seven value color palette. "
  )

