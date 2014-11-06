#!/bin/bash

INA1_ADDR=0x42
INA2_ADDR=0x43
INA3_ADDR=0x44
INA4_ADDR=0x45
INA5_ADDR=0x46
INA6_ADDR=0x47
TMP_ADDR=0x4C
AUX_INA_ADDR=0x4F

#INA226 Registers
CONFIG_REG=0x0
SHUNTV_REG=0x1
BUSV_REG=0x2
POWER_REG=0x3
CURRENT_REG=0x4
CALIB_REG=0x5

#Variables
SUPPLY=('INA1' 'INA2' 'INA3' 'INA4' 'INA5' 'INA6' 'AUX');
SHUNT=('0.05' '0.05' '0.05' '0.1' '0.1' '0.05' '2.0');
SHUNTV=('0' '0' '0' '0' '0' '0');
BUSV=('0' '0' '0' '0' '0' '0');
NUM_SUPPLIES=${#SUPPLY[@]}
COUNT=100

for ((i=0 ; i<$COUNT ; i++)); do

#Reset and initialize INA226
i2cset -y 1 $INA1_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $INA2_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $INA3_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $INA4_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $INA5_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $INA6_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $AUX_INA_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $INA1_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $INA2_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $INA3_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $INA4_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $INA5_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $INA6_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $AUX_INA_ADDR $CONFIG_REG 0xFF4F w


#Take voltage measurements
#INA1
INA1_SHUNTV=$(i2cget -y 1 $INA1_ADDR $SHUNTV_REG w)
let "temp = $INA1_SHUNTV >> 8"
let "temp2 = $INA1_SHUNTV << 8 | $temp"
let "INA1_SHUNTV = $temp2 & 0xffff"
INA1_SHUNTV[i]=$(echo "$INA1_SHUNTV*0.0025" | bc)
INA1_BUSV=$(i2cget -y 1 $INA1_ADDR $BUSV_REG w)
let "temp = $INA1_BUSV >> 8"
let "temp2 = $INA1_BUSV << 8 | $temp"
let "INA1_BUSV = $temp2 & 0xffff"
INA1_BUSV[i]=$(echo "$INA1_BUSV*0.00125" | bc)

#INA2
INA2_SHUNTV=$(i2cget -y 1 $INA2_ADDR $SHUNTV_REG w)
let "temp = $INA2_SHUNTV >> 8"
let "temp2 = $INA2_SHUNTV << 8 | $temp"
let "INA2_SHUNTV = $temp2 & 0xffff"
INA2_SHUNTV[i]=$(echo "$INA2_SHUNTV*0.0025" | bc)
INA2_BUSV=$(i2cget -y 1 $INA2_ADDR $BUSV_REG w)
let "temp = $INA2_BUSV >> 8"
let "temp2 = $INA2_BUSV << 8 | $temp"
let "INA2_BUSV = $temp2 & 0xffff"
INA2_BUSV[i]=$(echo "$INA2_BUSV*0.00125" | bc)

#INA3
INA3_SHUNTV=$(i2cget -y 1 $INA3_ADDR $SHUNTV_REG w)
let "temp = $INA3_SHUNTV >> 8"
let "temp2 = $INA3_SHUNTV << 8 | $temp"
let "INA3_SHUNTV = $temp2 & 0xffff"
INA3_SHUNTV[i]=$(echo "$INA3_SHUNTV*0.0025" | bc)
INA3_BUSV=$(i2cget -y 1 $INA3_ADDR $BUSV_REG w)
let "temp = $INA3_BUSV >> 8"
let "temp2 = $INA3_BUSV << 8 | $temp"
let "INA3_BUSV = $temp2 & 0xffff"
INA3_BUSV[i]=$(echo "$INA3_BUSV*0.00125" | bc)

#INA4
INA4_SHUNTV=$(i2cget -y 1 $INA4_ADDR $SHUNTV_REG w)
let "temp = $INA4_SHUNTV >> 8"
let "temp2 = $INA4_SHUNTV << 8 | $temp"
let "INA4_SHUNTV = $temp2 & 0xffff"
INA4_SHUNTV[i]=$(echo "$INA4_SHUNTV*0.0025" | bc)
INA4_BUSV=$(i2cget -y 1 $INA4_ADDR $BUSV_REG w)
let "temp = $INA4_BUSV >> 8"
let "temp2 = $INA4_BUSV << 8 | $temp"
let "INA4_BUSV = $temp2 & 0xffff"
INA4_BUSV[i]=$(echo "$INA4_BUSV*0.00125" | bc)

#INA5
INA5_SHUNTV=$(i2cget -y 1 $INA5_ADDR $SHUNTV_REG w)
let "temp = $INA5_SHUNTV >> 8"
let "temp2 = $INA5_SHUNTV << 8 | $temp"
let "INA5_SHUNTV = $temp2 & 0xffff"
INA5_SHUNTV[i]=$(echo "$INA5_SHUNTV*0.0025" | bc)
INA5_BUSV=$(i2cget -y 1 $INA5_ADDR $BUSV_REG w)
let "temp = $INA5_BUSV >> 8"
let "temp2 = $INA5_BUSV << 8 | $temp"
let "INA5_BUSV = $temp2 & 0xffff"
INA5_BUSV[i]=$(echo "$INA5_BUSV*0.00125" | bc)

#INA6
INA6_SHUNTV=$(i2cget -y 1 $INA6_ADDR $SHUNTV_REG w)
let "temp = $INA6_SHUNTV >> 8"
let "temp2 = $INA6_SHUNTV << 8 | $temp"
let "INA6_SHUNTV = $temp2 & 0xffff"
INA6_SHUNTV[i]=$(echo "$INA6_SHUNTV*0.0025" | bc)
INA6_BUSV=$(i2cget -y 1 $INA6_ADDR $BUSV_REG w)
let "temp = $INA6_BUSV >> 8"
let "temp2 = $INA6_BUSV << 8 | $temp"
let "INA6_BUSV = $temp2 & 0xffff"
INA6_BUSV[i]=$(echo "$INA6_BUSV*0.00125" | bc)

done

#Average all values and store
shuntv_sum=0
busv_sum=0
for ((x=1 ; x<$COUNT ; x++)); do
	shuntv_sum=$(echo "$shuntv_sum+${INA1_SHUNTV[$x]}" | bc)
	busv_sum=$(echo "$busv_sum+${INA1_BUSV[$x]}" | bc)
done
SHUNTV[0]=$(echo "$shuntv_sum/($COUNT-1)" | bc -l)
BUSV[0]=$(echo "$busv_sum/($COUNT-1)" | bc -l)

shuntv_sum=0
busv_sum=0
for ((x=1 ; x<$COUNT ; x++)); do
	shuntv_sum=$(echo "$shuntv_sum+${INA2_SHUNTV[$x]}" | bc)
	busv_sum=$(echo "$busv_sum+${INA2_BUSV[$x]}" | bc)
done
SHUNTV[1]=$(echo "$shuntv_sum/($COUNT-1)" | bc -l)
BUSV[1]=$(echo "$busv_sum/($COUNT-1)" | bc -l)

shuntv_sum=0
busv_sum=0
for ((x=1 ; x<$COUNT ; x++)); do
	shuntv_sum=$(echo "$shuntv_sum+${INA3_SHUNTV[$x]}" | bc)
	busv_sum=$(echo "$busv_sum+${INA3_BUSV[$x]}" | bc)
done
SHUNTV[2]=$(echo "$shuntv_sum/($COUNT-1)" | bc -l)
BUSV[2]=$(echo "$busv_sum/($COUNT-1)" | bc -l)

shuntv_sum=0
busv_sum=0
for ((x=1 ; x<$COUNT ; x++)); do
	shuntv_sum=$(echo "$shuntv_sum+${INA4_SHUNTV[$x]}" | bc)
	busv_sum=$(echo "$busv_sum+${INA4_BUSV[$x]}" | bc)
done
SHUNTV[3]=$(echo "$shuntv_sum/($COUNT-1)" | bc -l)
BUSV[3]=$(echo "$busv_sum/($COUNT-1)" | bc -l)

shuntv_sum=0
busv_sum=0
for ((x=1 ; x<$COUNT ; x++)); do
	shuntv_sum=$(echo "$shuntv_sum+${INA5_SHUNTV[$x]}" | bc)
	busv_sum=$(echo "$busv_sum+${INA5_BUSV[$x]}" | bc)
done
SHUNTV[4]=$(echo "$shuntv_sum/($COUNT-1)" | bc -l)
BUSV[4]=$(echo "$busv_sum/($COUNT-1)" | bc -l)

shuntv_sum=0
busv_sum=0
for ((x=1 ; x<$COUNT ; x++)); do
	shuntv_sum=$(echo "$shuntv_sum+${INA6_SHUNTV[$x]}" | bc)
	busv_sum=$(echo "$busv_sum+${INA6_BUSV[$x]}" | bc)
done
SHUNTV[5]=$(echo "$shuntv_sum/($COUNT-1)" | bc -l)
BUSV[5]=$(echo "$busv_sum/($COUNT-1)" | bc -l)

#Calculate power


#Output to console, log file
for ((i=0 ; i<$NUM_SUPPLIES ; i++)); do
	printf "%f %f\n" "${SHUNTV[i]}" "${BUSV[i]}"
done

