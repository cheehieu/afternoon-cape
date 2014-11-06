#!/bin/bash

#INA226 Registers
CONFIG_REG=0x0
SHUNTV_REG=0x1
BUSV_REG=0x2
POWER_REG=0x3
CURRENT_REG=0x4
CALIB_REG=0x5

#Constants
SHUNTV_COUNT=15
BUSV_COUNT=3

#EVM Specific
declare -a INA_ADDRS=(0x40 0x41 0x42 0x43 0x44 0x45 0x46 0x47 0x48 0x49 0x4a 0x4b);
declare -a SUPPLIES=('VDD_DSPEVE  ' 'VDD_MPU     ' '1V35_DDR    ' 'VDDA_1V8_PLL' 'VDD_GPU     ' 'VUSB3V3;
#declare -a SUPPLIES=('VDD_DSPEVE' 'VDD_MPU' '1V35_DDR' 'VDDA_1V8_PLL' 'VDD_GPU' 'VUSB3V3' 'VDDS18V' 'VD;
declare -a RES=(0.001 0.001 0.005 0.01 0.002 0.01 0.01 0.001 0.002 0.002 0.005 0.01);
NUM_SUPPLIES=${#SUPPLIES[@]}


#Reset and initialize INA226
#for ((i=0 ; i<$NUM_SUPPLIES ; i++)); do
#       i2cset -y 1 ${INA_ADDRS[i]} $CONFIG_REG 0x27C1 w
#       i2cset -y 1 ${INA_ADDRS[i]} $CONFIG_REG 0x0080 w
#       i2cset -y 1 ${INA_ADDRS[i]} $CONFIG_REG 0xFF4F w
#       i2cset -y 1 ${INA_ADDRS[i]} $CONFIG_REG 0x9746 w
#done


#Iterate over all supplies
for ((i=0 ; i<$NUM_SUPPLIES ; i++)); do
        #Take shunt voltage measurements
        for ((j=0 ; j<$SHUNTV_COUNT ; j++)); do
                #Re-initialize INA226
                i2cset -y 1 ${INA_ADDRS[i]} $CONFIG_REG 0x0080 w
                i2cset -y 1 ${INA_ADDRS[i]} $CONFIG_REG 0xFF4F w
                shuntv=$(i2cget -y 1 ${INA_ADDRS[i]} $SHUNTV_REG w)
                let "temp = shuntv >> 8"
                let "temp2 = shuntv << 8 | $temp"
                let "shuntv = $temp2 & 0xffff"
                let "neg_test = $shuntv & 0x8000"
                if [ "$neg_test" -gt 0 ]; then  #handle negative
                        shuntv=0
                fi
                shuntv=$(echo "$shuntv*0.0025" | bc)
                COLLECTED_SHUNTV[j]=$shuntv
        done

        #Take bus voltage measurements
        for ((k=0 ; k<$BUSV_COUNT ; k++)); do
                #Re-initialize INA226
                i2cset -y 1 ${INA_ADDRS[i]} $CONFIG_REG 0x0080 w
                i2cset -y 1 ${INA_ADDRS[i]} $CONFIG_REG 0xFF4F w
                busv=$(i2cget -y 1 ${INA_ADDRS[i]} $BUSV_REG w)
                let "temp = $busv >> 8"
                let "temp2 = $busv << 8 | $temp"
                let "busv = $temp2 & 0xffff"
                busv=$(echo "$busv*0.00125" | bc)
                COLLECTED_BUSV[k]=$busv
        done

        #Average all values and store
        shuntv_sum=0
        x=0
        for l in "${COLLECTED_SHUNTV[@]}"; do
                shuntv_sum=$(echo "$shuntv_sum+${COLLECTED_SHUNTV[$x]}" | bc)
                let "x=$x+1"
        done
        busv_sum=0
        x=0
        for m in "${COLLECTED_BUSV[@]}"; do
                busv_sum=$(echo "$busv_sum+${COLLECTED_BUSV[$x]}" | bc)
                let "x=$x+1"
        done
        SUPPLIES_SHUNTV[i]=$(echo "$shuntv_sum/$SHUNTV_COUNT" | bc -l)
        SUPPLIES_BUSV[i]=$(echo "$busv_sum/$BUSV_COUNT" | bc -l)
done


#Calculate power
for ((i=0 ; i<$NUM_SUPPLIES ; i++)); do
        SUPPLIES_CURRENT[i]=$(echo "${SUPPLIES_SHUNTV[i]}/${RES[i]}" | bc -l)
        SUPPLIES_POWER[i]=$(echo "${SUPPLIES_CURRENT[i]}*${SUPPLIES_BUSV[i]}" | bc -l)
        #echo ${SUPPLIES_CURRENT[i]} ${SUPPLIES_POWER[i]}
done
total_power=0
x=0
for n in "${SUPPLIES_POWER[@]}"; do
        total_power=$(echo "$total_power+${SUPPLIES_POWER[$x]}" | bc)
        let "x=$x+1"
done


#Output to console, log file
printf "Supply\t\tRes (ohm)\tShunt (mV)\tBus (V)\t\tCurrent (mA)\tPower (mW)\n"
for ((i=0 ; i<$NUM_SUPPLIES ; i++)); do
        printf "%s\t%.3f\t\t%f\t%f\t%f\t%f\n" "${SUPPLIES[i]}" "${RES[i]}" "${SUPPLIES_SHUNTV[i]}" "${SU"
done

#Output shunt and bus voltages for copy/paste into spreadsheet
#for ((i=0 ; i<$NUM_SUPPLIES ; i++)); do
#       printf "%f %f\n" "${SUPPLIES_SHUNTV[i]}" "${SUPPLIES_BUSV[i]}"
#done

printf "\n\t\t\t\t\t\t\tTotal Power (mW):\t%f\n" "$total_power"

