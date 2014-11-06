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
INA1_SHUNTV=$(echo "$INA1_SHUNTV*0.0025" | bc)
INA1_BUSV=$(i2cget -y 1 $INA1_ADDR $BUSV_REG w)
let "temp = $INA1_BUSV >> 8"
let "temp2 = $INA1_BUSV << 8 | $temp"
let "INA1_BUSV = $temp2 & 0xffff"
INA1_BUSV=$(echo "$INA1_BUSV*0.00125" | bc)

#INA2
INA2_SHUNTV=$(i2cget -y 1 $INA2_ADDR $SHUNTV_REG w)
let "temp = $INA2_SHUNTV >> 8"
let "temp2 = $INA2_SHUNTV << 8 | $temp"
let "INA2_SHUNTV = $temp2 & 0xffff"
INA2_SHUNTV=$(echo "$INA2_SHUNTV*0.0025" | bc)
INA2_BUSV=$(i2cget -y 1 $INA2_ADDR $BUSV_REG w)
let "temp = $INA2_BUSV >> 8"
let "temp2 = $INA2_BUSV << 8 | $temp"
let "INA2_BUSV = $temp2 & 0xffff"
INA2_BUSV=$(echo "$INA2_BUSV*0.00125" | bc)

#INA3
INA3_SHUNTV=$(i2cget -y 1 $INA3_ADDR $SHUNTV_REG w)
let "temp = $INA3_SHUNTV >> 8"
let "temp2 = $INA3_SHUNTV << 8 | $temp"
let "INA3_SHUNTV = $temp2 & 0xffff"
INA3_SHUNTV=$(echo "$INA3_SHUNTV*0.0025" | bc)
INA3_BUSV=$(i2cget -y 1 $INA3_ADDR $BUSV_REG w)
let "temp = $INA3_BUSV >> 8"
let "temp2 = $INA3_BUSV << 8 | $temp"
let "INA3_BUSV = $temp2 & 0xffff"
INA3_BUSV=$(echo "$INA3_BUSV*0.00125" | bc)

#INA4
INA4_SHUNTV=$(i2cget -y 1 $INA4_ADDR $SHUNTV_REG w)
let "temp = $INA4_SHUNTV >> 8"
let "temp2 = $INA4_SHUNTV << 8 | $temp"
let "INA4_SHUNTV = $temp2 & 0xffff"
INA4_SHUNTV=$(echo "$INA4_SHUNTV*0.0025" | bc)
INA4_BUSV=$(i2cget -y 1 $INA4_ADDR $BUSV_REG w)
let "temp = $INA4_BUSV >> 8"
let "temp2 = $INA4_BUSV << 8 | $temp"
let "INA4_BUSV = $temp2 & 0xffff"
INA4_BUSV=$(echo "$INA4_BUSV*0.00125" | bc)

#INA5
INA5_SHUNTV=$(i2cget -y 1 $INA5_ADDR $SHUNTV_REG w)
let "temp = $INA5_SHUNTV >> 8"
let "temp2 = $INA5_SHUNTV << 8 | $temp"
let "INA5_SHUNTV = $temp2 & 0xffff"
INA5_SHUNTV=$(echo "$INA5_SHUNTV*0.0025" | bc)
INA5_BUSV=$(i2cget -y 1 $INA5_ADDR $BUSV_REG w)
let "temp = $INA5_BUSV >> 8"
let "temp2 = $INA5_BUSV << 8 | $temp"
let "INA5_BUSV = $temp2 & 0xffff"
INA5_BUSV=$(echo "$INA5_BUSV*0.00125" | bc)

#INA6
INA6_SHUNTV=$(i2cget -y 1 $INA6_ADDR $SHUNTV_REG w)
let "temp = $INA6_SHUNTV >> 8"
let "temp2 = $INA6_SHUNTV << 8 | $temp"
let "INA6_SHUNTV = $temp2 & 0xffff"
INA6_SHUNTV=$(echo "$INA6_SHUNTV*0.0025" | bc)
INA6_BUSV=$(i2cget -y 1 $INA6_ADDR $BUSV_REG w)
let "temp = $INA6_BUSV >> 8"
let "temp2 = $INA6_BUSV << 8 | $temp"
let "INA6_BUSV = $temp2 & 0xffff"
INA6_BUSV=$(echo "$INA6_BUSV*0.00125" | bc)

#AUX INA226
AUX_SHUNTV=$(i2cget -y 1 $AUX_INA_ADDR $SHUNTV_REG w)
let "temp = $AUX_SHUNTV >> 8"
let "temp2 = $AUX_SHUNTV << 8 | $temp"
let "AUX_SHUNTV = $temp2 & 0xffff"
AUX_SHUNTV=$(echo "$AUX_SHUNTV*0.0025" | bc)
AUX_BUSV=$(i2cget -y 1 $AUX_INA_ADDR $BUSV_REG w)       
let "temp = $AUX_BUSV >> 8"
let "temp2 = $AUX_BUSV << 8 | $temp"
let "AUX_BUSV = $temp2 & 0xffff"
AUX_BUSV=$(echo "$AUX_BUSV*0.00125" | bc)


#Calculate power



#Output to console, log file
printf "INA1 Shunt Voltage (mV):\t%f\n" "$INA1_SHUNTV"
printf "INA1 Bus Voltage (V):\t\t%f\n" "$INA1_BUSV"
printf "INA2 Shunt Voltage (mV):\t%f\n" "$INA2_SHUNTV"
printf "INA2 Bus Voltage (V):\t\t%f\n" "$INA2_BUSV"
printf "INA3 Shunt Voltage (mV):\t%f\n" "$INA3_SHUNTV"
printf "INA3 Bus Voltage (V):\t\t%f\n" "$INA3_BUSV"
printf "INA4 Shunt Voltage (mV):\t%f\n" "$INA4_SHUNTV"
printf "INA4 Bus Voltage (V):\t\t%f\n" "$INA4_BUSV"
printf "INA5 Shunt Voltage (mV):\t%f\n" "$INA5_SHUNTV"
printf "INA5 Bus Voltage (V):\t\t%f\n" "$INA5_BUSV"
printf "INA6 Shunt Voltage (mV):\t%f\n" "$INA6_SHUNTV"
printf "INA6 Bus Voltage (V):\t\t%f\n" "$INA6_BUSV"
printf "AUX Shunt Voltage (mV):\t\t%f\n" "$AUX_SHUNTV"
printf "AUX Bus Voltage (V):\t\t%f\n\n" "$AUX_BUSV"

printf "%f,%f\n" "$INA1_SHUNTV" "$INA1_BUSV"
printf "%f,%f\n" "$INA2_SHUNTV" "$INA2_BUSV"
printf "%f,%f\n" "$INA3_SHUNTV" "$INA3_BUSV"
printf "%f,%f\n" "$INA4_SHUNTV" "$INA4_BUSV"
printf "%f,%f\n" "$INA5_SHUNTV" "$INA5_BUSV"
printf "%f,%f\n" "$AUX_SHUNTV" "$AUX_BUSV"
printf "\n\n%f,%f\n" "$INA6_SHUNTV" "$INA6_BUSV"

