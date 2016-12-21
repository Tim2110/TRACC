#######r.file###################

r.file<-function(){
infile<-readline('Input file (with extension):')
outfile<-readline('Output file (with extension):')
ddd<-read.csv(infile)
dx<-dim(ddd)
year<-ddd[,1]
doy<-ddd[,2]
hhmm<-ddd[,3]
Temp<-ddd[,4]
VPD<-ddd[,5]
SF<-as.matrix(ddd[,6:dx[2]])
list(SF=SF,outfile=outfile,year=year,hhmm=hhmm,doy=doy,Temp=Temp,VPD=VPD,dx=dx)
}

#######rbl.file###################

rbl.file<-function(){
infile<-readline('Input data file (with extension):')
outfile<-readline('Converted data file (with extension):')
BLfile<-readline('Zero-flow baseline file (with extension):')
ddd<-read.csv(infile)
dx<-dim(ddd)
year<-ddd[,1]
doy<-ddd[,2]
hhmm<-ddd[,3]
Temp<-ddd[,4]
VPD<-ddd[,5]
SF<-as.matrix(ddd[,6:dx[2]])
list(SF=SF,outfile=outfile,year=year,hhmm=hhmm,doy=doy,Temp=Temp,VPD=VPD,dx=dx,BLfile=BLfile)
}

#######rt.file###################

rt.file<-function(){
infile<-readline('Input file (with extension):')
outfile<-readline('Output file (with extension):')
ddd<-read.csv(infile)
dx<-dim(ddd)
year<-ddd[,1]
doy<-ddd[,2]
hhmm<-ddd[,3]
Temp<-ddd[,4]
VPD<-ddd[,5]
SF<-as.matrix(ddd[,6:dx[2]])
uplim<-as.numeric(readline('Upper Limit for All Sensors:'))
while(is.na(uplim)){
  uplim<-as.numeric(readline('Bad Input. Enter a number.'))
}
lolim<-as.numeric(readline('Lower Limit for All Sensors:'))
while(is.na(lolim)){
  lolim<-as.numeric(readline('Bad Input. Enter a number.'))
}
stsn<-as.numeric(readline('Start with Sensor:'))
while(is.na(stsn)){
  stsn<-as.numeric(readline('Bad Input. Enter a number.'))
}
SF[SF>uplim]<-NA
SF[SF<lolim]<-NA
list(SF=SF,outfile=outfile,year=year,hhmm=hhmm,doy=doy,Temp=Temp,VPD=VPD,dx=dx,stsn=stsn)
}

########plot whole sensor########
wsplot<-function(sn){
print(c('Trimming Sensor ',sn))
flag<-0
ymx<-max(SF[,sn],na.rm=T)
ymn<-min(SF[,sn],na.rm=T)

if(ymx>0){ #handles empty sensors
while(flag==0){
par(yaxt='n',mar=c(2,2,0,0))
plot(SF[,sn],type='l')
par(yaxt='s')       
axis(2,at=seq(floor(ymn),ceiling(ymx),1))
uplim<-as.numeric(readline('Upper Limit for This Sensor:'))
while(is.na(uplim)){
  uplim<-as.numeric(readline('Bad Input. Enter a number.'))
}
lolim<-as.numeric(readline('Lower Limit for This Sensor:'))
while(is.na(lolim)){
  lolim<-as.numeric(readline('Bad Input. Enter a number.'))
}
SF2<-SF
SF2[SF[,sn]>uplim,sn]<-NA
SF2[SF[,sn]<lolim,sn]<-NA
lines(SF2[,sn],col=2)
flag<-as.numeric(readline('Is this OK? (1 for yes/0 for no)'))
while(flag!=1&flag!=0|is.na(flag)){
  flag<-as.numeric(readline('Bad Input. Enter 0 or 1.'))
} 
}
  
SF<-SF2}
list(SF=SF)
}

###########plot sensor for cleaning#######
cleanplot<-function(sn,dpx){
print(c('Cleaning Sensor ',sn))
par(yaxt='s',mar=c(2,2,0,0))
if (is.na(dpx) dpx<-2000 #index width of plot
flag2<-0
flag3<-flag<-1
pmn<-1
pmx<-dpx
if(pmx>dx[1]) pmx<-dx[1]
while(flag3==1){
if(sum(is.finite(SF[pmn:pmx,sn]))==0){}else{
plot(pmn:pmx,SF[pmn:pmx,sn],type='l',xaxt='n')
axis(1,at=seq(pmn,pmx,100))
flag<-as.numeric(readline('Erase data? (1 for yes/0 for no)'))
while(flag!=1&flag!=0|is.na(flag)){
  flag<-as.numeric(readline('Bad Input. Enter 0 or 1.'))
} 
while(flag==1){
        while(flag2==0){
        SF2<-SF
        plot(pmn:pmx,SF[pmn:pmx,sn],type='l',xaxt='n')
        par(xaxt='s')
        axis(1,at=seq(pmn,pmx,100))
        emn<-as.numeric(readline('Erase from:'))
        while(is.na(emn)){
          emn<-as.numeric(readline('Bad Input. Enter a number.'))
        }
        if(emn==0){flag2<-1}else{
        emx<-as.numeric(readline('Erase to:'))
        while(is.na(emx)){
          emx<-as.numeric(readline('Bad Input. Enter a number.'))
        }
        SF2[emn:emx,sn]<-NA
        lines(emn:emx,SF[emn:emx,sn],col=2)
        flag2<-as.numeric(readline('Erase these data? (1 for yes/0 for no)'))
        while(flag2!=1&flag2!=0|is.na(flag2)){
          flag2<-as.numeric(readline('Bad Input. Enter 0 or 1.'))
        } }#end ifelse emn
        }#end while flag2        
SF<-SF2
if(sum(is.finite(SF[pmn:pmx,sn]))==0){flag<-0}else{
plot(pmn:pmx,SF[pmn:pmx,sn],type='l',xaxt='n')
flag<-as.numeric(readline('Erase more data? (1 for yes/0 for no)'))
while(flag!=1&flag!=0|is.na(flag)){
  flag<-as.numeric(readline('Bad Input. Enter 0 or 1.'))
} 
flag2<-0
}#end ifelse #1
}#end ifelse #2
}#end while flag

if((pmx)>=dx[1]) flag3<-0
pmn<-pmn+dpx
pmx<-pmx+dpx
if((pmx)>=dx[1]){
pmx<-dx[1]
}#end if
flag<-1
flag2<-0
}#end while flag3
list(SF=SF)
}#end function
###################End Clean Plot Function################


##############Select Baseline Points#####################
####This function looks for nights where VPD<0.1 kPa for at least 4 timesteps
####Any night with a mean reading from 2 am to 6 am above baseline is also included in BL2
baseline<-function(VPD,SF){
thr<-as.numeric(readline('VPD threshold (kPa):'))
while(is.na(thr)){
  thr<-as.numeric(readline('Bad Input. Enter a number.'))
} 
dur<-as.numeric(readline('Threshold duration (timesteps):'))
while(is.na(dur)){
  dur<-as.numeric(readline('Bad Input. Enter a number.'))
} 
dx<-dim(SF)
zz<-seq(1,dx[1],48)
days<-unique(year+doy/365)
BL<-SF*NA
OUT2<-OUT<-BL2<-BL3<-BL
for(i in 1:dx[2]){
if(sum(is.finite(SF[,i]))>48){
for(j in 1:length(days)){
xx<-which(hhmm<600&VPD<thr&(year+doy/365)==days[j])
if(length(xx)>=dur&sum(is.finite(SF[xx,i]))>0){
oo<-order(SF[xx,i],decreasing=T)
xxx<-xx[oo[1]]                                                           
yy<-mean(SF[xx[oo[1:3]],i],na.rm=T)
BL[xxx,i]<-yy
}}
BL2[,i]<-BL[,i]
BL3[,i]<-BL[,i]
zz<-which(is.finite(BL[,i]))
BL[,i]<-approx(zz,BL[zz,i],1:dx[1],rule=2)$y
K<-(BL[,i]-SF[,i])/SF[,i]
OUT[,i]<-alpha1*K^beta1
mm<-which(K<=0)
if(length(mm)>0) OUT[mm,i]<-0
for(j in 1:length(days)){
xx<-which(hhmm<600&hhmm>=200&(year+doy/365)==days[j])
if(sum(is.finite(SF[xx,i]))>0){
if(mean(SF[xx,i],na.rm=T)>mean(BL[xx,i])){
BL2[xx[5],i]<-mean(SF[xx,i],na.rm=T)
}}
}
zz<-which(is.finite(BL2[,i]))
BL2[,i]<-approx(zz,BL2[zz,i],1:dx[1],rule=2)$y
K<-(BL2[,i]-SF[,i])/SF[,i]
OUT2[,i]<-alpha1*K^beta1
mm<-which(K<=0)
if(length(mm)>0) OUT2[mm,i]<-0
}}
list(BL2=BL2,BL=BL,OUT=OUT,OUT2=OUT2)
}



##################BL PLOT FUNCTION W Cleaning###########
blplot2<-function(sn,dn){
if(sum(is.finite(SF[,sn])>0)){
sn<-sn#sensor number
wn<-1#window number
flag<-1
if(is.na(dn)) dn<-2000#window width
mn<-min(which(is.finite(OUT2[,sn])))
mx<-max(which(is.finite(OUT2[,sn])))
bk<-1

while(wn<((dx[1]-mn)/dn+1)){
  #print(wn)
xx<-(mn+(wn-1)*dn):(mn+(wn)*dn)
xx<-xx[xx<=mx]
#print(xx)
plot(1:2,1:2)#dummy plot
dev.off()
dev.new(height=6,width=16)
par(mfrow=c(2,1),mar=c(2,2,0,0))
if(sum(is.finite(OUT2[xx,sn]))>0) plot(xx,SF[xx,sn],type='l',col=3)
#lines(xx,BL[xx,sn],col=1)
if(sum(is.finite(OUT2[xx,sn]))>0) lines(xx,BL2[xx,sn],col=1)
#bringToTop(-1) 
#plot(xx,OUT2[xx,sn],type='l',col=2)
#lines(xx,OUT[xx,sn],col=1)

flag2<-0
flag<-1
if(sum(is.finite(OUT2[xx,sn]))==0){}else{
plot(xx,OUT2[xx,sn],type='l',xaxt='n')
axis(1,at=seq(min(xx),max(xx),100))
flag<-as.numeric(readline('Edit output? (0 for no, 1 for yes)'))
while(flag!=1&flag!=0|is.na(flag)){
  flag<-as.numeric(readline('Bad Input. Enter 0 or 1.'))
} }#end ifelse
flag2<-0
while(flag==1&sum(is.finite(OUT2[xx,sn]))>0){
        while(flag2==0){
        OUT2e<-OUT2
        plot(xx,OUT2[xx,sn],type='l',xaxt='n')
        par(xaxt='s')
        axis(1,at=seq(min(xx),max(xx),100))
        emn<-as.numeric(readline('Erase from:'))
        if(emn==0){flag2<-1}else{
        emx<-as.numeric(readline('Erase to:'))
        OUT2e[emn:emx,sn]<-NA
        lines(emn:emx,OUT2[emn:emx,sn],col=3)
        flag2<-as.numeric(readline('Erase these data? (1 for yes/0 for no)'))
        while(flag2!=1&flag2!=0|is.na(flag2)){
          flag2<-as.numeric(readline('Bad Input. Enter 0 or 1.'))
        } }#end ifelse
        }#end while flag2        
OUT2<-OUT2e
if(sum(is.finite(OUT2[xx,sn]))==0){flag<-0}else{
plot(xx,OUT2[xx,sn],type='l',xaxt='n')
flag<-as.numeric(readline('Erase more data? (1 for yes/0 for no)'))
while(flag!=1&flag!=0|is.na(flag)){
  flag<-as.numeric(readline('Bad Input. Enter 0 or 1.'))
}
flag2<-0
}#end ifelse #1
}#end while flag

wn<-wn+1} #end while wn
}#end if sum SF
cat('Done with sensor #',sn,'\n')
#cat('All Done','\n')
list(OUT2=OUT2)
}
###################End BL Plot Function################
