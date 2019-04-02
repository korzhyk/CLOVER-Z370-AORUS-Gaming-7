DefinitionBlock ("", "SSDT", 2, "ALASKA", "EXT", 0x00000000)
{
    External (HUBC, IntObj)
    External (UMAP, IntObj)
    External (_PR.PR00, DeviceObj)
    External (_SB.PCI0, DeviceObj)
    External (_SB.PCI0.LPCB, DeviceObj)
    External (_SB.PCI0.PPMC, DeviceObj)
    External (_SB.PCI0.SBUS, DeviceObj)
    External (_SB.PCI0.PEG0, DeviceObj)
    External (_SB.PCI0.GLAN, DeviceObj)
    External (_SB.PCI0.XHC, DeviceObj)
    External (_SB.PCI0.XHC.RHUB, DeviceObj)
    External (_SB.PCI0.SATA, DeviceObj)
    External (_SB.PCI0.RP03.PXSX, DeviceObj)  // Qualcomm Atheros Killer E2500
    External (_SB.PCI0.RP05.PXSX, DeviceObj)  // ASMedia USB 3.0 controller
    External (_SB.PCI0.RP07.PXSX, DeviceObj)  // ASMedia USB 3.0 controller
    External (_SB.PCI0.RP09.PXSX, DeviceObj)  // M.2 SSD
    External (_SB.PCI0.RP21.PXSX, DeviceObj)  // M.2 SSD
    External (_SB.PCI0.RP23.PXSX, DeviceObj)  // Broadcom WiFi module BCM43xx
    
    Method (_TTS, 1, NotSerialized)  // _TTS: Transition To State
    {
        SLTP = Arg0
    }
    
    Name (SLTP, Zero)
    OperationRegion (GPIO, SystemIO, 0x0500, 0x3C)
    Field (GPIO, ByteAcc, NoLock, Preserve)
    {
        Offset (0x0C),
        GL00,   8,
        Offset (0x2C),
            ,   1,
        GI01,   1,
            ,   1,
        GI06,   1,
        Offset (0x2D),
        GL04,   8
    }

    Method (DTGP, 5, NotSerialized)
    {
        If ((Arg0 == ToUUID ("a0b5b7c6-1318-441c-b0c9-fe695eaf949b")))
        {
            If ((Arg1 == One))
            {
                If ((Arg2 == Zero))
                {
                    Arg4 = Buffer (One)
                        {
                             0x03                                             // .
                        }
                    Return (One)
                }

                If ((Arg2 == One))
                {
                    Return (One)
                }
            }
        }

        Arg4 = Buffer (One)
            {
                 0x00                                             // .
            }
        Return (Zero)
    }
    
    Scope (_PR.PR00)
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg2 == Zero))
            {
                Return (Buffer (One)
                {
                     0x03                                             // .
                })
            }

            Return (Package (0x02)
            {
                "plugin-type",
                One
            })
        }
    }

    Scope (_SB)
    {
        Device (USBX)
        {
            Name (_ADR, Zero)  // _ADR: Address
            Method (_INI, 0, NotSerialized)  // _INI: Initialize
            {
                HUBC = 0x3C80
                UMAP = 0x3F
            }

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
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

        Device (SLPB)
        {
            Name (_HID, EisaId ("PNP0C0E") /* Sleep Button Device */)  // _HID: Hardware ID
            Name (_STA, 0x0B)  // _STA: Status
        }

        Device (PNLF)
        {
            Name (_ADR, Zero)  // _ADR: Address
            Name (_HID, EisaId ("APP0002"))  // _HID: Hardware ID
            Name (_CID, "backlight")  // _CID: Compatible ID
            Name (_UID, 0x0A)  // _UID: Unique ID
            Name (_STA, 0x0B)  // _STA: Status
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x03                                             // .
                    })
                }

                Return (Package (0x06)
                {
                    "refnum",
                    Zero,
                    "type",
                    0x49324300,
                    "version",
                    0x03
                })
            }
        }
    }

    Scope (_SB.PCI0)
    {
        Device (MCHC)
        {
            Name (_ADR, Zero)  // _ADR: Address
        }

        Device (IMEI)
        {
            Name (_ADR, 0x00160000)  // _ADR: Address
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
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
                    "AAPL,slot-name",
                    "Built In",
                    "model",
                    Buffer (0x31)
                    {
                        "Intel Corporation, Series Chipset MEI Controller"
                    },

                    "name",
                    Buffer (0x16)
                    {
                        "Intel IMEI Controller"
                    },

                    "device_type",
                    Buffer (0x10)
                    {
                        "IMEI Controller"
                    }
                })
            }
        }

        Device (HDEF)
        {
            Name (_ADR, 0x001F0003)  // _ADR: Address
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x03                                             // .
                    })
                }

                Return (Package (0x0e)
                {
                    "AAPL,slot-name",
                    "Built In",
                    "name",
                    "Audio Controller",
                    "model",
                    Buffer (0x27)
                    {
                        "Apple High Definition Audio Controller"
                    },

                    "device_type",
                    Buffer (0x11)
                    {
                        "Audio Controller"
                    },

                    "MaximumBootBeepVolume",
                    Buffer (One)
                    {
                         0x01                                             // .
                    },
                    "PinConfigurations",
                    Buffer (Zero){},
                    "hda-gfx",
                    Buffer (0x0A)
                    {
                        "onboard-1"
                    }
                })
            }
        }

        Device (XSPI)
        {
            Name (_ADR, 0x001F0005)  // _ADR: Address
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x03                                             // .
                    })
                }

                Return (Package (0x02)
                {
                    "pci-device-hidden",
                    Buffer (0x08)
                    {
                         0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   // ........
                    }
                })
            }
        }

        Device (PMCR)
        {
            Name (_HID, EisaId ("APP9876"))  // _HID: Hardware ID
            Name (_STA, 0x0B)  // _STA: Status
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                Memory32Fixed (ReadWrite,
                    0xFE000000,         // Address Base
                    0x00010000,         // Address Length
                    )
            })
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
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
                    "AAPL,slot-name",
                    Buffer (0x09)
                    {
                        "Built In"
                    },

                    "device_type",
                    Buffer (0x13)
                    {
                        "ACPIPMC Controller"
                    },

                    "name",
                    Buffer (0x19)
                    {
                        "Apple ACPIPMC Controller"
                    },

                    "model",
                    Buffer (0x35)
                    {
                        "Intel Corporation, Series Chipset ACPIPMC Controller"
                    }
                })
            }
        }
    }

    Scope (_SB.PCI0.LPCB)
    {
        Device (RTC)
        {
            Name (_HID, EisaId ("PNP0B00") /* AT Real-Time Clock */)  // _HID: Hardware ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                IO (Decode16,
                    0x0070,             // Range Minimum
                    0x0070,             // Range Maximum
                    0x00,               // Alignment
                    0x02,               // Length
                    )
            })
        }

        Device (DMAC)
        {
            Name (_HID, EisaId ("PNP0200") /* PC-class DMA Controller */)  // _HID: Hardware ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                IO (Decode16,
                    0x0000,             // Range Minimum
                    0x0000,             // Range Maximum
                    0x01,               // Alignment
                    0x20,               // Length
                    )
                IO (Decode16,
                    0x0081,             // Range Minimum
                    0x0081,             // Range Maximum
                    0x01,               // Alignment
                    0x11,               // Length
                    )
                IO (Decode16,
                    0x0093,             // Range Minimum
                    0x0093,             // Range Maximum
                    0x01,               // Alignment
                    0x0D,               // Length
                    )
                IO (Decode16,
                    0x00C0,             // Range Minimum
                    0x00C0,             // Range Maximum
                    0x01,               // Alignment
                    0x20,               // Length
                    )
                DMA (Compatibility, NotBusMaster, Transfer8_16, )
                    {4}
            })
        }

        Device (ALS0)
        {
            Name (_HID, "ACPI0008" /* Ambient Light Sensor Device */)  // _HID: Hardware ID
            Name (_CID, "smc-als")  // _CID: Compatible ID
            Name (_ALI, 0x012C)  // _ALI: Ambient Light Illuminance
            Name (_ALR, Package (One)  // _ALR: Ambient Light Response
            {
                Package (0x02)
                {
                    0x64,
                    0x012C
                }
            })
        }

        Device (FWHD)
        {
            Name (_HID, EisaId ("INT0800") /* Intel 82802 Firmware Hub Device */)  // _HID: Hardware ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                Memory32Fixed (ReadOnly,
                    0xFF000000,         // Address Base
                    0x01000000,         // Address Length
                    )
            })
        }

        Device (HPET)
        {
            Name (_HID, EisaId ("PNP0103") /* HPET System Timer */)  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0C01") /* System Board */)  // _CID: Compatible ID
            Name (_STA, 0x0F)  // _STA: Status
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                IRQNoFlags ()
                    {0}
                IRQNoFlags ()
                    {8}
                IRQNoFlags ()
                    {11}
                IRQNoFlags ()
                    {15}
                Memory32Fixed (ReadWrite,
                    0xFED00000,         // Address Base
                    0x00000400,         // Address Length
                    )
            })
        }

        Device (EC)
        {
            Name (_HID, EisaId ("KRZ0000"))  // _HID: Hardware ID
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                IO (Decode16,
                    0x0062,             // Range Minimum
                    0x0062,             // Range Maximum
                    0x00,               // Alignment
                    0x01,               // Length
                    )
                IO (Decode16,
                    0x0066,             // Range Minimum
                    0x0066,             // Range Maximum
                    0x00,               // Alignment
                    0x01,               // Length
                    )
            })
            Name (_GPE, 0x17)  // _GPE: General Purpose Events
        }
    }


    Scope (_SB.PCI0.PPMC)
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
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
                "AAPL,slot-name",
                Buffer (0x09)
                {
                    "Built In"
                },

                "device_type",
                Buffer (0x12)
                {
                    "PCHPMC Controller"
                },

                "name",
                Buffer (0x18)
                {
                    "Intel PCHPMC Controller"
                },

                "model",
                Buffer (0x34)
                {
                    "Intel Corporation, Series Chipset PCHPMC Controller"
                }
            })
        }
    }

    Scope (_SB.PCI0.SBUS)
    {
        Device (BUS0)
        {
            Name (_CID, "smbus")  // _CID: Compatible ID
            Name (_ADR, Zero)  // _ADR: Address
            Device (MKY0)
            {
                Name (_ADR, Zero)  // _ADR: Address
                Name (_CID, "mikey")  // _CID: Compatible ID
                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    If ((Arg2 == Zero))
                    {
                        Return (Buffer (One)
                        {
                             0x03                                             // .
                        })
                    }

                    Return (Package (0x07)
                    {
                        "refnum",
                        Zero,
                        "address",
                        0x39,
                        "device-id",
                        0x0CCB,
                        Buffer (One)
                        {
                             0x00                                             // .
                        }
                    })
                }

                Method (H1EN, 1, Serialized)
                {
                    If ((Arg0 <= One))
                    {
                        If ((Arg0 == One))
                        {
                            GL04 |= 0x04
                        }
                        Else
                        {
                            GL04 &= 0xFB
                        }
                    }
                }

                Method (H1IL, 0, Serialized)
                {
                    Local0 = ((GL00 & 0x02) >> One)
                    Return (Local0)
                }

                Method (H1IP, 1, Serialized)
                {
                    If ((Arg0 <= One))
                    {
                        Arg0 = ~Arg0
                        GI01 = Arg0
                    }
                }

                Name (H1IN, 0x11)
                Scope (\_GPE)
                {
                    Method (_L11, 0, NotSerialized)  // _Lxx: Level-Triggered GPE, xx=0x00-0xFF
                    {
                        Notify (\_SB.PCI0.SBUS.BUS0.MKY0, 0x80) // Status Change
                    }
                }

                Method (P1IL, 0, Serialized)
                {
                    Local0 = ((GL00 & 0x40) >> 0x06)
                    Return (Local0)
                }

                Method (P1IP, 1, Serialized)
                {
                    If ((Arg0 <= One))
                    {
                        Arg0 = ~Arg0
                        GI06 = Arg0
                    }
                }

                Name (P1IN, 0x16)
                Scope (\_GPE)
                {
                    Method (_L16, 0, NotSerialized)  // _Lxx: Level-Triggered GPE, xx=0x00-0xFF
                    {
                        GI06 ^= One
                        Notify (\_SB.PCI0.SBUS.BUS0.MKY0, 0x81) // Information Change
                    }
                }
            }

            Device (DVL0)
            {
                Name (_ADR, 0x57)  // _ADR: Address
                Name (_CID, "diagsvault")  // _CID: Compatible ID
                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    If ((Arg2 == Zero))
                    {
                        Return (Buffer (One)
                        {
                             0x03                                             // .
                        })
                    }

                    Return (Package (0x03)
                    {
                        "address",
                        0x57,
                        Buffer (One)
                        {
                             0x00                                             // .
                        }
                    })
                }
            }
        }

        Device (BUS1)
        {
            Name (_CID, "smbus")  // _CID: Compatible ID
            Name (_ADR, One)  // _ADR: Address
        }
    }

    Scope (_SB.PCI0.GLAN)
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg2 == Zero))
            {
                Return (Buffer (One)
                {
                     0x03                                             // .
                })
            }

            Return (Package (0x0C)
            {
                "AAPL,slot-name",
                "Built In",
                "built-in",
                Buffer (One)
                {
                     0x00                                             // .
                },

                "model",
                Buffer (0x2A)
                {
                    "Intel I219V2 PCI Express Gigabit Ethernet"
                },

                "name",
                Buffer (0x14)
                {
                    "Ethernet Controller"
                },

                "device_type",
                Buffer (0x14)
                {
                    "Ethernet Controller"
                },

                "empty",
                Zero
            })
        }
    }

    Scope (_SB.PCI0.XHC)
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg2 == Zero))
            {
                Return (Buffer (One)
                {
                     0x03                                             // .
                })
            }

            Return (Package (0x16)
            {
                "AAPL,slot-name",
                "Built In",
                "name",
                "Intel USB Controller",
                "device_type",
                Buffer (0x0F)
                {
                    "USB Controller"
                },

                "model",
                Buffer (0x3B)
                {
                    "Intel Corporation, Series Chipset USB xHCI Host Controller"
                },

                "subsystem-id",
                Buffer (0x04)
                {
                     0x70, 0x72, 0x00, 0x00                           // pr..
                },

                "subsystem-vendor-id",
                Buffer (0x04)
                {
                     0x86, 0x80, 0x00, 0x00                           // ....
                },

                "AAPL,current-available",
                0x0834,
                "AAPL,current-extra",
                0x0898,
                "AAPL,current-extra-in-sleep",
                0x0640,
                "AAPL,device-internal",
                0x02,
                "AAPL,max-port-current-in-sleep",
                0x0834
            })
        }

        Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
        {
            Return (Package (0x02)
            {
                0x6D,
                0x04
            })
        }
    }

    Scope (_SB.PCI0.XHC.RHUB)
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg2 == Zero))
            {
                Return (Buffer (One)
                {
                     0x03                                             // .
                })
            }

            Return (Package (0x16)
            {
                "AAPL,slot-name",
                "Built In",
                "name",
                "Intel USB Controller",
                "device_type",
                Buffer (0x0F)
                {
                    "USB Controller"
                },

                "model",
                Buffer (0x3B)
                {
                    "Intel Corporation, Series Chipset USB xHCI Host Controller"
                },

                "subsystem-id",
                Buffer (0x04)
                {
                     0x70, 0x72, 0x00, 0x00                           // pr..
                },

                "subsystem-vendor-id",
                Buffer (0x04)
                {
                     0x86, 0x80, 0x00, 0x00                           // ....
                },

                "AAPL,current-available",
                0x0834,
                "AAPL,current-extra",
                0x0898,
                "AAPL,current-extra-in-sleep",
                0x0640,
                "AAPL,device-internal",
                0x02,
                "AAPL,max-port-current-in-sleep",
                0x0834
            })
        }

        Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
        {
            Return (Package (0x02)
            {
                0x6D,
                0x04
            })
        }
    }

    Scope (_SB.PCI0.SATA)
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg2 == Zero))
            {
                Return (Buffer (One)
                {
                     0x03                                             // .
                })
            }

            Return (Package (0x0C)
            {
                "AAPL,slot-name",
                "Built In",
                "name",
                "Intel AHCI Controller",
                "device-id",
                Buffer (0x04)
                {
                     0x02, 0xA1, 0x00, 0x00                           // ....
                },

                "compatible",
                Buffer (0x0D)
                {
                    "pci8086,a102"
                },

                "model",
                Buffer (0x32)
                {
                    "Intel Corporation, Series Chipset SATA Controller"
                },

                "device_type",
                Buffer (0x10)
                {
                    "AHCI Controller"
                }
            })
        }
    }

    Scope (_SB.PCI0.PEG0)
    {
        Device (HDAU)
        {
            Name (_ADR, One)  // _ADR: Address
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If ((Arg2 == Zero))
                {
                    Return (Buffer (One)
                    {
                         0x03                                             // .
                    })
                }

                Return (Package (0x0A)
                {
                    "AAPL,slot-name",
                    "Built In",
                    "name",
                    "HDMI Controller",
                    "built-in",
                    Buffer (One)
                    {
                         0x00                                             // .
                    },

                    "model",
                    Buffer (0x1C)
                    {
                        "Apple HDMI Audio Controller"
                    },

                    "device_type",
                    Buffer (0x10)
                    {
                        "HDMI Controller"
                    }
                })
            }
        }
    }

    

    Scope (_SB.PCI0.RP03.PXSX)
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg2 == Zero))
            {
                Return (Buffer (One)
                {
                     0x03                                             // .
                })
            }

            Return (Package (0x0C)
            {
                "AAPL,slot-name",
                "Built In",
                "built-in",
                Buffer (One)
                {
                     0x00                                             // .
                },

                "model",
                Buffer (0x3B)
                {
                    "Qualcomm Atheros Killer E2500 PCI Express Gigabit Ethernet"
                },

                "name",
                Buffer (0x14)
                {
                    "Ethernet Controller"
                },

                "device_type",
                Buffer (0x14)
                {
                    "Ethernet Controller"
                },

                "empty",
                Zero
            })
        }
    }

    Scope (_SB.PCI0.RP05.PXSX)
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg2 == Zero))
            {
                Return (Buffer (One)
                {
                     0x03                                             // .
                })
            }

            Return (Package (0x0A)
            {
                "AAPL,slot-name",
                "Built In",
                "built-in",
                Buffer (One)
                {
                     0x00                                             // .
                },

                "name",
                "USB Controller",
                "device_type",
                Buffer (0x0F)
                {
                    "USB Controller"
                },

                "model",
                Buffer (0x27)
                {
                    "ASMedia USB eXtensible Host Controller"
                }
            })
        }
    }

    Scope (_SB.PCI0.RP07.PXSX)
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg2 == Zero))
            {
                Return (Buffer (One)
                {
                     0x03                                             // .
                })
            }

            Return (Package (0x0A)
            {
                "AAPL,slot-name",
                "Built In",
                "built-in",
                Buffer (One)
                {
                     0x00                                             // .
                },

                "name",
                "USB Controller",
                "device_type",
                Buffer (0x0F)
                {
                    "USB Controller"
                },

                "model",
                Buffer (0x27)
                {
                    "ASMedia USB eXtensible Host Controller"
                }
            })
        }
    }

    Scope (_SB.PCI0.RP09.PXSX)
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg2 == Zero))
            {
                Return (Buffer (One)
                {
                     0x03                                             // .
                })
            }

            Return (Package (0x0A)
            {
                "AAPL,slot-name",
                "Built In",
                "built-in",
                Buffer (0x09)
                {
                    "NVMe SSD"
                },

                "name",
                Buffer (0x13)
                {
                    "Storage Controller"
                },

                "device_type",
                "Storage Controller",
                "model",
                "MyDigitalSSD SBX 128GB NVMe M2 Flash Drive"
            })
        }
    }
    
    Scope (_SB.PCI0.RP21.PXSX)
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg2 == Zero))
            {
                Return (Buffer (One)
                {
                     0x03                                             // .
                })
            }

            Return (Package (0x0A)
            {
                "AAPL,slot-name",
                "Built In",
                "built-in",
                Buffer (0x09)
                {
                    "NVMe SSD"
                },

                "name",
                Buffer (0x13)
                {
                    "Storage Controller"
                },

                "device_type",
                "Storage Controller",
                "model",
                "MyDigitalSSD SBX 128GB NVMe M2 Flash Drive"
            })
        }
    }
    
    Scope (_SB.PCI0.RP23.PXSX)
    {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If ((Arg2 == Zero))
            {
                Return (Buffer (One)
                {
                     0x03                                             // .
                })
            }

            Return (Package (0x0C)
            {
                "AAPL,slot-name",
                "Built In",
                "built-in",
                Buffer (One)
                {
                     0x00                                             // .
                },

                "model",
                Buffer (0x2A)
                {
                    "Broadcom BCM43xx Wireless Network Adapter"
                },

                "name",
                Buffer (0x13)
                {
                    "AirPort Controller"
                },

                "device_type",
                Buffer (0x10)
                {
                    "AirPort Extreme"
                },

                "empty",
                Zero
            })
        }
    }
}
