#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <linux/i2c-dev.h>
#include <linux/i2c.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

main() {
	printf("\nHello World!\n");
	
	int file;
	int adapter_nr = 1; 
	char filename[20];
	
	snprintf(filename, 19, "/dev/i2c-%d", adapter_nr);
	file = open(filename, O_RDWR);
	if (file < 0) {
        	exit(1);
	}

	int addr = 0x40;
	if (ioctl(file, I2C_SLAVE, addr) < 0) {
		exit(1);
	}  

  	char ina_reg = 0x0; 
    	int res;
      	char buf[10];

	// Using I2C Write, equivalent of i2c_smbus_write_word_data(file, register, 0x6543)
	buf[0] = ina_reg;
	buf[1] = 0xff;
	buf[2] = 0x4f;
	if (write(file, buf, 3) != 3) {
	}

	// Using I2C Read, equivalent of i2c_smbus_read_byte(file) 
	if (read(file, buf, 1) != 1) {
		/* ERROR HANDLING: i2c transaction failed */
	} else {
		/* buf[0] contains the read byte */
		printf("Read: 0x%04x\n", buf[0]);
	}

	res = i2c_smbus_read_word_data(file, ina_reg);
	if (res < 0) {
	} else {
		printf("Read: 0x%04x\n", res);
	}

	printf("\nGoodbye World!\n");
}

