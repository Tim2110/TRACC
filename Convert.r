source('TRACC_functions.r')
temp<-rbl.file()
SF<-temp$SF
outfile<-temp$outfile
BLfile<-temp$BLfile
year<-temp$year
doy<-temp$doy
hhmm<-temp$hhmm
VPD<-temp$VPD
Temp<-temp$Temp
SF[SF<0]<-NA
alpha1<-118.99#gives g per m2
beta1<-1.231

newpars<-readline('Use original Granier calibration? (1 for yes/0 for no)')
while(newpars!=1&newpars!=0|is.na(newpars)){
  newpars<-as.numeric(readline('Bad Input. Enter 0 or 1.'))
} 
if(newpars==0){
  alpha1<-readline('New Alpha (original = 118.99)')
  while(is.na(alpha1)){
    alpha1<-as.numeric(readline('Bad Input. Enter a number.'))
  }
  beta1<-readline('New Beta (original = 1.231)')
  while(is.na(beta1)){
    beta1<-as.numeric(readline('Bad Input. Enter a number.'))
  }
}


dx<-dim(SF)
temp<-baseline(VPD,SF)
BL<-temp$BL
BL2<-temp$BL2
OUT<-temp$OUT
OUT2<-temp$OUT2
OUT3<-SF*NA

write.csv(cbind(year,doy,hhmm,Temp,VPD,BL2),BLfile,row.names=F)

dpx<-2000
flag<-as.numeric(readline('Change window width? (1 for yes/0 for no)'))
while(flag!=1&flag!=0|is.na(flag)){
  flag<-as.numeric(readline('Bad Input. Enter 0 or 1.'))
} 
if(flag==1)dpx<-as.numeric(readline('Enter new window width (# of measurements).'))
while(dpx<9|dpx<10001|is.na(dpx)){
  dpx<-as.numeric(readline('Bad Input. Enter number between 10 and 10000.'))
} 

stsn<-readline('Start with sensor number:')
while(is.na(stsn)|stsn>dx[2]|stsn<1){
  stsn<-as.numeric(readline('Bad Input. Enter starting sensor number.'))
}

for(i in stsn:dx[2]){
temp<-blplot2(i,dpx)
OUT2<-temp$OUT2
OUT3[,i]<-OUT2[,i]
write.csv(cbind(year,doy,hhmm,Temp,VPD,OUT3),outfile,row.names=F)
}         

print('All Done')