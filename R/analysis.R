#Require the libraries 
library(tidyverse)

# Data Visualization 
sif <- readr::read_rds("data/database.rds")

sif %>% 
  filter(year == 2015) %>% 
  ggplot(aes(x=Lon,y=Lat)) +
  geom_point()
  