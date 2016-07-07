############# R FLUX programs README#############

###################Version 2#####################


CleanAndBaselineFunctions.r, CleanSapfluxData.r, BaselineSapfluxData.r and datafiles should all be in same folder.

Datafiles should be comma-delimited (.csv) and have the columns: Year, DOY, HHMM, Temp, VPD, followed by columns of sap flux data.

DOY is an integer of the julian day, HHMM is the time in hours and minutes (i.e. 1230 is half-past noon), Temp is air temperature in degrees C, and VPD is vapor pressure deficit in kPa.

CleanAndBaselineFunctions.r is source code that is called by the other two programs.


########### Mac Users and older versions of R ##############

To run the programs, you will need to comment out line 246 of CleanAndBaselineFunctions.r "bringToTop(-1)" by adding a '#' at the beginning.

It should be pretty clear if you get the error message that requires this.  All that command does is save you the trouble of having to select the graph window for inspection.

################Clean data##################

To run the CleanSapfluxData.r program, you can copy the script into the R window, or type:

source('CleanSapfluxData.r')

The program will ask you for input and output comma-delimited file names.

The program will then ask you for an upper limit and lower limit for sap flux data (usually a temperature difference in degrees C).  Any data outside these bounds will be changed to NA ('not available').  

It should then ask which sensor to start with.  The program saves to the output when each sensor is finished, so if you have a crash, you can restart the program, give a new output name, then tell it to start with the sensor on which you crashed.  After you are done, you can then use excel or another program to merge the output files.

A plot with the sensor data should now appear.  I usually resize this to take up the bottom half of my window, with the R console on the lower half.  The program will now ask for an upper and lower limit for this sensor.  It will highlight the data that has not been trimmed and ask you if this is OK.  If not, then it should repeat the process.

When the sensor trimming is complete it should plot the first 2000 non-missing datapoints and ask if you wish to erase any.  If you choose to erase, you must provide a starting and ending index for data to erase (look at x-axis on graph).  It will then highlight the proposed erasure in red and ask for approval.  It should then ask if you want to edit more data.  If you say no, it should present the next 2000, etc.  If you accidentally say 'yes' to erasing data, but do not want to, put a zero in response to 'Erase from:'.

This cycle should repeat until all sensors are finished.



################Baseline Data###########

To run the BaselineSapfluxData.r program, you can copy the script into the R window, or type:


source('BaselineSapfluxData.r')


This program selects nights for zero-flow values of temperature-difference readings based on VPD (Oishi et al. 2008).  It is assumed that if VPD is low enough for a minimum amount of time, there is little transpiration or hydraulic recharge to create flow at sensor height and a zero-flow point is taken as the mean of the highest 3 readings between midnight and 5:30 am at the time of the highest reading.  These points are then interpolated across the data set to form the initial baseline, assuming constant values before the first zero-flow point and after the final zero-flow point.  After the initial baseline is placed, new zero-flow points are placed on nights where the mean nighttime reading is above the initial baseline between 2 and 6 am, as the mean value of this period at 4 am.  These new baseline points are added to the initial ones and interpolated for the final baseline.

The program will ask you for input and output comma-delimited file names.  Then it will ask for a maximum VPD and minimum number of readings for the zero-flow selection.  For mature loblolly pine in North Carolina, we have employed 0.1 kPa for 4 half-hourly readings with good results.  There will be a pause as all sensors are baselined.  If this pause is too long, it may be that you have too large number of readings and/or sensors for the program to handle.

It should then ask which sensor to start with.  The program saves to the output when each sensor is finished, so if you have a crash, you can restart the program, give a new output name, then tell it to start with the sensor on which you crashed.  After you are done, you can then use excel or another program to merge the output files.

A plot with the the first 2000 non-missing datapoints should now appear, with the temperature difference data (green) and baseline in the top panel, and the converted data in g/m^2/s in the bottom.  I usually resize this to take up the bottom 2/3 of my window, with the R console on the top 1/3.  It should ask if you would like to edit the output.  If you choose to erase, it will replot the data and you must provide a starting and ending index for data to erase (look at x-axis on graph).  It should highlight these data in green and ask for confirmation.  If you say no, it should present the next 2000, etc.  If you accidentally say 'yes' to erasing data, but do not want to, put a zero in response to 'Erase from:'.














