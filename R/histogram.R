files_names<-dir("data/",pattern = ".csv")
year<-readr::parse_number(files_names)

for(i in 1:length(files_names)){
  if(i==1){
    tab<-read.table(paste0("data/",files_names[i]), h=TRUE, sep=",")
    tab <- tab |>
      dplyr::mutate(year = year[i])
  }else{
    tab_aux<-read.table(paste0("data/",files_names[i]), h=TRUE, sep=",")
    tab_aux <- tab_aux |>
      dplyr::mutate(year = year[i])
    tab <- rbind(tab,tab_aux)
  }
}


tab |>
  dplyr::group_by(year) |>
  ggplot2::ggplot(ggplot2::aes(x=sif))+
  ggplot2::geom_histogram()+
  ggplot2::facet_wrap(~year, scales="free")+
  ggplot2::labs(x="SIF", y= "Frequency")+
  ggplot2::theme_classic()
