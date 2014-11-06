#!/bin/bash

MUX1_INA_ADDR=0x42
MUX2_INA_ADDR=0x43
AUX_INA_ADDR=0x4F

#INA226 Registers
CONFIG_REG=0x0
SHUNTV_REG=0x1
BUSV_REG=0x2
POWER_REG=0x3
CURRENT_REG=0x4
CALIB_REG=0x5

COUNT=10;

for ((i=0 ; i<COUNT ; i++));
do
#Initialize INA226
i2cset -y 1 $MUX1_INA_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $MUX1_INA_ADDR $CONFIG_REG 0xFF4F w

#Take voltage measurements
#MUX1's INA226
MUX1_SHUNTV=$(i2cget -y 1 $MUX1_INA_ADDR $SHUNTV_REG w)
let "temp = $MUX1_SHUNTV >> 8"
let "temp2 = $MUX1_SHUNTV << 8 | $temp"
let "MUX1_SHUNTV = $temp2 & 0xffff"
MUX1_SHUNTV=$(echo "$MUX1_SHUNTV*0.0025" | bc)
MUX1_BUSV=$(i2cget -y 1 $MUX1_INA_ADDR $BUSV_REG w)	
let "temp = $MUX1_BUSV >> 8"
let "temp2 = $MUX1_BUSV << 8 | $temp"
let "MUX1_BUSV = $temp2 & 0xffff"
MUX1_BUSV=$(echo "$MUX1_BUSV*0.00125" | bc)

#Store in array
SHUNTV_ARRAY[i]=$MUX1_SHUNTV
BUSV_ARRAY[i]=$MUX1_BUSV

#Calculate power


#Output to console, log file
printf "%f %f\n" "$MUX1_SHUNTV" "$MUX1_BUSV"
#printf "%f\n" "$MUX1_BUSV"

done

echo ${SHUNTV_ARRAY[@]}
echo ${BUSV_ARRAY[@]}
