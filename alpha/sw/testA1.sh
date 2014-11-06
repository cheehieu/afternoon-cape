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

#Constants
SHUNTV_COUNT=10
BUSV_COUNT=10
TMP_FLAG=0
AUX_INA_FLAG=0
PMDC_FLAG=0

#EVM Specific
declare -a SUPPLIES=('VDD_CORE' 'VDD_MPU' 'VDDS_DDR' 'V1_8D' 'V3_3D' 'VDDS_DDR_MEM');
declare -a RES=(0.05 0.05 0.05 0.1 0.1 0.05);
NUM_SUPPLIES=${#SUPPLIES[@]}

#Initialize INA226
i2cset -y 1 $MUX1_INA_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $MUX2_INA_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $AUX_INA_ADDR $CONFIG_REG 0x27C1 w
i2cset -y 1 $MUX1_INA_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $MUX2_INA_ADDR $CONFIG_REG 0xFF4F w
i2cset -y 1 $AUX_INA_ADDR $CONFIG_REG 0xFF4F w

#Initialize GPIO
echo 44 > /sys/class/gpio/export
echo 49 > /sys/class/gpio/export
echo 115 > /sys/class/gpio/export
echo 60 > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio44/direction
echo "out" > /sys/class/gpio/gpio49/direction
echo "out" > /sys/class/gpio/gpio115/direction
echo "out" > /sys/class/gpio/gpio60/direction
#echo 0 > /sys/class/gpio/gpio44/value
#echo 0 > /sys/class/gpio/gpio49/value
#echo 0 > /sys/class/gpio/gpio115/value
#echo 0 > /sys/class/gpio/gpio60/value

#Take voltage measurements
for ((i=0 ; i<$NUM_SUPPLIES ; i++)); do
	#Configure GPIO
	let "mux_sel0 = ($i & 0x1)"
	let "mux_sel1 = ($i & 0x2) >> 1"
	let "mux_sel2 = ($i & 0x4) >> 2"
	let "mux_sel3 = ($i & 0x8) >> 3"
	echo $mux_sel0 > /sys/class/gpio/gpio44/value
	echo $mux_sel1 > /sys/class/gpio/gpio49/value
	echo $mux_sel2 > /sys/class/gpio/gpio115/value
	echo $mux_sel3 > /sys/class/gpio/gpio60/value
	echo MUX_SEL[3-0] = $mux_sel3 $mux_sel2 $mux_sel1 $mux_sel0
	
	#Delay
	#sleep 5

	if [ "$i" -lt 16 ]; then
		#MUX1's INA226
		for ((j=0 ; j<$SHUNTV_COUNT ; j++)); do
			#Initialize INA226
			i2cset -y 1 $MUX1_INA_ADDR $CONFIG_REG 0x27C1 w
			i2cset -y 1 $MUX1_INA_ADDR $CONFIG_REG 0xFF4F w
			
			shuntv=$(i2cget -y 1 $MUX1_INA_ADDR $SHUNTV_REG w)
#			echo SHUNTV: $shuntv
			let "temp = $shuntv >> 8"
			let "temp2 = $shuntv << 8 | $temp"
			let "shuntv = $temp2 & 0xffff"
#			let "neg_test = $shuntv & 0x8000"
#			if [ "$neg_test" -gt 0 ]; then	#handle negative	
#				shuntv=0
#			fi
			shuntv=$(echo "$shuntv*0.0025" | bc)
			MUX1_SHUNTV[j]=$shuntv
#			echo SHUNTV:${MUX1_SHUNTV[j]}
		done
		for ((k=0 ; k<$BUSV_COUNT ; k++)); do
			#Initialize INA226
			i2cset -y 1 $MUX2_INA_ADDR $CONFIG_REG 0x27C1 w
			i2cset -y 1 $MUX2_INA_ADDR $CONFIG_REG 0xFF4F w
			
			busv=$(i2cget -y 1 $MUX1_INA_ADDR $BUSV_REG w)
			let "temp = $busv >> 8"
			let "temp2 = $busv << 8 | $temp"
			let "busv = $temp2 & 0xffff"
			busv=$(echo "$busv*0.00125" | bc)
			MUX1_BUSV[k]=$busv
		done
		#Average all values and store
		shuntv_sum=0
		x=0
		for l in "${MUX1_SHUNTV[@]}"; do
			shuntv_sum=$(echo "$shuntv_sum+${MUX1_SHUNTV[$x]}" | bc)
			let "x=$x+1"
		done
		busv_sum=0
		x=0
		for m in "${MUX1_BUSV[@]}"; do
			busv_sum=$(echo "$busv_sum+${MUX1_BUSV[$x]}" | bc)
			let "x=$x+1"
		done
		SUPPLIES_SHUNTV[i]=$(echo "$shuntv_sum / $SHUNTV_COUNT" | bc -l)
		SUPPLIES_BUSV[i]=$(echo "$busv_sum/$BUSV_COUNT" | bc -l)
	else
		#MUX2's INA226
		for ((j=0 ; j<$SHUNTV_COUNT ; j++)); do
			shuntv=$(i2cget -y 1 $MUX2_INA_ADDR $SHUNTV_REG w)
			let "temp = $shuntv >> 8"
			let "temp2 = $shuntv << 8 | $temp"
			let "shuntv = $temp2 & 0xffff"
			shuntv=$(echo "$shuntv*0.0025" | bc)
			MUX2_SHUNTV[j]=$shuntv
		done
		for ((k=0 ; k<$BUSV_COUNT ; k++)); do
			busv=$(i2cget -y 1 $MUX1_INA_ADDR $BUSV_REG w)
			let "temp = $busv >> 8"
			let "temp2 = $busv << 8 | $temp"
			let "busv = $temp2 & 0xffff"
			busv=$(echo "$busv*0.00125" | bc)
			MUX2_BUSV[$k]=$busv
		done
		#Average all values and store
		shuntv_sum=0
		x=0
		for l in "${MUX2_SHUNTV[@]}"; do
			shuntv_sum=$(echo "$shuntv_sum+${MUX2_SHUNTV[$x]}" | bc)
			let "x=$x+1"
		done
		busv_sum=0
		x=0
		for m in "${MUX2_BUSV[@]}"; do
			busv_sum=$(echo "$busv_sum+${MUX2_BUSV[$x]}" | bc)
			let "x=$x+1"
		done
		SUPPLIES_SHUNTV[i]=$(echo "$shuntv_sum/$SHUNTV_COUNT" | bc -l)
		SUPPLIES_BUSV[i]=$(echo "$busv_sum/$BUSV_COUNT" | bc -l)
	fi
done

#i2cset -y 1 $AUX_INA_ADDR $CONFIG_REG 0x27C1 w
#i2cset -y 1 $AUX_INA_ADDR $CONFIG_REG 0xFF4F w

#Calculate power
for ((i=0 ; i<$NUM_SUPPLIES ; i++)); do
	SUPPLIES_CURRENT[i]=$(echo "${SUPPLIES_SHUNTV[i]}/${RES[i]}" | bc -l)
	SUPPLIES_POWER[i]=$(echo "${SUPPLIES_CURRENT[i]}*${SUPPLIES_BUSV[i]}" | bc -l)
	echo ${SUPPLIES_CURRENT[i]} ${SUPPLIES_POWER[i]}
done
total_power=0
x=0
for n in "${SUPPLIES_POWER[@]}"; do
	total_power=$(echo "$total_power+${SUPPLIES_POWER[$x]}" | bc)
	let "x=$x+1"
done


#Output to console, log file
for ((i=0 ; i<$NUM_SUPPLIES ; i++)); do
	printf "%f %f\n" "${SUPPLIES_SHUNTV[i]}" "${SUPPLIES_BUSV[i]}"
done
printf "\n\nTotal Power (mW): %f\n" "$total_power"


#Cleanup
echo 44 > /sys/class/gpio/unexport
echo 49 > /sys/class/gpio/unexport
echo 115 > /sys/class/gpio/unexport
echo 60 > /sys/class/gpio/unexport

