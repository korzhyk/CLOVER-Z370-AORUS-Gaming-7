# Hackintosh on Gigabyte Z370 AORUS Gaming 7

<p align="center">
  <img src="./misc/system.png" alt="System specs">
</p>

*Mojave nVidia webdriver not avaliable yet :cry:*
This is light configuration to run macOS smoothly. I didn't get any kernel panics science after macOS install.

## Hardware configuration

* Intel Core i7 8700K
* Gigabyte Z370 AORUS Gaming 7
* 4×8GB Samsung M378A1K43CB2-CRC (OC 3200MHz)
* M.2 NVME MyDigitalSSD SBX 120GB (macOS)
* PCI-e Broadcom BCM4360 WiFi ac + USB Bluetooth 4.0

## Before you start make sure you have

* Working hardware 
* Motherboard BIOS version [F11 RB][103]
* Fresh Clover with generated SMBIOS.plist *this file contains serial number so you must [genenerate][1] your own*

 
# Installation

## BIOS Settings
* *MIT* → Advanced Frequency Settings → Advanced CPU Core Settings → CFG Lock : **Disabled**
* *Peripherals* → USB Configuration → XHCI Hand-off : **Enabled**
* *Peripherals* → Initial Display Output : **PCIe 1 Slot**

## What's behind the scenes

### Kexts

* [AppleALC.kext][2] - Enabling audio, with layout inject `1`
* AtherosE2200Ethernet.kext - Atheros driver for Ethernet
* IntelMausiEthernet.kext - Another intel driver for Ethernet
* [Lilu.kext][3] - Just a f\*ckin great patcher, dependency of `AppleALC.kext`, *`VirtualSMC.kext`* and `WhateverGreen.kext`
* SMCProcessor.kext - Kext for processor sensors, bundled with `VirtualSMC.kext`
* SMCSuperIO.kext - Kext for reading SuperIO devices, bundled with `VirtualSMC.kext`
* [VirtualSMC.kext][4] - A advanced replacement of FakeSMC, almost like native mac SMC.
* [WhateverGreen.kext][5] - Need for GPU support

### EFI drivers

* ApfsDriverLoader-64.efi - Must have to run 10.14+
* AptioMemoryFix-64.efi - Must have to work with native NVRAM
* VBoxHfs-64.efi - Must have to run 10.13-
* VirtualSmc.efi - Bundled with `VirtualSMC.kext`. Disabled in Clover, needed if you use File Vault 2 or [authrestart][6].

## Issues

1. There is an issue with USB drives after sleep: the system warns about not properly unmounted storage device. This happens when I overclock the memory modules. And, I need two times mouse clicks to get the desktop (but this resolved by boot arg `darkwake=0`).
2. The limit of USB ports is `15` but it counts not only physical but also protocol based. So if one physical port can be used by two protocols such as 3.0 (SS) and 2.0 (HS), in this way in system he actually own two of fifteen addresses (eg. HS01/SS01). You can see the real USB mapping in this [picture][102]. Due to these limits I didn't enable a `HS08` port in `SSDT-8-USBx.aml` table, but if you need this USB 2.0 header to work, you can drop the USB 3.0 protocol on another port. And keep in mind USB 3.1 ports such as Type-C, Type-A and header provided by ASMedia are controller and discovered like independent devices by system without problems.

## USB ports mapping

| USB 2.0   |          | USB 3.0   |          |
|-----------|----------|-----------|----------|
| Port NAME | Port ADR | Port NAME | Port ADR |
| HS02      | 2        | SS02      | 12       |
| HS03      | 3        | SS03      | 13       |
| HS04      | 4        | SS04      | 14       |
| HS05      | 5        | SS05      | 15       |
| HS06      | 6        | SS06      | 16       |
| Headers   |          |           |          |
| HS01      | 1        | SS01      | 11       |
| HS07      | 7        |           |          |
| ~HS08~    | ~8~      |           |          |
| HS09      | 9        |           |          |
| HS10      | 10       |           |          |

## Chnagelog
###### 20/11/2018
* Added `SMCSuperIO.kext`
* Updated kexts to newest versions
* Recompiled `DSDT` with external references
###### 19/11/2018
* Updated ACPI-tables to [F11 BIOS][103] version
* Use SSDT to define ~working~ ports
* Removed `Legacy_USB3.kext`
* Updated table of [USB mapping][#usb-ports-mapping]
* Updated README
###### 16/11/2018
* Added new F11 BIOS version with `CFG Lock` option.
###### 7/10/2018
* Rewrited audio `layout-id` injection.
###### 13/09/2018
* The initial push to GitHub

[1]: http://cloudclovereditor.altervista.org/cce/editor.php#smbios
[2]: https://github.com/acidanthera/AppleALC
[3]: https://github.com/acidanthera/Lilu
[4]: https://github.com/acidanthera/VirtualSMC
[5]: https://github.com/acidanthera/WhateverGreen
[6]: https://lifehacker.com/bypass-a-filevault-password-at-startup-by-rebooting-fro-1686770324

[101]: ./misc/system.png
[102]: ./misc/physical-usb-ports.png
[103]: ./misc/Z370AORUSGaming7_CFG-Lock.F11
