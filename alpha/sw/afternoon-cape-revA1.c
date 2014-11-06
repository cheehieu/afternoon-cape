#include <stdio.h>

#define PMDC_INA1_ADDR	0x40
#define PMDC_INA2_ADDR	0x41
#define CAPE_INA1_ADDR	0x42
#define CAPE_INA2_ADDR	0x43
#define TMP441_ADDR	0x4C
#define AUX_INA_ADDR	0x4F

#define TI_MUX1_GPIO	0x1
#define TI_MUX2_GPIO	0x2
#define TI_MUX3_GPIO	0x3
#define TI_MUX4_GPIO	0x4
#define ADI_MUX1_GPIO	0x1
#define ADI_MUX2_GPIO	0x2

//unsigned with a -64C offset (ranges from -64 to 191C)
#define EXT_HIGH_BYTE_C_CONV(a)	a-64;
#define LOW_BYTE_C_CONV(b)	b/16*0.0625;	//b is unsigned

main() 	{
	//Initialize INA226's
	#CALIBRATION to set shunt resistor value
	#based on equation 1 in datasheet

	#CURRENT and POWER need averaging to be set in config register
	i2cset -y 1 0x40 0x00 0x2747 w	#sets config register to have averaging 64x

	//Initialize TMP441
	//extended range, conversion rate, beta compensation, n-factor correction
	i2cset -y 1 0x4c 0x9 0x04	#extended temp range
	

	//Initialize LCD and GUI (light-tft server)
	//Set capture options (frequency, select supplies to omit)
	//set display options (show history, last 30 seconds, real time,)

	//Read in EVM/*evm files
	//save values to arrays of structs

	
	//Take a power measurement
	#SHUNT VOLTAGE = DEC(msbyte_lsbyte) * 2.5 UV
	i2cget -y 1 0x40 0x01 w		#gets shunt voltage in hex 0x[lsbyte][msbyte]

	#BUS VOLTAGE = DEC(msbyte_lsbyte) * 1.25 mV
	i2cget -y 1 0x40 0x02 w		#gets bus voltage in hex 0x[lsbyte][msbyte]


	//Take a thermal measurement (remote and local)
	//show both celsius and fahrenheit
	i2cget -y 1 0x4c 0x1 w		#read lowbyteHighbyte of remote sensor
	

	//Print measurement to console in spreadsheet copy/paste format
	//Output a log
	//Output last data capture


}

