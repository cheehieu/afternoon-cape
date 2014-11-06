#!/bin/bash

INA0_ADDR=0x40
INA1_ADDR=0x41
INA2_ADDR=0x42
INA3_ADDR=0x43
INA4_ADDR=0x44
INA5_ADDR=0x45
INA6_ADDR=0x46
INA7_ADDR=0x47
INA8_ADDR=0x48
INA9_ADDR=0x49
INA10_ADDR=0x4a
INA11_ADDR=0x4b

#INA226 Registers
CONFIG_REG=0x0
SHUNTV_REG=0x1
BUSV_REG=0x2
POWER_REG=0x3
CURRENT_REG=0x4
CALIB_REG=0x5

#Constants
SHUNTV_COUNT=10
BUSV_COUNT=10

#Reset and initialize INA226
i2cset -y 1 $INA0_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $INA1_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $INA2_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $INA3_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $INA4_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $INA5_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $INA6_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $INA7_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $INA8_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $INA9_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $INA10_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $INA11_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $INA0_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $INA1_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $INA2_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $INA3_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $INA4_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $INA5_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $INA6_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $INA7_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $INA8_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $INA9_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $INA10_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $INA11_ADDR $CONFIG_REG 0xFF4F w


#Take voltage measurements
#INA0
INA0_SHUNTV=$(i2cget -y 1 $INA0_ADDR $SHUNTV_REG w)
let "temp = $INA0_SHUNTV >> 8"
let "temp2 = $INA0_SHUNTV << 8 | $temp"
let "INA0_SHUNTV = $temp2 & 0xffff"
INA0_SHUNTV=$(echo "$INA0_SHUNTV*0.0025" | bc)
INA0_BUSV=$(i2cget -y 1 $INA0_ADDR $BUSV_REG w)
let "temp = $INA0_BUSV >> 8"
let "temp2 = $INA0_BUSV << 8 | $temp"
let "INA0_BUSV = $temp2 & 0xffff"
INA0_BUSV=$(echo "$INA0_BUSV*0.00125" | bc)

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

#INA7
INA7_SHUNTV=$(i2cget -y 1 $INA7_ADDR $SHUNTV_REG w)
let "temp = $INA7_SHUNTV >> 8"
let "temp2 = $INA7_SHUNTV << 8 | $temp"
let "INA7_SHUNTV = $temp2 & 0xffff"
INA7_SHUNTV=$(echo "$INA7_SHUNTV*0.0025" | bc)
INA7_BUSV=$(i2cget -y 1 $INA7_ADDR $BUSV_REG w)
let "temp = $INA7_BUSV >> 8"
let "temp2 = $INA7_BUSV << 8 | $temp"
let "INA7_BUSV = $temp2 & 0xffff"
INA7_BUSV=$(echo "$INA7_BUSV*0.00125" | bc)

#INA8
INA8_SHUNTV=$(i2cget -y 1 $INA8_ADDR $SHUNTV_REG w)
let "temp = $INA8_SHUNTV >> 8"
let "temp2 = $INA8_SHUNTV << 8 | $temp"
let "INA8_SHUNTV = $temp2 & 0xffff"
INA8_SHUNTV=$(echo "$INA8_SHUNTV*0.0025" | bc)
INA8_BUSV=$(i2cget -y 1 $INA8_ADDR $BUSV_REG w)
let "temp = $INA8_BUSV >> 8"
let "temp2 = $INA8_BUSV << 8 | $temp"
let "INA8_BUSV = $temp2 & 0xffff"
INA8_BUSV=$(echo "$INA8_BUSV*0.00125" | bc)

#INA9
INA9_SHUNTV=$(i2cget -y 1 $INA9_ADDR $SHUNTV_REG w)
let "temp = $INA9_SHUNTV >> 8"
let "temp2 = $INA9_SHUNTV << 8 | $temp"
let "INA9_SHUNTV = $temp2 & 0xffff"
INA9_SHUNTV=$(echo "$INA9_SHUNTV*0.0025" | bc)
INA9_BUSV=$(i2cget -y 1 $INA9_ADDR $BUSV_REG w)
let "temp = $INA9_BUSV >> 8"
let "temp2 = $INA9_BUSV << 8 | $temp"
let "INA9_BUSV = $temp2 & 0xffff"
INA9_BUSV=$(echo "$INA9_BUSV*0.00125" | bc)

#INA10
INA10_SHUNTV=$(i2cget -y 1 $INA10_ADDR $SHUNTV_REG w)
let "temp = $INA10_SHUNTV >> 8"
let "temp2 = $INA10_SHUNTV << 8 | $temp"
let "INA10_SHUNTV = $temp2 & 0xffff"
INA10_SHUNTV=$(echo "$INA10_SHUNTV*0.0025" | bc)
INA10_BUSV=$(i2cget -y 1 $INA10_ADDR $BUSV_REG w)
let "temp = $INA10_BUSV >> 8"
let "temp2 = $INA10_BUSV << 8 | $temp"
let "INA10_BUSV = $temp2 & 0xffff"
INA10_BUSV=$(echo "$INA10_BUSV*0.00125" | bc)

#INA11
INA11_SHUNTV=$(i2cget -y 1 $INA11_ADDR $SHUNTV_REG w)
let "temp = $INA11_SHUNTV >> 8"
let "temp2 = $INA11_SHUNTV << 8 | $temp"
let "INA11_SHUNTV = $temp2 & 0xffff"
INA11_SHUNTV=$(echo "$INA11_SHUNTV*0.0025" | bc)
INA11_BUSV=$(i2cget -y 1 $INA11_ADDR $BUSV_REG w)
let "temp = $INA11_BUSV >> 8"
let "temp2 = $INA11_BUSV << 8 | $temp"
let "INA11_BUSV = $temp2 & 0xffff"
INA11_BUSV=$(echo "$INA11_BUSV*0.00125" | bc)


#Calculate power



#Output to console, log file
printf "%f,%f\n" "$INA0_SHUNTV" "$INA0_BUSV"
printf "%f,%f\n" "$INA1_SHUNTV" "$INA1_BUSV"
printf "%f,%f\n" "$INA2_SHUNTV" "$INA2_BUSV"
printf "%f,%f\n" "$INA3_SHUNTV" "$INA3_BUSV"
printf "%f,%f\n" "$INA4_SHUNTV" "$INA4_BUSV"
printf "%f,%f\n" "$INA5_SHUNTV" "$INA5_BUSV"
printf "%f,%f\n" "$INA6_SHUNTV" "$INA6_BUSV"
printf "%f,%f\n" "$INA7_SHUNTV" "$INA7_BUSV"
printf "%f,%f\n" "$INA8_SHUNTV" "$INA8_BUSV"
printf "%f,%f\n" "$INA9_SHUNTV" "$INA9_BUSV"
printf "%f,%f\n" "$INA10_SHUNTV" "$INA10_BUSV"
printf "%f,%f\n" "$INA11_SHUNTV" "$INA11_BUSV"


