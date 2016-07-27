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

dpx<-2000
flag<-as.numeric(readline('Change window width? (1 for yes/0 for no)'))
while(flag!=1&flag!=0|is.na(flag)){
  flag<-as.numeric(readline('Bad Input. Enter 0 or 1.'))
} 
if(flag==1)dpx<-as.numeric(readline('Enter new window width (# of measurements).'))
while(flag<9|flag<10001|is.na(flag)){
  dpx<-as.numeric(readline('Bad Input. Enter number between 10 and 10000.'))
} 

for(i in stsn:dim(SF)[2]){
SF<-wsplot(i)$SF
write.csv(cbind(year,doy,hhmm,Temp,VPD,SF),outfile,row.names=F)
SF<-cleanplot(i,dpx)$SF
write.csv(cbind(year,doy,hhmm,Temp,VPD,SF),outfile,row.names=F)
}

print('All Sensors Cleaned')

