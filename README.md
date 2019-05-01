# Hackintosh on Gigabyte Z370 AORUS Gaming 7

<p align="center">
  <img src="./misc/system.png" alt="System specs">
</p>

*Mojave nVidia webdriver not avaliable yet :cry:* :idea: But you can use a High Sierra, why not?
This is light configuration to run macOS smoothly. I didn't get any kernel panics science after macOS install.

## Hardware configuration

* Intel Core i7 8700K
* Gigabyte Z370 AORUS Gaming 7
* 4×8GB Samsung M378A1K43BB2-CRC (no OC *due to issues with USB ejection after sleep*)
* M.2 NVME MyDigitalSSD SBX 120GB (macOS)
* PCI-e Broadcom BCM4360 WiFi ac + USB Bluetooth 4.0

## Before you start make sure you have

* Working hardware
* Motherboard BIOS version [F13RB][104]
* Fresh Clover with generated SMBIOS.plist *this file contains serial number so you must [genenerate][1] your own, if you are using a external GPU use mac Model 18,3 in another cases use 18,1*


# Installation

## BIOS Settings
* *MIT* → Advanced Frequency Settings → Advanced CPU Core Settings → CFG Lock : **Disabled**
* *Peripherals* → USB Configuration → XHCI Hand-off : **Enabled**
* *Peripherals* → USB Configuration → Port 60/64 Emulation : **Disabled**
* *Peripherals* → Initial Display Output : **PCIe 1 Slot** *(Only if using external GPU)*
* *Chipset* → IOAPIC 24-119 Entries : **Disabled**

## What's behind the scenes

### Kexts

* [AppleALC.kext][2] - Enabling audio, with layout inject `16`
* AtherosE2200Ethernet.kext - Atheros driver for Ethernet
* IntelMausiEthernet.kext - Another intel driver for Ethernet
* [Lilu.kext][3] - Dependency of `AppleALC.kext`, *`VirtualSMC.kext`* and `WhateverGreen.kext`
* SMCProcessor.kext - Kext for processor sensors, bundled with `VirtualSMC.kext`
* [VirtualSMC.kext][4] - A advanced replacement of FakeSMC, almost like native mac SMC.
* [WhateverGreen.kext][5] - Need for GPU support

### EFI drivers

* ApfsDriverLoader.efi - Must have to run 10.13.6+
* AptioMemoryFix.efi - Must have to work with native NVRAM
* VBoxHfs-64.efi - Must have to run < 10.13.6
* VirtualSmc.efi - Bundled with `VirtualSMC.kext`. Needed if you use File Vault 2 or [authrestart][6].

## Issues

1. There is an issue with USB drives after sleep: the system warns about not properly unmounted storage device. This happens when I overclock the memory modules. And, I need two times mouse clicks to get the desktop (but this resolved by boot arg `darkwake=0`).
2. The limit of USB ports is `15` but it counts not only physical but also protocol based. So if one physical port can be used by two protocols such as 3.0 (SS) and 2.0 (HS), in this way in system he actually own two of fifteen addresses (eg. HS01/SS01). You can see the real USB mapping in this [picture][102]. Due to these limits I didn't enable a `HS08` port in [SSDT-10-EXT.aml](OEM/Z370%20AORUS%20Gaming%207/ACPI/patched/SSDT-10-EXT.dsl#L98) table, but if you need this USB 2.0 header to work, you can drop the USB 3.0 protocol on another port. And keep in mind USB 3.1 ports such as Type-C, Type-A and header provided by ASMedia controller.

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

## How to install *modded* BIOS

:exclamation: This is not required for using macOS. Only [F13RB][104] is enought.
:exclamation: Backup current profile to USB disk.
1. You need a `FPT.efi` from `Intel CSME System Tools v11` and in UEFI shell (you can use Clover shell aswell)
```
FPT.efi --savemac -f mod_Z370AOG7.F13RB
```
2. After this operation you must clear CMOS *just press button with black key next to DRAM slots*

3. To use `Intel® ME v11.8.60.3561` you must flash firmware from `Intel® Management(ME) 11.8.60.3561 (Firmware)`
```
FWUpdLcl64.exe -allowsv -f 11.8.60.3561.bin
```

## Chnagelog
###### 11/04/2019
* Removed drop of set SSDT tables, only keep DMAR drop (Vd-T)
* Clover config disable generate C and P states, so we can use states provided by BIOS
###### 7/04/2019
* Changed layout-id to 16
* Removed audio issue
###### 4/04/2019
* Added modded BIOS with latest drivers and microcodes
###### 1/04/2019
* Rewrite and cleanup in DSDT
* Inject devices properties through SSDT
###### 27/03/2019
* Add new DSDT compatible with [F13RB][104] bios
* Update config to use with High Sierra with nvidia GPU
###### 26/03/2019
* Add new [F13RB][104] bios with `CFG lock` option (MSR 0xE2)
###### 24/03/2019
* Fixed DSDT from F12 BIOS
* Updated EFI drivers
###### 18/03/2019
* Updated kexts to newest versions
###### 20/11/2018
* Updated kexts to newest versions
* Recompiled `DSDT` with external references
* Config can be used with only iGPU card, external GPU is disabled via `WhateverGreen.kext`
###### 19/11/2018
* Updated ACPI-tables to [F11RB][103] bios version
* Use SSDT to enable working ports
* Removed `Legacy_USB3.kext`
* Updated table of [USB mapping](#usb-ports-mapping)
* Updated README
###### 16/11/2018
* Added new F11 BIOS version with `CFG Lock` option (MSR 0xE2)
###### 7/10/2018
* Rewrited audio `layout-id` injection
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
[103]: ./misc/Z370AOG7_F11RB.zip
[104]: ./misc/Z370AOG7_F13RB.zip
