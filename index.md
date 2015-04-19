---
layout: project
title: afternoon-cape
subtitle: A low-cost power monitoring cape for the BeagleBone Black.
---

<img src="http://niftyhedgehog.com/afternoon-cape/images/pmcape_lcd.jpg">

## Overview
The AfternoonCape is a low-cost power monitoring (PM aka "afternoon") cape for the BeagleBone Black. It utilizes the INA226 instrumentation amplifier to accurately sample and monitor voltage, current, and power consumption of a given supply. This cape was created because of a need to quickly measure the active/leakage power of TI Sitara processors, without the use of hefty digital multimeter lab equipment. The AfternoonCape is a portable, relatively low-cost (~$20) solution and meets the accuracy and sampling rate requirements for my power characterization purposes.

This repository contains:

* Altium libraries, schematics, and board files
* PCB gerbers and drill files
* Bill of materials
* Standalone Bash scripts, Linux device drivers for INA226, TMP441
* GUI source, logging infrastructure

## Hardware
The AfternoonCape relies on special techniques and assumptions used for measuring power using current shunt monitors. For more information on current shunt monitors, please review this great application note: [Current Shunt Monitors](http://www.ti.com/lit/ml/slyb194a/slyb194a.pdf). 

<img src="http://niftyhedgehog.com/afternoon-cape/images/capes_display.jpg">

A few different board revisions were designed to test the accuracy/reliability of different signal path implementations. These "Alpha" revisions were comprised of the following: 

* *Rev. A1*: supports 32 channel inputs --> 4 discrete 16-to-1 analog muxes --> 2 instrumentation amplifiers sampling the voltage drop across a current shunt
* *Rev. A2*: supports 32 channel inputs --> 2 differential 16-to-1 analog muxes --> 2 instrumentation amplifiers sampling the voltage drop across a current shunt
* *Rev. A3*: supports 12 channel inputs --> 12 dedicated instrumentation amplifiers sampling the voltage drop across each current shunt --> LCD output


### Rev. A1:
This revision supports 32 channel inputs, which means it can measure the power consumption from 32 separate power supplies. The TI Sitara processors have advanced power designs to enable key power management techniques. One such technique is having several voltage and power domains, which can be individually turned off during periods of low activity (to save power). This type of design leads to a single-core processor having upwards of thirty separate power supplies. Thus, in order to measure total device power with voltage domain granularity, it is imperative that the measurement tool supports a sufficient amount of channel inputs.

Rev. A1 accomplishes this by utilizing the Texas Instruments CD74HC4067 16-channel analog multiplexer. This cape uses four of them to be exact. Four BBB GPIO's are interfaced to the mux select bits, which allow the proper analog signals to pass to the two INA2226's. Each INA226 handles 16 input channels. So, in order to take a total device power measurement, the cape must cycle through the mux select bits and log power data for each iteration.

<img src="http://niftyhedgehog.com/afternoon-cape/images/pmcape_A1_oshpark_bottom.png" width="400">

Details:

* MUX_SEL0 (P8, pin 12), GPIO1_12 (0x44e10830, 0x30 offset, #44)
* MUX_SEL1 (P9, pin 23), GPIO1_17 (0x44e10844, 0x44 offset, #49)
* MUX_SEL2 (P9, pin 27), GPIO3_19 (0x44e109a4, 0x1a4 offset, #115)
* MUX_SEL3 (P9, pin 12), GPIO1_28 (0x44e10878, 0x78 offset, #60)
* INA_42 handles channels 0 through 15
* INA_43 handles channels 16 through 31
* Accuracy +/- %

### Rev. A2:
This revision also supports 32 channel inputs, but utilizes the Analog Devices ADG726 dual 16-channel analog multiplexer. The unique feature about the ADI mux vs. the TI mux is that the ADI mux can support differential operation. Thus, paired current shunt analog signals can be passed together through the same ICs. Also, only 2 of these muxes are needed due to its differential nature. The only major downside is that these ADG726 components are significantly more expensive than the TI counterpart.

Rev. A2 utilizes the same BBB GPIO control signals as mux select bits. Two INA226's are also used to measure data from 32 channel inputs.

<img src="http://niftyhedgehog.com/afternoon-cape/images/pmcape_A2_oshpark_bottom.png" width="400">

Details:

* MUX_SEL0 (P8, pin 12)
* MUX_SEL1 (P9, pin 23)
* MUX_SEL2 (P9, pin 27)
* MUX_SEL3 (P9, pin 12)
* INA_42 handles channels 0 through 15
* INA_43 handles channels 16 through 31
* Accuracy +/- %

### Rev. A3:
This revision utilizes discrete INA226s for each channel input. It only supports 12 channels in total, but can take these power measurements simultaneously; no GPIO mux selects need to be cycled through before taking a measurement. With less channel inputs, there is routing space available for an LCD connector. The Newhaven Display International NHD-2.4-240320SF-CTXL#-FTN1 2.4" TFT LCD module was selected due to its small size and compatibility with the AM335x processor.

<img src="http://niftyhedgehog.com/afternoon-cape/images/pmcape_A3_oshpark_bottom.png" width="400">

<img src="http://niftyhedgehog.com/afternoon-cape/images/pmcape_board.jpg" width="400">

Details:

* INA42-INA4F handles channels 0 through 11
* Accuracy +/- %


### Rev. B1:
After testing all three Alpha revisions, it was determined that the TI analog mux (Rev. A1) was sufficiently accurate for active power characterization purposes. The Beta revision is a board shrink that incorporates lessons learned.

<!--img src="http://niftyhedgehog.com/afternoon-cape/images/pmcape_B1_oshpark_top.png" width="400"-->

<!--img src="http://niftyhedgehog.com/afternoon-cape/images/pmcape_B1_oshpark_bottom.png" width="400"-->

Details:

* Smaller vias
* Decoupling caps
* 16-channel
* LCD connector
* FTDI connector for serial communication with a host PC
* AUX INA226 for dedicated system input power measurement
* PMDC connector brings out signals for daisy chaining with PMDC daughter cards
* TMP441 for thermal diode junction temperature monitoring


## Software

### Standalone Bash Script
The standalone Bash script is the quick way to generate power numbers in a single instance. The script can be executed in a shell terminal on the BeagleBone Black running an Arago distribution. The following is a high-level procedure for taking power measurements with the AfternoonCape:

1. Initialize INA226, GPIOs
2. Take shunt and bus voltage measurements for all supplies
3. Average the measurement values and store
4. Calculate power
5. Output to console and/or log file
6. Cleanup

```bash
...
#EVM Specific
declare -a SUPPLIES=('VDD_CORE' 'VDD_MPU' 'VDDS_DDR' 'V1_8D' 'V3_3D' 'VDDS_DDR_M
EM');
declare -a RES=(0.05 0.05 0.05 0.1 0.1 0.05);

...

echo $mux_sel0 > /sys/class/gpio/gpio44/value
echo $mux_sel1 > /sys/class/gpio/gpio49/value
echo $mux_sel2 > /sys/class/gpio/gpio115/value
echo $mux_sel3 > /sys/class/gpio/gpio60/value

...

#Collect shunt voltage measurement
shuntv=$(i2cget -y 1 $MUX1_INA_ADDR $SHUNTV_REG w)
let "temp = $shuntv >> 8"
let "temp2 = $shuntv << 8 | $temp"
let "shuntv = $temp2 & 0xffff"
shuntv=$(echo "$shuntv*0.0025" | bc)
MUX1_SHUNTV[j]=$shuntv

...

#Collect bus voltage measurement
busv=$(i2cget -y 1 $MUX1_INA_ADDR $BUSV_REG w)
let "temp = $busv >> 8"
let "temp2 = $busv << 8 | $temp"
let "busv = $temp2 & 0xffff"
busv=$(echo "$busv*0.00125" | bc)
MUX1_BUSV[k]=$busv

...

#Calculate power
SUPPLIES_CURRENT[i]=$(echo "${SUPPLIES_SHUNTV[i]}/${RES[i]}" | bc -l)
SUPPLIES_POWER[i]=$(echo "${SUPPLIES_CURRENT[i]}*${SUPPLIES_BUSV[i]}" |
total_power=$(echo "$total_power+${SUPPLIES_POWER[$x]}" | bc)
```

#### Usage:
```bash
root@beaglebone:~# ./testA2.sh
```

* loadmod afternoon-cape.ko EVM=am437xGP.txt
* Bash shell scripts using sysfs GPIO
* PMDC I2C protocol

### Accuracy
The afternoon-cape is a good, low-cost solution for getting "ballpark" power measurements. It works best in medium power use cases, where the current shunt voltage is >1mV; voltages on the micro-volt level are less accurately interpreted through the analog mux.
Some tests were done on the AM335x GP EVM to determine accuracy. Compared with a $1000+ Keithley Digital Multimeter with a $500 switching multiplexer module, the accuracy was comparable.
* Table comparison

## 3D CAD
<iframe width="640" height="480" src="https://sketchfab.com/models/0be9d541e4cb438f95a222904efbc644/embed" frameborder="0" allowfullscreen mozallowfullscreen="true" webkitallowfullscreen="true" onmousewheel=""></iframe>

<p style="font-size: 13px; font-weight: normal; margin: 5px; color: #4A4A4A;">
    <a href="https://sketchfab.com/models/0be9d541e4cb438f95a222904efbc644?utm_source=oembed&utm_medium=embed&utm_campaign=0be9d541e4cb438f95a222904efbc644" target="_blank" style="font-weight: bold; color: #1CAAD9;">Afternoon Cape Rev. A3</a>
    by <a href="https://sketchfab.com/hieu?utm_source=oembed&utm_medium=embed&utm_campaign=0be9d541e4cb438f95a222904efbc644" target="_blank" style="font-weight: bold; color: #1CAAD9;">hieu</a>
    on <a href="https://sketchfab.com?utm_source=oembed&utm_medium=embed&utm_campaign=0be9d541e4cb438f95a222904efbc644" target="_blank" style="font-weight: bold; color: #1CAAD9;">Sketchfab</a>
</p>

## To Do:
* Complete design for Rev. B, assemble & test
* Ensure script compatibility with latest v3.14 kernel
* Cost comparison with other *more expensive* solutions (DARA, ACME, PMDC, Spectrum Digital, Tick)
* Qt GUI and data logging over a network connection to a host PC
* Update README with Accuracy and BOM materials
