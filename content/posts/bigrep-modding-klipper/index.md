+++
title = 'BigRep Modding Klipper'
date = 2024-08-29T16:16:36+02:00
draft = true
+++

Having to opportunity to fix and modernize a large format 3d-printer at my local makerspace sounds like a cool challenge! Especially when it's about a professional printer (with a profesisonal pricetag) that you usually don't have access to as a hobbyist.
The exact type of this printer model is unknown to me, but it is some early version of the `BigRep ONE`, probably a `BigRep ONE.3b` manufactured in 2016 or so.

## Investigating the BigRep ONE
While the newer BigRep machines come shipped with a Windows embedded PC (apparently for some motor driver compatibility reasons...) the printer I'm working on still had a linux-pc with LUbuntu 16.04 installed.
This Computer is connected via USB to a so called `BoogieBoard` which is BigRep's modified version of the OpenSource [SmoothieBoard](https://smoothieware.github.io/smoothieware-website-v1//smoothieboard-v1).
To be specific, the board in this printer had the version `Boogieboard 1 3`. The MCU does not have any stepper drivers mounted but rather sends pulses/direction signals to the external drivers (wired using the RJ45 ports).
For motion in XYZ drivers of type `Leadshine DM556` are used, while it's a `Leadshine DM442` for the extruders each.

The root password for the Linux Computer is written in the service protocol, that's great! The frontend on this PC is just a modified OctoPrint with the capability to update the modified SmoothieWare firmware running on the Boogieboard.

### Extruder
This BigRep is equipped with two extruders for 2.85mm wide filament which can be individually raised or lowered by a linear actuator. The temperature sensor is a `3-wire pt100`. 
They used the heat sink from a V6 hotend and added a custom aluminium heatblock with two 24V-50W heater elements in parallel. The nozzle is a standard volcano nozzle. Heatblock and heatsink are connected using a custom heatbreak which reaches really long into the heatblock - not optimal.

## Installing Klipper on PC
I went for a fresh install of Debian for the existing embedded PC. Since Klipper is usually run on RaspberryPis and the default username is 'pi' that is also what I went with for the installation.
Once Debian was running the [KIAUH](https://github.com/dw-0/kiauh) installer did the rest.

## Compiling Klipper for MCU
The following settings are used:
```
Micro-controller Architecture -> LPC176x (Smoothieboard)
Processor model -> lpc1769 (120 MHz)
Bootloader offset -> 16KiB bootloader (Smoothieware bootloader)
Communication interface -> USB
```


## Flashing MCU
The usual flashing procedure for SmoothieBoards is to place a `firmware.bin` file on the sd card which gets renamed to `firmware.bin` after successful flashing. BigRep modified the bootloader in such a way so that a matching `firmware.inf` file is required in addition to the `firmware.bin`.
This file only contains a CRC16-XMODEM checksum of the binary file and can be calculated using the following script and the python library [crc16](https://pypi.python.org/pypi/crc16/0.1.1).

```python
#!/usr/bin/env python3
"""
Calculates the crc value of a given file. Uses crc16 library: https://pypi.python.org/pypi/crc16/0.1.1


modified by Sandro Pischinger on 31.5.2024
    - set seed to 0xFFF (default)
    - remove unused blocksize
"""
import struct
import argparse
from crc16 import crc16xmodem


def main():
    parser = argparse.ArgumentParser(description="Calculate CRC for a given file")
    parser.add_argument('filename', help="The binary file to calculate the CRC for")
    parser.add_argument('-f', '--info_file', help='Output file for firmware metadata')

    args = parser.parse_args()

    with open(args.filename, "rb") as f:
        binData = f.read()

    crc = crc16xmodem(binData, 0xFFFF)
    print(f"CRC overall: 0x{crc:04x}")

    if args.info_file:
        with open(args.info_file, "wb") as finfo:
            finfo.write(struct.pack(">H", crc))


if __name__ == '__main__':
    main()
```

For flashing turn off the BigRep and unscrew the cover for the BoogieBoard. You should see a sd card(-holder) on the PCB right next to the bigrep logo. Place your thumb on the metal holder and gently push it to the right in order to open it. You can now remove the sd card, and place the `firmware.bin` and matching `firmware.inf` file on the sd-card using a computer.
Then insert the sd card back into the BoogieBoard and power up the machine. The firmware should now be flashed. You can confirm by either connecting to UART and check the debug output or inspect the `firmware.cur` file on the sd-card and compare it to your freshly compiled `firmware.bin`.

## Mechanical Issues

## Hardware Modifications
