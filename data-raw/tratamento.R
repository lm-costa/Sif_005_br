# Code to prepare sif dataset
## Load magrittr to PIPE
library(magrittr)

## Creating a list of .xlsx files names
files_names<-dir("data-raw/",pattern = ".xlsx")

## Lets read each file separate
year<-readr::parse_number(files_names)
for(i in 1:length(files_names)){
    if(i==1){
    tab<-readxl::read_excel(paste0("data-raw/",files_names[i]))
    tab <- tab %>% 
              dplyr::mutate(year = year[i])
  }else{
    tab_aux<-readxl::read_excel(paste0("data-raw/",files_names[i]))
    tab_aux <- tab_aux %>% 
      dplyr::mutate(year = year[i])
    tab <- rbind(tab,tab_aux)
  }
}

# Creating the rds file from tab 
readr::write_rds(tab, "data/database.rds")
