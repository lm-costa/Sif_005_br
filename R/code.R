df <- read.csv('data/bioma_analise.csv')

df <- df |> 
  dplyr::mutate(
    bioma=dplyr::case_when(
      RASTERVALU==1~'AMZ',
      RASTERVALU==2~'MCOS',
      RASTERVALU==3~'MCON',
      RASTERVALU==4~'ATF',
      RASTERVALU==5~'CER',
      RASTERVALU==6~'CAAT',
      RASTERVALU==7~'PNT',
      RASTERVALU==8~'PMP'
    )
  ) |> 
  dplyr::filter(bioma!='MCOS'& bioma!='MCON') |> 
  dplyr::select(lon,lat,prec,sif,year_,bioma)



df |> 
  ggplot2::ggplot(ggplot2::aes(x=prec,y=sif
                               ))+
  ggplot2::geom_point()+
  ggplot2::geom_smooth(method='lm')+
  ggplot2::facet_wrap(~bioma,scales = 'fixed')+
  ggplot2::xlab('Precipitation (mm)')+
  ggplot2::ylab(expression('SIF ('~Wm^-2*sr^-1*mu*m^-1~')'))
