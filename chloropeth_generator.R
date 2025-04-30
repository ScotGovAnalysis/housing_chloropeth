library(ggplot2)
library(sf)
library(dplyr)
library(readr)
library(ggthemes)

#Loading in data
stl_data <- readr::read_csv("data/data_la.csv")

#load geographies
shapefile <- sf::read_sf('./data/ne_10m_Scotland_local_authorities.shp') %>%
  sf::st_transform('+proj=longlat +datum=WGS84')

#attached data to geography
shapedata <- shapefile %>%
  dplyr::left_join(stl_data, by = c("CODE" = "la_code"))

ggplot2::ggplot(shapedata) +
  ggplot2::geom_sf(aes(fill = rate), colour = "white") +
  ggplot2::scale_fill_gradient(low = "#bdd7e7",
                               #mid = "white",
                               high = "#08519c") +
  ggplot2::theme(legend.position="none") +
  ggthemes::theme_map() 

ggplot2::ggsave("la_map_test.png", width = 10, height = 8, units = "in", dpi = 300)