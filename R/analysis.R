#Require the libraries 
library(tidyverse)

# Data Visualization 
sif <- readr::read_rds("data/database.rds")

sif %>% 
  filter(year == 2015) %>% 
  ggplot(aes(x=Lon,y=Lat)) +
  geom_point()
  
# usethis::use_git_config(
#   user.name= "lm-costa", 
#   user.email="luism.costa00@gmail.com"
# )
# 
# usethis::create_github_token()
# gitcreds::gitcreds_set(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)

#comentario 