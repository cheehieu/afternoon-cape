afternoon-cape
==============

Power Monitor (PM aka "Afternoon") cape for the BeagleBone Black

This repository contains:
- Altium library, schematic, and board files
- PCB gerbers and drill files
- Bill of materials
- Linux device driver for CD74HC4067, INA226, TMP441
- GUI source


Usage:
- loadmod afternoon-cape.ko EVM=am437xGP.txt


Revision History:
- Alpha releases A1 (TI mux), A2 (ADI mux), A3 (all INAs)

- A1: 
- MUX_SEL0 (P8, pin 12)
- MUX_SEL1 (P9, pin 23)
- MUX_SEL2 (P9, pin 27)
- MUX_SEL3 (P9, pin 12)
- INA_42 handles channels 0 through 15
- INA_43 handles channels 16 through 31


- A2:
- MUX_SEL0 (P8, pin 12)
- MUX_SEL1 (P9, pin 23)
- MUX_SEL2 (P9, pin 27)
- MUX_SEL3 (P9, pin 12)
- INA_42 handles channels 0 through 15
- INA_43 handles channels 16 through 31
