# Ender 3

I use Ender 3 3D printer which I bought in June 2018 for $238. It was upgraded with:
* July 2018:
  * Nozzle set 0.2 - 0.5mm for $7.99
* July 2019:
  * NEMA 17 Stepper motors for X and Y axis:
    * Vibration dampers - 3pcs for $5.64
    * Heat sinks 40x40x11.3mm - 5pcs for $2.48
  * Heatbed springs 8mm OD x 25mm - 5pcs for $0.99
* November 2021:
  * Glass Bed, 235x235x4mm for $15.99
  * Heater silicon cover - 3pcs for $7.89
  * NTC Thermistor sensor 100K - 5pcs for $9.89
* February 2023:
  * Silent main control board v4.2.7 with TMC2225 Driver for $39.99

## Firmware

Ender 3 was upgraded with Creality3D main board v4.2.7.  
It is also known as silent board and uses the 32-bit STM32 microcontroller instead of a standard 8-bit ATmega 1284p.

![Ender 3 board](pics/Ender3_mb_silent.jpg)

I've tried several FW and ended up with TH3D Unified 2 firmware for v4.2.7 board ([details](https://support.th3dstudio.com/helpcenter/creality-ender-3-firmware-v4-2-7-board/)).

I use [Octoprint Firmware Updater](https://github.com/OctoPrint/OctoPrint-FirmwareUpdater/blob/master/README.md) to update the printer FW.

### Firmware configuration

I prefer compiling FW using command line tools inside Python virtual environment.  
There are several parameters to setup before flashing - [Configuration.h](fw/Configuration.h)  
To build a new FW version simple run the script - [th3d_fw_build.sh](fw/th3d_fw_build.sh)
