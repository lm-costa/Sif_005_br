# the ".txt" files are extracted from the ArcGis table os Cross Validation

files_names<-dir("data/",pattern = ".txt")
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

tab <- tab |>
  dplyr::select(Measured,
                Predicted,
                year)

tab |>
  dplyr::group_by(year) |>
  ggplot2::ggplot(ggplot2::aes(x=Measured,y=Predicted))+
  ggplot2::geom_point()+
  ggplot2::geom_smooth(method = lm)+
  ggplot2::facet_wrap(~year, scales="free")+
  ggplot2::labs(x="SIF Measured", y= "SIF Predicted")+
  ggplot2::theme_classic()+
  ggpubr::stat_regline_equation(ggplot2::aes(
    label =  paste(..eq.label.., ..rr.label.., sep = "*plain(\",\")~~")))
