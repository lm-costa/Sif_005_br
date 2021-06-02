`%>%` <- magrittr::`%>%`

arch <- dir("data-raw/", pattern = "yyyy") # set the year here
n_links <- length(arch)
n_split <- length(stringr::str_split(arch[1],"/",simplify = TRUE))
name.arch <- stringr::str_split_fixed(arch,"/",n=Inf)[,n_split]
dir.arch <- paste0("data-raw/AMJ15/",name.arch)

for(i in 1:n_links){
  if(i==1){
    sif.005<-raster::brick(dir.arch[i])
    sif.005<- raster::as.data.frame(sif.005[[1]], xy=T)
    sif.005<- na.omit(sif.005)
    sif.005 <- sif.005 %>%
      dplyr::filter(
        x < -30,
        y < 10
      )
  } else {
    sif.005a<-raster::brick(dir.arch[i])
    sif.005a<- raster::as.data.frame(sif.005a[[1]], xy=T)
    sif.005a<- na.omit(sif.005a)
    sif.005a <- sif.005a %>%
      dplyr::filter(
        x < -30,
        y < 10
      )
    sif.005 <- rbind(sif.005,sif.005a)
  }
}

#creating a polygon for Br

br <- geobr::read_country(showProgress = FALSE)
region <- geobr::read_region(showProgress = FALSE)

pol.br <- as.matrix(br$geom[[1]])
pol.br <- pol.br[pol.br[,1]<=-34,] # Adjustment
pol.br <- pol.br[!((pol.br[,1]>=-38.8 & pol.br[,1]<=-38.6) &
                     (pol.br[,2]>= -19 & pol.br[,2]<= -16)),]

pol_NE <- as.matrix(region$geom[[2]]) # pol North Easth
pol_NE <- pol_NE[pol_NE[,1]<=-34,]# Adjustment
pol_NE <- pol_NE[!((pol_NE[,1]>=-38.7 & pol_NE[,1]<=-38.6) &
                     pol_NE[,2]<= -15),]

#  Logical vector for filter data in a location
sif.005 <- sif.005 %>%
  dplyr::mutate(
    point_in_pol = as.logical(sp::point.in.polygon(point.x = x,
                                                   point.y = y,
                                                   pol.x = pol.br[,1],
                                                   pol.y = pol.br[,2])
                              |
                                sp::point.in.polygon(point.x = x,
                                                     point.y = y,
                                                     pol.x = pol_NE[,1],
                                                     pol.y = pol_NE[,2])
    )
  )

sif.005 <- sif.005 %>%
  dplyr::filter(point_in_pol != FALSE)

#outliers

sif.005 %>%
  ggplot2:: ggplot(ggplot2::aes(y=layer))+
  ggplot2::geom_boxplot(fill="green",outlier.colour = "black")+
  ggplot2::coord_cartesian(xlim=c(-1,1))+
  ggplot2::theme_classic()

remove_outlier <- function(x,coefi=1.5){
  med = median(x)
  li = med - coefi*IQR(x)
  ls = med + coefi*IQR(x)
  c(Lim_Inf = li, Lim_Sup = ls)
}

sif.005 <-  sif.005 %>%
  dplyr::filter(
    layer > remove_outlier(sif.005$layer)[1] &
      layer < remove_outlier(sif.005$layer)[2]
  )

sif.005 %>%
  ggplot2:: ggplot(ggplot2::aes(y=layer))+
  ggplot2::geom_boxplot(fill="green",outlier.colour = "black")+
  ggplot2::coord_cartesian(xlim=c(-1,1))+
  ggplot2::theme_classic()

sif.005 <- sif.005 %>%
  dplyr::mutate(coord = stringr::str_c(x,y, sep= ":")) %>%
  dplyr::group_by(coord) %>%
  dplyr::summarise(sif = mean(layer))

coords = data.frame(stringr::str_split(sif.005$coord, ":", n=Inf,simplify = T))

sif.005<- sif.005 %>%
  dplyr::mutate(
    lon = coords$X1,
    lat = coords$X2) %>%
  dplyr::select(lon, lat, sif)


write.csv(sif.005,"data/sifyyyy.csv")
