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

#Initialize GPIO
echo 44 > /sys/class/gpio/export
echo 49 > /sys/class/gpio/export
echo 115 > /sys/class/gpio/export
echo 60 > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio44/direction
echo "out" > /sys/class/gpio/gpio49/direction
echo "out" > /sys/class/gpio/gpio115/direction
echo "out" > /sys/class/gpio/gpio60/direction
echo 0 > /sys/class/gpio/gpio44/value
echo 0 > /sys/class/gpio/gpio49/value
echo 0 > /sys/class/gpio/gpio115/value
echo 0 > /sys/class/gpio/gpio60/value

#Reset and initialize INA226
i2cset -y 1 $MUX1_INA_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $MUX2_INA_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $AUX_INA_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $MUX1_INA_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $MUX2_INA_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $AUX_INA_ADDR $CONFIG_REG 0xFF4F w

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

#MUX2's INA226
MUX2_SHUNTV=$(i2cget -y 1 $MUX2_INA_ADDR $SHUNTV_REG w)
let "temp = $MUX2_SHUNTV >> 8"
let "temp2 = $MUX2_SHUNTV << 8 | $temp"
let "MUX2_SHUNTV = $temp2 & 0xffff"
MUX2_SHUNTV=$(echo "$MUX2_SHUNTV*0.0025" | bc)
MUX2_BUSV=$(i2cget -y 1 $MUX2_INA_ADDR $BUSV_REG w)
let "temp = $MUX2_BUSV >> 8"
let "temp2 = $MUX2_BUSV << 8 | $temp"
let "MUX2_BUSV = $temp2 & 0xffff"
MUX2_BUSV=$(echo "$MUX2_BUSV*0.00125" | bc)

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
echo "GPIO = 0x0"
printf "%f,%f\n" "$MUX1_INA_SHUNTV" "$MUX1_INA_BUSV"
printf "%f,%f\n" "$MUX2_INA_SHUNTV" "$MUX2_INA_BUSV"
#printf "%f,%f\n" "$AUX_SHUNTV" "$AUX_BUSV"

echo 0 > /sys/class/gpio/gpio44/value
echo 1 > /sys/class/gpio/gpio49/value
echo 0 > /sys/class/gpio/gpio115/value
echo 0 > /sys/class/gpio/gpio60/value
echo "GPIO = 0x2"

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

#MUX2's INA226
MUX2_SHUNTV=$(i2cget -y 1 $MUX2_INA_ADDR $SHUNTV_REG w)
let "temp = $MUX2_SHUNTV >> 8"
let "temp2 = $MUX2_SHUNTV << 8 | $temp"
let "MUX2_SHUNTV = $temp2 & 0xffff"
MUX2_SHUNTV=$(echo "$MUX2_SHUNTV*0.0025" | bc)
MUX2_BUSV=$(i2cget -y 1 $MUX2_INA_ADDR $BUSV_REG w)
let "temp = $MUX2_BUSV >> 8"
let "temp2 = $MUX2_BUSV << 8 | $temp"
let "MUX2_BUSV = $temp2 & 0xffff"
MUX2_BUSV=$(echo "$MUX2_BUSV*0.00125" | bc)

printf "%f %f\n" "$MUX1_INA_SHUNTV" "$MUX1_INA_BUSV"
printf "%f %f\n" "$MUX2_INA_SHUNTV" "$MUX2_INA_BUSV"

#Cleanup
echo 44 > /sys/class/gpio/unexport
echo 49 > /sys/class/gpio/unexport
echo 115 > /sys/class/gpio/unexport
echo 60 > /sys/class/gpio/unexport
