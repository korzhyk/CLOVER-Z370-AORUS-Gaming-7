<p align="center">
  <img src="./misc/system.png" alt="System specs">
</p>

*Mojave nVidia webdriver not avaliable yet :cry:*
This is light configuration to run macOS smoothly. I didn't get any kernel panics science after macOS install.

# Hardaware configuration

* Intel Core i7 8700K (OC multiplier 50-50-49-49-48-48)
* Gigabyte Z370 AORUS Gaming 7
* 2×8GB Samsung M378A1K43BB2-CRC (OC 3600MHz) 
* M.2 NVME MyDigitalSSD SBX 120GB (macOS)
* PCI-e Broadcom BCM4360 WiFi ac + USB Bluetooth 4.0

# Before you start make sure you have

* Working hardware 
* Motherboard BIOS version [F11 RB][103]
* Fresh Clover with generated SMBIOS.plist *this file contains serial number so you must [genenerate][1] your own*

# BIOS/UEFI Settings
* MIT>Advanced Frequency Settings>Advanced CPU Core Settings>CFG Lock - *disabled*
* EHCI Hand-Off - *enabled*
 
# Installation

1. Create bootable Clover media
2. Download repo or release of working config
3. Unpack to your Clover bootable media `/EFI/CLOVER` and also put generated `SMBIOS.plist`
4. You are ready to install or run macOS on your Hackintosh 

# What behind

### Kexts

* [AppleALC.kext][2] - Enabling audio, with layout inject `1`
* AtherosE2200Ethernet.kext - Atheros driver for Ethernet
* IntelMausiEthernet.kext - Another intel driver for Ethernet
* Legacy_USB3.kext - This one allows to describe a physical USB ports on MOBO without patching `AppleUSBXHCIPCI.kext` to increase port limit (15).
* [Lilu.kext][3] - Just a f\*ckin great patcher, dependency of `AppleALC.kext`, *`VirtualSMC.kext`* and `WhateverGreen.kext`
* SMCProcessor.kext - Kext for processor sensors, bundled with `VirtualSMC.kext`
* [VirtualSMC.kext][4] - A advanced replacement of FakeSMC, almost like native mac SMC.
* [WhateverGreen.kext][5] - Need for GPU support

### EFI drivers

* ApfsDriverLoader-64.efi - Must have to run 10.14+
* AptioMemoryFix-64.efi - Must have to run macOS
* VBoxHfs-64.efi - Must have to run 10.13-
* VirtualSmc.efi - Bundled with `VirtualSMC.kext`. Disabled in Clover, needed if you use File Vault 2 or [authrestart][6].

# Issues

1. There an issue with USB drives after sleep, system warning about not properly unmounted storage device. This happens when I'm overclock memory modules. And need two times mouse clicks to get the desktop (but this resolved by boot arg `darkwake=0`).
2. The limit of USB ports is `15` but there counts not only physical but also protocol based. So if one physical port can be used by two protocols such as 3.0 (SS) and 2.0 (HS) in this way in system he actually own two of fifteen addresses (eg. HS01/SS01). The real USB mapping you can see on this [picture][102]. Due this limits I didn't describe a `HS08` port in `Legacy_USB3.kext` but if you need this USB 2.0 header to work you can drop USB 3.0 protocol on another port. And keep in mind USB 3.1 ports such as Type-C, Type-A and header provided by ASMedia controller and discovered like independent device by system without problems.

# USB ports mapping

| USB 2.0   |          | USB 3.0   |          |
|-----------|----------|-----------|----------|
| Port NAME | Port ADR | Port NAME | Port ADR |
| HS04      | 4        | SS08      | 20       |
| HS03      | 3        | SS07      | 19       |
| HS06      | 6        | SS10      | 22       |
| HS05      | 5        | SS09      | 21       |
| HS02      | 2        | SS06      | 18       |
| Headers   |          |           |          |
| HS01      | 1        | SS05      | 17       |
| HS09      | 9        |           |          |
| HS10      | 10       |           |          |
| HS07      | 7        |           |          |
| ~HS08~    | ~8~      |           |          |

# Chnagelog
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
