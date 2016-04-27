#!/bin/bash

#//Base Variables
#int Time;
#int Temp;
#int IRR;
#int RiseRate;

#//Lower Level Logic Variables
#Int ThreshCheck;
#int RRCheck;
#int IRRCheck;

#//Output Variables  (Connected to output ports)
#Int ThreshDisplay;
#int RRDisplay;
#int IRRDisplay;
#int MasterAlarm;

#//Extra Variables
#int t1;	//[s]
#int t2;	//[s]
#int Temp1;	//[C]
#int Temp2;	//[C]

#int SimpleRiseRate;	//[C/s]
#int RR;	//[#]
RR=0


#constant int
RiseRateLevel=35 #Must be changed with test in degrees Celsius per second
Threshold=35	#Must be changed with test in degrees Celsius
IRRLevel=35	#Must be changed with test in W/area?

#Determines RiseRate
Time=34

function thermocouple (
./thermo
)

while [ true ]; 
do 
	Temp1=thermocouple
	Temp1=$((($Temp1)/10))

	sleep 1
	
	Temp2=thermocouple
	Temp2=$((($Temp2)/10))

	SimpleRiseRate = $(($Temp2-$Temp1)) | bc
	if [ "$SimpleRiseRate" >= "$RiseRateLevel"]; then 
		RiseRate=$(($RR+1))
	else
		RR=0
	fi
done

#Main code

#Checks

if ["$Temp" >= "$Threshold"]; then
	ThreshCheck=1
else ThreshCheck=0
fi

if ["$RiseRate" >= 3 ]; then
	RRhCheck=1
else RRCheck=0
fi

if ["$IRR" >= "$IRRLevel"]; then
	IRRCheck=1
else IRRCheck=0
fi

#Display
if ["$ThreshCheck" = 1]; then
	ThreshDisplay=1;
else Threshdisplay=0;
fi

if ["$RRCheck" = 1]; then
	RRDisplay=1;
else RRdisplay=0;
fi

if ["$IRRCheck" = 1]; then
	IRRDisplay=1;
else IRRdisplay=0;
fi

DATE=$(date +"%Y-%m-%d_%H%M")
if [ $ThreshCheck -eq 1 ] && [ $RRCheck -eq 1 ] && [ $IRRCheck -eq 1 ]; then
	raspistill -t 1000 -o /home/pi/Pictures/$DATE.jpg
	xdg-open /home/pi/Pictures/$DATE.jpg
	MasterAlarm=1
else MasterAlarm=0
fi
