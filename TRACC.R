FLAG<-as.numeric(readline('Clean (1) or Convert (2)?'))
while(FLAG!=1&FLAG!=2|is.na(FLAG)){
  FLAG<-as.numeric(readline('Bad Input. Enter 1 or 2.'))
} 
if(FLAG==1) source('CleanSapfluxData.r')
if(FLAG==2) source('BaselineSapfluxData.r')

