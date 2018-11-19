/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180810 (32-bit version)
 * Copyright (c) 2000 - 2018 Intel Corporation
 *
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of G:/EFI/CLOVER/OEM/Z370 AORUS Gaming 7/ACPI/patched/SSDT-8-USBx.aml, Thu Sep 20 17:33:43 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000147 (327)
 *     Revision         0x02
 *     Checksum         0x79
 *     OEM ID           "ALASKA"
 *     OEM Table ID     "USBX"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180427 (538444839)
 */
DefinitionBlock ("", "SSDT", 2, "ALASKA", "USBX", 0x00000000)
{
    External (UMAP, IntObj)
    External (HUBC, IntObj)

    Scope (_SB)
    {
        Device (USBX)
        {
            Name (_ADR, Zero)  // _ADR: Address
            Method (_INI, 0, NotSerialized)  // _INI: Initialize
            {
                UMAP = 0x3F     // SuperSpeed mask [1]
                HUBC = 0x3C80   // HighSpeed mask [0]
            }

            Method (XDSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                        0x03                                             // .
                    })
                }

                Return (Package (0x08)
                {
                    "kUSBSleepPowerSupply",
                    0x13EC,
                    "kUSBSleepPortCurrentLimit",
                    0x0834,
                    "kUSBWakePowerSupply",
                    0x13EC,
                    "kUSBWakePortCurrentLimit",
                    0x0834
                })
            }
        }
    }
}

