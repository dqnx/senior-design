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
MasterAlarm=0

#constant int
RiseRateLevel=35 #Must be changed with test in degrees Celsius per second
Threshold=32	#Must be changed with test in degrees Celsius
IRRLevel=35	#Must be changed with test in W/area?

#Determines RiseRate
Time=34

function thermocouple {
sudo ./thermo
}

function IRread {
python readonce.py
}

while [ true ]; 
do
	IRR=$(IRread) 
	Temp1=$(thermocouple)
	Temp1=$((($Temp1)/10))
	echo "IRR = $IRR"
	sleep 1
	
	Temp2=$(thermocouple)
	Temp2=$((($Temp2)/10))

	SimpleRiseRate=$(($Temp2-$Temp1))
	echo "$SimpleRiseRate"
	if (("$SimpleRiseRate" <= "$RiseRateLevel")); then 
		RiseRate=$(($RR+1))
		echo "RiseRate = $RiseRate"
		echo "RR = $RR"
	else
		RR=0
	fi


#Main code

#Checks
	#Temp2=80 #debug
	if (("$Temp2" >= "$Threshold")); then
		ThreshCheck=1
	else ThreshCheck=0
	fi
	
	#RiseRate=5 #debug
	if (("$RiseRate" >= 3)); then
		RRCheck=1
	else RRCheck=0
	fi

	#IRR=80 #debug
	if (("$IRR" >= "$IRRLevel")); then
		IRRCheck=1
	else IRRCheck=0
	fi

	#Display
	if (("$ThreshCheck" == 1)); then
		ThreshDisplay=1;
	else Threshdisplay=0;
	fi

	if (("$RRCheck" == 1)); then
		RRDisplay=1;
	else RRdisplay=0;
	fi

	if (("$IRRCheck" == 1)); then
		IRRDisplay=1;
	else IRRdisplay=0;
	fi

	DATE=$(date +"%Y-%m-%d_%H%M")
	if (("$ThreshCheck" == 1)) && (("$RRCheck" == 1)) && (("$IRRCheck" == 1)); then
		raspistill -t 1000 -o /home/pi/Pictures/$DATE.jpg
		echo "Picture Taken"
		##xdg-open /home/pi/Pictures/$DATE.jpg
		MasterAlarm=1
	fi
	
	echo "Threshdisplay = $Threshdisplay"
	echo "RRdisplay = $RRdisplay"
	echo "IRRdisplay = $IRRdisplay"
	echo "MasterAlarm = $MasterAlarm"
done
