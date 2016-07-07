source('CleanAndBaselineFunctionsNew.r')
temp<-rt.file()
SF<-temp$SF
outfile<-temp$outfile
year<-temp$year
doy<-temp$doy
hhmm<-temp$hhmm
Temp<-temp$Temp
VPD<-temp$VPD
stsn<-temp$stsn
dx<-dim(SF)


for(i in stsn:dim(SF)[2]){
SF<-wsplot(i)$SF
write.csv(cbind(year,doy,hhmm,Temp,VPD,SF),outfile,row.names=F)
SF<-cleanplot(i)$SF
write.csv(cbind(year,doy,hhmm,Temp,VPD,SF),outfile,row.names=F)
}

print('All Sensors Cleaned')

