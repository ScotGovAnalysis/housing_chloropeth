library(ggplot2)
library(sf)
library(dplyr)
library(readr)
library(ggthemes)

#Loading in data
stl_data <- readr::read_csv("data/data_la.csv") %>%
#manually establish breakpoints
  mutate(rate_bin = case_when(rate <= 100 ~ "< 100",
                            rate <= 200 ~ "< 200",
                           rate <= 300 ~ "< 300",
                          rate > 300 ~ "> 300"))

#load geographies
shapefile <- sf::read_sf('./data/ne_10m_Scotland_local_authorities.shp') %>%
  sf::st_transform('+proj=longlat +datum=WGS84')

#We use the rgb function to translate the standard rgb colour schemes to Hex codes
#To use different colour slot in the rgb codes into the numberators of the divisions
#If you have Hex codes just stick them in as a vector of strings
custom_blues <- c(`< 100` = rgb(239/255,243/255,255/255),
      `< 200` = rgb(189/255,215/255,231/255),
     `< 300` = rgb(107/255,174/255,214/255),
    `> 300` = rgb(33/255,113/255,181/255))

#attached data to geography
shapedata <- shapefile %>%
  dplyr::left_join(stl_data, by = c("CODE" = "la_code"))

ggplot2::ggplot(shapedata) +
  ggplot2::geom_sf(aes(fill = rate_bin), colour = "black") +
  scale_fill_manual(values = custom_blues) +
  ggplot2::theme(legend.position="none") +
  guides(fill = guide_legend(reverse=TRUE)) +
  ggthemes::theme_map() 

ggplot2::ggsave("la_map_test.png", width = 10, height = 8, units = "in", dpi = 300)
