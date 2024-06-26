
//2024 Gehstock

{ JEDEC - Standard Manufacturer’s Identification Codes

  JEP106AQ , (Revision of JEP106AP, February 2015)


  http:www.jedec.orgCatalogcatalog.cfm



  The intent of this identification code is that it may be used whenever a
  digital field is required, e.g., hardware, software, documentation, etc.

  The manufacturer’s identification code is defined by one or more eight bit
  fields, each consisting of seven data bits plus one odd parity bit. The
  manufacturer’s identification code is assigned, maintained and updated by
  the JEDEC office. It is a single field, limiting the possible number of
  vendors to 128. To expand the maximum number of identification codes, a
  continuation scheme has been defined. The code 7F indicates that the
  manufacturer’s code is beyond the limit of this field and the next
  sequential manufacturer’s identification field is used. Multiple
  continuation fields are permitted and when used, shall comprise of the
  identification code. }

unit uJedec;

{$RANGECHECKS OFF}
{$OVERFLOWCHECKS OFF}

interface

uses CommCtrl, SysUtils, StrUtils;

function JedecManufacturerFromBinary(const AData; ASize: Integer): String;
function JedecManufacturerFromString(const AText: String): String;
function DecodeMan(s: string): string;

const
  InvalidJedecManufacturerBank = 0;
  MaximumJedecManufacturerBank = 9;
  InvalidJedecManufacturerCode = 0;
  MaximumJedecManufacturerCode = 126;
  ContinuationManufacturerCode = 127;

  ManArr: Array [1 .. 126] of string = ('01', '02', '83', '04', '85', '86',
    '07', '08', '89', '8A', '0B', '8C', '0D', '0E', '8F', '10', '91', '92',
    '13', '94', '15', '16', '97', '98', '19', '1A', '9B', '1C', '9D', '9E',
    '1F', '20', 'A1', 'A2', '23', 'A4', '25', '26', 'A7', 'A8', '29', '2A',
    'AB', '2C', 'AD', 'AE', '2F', 'B0', '31', '32', 'B3', '34', 'B5', 'B6',
    '37', '38', 'B9', 'BA', '3B', 'BC', '3D', '3E', 'BF', '40', 'C1', 'C2',
    '43', 'C4', '45', '46', 'C7', 'C8', '49', '4A', 'CB', '4C', 'CD', 'CE',
    '4F', 'D0', '51', '52', 'D3', '54', 'D5', 'D6', '57', '58', 'D9', 'DA',
    '5B', 'DC', '5D', '5E', 'DF', 'E0', '61', '62', 'E3', '64', 'E5', 'E6',
    '67', '68', 'E9', 'EA', '6B', 'EC', '6D', '6E', 'EF', '70', 'F1', 'F2',
    '73', 'F4', '75', '76', 'F7', 'F8', '79', '7A', 'FB', '7C', 'FD', 'FE');

  JedecManufacturerTable: array [1 .. MaximumJedecManufacturerBank,
    1 .. MaximumJedecManufacturerCode] of String = ( // Bank 1
    ('AMD', // 1 0100000000000000
    'AMI', // 2 0200000000000000
    'Fairchild', // 3 8300000000000000
    'Fujitsu', // 4 0400000000000000
    'GTE', // 5 8500000000000000
    'Harris', // 6 8600000000000000
    'Hitachi', // 7 0700000000000000
    'Inmos', // 8 0800000000000000
    'Intel', // 9 8900000000000000
    'I.T.T.', // 10 8A00000000000000
    'Intersil', // 11 0B00000000000000
    'Monolithic Memories', // 12 8C00000000000000
    'Mostek', // 13 0D00000000000000
    'Freescale (Motorola)', // 14 0E00000000000000
    'National', // 15 8F00000000000000
    'NEC', // 16 1000000000000000
    'RCA', // 17 9100000000000000
    'Raytheon', // 18 9200000000000000
    'Conexant (Rockwell)', // 19 1300000000000000
    'Seeq', // 20 9400000000000000
    'NXP (Philips)', // 21 1500000000000000
    'Synertek', // 22 1600000000000000
    'Texas Instruments', // 23 9700000000000000
    'Toshiba', // 24 9800000000000000
    'Xicor', // 25 1900000000000000
    'Zilog', // 26 1A00000000000000
    'Eurotechnique', // 27 9B00000000000000
    'Mitsubishi', // 28 1C00000000000000
    'Lucent (AT&T)', // 29 9D00000000000000
    'Exel', // 30 9E00000000000000
    'Atmel', // 31 1F00000000000000
    'STMicroelectronics', // 32 2000000000000000
    'Lattice Semi.', // 33 A100000000000000
    'NCR', // 34 A200000000000000
    'Wafer Scale Integration', // 35 2300000000000000
    'IBM', // 36 A400000000000000
    'Tristar', // 37 2500000000000000
    'Visic', // 38 2600000000000000
    'Intl. CMOS Technology', // 39 A700000000000000
    'SSSI', // 40 A800000000000000
    'MicrochipTechnology', // 41 2900000000000000
    'Ricoh Ltd.', // 42 2A00000000000000
    'VLSI', // 43 AB00000000000000
    'Micron Technology', // 44 2C00000000000000
    'SK Hynix', // 45 AD00000000000000
    'OKI Semiconductor', // 46 AE00000000000000
    'ACTEL', // 47 2F00000000000000
    'Sharp', // 48 B000000000000000
    'Catalyst', // 49 3100000000000000
    'Panasonic', // 50 3200000000000000
    'IDT', // 51 B300000000000000
    'Cypress', // 52 3400000000000000
    'DEC', // 53 B500000000000000
    'LSI Logic', // 54 B600000000000000
    'Zarlink (Plessey)', // 55 3700000000000000
    'UTMC', // 56 3800000000000000
    'Thinking Machine', // 57 B900000000000000
    'Thomson CSF', // 58 BA00000000000000
    'Integrated CMOS (Vertex)', // 59 3B00000000000000
    'Honeywell', // 60 BC00000000000000
    'Tektronix', // 61 3D00000000000000
    'Oracle Corporation', // 62 3E00000000000000
    'Silicon Storage Technology (SST)', // 63 BF00000000000000
    'ProMos/Mosel Vitelic', // 64 4000000000000000
    'Infineon (Siemens)', // 65 C100000000000000
    'Macronix', // 66 C200000000000000
    'Xerox', // 67 4300000000000000
    'Plus Logic', // 68 C400000000000000
    'SanDisk Corporation', // 69 4500000000000000
    'Elan Circuit Tech.', // 70 4600000000000000
    'European Silicon Str.', // 71 C700000000000000
    'Apple Computer', // 72 C800000000000000
    'Xilinx', // 73 4900000000000000
    'Compaq', // 74 4A00000000000000
    'Protocol Engines', // 75 CB00000000000000
    'SCI', // 76 4C00000000000000
    'Seiko Instruments', // 77 CD00000000000000
    'Samsung', // 78 CE00000000000000
    'I3 Design System', // 79 4F00000000000000
    'Klic', // 80 D000000000000000
    'Crosspoint Solutions', // 81 5100000000000000
    'Alliance Semiconductor', // 82 5200000000000000
    'Tandem', // 83 D300000000000000
    'Hewlett-Packard', // 84 5400000000000000
    'Intg. Silicon Solutions', // 85 D500000000000000
    'Brooktree', // 86 D600000000000000
    'New Media', // 87 5700000000000000
    'MHS Electronic', // 88 5800000000000000
    'Performance Semi.', // 89 D900000000000000
    'Winbond Electronic', // 90 DA00000000000000
    'Kawasaki Steel', // 91 5B00000000000000
    'Bright Micro', // 92 DC00000000000000
    'TECMAR', // 93 5D00000000000000
    'Exar', // 94 5E00000000000000
    'PCMCIA', // 95 DF00000000000000
    'LG Semi (Goldstar)', // 96 E000000000000000
    'Northern Telecom', // 97 6100000000000000
    'Sanyo', // 98 6200000000000000
    'Array Microsystems', // 99 E300000000000000
    'Crystal Semiconductor', // 100 6400000000000000
    'Analog Devices', // 101 E500000000000000
    'PMC-Sierra', // 102 E600000000000000
    'Asparix', // 103 6700000000000000
    'Convex Computer', // 104 6800000000000000
    'Quality Semiconductor', // 105 E900000000000000
    'Nimbus Technology', // 106 EA00000000000000
    'Transwitch', // 107 6B00000000000000
    'Micronas (ITT Intermetall)', // 108 EC00000000000000
    'Cannon', // 109 6D00000000000000
    'Altera', // 110 6E00000000000000
    'NEXCOM', // 111 EF00000000000000
    'QUALCOMM', // 112 7000000000000000
    'Sony', // 113 F100000000000000
    'Cray Research', // 114 F200000000000000
    'AMS(Austria Micro)', // 115 7300000000000000
    'Vitesse', // 116 F400000000000000
    'Aster Electronics', // 117 7500000000000000
    'Bay Networks (Synoptic)', // 118 7600000000000000
    'Zentrum/ZMD', // 119 F700000000000000
    'TRW', // 120 F800000000000000
    'Thesys', // 121 7900000000000000
    'Solbourne Computer', // 122 7A00000000000000
    'Allied-Signal', // 123 FB00000000000000
    'Dialog', // 124 7C00000000000000
    'Media Vision', // 125 FD00000000000000
    'Level One Communication' // 126 FE00000000000000
    ),
    // Bank 2
    ('Cirrus Logic', // 1 7F01000000000000
    'National Instruments', // 2 7F02000000000000
    'ILC Data Device', // 3 7F83000000000000
    'Alcatel Mietec', // 4 7F04000000000000
    'Micro Linear', // 5 7F85000000000000
    'Univ. of NC', // 6 7F86000000000000
    'JTAG Technologies', // 7 7F07000000000000
    'BAE Systems (Loral)', // 8 7F08000000000000
    'Nchip', // 9 7F89000000000000
    'Galileo Tech', // 10 7F8A000000000000
    'Bestlink Systems', // 11 7F0B000000000000
    'Graychip', // 12 7F8C000000000000
    'GENNUM', // 13 7F0D000000000000
    'VideoLogic', // 14 7F0E000000000000
    'Robert Bosch', // 15 7F8F000000000000
    'Chip Express', // 16 7F10000000000000
    'DATARAM', // 17 7F91000000000000
    'United Microelec Corp.', // 18 7F92000000000000
    'TCSI', // 19 7F13000000000000
    'Smart Modular', // 20 7F94000000000000
    'Hughes Aircraft', // 21 7F15000000000000
    'Lanstar Semiconductor', // 22 7F16000000000000
    'Qlogic', // 23 7F97000000000000
    'Kingston', // 24 7F98000000000000
    'Music Semi', // 25 7F19000000000000
    'Ericsson Components', // 26 7F1A000000000000
    'SpaSE', // 27 7F9B000000000000
    'Eon Silicon Devices', // 28 7F1C000000000000
    'Programmable Micro Corp', // 29 7F9D000000000000
    'DoD', // 30 7F9E000000000000
    'Integ. Memories Tech.', // 31 7F1F000000000000
    'Corollary Inc.', // 32 7F20000000000000
    'Dallas Semiconductor', // 33 7FA1000000000000
    'Omnivision', // 34 7FA2000000000000
    'EIV(Switzerland)', // 35 7F23000000000000
    'Novatel Wireless', // 36 7FA4000000000000
    'Zarlink (Mitel)', // 37 7F25000000000000
    'Clearpoint', // 38 7F26000000000000
    'Cabletron', // 39 7FA7000000000000
    'STEC (Silicon Tech)', // 40 7FA8000000000000
    'Vanguard', // 41 7F29000000000000
    'Hagiwara Sys-Com', // 42 7F2A000000000000
    'Vantis', // 43 7FAB000000000000
    'Celestica', // 44 7F2C000000000000
    'Century', // 45 7FAD000000000000
    'Hal Computers', // 46 7FAE000000000000
    'Rohm Company Ltd.', // 47 7F2F000000000000
    'Juniper Networks', // 48 7FB0000000000000
    'Libit Signal Processing', // 49 7F31000000000000
    'Mushkin Enhanced Memory', // 50 7F32000000000000
    'Tundra Semiconductor', // 51 7FB3000000000000
    'Adaptec Inc.', // 52 7F34000000000000
    'LightSpeed Semi.', // 53 7FB5000000000000
    'ZSP Corp.', // 54 7FB6000000000000
    'AMIC Technology', // 55 7F37000000000000
    'Adobe Systems', // 56 7F38000000000000
    'Dynachip', // 57 7FB9000000000000
    'PNY Technologies, Inc.', // 58 7FBA000000000000
    'Newport Digital', // 59 7F3B000000000000
    'MMC Networks', // 60 7FBC000000000000
    'T Square', // 61 7F3D000000000000
    'Seiko Epson', // 62 7F3E000000000000
    'Broadcom', // 63 7FBF000000000000
    'Viking Components', // 64 7F40000000000000
    'V3 Semiconductor', // 65 7FC1000000000000
    'Flextronics (Orbit Semiconductor)', // 66 7FC2000000000000
    'Suwa Electronics', // 67 7F43000000000000
    'Transmeta', // 68 7FC4000000000000
    'Micron CMS', // 69 7F45000000000000
    'American Computer & Digital Components Inc', // 70 7F46000000000000
    'Enhance 3000 Inc', // 71 7FC7000000000000
    'Tower Semiconductor', // 72 7FC8000000000000
    'CPU Design', // 73 7F49000000000000
    'Price Point', // 74 7F4A000000000000
    'Maxim Integrated Product', // 75 7FCB000000000000
    'Tellabs', // 76 7F4C000000000000
    'Centaur Technology', // 77 7FCD000000000000
    'Unigen Corporation', // 78 7FCE000000000000
    'Transcend Information', // 79 7F4F000000000000
    'Memory Card Technology', // 80 7FD0000000000000
    'CKD Corporation Ltd.', // 81 7F51000000000000
    'Capital Instruments, Inc.', // 82 7F52000000000000
    'Aica Kogyo, Ltd.', // 83 7FD3000000000000
    'Linvex Technology', // 84 7F54000000000000
    'MSC Vertriebs GmbH', // 85 7FD5000000000000
    'AKM Company, Ltd.', // 86 7FD6000000000000
    'Dynamem, Inc.', // 87 7F57000000000000
    'NERA ASA', // 88 7F58000000000000
    'GSI Technology', // 89 7FD9000000000000
    'Dane-Elec (C Memory)', // 90 7FDA000000000000
    'Acorn Computers', // 91 7F5B000000000000
    'Lara Technology', // 92 7FDC000000000000
    'Oak Technology, Inc.', // 93 7F5D000000000000
    'Itec Memory', // 94 7F5E000000000000
    'Tanisys Technology', // 95 7FDF000000000000
    'Truevision', // 96 7FE0000000000000
    'Wintec Industries', // 97 7F61000000000000
    'Super PC Memory', // 98 7F62000000000000
    'MGV Memory', // 99 7FE3000000000000
    'Galvantech', // 100 7F64000000000000
    'Gadzoox Networks', // 101 7FE5000000000000
    'Multi Dimensional Cons.', // 102 7FE6000000000000
    'GateField', // 103 7F67000000000000
    'Integrated Memory System', // 104 7F68000000000000
    'Triscend', // 105 7FE9000000000000
    'XaQti', // 106 7FEA000000000000
    'Goldenram', // 107 7F6B000000000000
    'Clear Logic', // 108 7FEC000000000000
    'Cimaron Communications', // 109 7F6D000000000000
    'Nippon Steel Semi. Corp.', // 110 7F6E000000000000
    'Advantage Memory', // 111 7FEF000000000000
    'AMCC', // 112 7F70000000000000
    'LeCroy', // 113 7FF1000000000000
    'Yamaha Corporation', // 114 7FF2000000000000
    'Digital Microwave', // 115 7F73000000000000
    'NetLogic Microsystems', // 116 7FF4000000000000
    'MIMOS Semiconductor', // 117 7F75000000000000
    'Advanced Fibre', // 118 7F76000000000000
    'BF Goodrich Data.', // 119 7FF7000000000000
    'Epigram', // 120 7FF8000000000000
    'Acbel Polytech Inc.', // 121 7F79000000000000
    'Apacer Technology', // 122 7F7A000000000000
    'Admor Memory', // 123 7FFB000000000000
    'FOXCONN', // 124 7F7C000000000000
    'Quadratics Superconductor', // 125 7FFD000000000000
    '3COM' // 126 7FFE000000000000
    ),
    // Bank 3
    ('Camintonn Corporation', // 1 7F7F010000000000
    'ISOA Incorporated', // 2 7F7F020000000000
    'Agate Semiconductor', // 3 7F7F830000000000
    'ADMtek Incorporated', // 4 7F7F040000000000
    'HYPERTEC', // 5 7F7F850000000000
    'Adhoc Technologies', // 6 7F7F860000000000
    'MOSAID Technologies', // 7 7F7F070000000000
    'Ardent Technologies', // 8 7F7F080000000000
    'Switchcore', // 9 7F7F890000000000
    'Cisco Systems, Inc.', // 10 7F7F8A0000000000
    'Allayer Technologies', // 11 7F7F0B0000000000
    'WorkX AG (Wichman)', // 12 7F7F8C0000000000
    'Oasis Semiconductor', // 13 7F7F0D0000000000
    'Novanet Semiconductor', // 14 7F7F0E0000000000
    'E-M Solutions', // 15 7F7F8F0000000000
    'Power General', // 16 7F7F100000000000
    'Advanced Hardware Arch.', // 17 7F7F910000000000
    'Inova Semiconductors GmbH', // 18 7F7F920000000000
    'Telocity', // 19 7F7F130000000000
    'Delkin Devices', // 20 7F7F940000000000
    'Symagery Microsystems', // 21 7F7F150000000000
    'C-Port Corporation', // 22 7F7F160000000000
    'SiberCore Technologies', // 23 7F7F970000000000
    'Southland Microsystems', // 24 7F7F980000000000
    'Malleable Technologies', // 25 7F7F190000000000
    'Kendin Communications', // 26 7F7F1A0000000000
    'Great Technology Microcomputer', // 27 7F7F9B0000000000
    'Sanmina Corporation', // 28 7F7F1C0000000000
    'HADCO Corporation', // 29 7F7F9D0000000000
    'Corsair', // 30 7F7F9E0000000000
    'Actrans System Inc.', // 31 7F7F1F0000000000
    'ALPHA Technologies', // 32 7F7F200000000000
    'Silicon Laboratories, Inc. (Cygnal)', // 33 7F7FA10000000000
    'Artesyn Technologies', // 34 7F7FA20000000000
    'Align Manufacturing', // 35 7F7F230000000000
    'Peregrine Semiconductor', // 36 7F7FA40000000000
    'Chameleon Systems', // 37 7F7F250000000000
    'Aplus Flash Technology', // 38 7F7F260000000000
    'MIPS Technologies', // 39 7F7FA70000000000
    'Chrysalis ITS', // 40 7F7FA80000000000
    'ADTEC Corporation', // 41 7F7F290000000000
    'Kentron Technologies', // 42 7F7F2A0000000000
    'Win Technologies', // 43 7F7FAB0000000000
    'Tezzaron Semiconductor', // 44 7F7F2C0000000000
    'Extreme Packet Devices', // 45 7F7FAD0000000000
    'RF Micro Devices', // 46 7F7FAE0000000000
    'Siemens AG', // 47 7F7F2F0000000000
    'Sarnoff Corporation', // 48 7F7FB00000000000
    'Itautec Philco SA', // 49 7F7F310000000000
    'Radiata Inc.', // 50 7F7F320000000000
    'Benchmark Elect. (AVEX)', // 51 7F7FB30000000000
    'Legend', // 52 7F7F340000000000
    'SpecTek Incorporated', // 53 7F7FB50000000000
    'Hi/fn', // 54 7F7FB60000000000
    'Enikia Incorporated', // 55 7F7F370000000000
    'SwitchOn Networks', // 56 7F7F380000000000
    'AANetcom Incorporated', // 57 7F7FB90000000000
    'Micro Memory Bank', // 58 7F7FBA0000000000
    'ESS Technology', // 59 7F7F3B0000000000
    'Virata Corporation', // 60 7F7FBC0000000000
    'Excess Bandwidth', // 61 7F7F3D0000000000
    'West Bay Semiconductor', // 62 7F7F3E0000000000
    'DSP Group', // 63 7F7FBF0000000000
    'Newport Communications', // 64 7F7F400000000000
    'Chip2Chip Incorporated', // 65 7F7FC10000000000
    'Phobos Corporation', // 66 7F7FC20000000000
    'Intellitech Corporation', // 67 7F7F430000000000
    'Nordic VLSI ASA', // 68 7F7FC40000000000
    'Ishoni Networks', // 69 7F7F450000000000
    'Silicon Spice', // 70 7F7F460000000000
    'Alchemy Semiconductor', // 71 7F7FC70000000000
    'Agilent Technologies', // 72 7F7FC80000000000
    'Centillium Communications', // 73 7F7F490000000000
    'W.L. Gore', // 74 7F7F4A0000000000
    'HanBit Electronics', // 75 7F7FCB0000000000
    'GlobeSpan', // 76 7F7F4C0000000000
    'Element 14', // 77 7F7FCD0000000000
    'Pycon', // 78 7F7FCE0000000000
    'Saifun Semiconductors', // 79 7F7F4F0000000000
    'Sibyte, Incorporated', // 80 7F7FD00000000000
    'MetaLink Technologies', // 81 7F7F510000000000
    'Feiya Technology', // 82 7F7F520000000000
    'I & C Technology', // 83 7F7FD30000000000
    'Shikatronics', // 84 7F7F540000000000
    'Elektrobit', // 85 7F7FD50000000000
    'Megic', // 86 7F7FD60000000000
    'Com-Tier', // 87 7F7F570000000000
    'Malaysia Micro Solutions', // 88 7F7F580000000000
    'Hyperchip', // 89 7F7FD90000000000
    'Gemstone Communications', // 90 7F7FDA0000000000
    'Anadigm (Anadyne)', // 91 7F7F5B0000000000
    '3ParData', // 92 7F7FDC0000000000
    'Mellanox Technologies', // 93 7F7F5D0000000000
    'Tenx Technologies', // 94 7F7F5E0000000000
    'Helix AG', // 95 7F7FDF0000000000
    'Domosys', // 96 7F7FE00000000000
    'Skyup Technology', // 97 7F7F610000000000
    'HiNT Corporation', // 98 7F7F620000000000
    'Chiaro', // 99 7F7FE30000000000
    'MDT Technologies GmbH', // 100 7F7F640000000000
    'Exbit Technology A/S', // 101 7F7FE50000000000
    'Integrated Technology Express', // 102 7F7FE60000000000
    'AVED Memory', // 103 7F7F670000000000
    'Legerity', // 104 7F7F680000000000
    'Jasmine Networks', // 105 7F7FE90000000000
    'Caspian Networks', // 106 7F7FEA0000000000
    'nCUBE', // 107 7F7F6B0000000000
    'Silicon Access Networks', // 108 7F7FEC0000000000
    'FDK Corporation', // 109 7F7F6D0000000000
    'High Bandwidth Access', // 110 7F7F6E0000000000
    'MultiLink Technology', // 111 7F7FEF0000000000
    'BRECIS', // 112 7F7F700000000000
    'World Wide Packets', // 113 7F7FF10000000000
    'APW', // 114 7F7FF20000000000
    'Chicory Systems', // 115 7F7F730000000000
    'Xstream Logic', // 116 7F7FF40000000000
    'Fast-Chip', // 117 7F7F750000000000
    'Zucotto Wireless', // 118 7F7F760000000000
    'Realchip', // 119 7F7FF70000000000
    'Galaxy Power', // 120 7F7FF80000000000
    'eSilicon', // 121 7F7F790000000000
    'Morphics Technology', // 122 7F7F7A0000000000
    'Accelerant Networks', // 123 7F7FFB0000000000
    'Silicon Wave', // 124 7F7F7C0000000000
    'SandCraft', // 125 7F7FFD0000000000
    'Elpida' // 126 7F7FFE0000000000
    ),
    // Bank 4
    ('Solectron', // 1 7F7F7F0100000000
    'Optosys Technologies', // 2 7F7F7F0200000000
    'Buffalo (Formerly Melco)', // 3 7F7F7F8300000000
    'TriMedia Technologies', // 4 7F7F7F0400000000
    'Cyan Technologies', // 5 7F7F7F8500000000
    'Global Locate', // 6 7F7F7F8600000000
    'Optillion', // 7 7F7F7F0700000000
    'Terago Communications', // 8 7F7F7F0800000000
    'Ikanos Communications', // 9 7F7F7F8900000000
    'Princeton Technology', // 10 7F7F7F8A00000000
    'Nanya Technology', // 11 7F7F7F0B00000000
    'Elite Flash Storage', // 12 7F7F7F8C00000000
    'Mysticom', // 13 7F7F7F0D00000000
    'LightSand Communications', // 14 7F7F7F0E00000000
    'ATI Technologies', // 15 7F7F7F8F00000000
    'Agere Systems', // 16 7F7F7F1000000000
    'NeoMagic', // 17 7F7F7F9100000000
    'AuroraNetics', // 18 7F7F7F9200000000
    'Golden Empire', // 19 7F7F7F1300000000
    'Mushkin', // 20 7F7F7F9400000000
    'Tioga Technologies', // 21 7F7F7F1500000000
    'Netlist', // 22 7F7F7F1600000000
    'TeraLogic', // 23 7F7F7F9700000000
    'Cicada Semiconductor', // 24 7F7F7F9800000000
    'Centon Electronics', // 25 7F7F7F1900000000
    'Tyco Electronics', // 26 7F7F7F1A00000000
    'Magis Works', // 27 7F7F7F9B00000000
    'Zettacom', // 28 7F7F7F1C00000000
    'Cogency Semiconductor', // 29 7F7F7F9D00000000
    'Chipcon AS', // 30 7F7F7F9E00000000
    'Aspex Technology', // 31 7F7F7F1F00000000
    'F5 Networks', // 32 7F7F7F2000000000
    'Programmable Silicon Solutions', // 33 7F7F7FA100000000
    'ChipWrights', // 34 7F7F7FA200000000
    'Acorn Networks', // 35 7F7F7F2300000000
    'Quicklogic', // 36 7F7F7FA400000000
    'Kingmax Semiconductor', // 37 7F7F7F2500000000
    'BOPS', // 38 7F7F7F2600000000
    'Flasys', // 39 7F7F7FA700000000
    'BitBlitz Communications', // 40 7F7F7FA800000000
    'eMemory Technology', // 41 7F7F7F2900000000
    'Procket Networks', // 42 7F7F7F2A00000000
    'Purple Ray', // 43 7F7F7FAB00000000
    'Trebia Networks', // 44 7F7F7F2C00000000
    'Delta Electronics', // 45 7F7F7FAD00000000
    'Onex Communications', // 46 7F7F7FAE00000000
    'Ample Communications', // 47 7F7F7F2F00000000
    'Memory Experts Intl', // 48 7F7F7FB000000000
    'Astute Networks', // 49 7F7F7F3100000000
    'Azanda Network Devices', // 50 7F7F7F3200000000
    'Dibcom', // 51 7F7F7FB300000000
    'Tekmos', // 52 7F7F7F3400000000
    'API NetWorks', // 53 7F7F7FB500000000
    'Bay Microsystems', // 54 7F7F7FB600000000
    'Firecron Ltd', // 55 7F7F7F3700000000
    'Resonext Communications', // 56 7F7F7F3800000000
    'Tachys Technologies', // 57 7F7F7FB900000000
    'Equator Technology', // 58 7F7F7FBA00000000
    'Concept Computer', // 59 7F7F7F3B00000000
    'SILCOM', // 60 7F7F7FBC00000000
    '3Dlabs', // 61 7F7F7F3D00000000
    'c’t Magazine', // 62 7F7F7F3E00000000
    'Sanera Systems', // 63 7F7F7FBF00000000
    'Silicon Packets', // 64 7F7F7F4000000000
    'Viasystems Group', // 65 7F7F7FC100000000
    'Simtek', // 66 7F7F7FC200000000
    'Semicon Devices Singapore', // 67 7F7F7F4300000000
    'Satron Handelsges', // 68 7F7F7FC400000000
    'Improv Systems', // 69 7F7F7F4500000000
    'INDUSYS GmbH', // 70 7F7F7F4600000000
    'Corrent', // 71 7F7F7FC700000000
    'Infrant Technologies', // 72 7F7F7FC800000000
    'Ritek Corp', // 73 7F7F7F4900000000
    'empowerTel Networks', // 74 7F7F7F4A00000000
    'Hypertec', // 75 7F7F7FCB00000000
    'Cavium Networks', // 76 7F7F7F4C00000000
    'PLX Technology', // 77 7F7F7FCD00000000
    'Massana Design', // 78 7F7F7FCE00000000
    'Intrinsity', // 79 7F7F7F4F00000000
    'Valence Semiconductor', // 80 7F7F7FD000000000
    'Terawave Communications', // 81 7F7F7F5100000000
    'IceFyre Semiconductor', // 82 7F7F7F5200000000
    'Primarion', // 83 7F7F7FD300000000
    'Picochip Designs Ltd', // 84 7F7F7F5400000000
    'Silverback Systems', // 85 7F7F7FD500000000
    'Jade Star Technologies', // 86 7F7F7FD600000000
    'Pijnenburg Securealink', // 87 7F7F7F5700000000
    'takeMS International AG', // 88 7F7F7F5800000000
    'Cambridge Silicon Radio', // 89 7F7F7FD900000000
    'Swissbit', // 90 7F7F7FDA00000000
    'Nazomi Communications', // 91 7F7F7F5B00000000
    'eWave System', // 92 7F7F7FDC00000000
    'Rockwell Collins', // 93 7F7F7F5D00000000
    'Picocel Co. Ltd. (Paion)', // 94 7F7F7F5E00000000
    'Alphamosaic Ltd', // 95 7F7F7FDF00000000
    'Sandburst', // 96 7F7F7FE000000000
    'SiCon Video', // 97 7F7F7F6100000000
    'NanoAmp Solutions', // 98 7F7F7F6200000000
    'Ericsson Technology', // 99 7F7F7FE300000000
    'PrairieComm', // 100 7F7F7F6400000000
    'Mitac International', // 101 7F7F7FE500000000
    'Layer N Networks', // 102 7F7F7FE600000000
    'MtekVision (Atsana)', // 103 7F7F7F6700000000
    'Allegro Networks', // 104 7F7F7F6800000000
    'Marvell Semiconductors', // 105 7F7F7FE900000000
    'Netergy Microelectronic', // 106 7F7F7FEA00000000
    'NVIDIA', // 107 7F7F7F6B00000000
    'Internet Machines', // 108 7F7F7FEC00000000
    'Memorysolution GmbH', // 109 7F7F7F6D00000000
    'Litchfield Communication', // 110 7F7F7F6E00000000
    'Accton Technology', // 111 7F7F7FEF00000000
    'Teradiant Networks', // 112 7F7F7F7000000000
    'Europe Technologies', // 113 7F7F7FF100000000
    'Cortina Systems', // 114 7F7F7FF200000000
    'RAM Components', // 115 7F7F7F7300000000
    'Raqia Networks', // 116 7F7F7FF400000000
    'ClearSpeed', // 117 7F7F7F7500000000
    'Matsushita Battery', // 118 7F7F7F7600000000
    'Xelerated', // 119 7F7F7FF700000000
    'SimpleTech', // 120 7F7F7FF800000000
    'Utron Technology', // 121 7F7F7F7900000000
    'Astec International', // 122 7F7F7F7A00000000
    'AVM gmbH', // 123 7F7F7FFB00000000
    'Redux Communications', // 124 7F7F7F7C00000000
    'Dot Hill Systems', // 125 7F7F7FFD00000000
    'TeraChip' // 126 7F7F7FFE00000000
    ),
    // Bank 5
    ('T-RAM Incorporated', // 1 7F7F7F7F01000000
    'Innovics Wireless', // 2 7F7F7F7F02000000
    'Teknovus', // 3 7F7F7F7F83000000
    'KeyEye Communications', // 4 7F7F7F7F04000000
    'Runcom Technologies', // 5 7F7F7F7F85000000
    'RedSwitch', // 6 7F7F7F7F86000000
    'Dotcast', // 7 7F7F7F7F07000000
    'Silicon Mountain Memory', // 8 7F7F7F7F08000000
    'Signia Technologies', // 9 7F7F7F7F89000000
    'Pixim', // 10 7F7F7F7F8A000000
    'Galazar Networks', // 11 7F7F7F7F0B000000
    'White Electronic Designs', // 12 7F7F7F7F8C000000
    'Patriot Scientific', // 13 7F7F7F7F0D000000
    'Neoaxiom Corporation', // 14 7F7F7F7F0E000000
    '3Y Power Technology', // 15 7F7F7F7F8F000000
    'Europe Technologies', // 16 7F7F7F7F10000000
    'Potentia Power Systems', // 17 7F7F7F7F91000000
    'C-guys Incorporated', // 18 7F7F7F7F92000000
    'Digital Communications Technology Incorporated', // 19 7F7F7F7F13000000
    'Silicon-Based Technology', // 20 7F7F7F7F94000000
    'Fulcrum Microsystems', // 21 7F7F7F7F15000000
    'Positivo Informatica Ltd', // 22 7F7F7F7F16000000
    'XIOtech Corporation', // 23 7F7F7F7F97000000
    'PortalPlayer', // 24 7F7F7F7F98000000
    'Zhiying Software', // 25 7F7F7F7F19000000
    'Direct2Data', // 26 7F7F7F7F1A000000
    'Phonex Broadband', // 27 7F7F7F7F9B000000
    'Skyworks Solutions', // 28 7F7F7F7F1C000000
    'Entropic Communications', // 29 7F7F7F7F9D000000
    'I’M Intelligent Memory Ltd.', // 30 7F7F7F7F9E000000
    'Zensys A/S', // 31 7F7F7F7F1F000000
    'Legend Silicon Corp.', // 32 7F7F7F7F20000000
    'sci-worx GmbH', // 33 7F7F7F7FA1000000
    'SMSC (Standard Microsystems)', // 34 7F7F7F7FA2000000
    'Renesas Technology', // 35 7F7F7F7F23000000
    'Raza Microelectronics', // 36 7F7F7F7FA4000000
    'Phyworks', // 37 7F7F7F7F25000000
    'MediaTek', // 38 7F7F7F7F26000000
    'Non-cents Productions', // 39 7F7F7F7FA7000000
    'US Modular', // 40 7F7F7F7FA8000000
    'Wintegra Ltd', // 41 7F7F7F7F29000000
    'Mathstar', // 42 7F7F7F7F2A000000
    'StarCore', // 43 7F7F7F7FAB000000
    'Oplus Technologies', // 44 7F7F7F7F2C000000
    'Mindspeed', // 45 7F7F7F7FAD000000
    'Just Young Computer', // 46 7F7F7F7FAE000000
    'Radia Communications', // 47 7F7F7F7F2F000000
    'OCZ', // 48 7F7F7F7FB0000000
    'Emuzed', // 49 7F7F7F7F31000000
    'LOGIC Devices', // 50 7F7F7F7F32000000
    'Inphi Corporation', // 51 7F7F7F7FB3000000
    'Quake Technologies', // 52 7F7F7F7F34000000
    'Vixel', // 53 7F7F7F7FB5000000
    'SolusTek', // 54 7F7F7F7FB6000000
    'Kongsberg Maritime', // 55 7F7F7F7F37000000
    'Faraday Technology', // 56 7F7F7F7F38000000
    'Altium Ltd.', // 57 7F7F7F7FB9000000
    'Insyte', // 58 7F7F7F7FBA000000
    'ARM Ltd.', // 59 7F7F7F7F3B000000
    'DigiVision', // 60 7F7F7F7FBC000000
    'Vativ Technologies', // 61 7F7F7F7F3D000000
    'Endicott Interconnect Technologies', // 62 7F7F7F7F3E000000
    'Pericom', // 63 7F7F7F7FBF000000
    'Bandspeed', // 64 7F7F7F7F40000000
    'LeWiz Communications', // 65 7F7F7F7FC1000000
    'CPU Technology', // 66 7F7F7F7FC2000000
    'Ramaxel Technology', // 67 7F7F7F7F43000000
    'DSP Group', // 68 7F7F7F7FC4000000
    'Axis Communications', // 69 7F7F7F7F45000000
    'Legacy Electronics', // 70 7F7F7F7F46000000
    'Chrontel', // 71 7F7F7F7FC7000000
    'Powerchip Semiconductor', // 72 7F7F7F7FC8000000
    'MobilEye Technologies', // 73 7F7F7F7F49000000
    'Excel Semiconductor', // 74 7F7F7F7F4A000000
    'A-DATA Technology', // 75 7F7F7F7FCB000000
    'VirtualDigm', // 76 7F7F7F7F4C000000
    'G Skill Intl', // 77 7F7F7F7FCD000000
    'Quanta Computer', // 78 7F7F7F7FCE000000
    'Yield Microelectronics', // 79 7F7F7F7F4F000000
    'Afa Technologies', // 80 7F7F7F7FD0000000
    'KINGBOX Technology Co. Ltd.', // 81 7F7F7F7F51000000
    'Ceva', // 82 7F7F7F7F52000000
    'iStor Networks', // 83 7F7F7F7FD3000000
    'Advance Modules', // 84 7F7F7F7F54000000
    'Microsoft', // 85 7F7F7F7FD5000000
    'Open-Silicon', // 86 7F7F7F7FD6000000
    'Goal Semiconductor', // 87 7F7F7F7F57000000
    'ARC International', // 88 7F7F7F7F58000000
    'Simmtec', // 89 7F7F7F7FD9000000
    'Metanoia', // 90 7F7F7F7FDA000000
    'Key Stream', // 91 7F7F7F7F5B000000
    'Lowrance Electronics', // 92 7F7F7F7FDC000000
    'Adimos', // 93 7F7F7F7F5D000000
    'SiGe Semiconductor', // 94 7F7F7F7F5E000000
    'Fodus Communications', // 95 7F7F7F7FDF000000
    'Credence Systems Corp.', // 96 7F7F7F7FE0000000
    'Genesis Microchip Inc.', // 97 7F7F7F7F61000000
    'Vihana, Inc.', // 98 7F7F7F7F62000000
    'WIS Technologies', // 99 7F7F7F7FE3000000
    'GateChange Technologies', // 100 7F7F7F7F64000000
    'High Density Devices AS', // 101 7F7F7F7FE5000000
    'Synopsys', // 102 7F7F7F7FE6000000
    'Gigaram', // 103 7F7F7F7F67000000
    'Enigma Semiconductor Inc.', // 104 7F7F7F7F68000000
    'Century Micro Inc.', // 105 7F7F7F7FE9000000
    'Icera Semiconductor', // 106 7F7F7F7FEA000000
    'Mediaworks Integrated Systems', // 107 7F7F7F7F6B000000
    'O’Neil Product Development', // 108 7F7F7F7FEC000000
    'Supreme Top Technology Ltd.', // 109 7F7F7F7F6D000000
    'MicroDisplay Corporation', // 110 7F7F7F7F6E000000
    'Team Group Inc.', // 111 7F7F7F7FEF000000
    'Sinett Corporation', // 112 7F7F7F7F70000000
    'Toshiba Corporation', // 113 7F7F7F7FF1000000
    'Tensilica', // 114 7F7F7F7FF2000000
    'SiRF Technology', // 115 7F7F7F7F73000000
    'Bacoc Inc.', // 116 7F7F7F7FF4000000
    'SMaL Camera Technologies', // 117 7F7F7F7F75000000
    'Thomson SC', // 118 7F7F7F7F76000000
    'Airgo Networks', // 119 7F7F7F7FF7000000
    'Wisair Ltd.', // 120 7F7F7F7FF8000000
    'SigmaTel', // 121 7F7F7F7F79000000
    'Arkados', // 122 7F7F7F7F7A000000
    'Compete IT gmbH Co. KG', // 123 7F7F7F7FFB000000
    'Eudar Technology Inc.', // 124 7F7F7F7F7C000000
    'Focus Enhancements', // 125 7F7F7F7FFD000000
    'Xyratex' // 126 7F7F7F7FFE000000
    ),
    // Bank 6
    ('Specular Networks', // 1 7F7F7F7F7F010000
    'Patriot Memory (PDP Systems)', // 2 7F7F7F7F7F020000
    'U-Chip Technology Corp.', // 3 7F7F7F7F7F830000
    'Silicon Optix', // 4 7F7F7F7F7F040000
    'Greenfield Networks', // 5 7F7F7F7F7F850000
    'CompuRAM GmbH', // 6 7F7F7F7F7F860000
    'Stargen, Inc.', // 7 7F7F7F7F7F070000
    'NetCell Corporation', // 8 7F7F7F7F7F080000
    'Excalibrus Technologies Ltd', // 9 7F7F7F7F7F890000
    'SCM Microsystems 1', // 10 7F7F7F7F7F8A0000
    'Xsigo Systems, Inc.', // 11 7F7F7F7F7F0B0000
    'CHIPS & Systems Inc', // 12 7F7F7F7F7F8C0000
    'Tier 1 Multichip Solutions', // 13 7F7F7F7F7F0D0000
    'CWRL Labs', // 14 7F7F7F7F7F0E0000
    'Teradici', // 15 7F7F7F7F7F8F0000
    'Gigaram, Inc.', // 16 7F7F7F7F7F100000
    'g2 Microsystems', // 17 7F7F7F7F7F910000
    'PowerFlash Semiconductor', // 18 7F7F7F7F7F920000
    'P.A. Semi, Inc.', // 19 7F7F7F7F7F130000
    'NovaTech Solutions, S.A.', // 20 7F7F7F7F7F940000
    'c2 Microsystems, Inc.', // 21 7F7F7F7F7F150000
    'Level5 Networks', // 22 7F7F7F7F7F160000
    'COS Memory AG', // 23 7F7F7F7F7F970000
    'Innovasic Semiconductor', // 24 7F7F7F7F7F980000
    '02IC Co. Ltd', // 25 7F7F7F7F7F190000
    'Tabula, Inc.', // 26 7F7F7F7F7F1A0000
    'Crucial Technology', // 27 7F7F7F7F7F9B0000
    'Chelsio Communications', // 28 7F7F7F7F7F1C0000
    'Solarflare Communications', // 29 7F7F7F7F7F9D0000
    'Xambala Inc.', // 30 7F7F7F7F7F9E0000
    'EADS Astrium', // 31 7F7F7F7F7F1F0000
    'Terra Semiconductor Inc', // 32 7F7F7F7F7F200000
    'Imaging Works, Inc.', // 33 7F7F7F7F7FA10000
    'Astute Networks, Inc.', // 34 7F7F7F7F7FA20000
    'Tzero', // 35 7F7F7F7F7F230000
    'Emulex', // 36 7F7F7F7F7FA40000
    'Power-One', // 37 7F7F7F7F7F250000
    'Pulse~LINK Inc.', // 38 7F7F7F7F7F260000
    'Hon Hai Precision Industry', // 39 7F7F7F7F7FA70000
    'White Rock Networks Inc.', // 40 7F7F7F7F7FA80000
    'Telegent Systems USA, Inc.', // 41 7F7F7F7F7F290000
    'Atrua Technologies, Inc.', // 42 7F7F7F7F7F2A0000
    'Acbel Polytech Inc.', // 43 7F7F7F7F7FAB0000
    'eRide Inc.', // 44 7F7F7F7F7F2C0000
    'ULi Electronics Inc.', // 45 7F7F7F7F7FAD0000
    'Magnum Semiconductor Inc.', // 46 7F7F7F7F7FAE0000
    'neoOne Technology, Inc.', // 47 7F7F7F7F7F2F0000
    'Connex Technology, Inc.', // 48 7F7F7F7F7FB00000
    'Stream Processors, Inc.', // 49 7F7F7F7F7F310000
    'Focus Enhancements', // 50 7F7F7F7F7F320000
    'Telecis Wireless, Inc.', // 51 7F7F7F7F7FB30000
    'uNav Microelectronics', // 52 7F7F7F7F7F340000
    'Tarari, Inc.', // 53 7F7F7F7F7FB50000
    'Ambric, Inc.', // 54 7F7F7F7F7FB60000
    'Newport Media, Inc.', // 55 7F7F7F7F7F370000
    'VMTS', // 56 7F7F7F7F7F380000
    'Enuclia Semiconductor, Inc.', // 57 7F7F7F7F7FB90000
    'Virtium Technology Inc.', // 58 7F7F7F7F7FBA0000
    'Solid State System Co., Ltd.', // 59 7F7F7F7F7F3B0000
    'Kian Tech LLC', // 60 7F7F7F7F7FBC0000
    'Artimi', // 61 7F7F7F7F7F3D0000
    'Power Quotient International', // 62 7F7F7F7F7F3E0000
    'Avago Technologies', // 63 7F7F7F7F7FBF0000
    'ADTechnology', // 64 7F7F7F7F7F400000
    'Sigma Designs', // 65 7F7F7F7F7FC10000
    'SiCortex, Inc.', // 66 7F7F7F7F7FC20000
    'Ventura Technology Group', // 67 7F7F7F7F7F430000
    'eASIC', // 68 7F7F7F7F7FC40000
    'M.H.S. SAS', // 69 7F7F7F7F7F450000
    'Micro Star International', // 70 7F7F7F7F7F460000
    'Rapport Inc.', // 71 7F7F7F7F7FC70000
    'Makway International', // 72 7F7F7F7F7FC80000
    'Broad Reach Engineering Co.', // 73 7F7F7F7F7F490000
    'Semiconductor Mfg Intl Corp', // 74 7F7F7F7F7F4A0000
    'SiConnect', // 75 7F7F7F7F7FCB0000
    'FCI USA Inc.', // 76 7F7F7F7F7F4C0000
    'Validity Sensors', // 77 7F7F7F7F7FCD0000
    'Coney Technology Co. Ltd.', // 78 7F7F7F7F7FCE0000
    'Spans Logic', // 79 7F7F7F7F7F4F0000
    'Neterion Inc.', // 80 7F7F7F7F7FD00000
    'Qimonda', // 81 7F7F7F7F7F510000
    'New Japan Radio Co. Ltd.', // 82 7F7F7F7F7F520000
    'Velogix', // 83 7F7F7F7F7FD30000
    'Montalvo Systems', // 84 7F7F7F7F7F540000
    'iVivity Inc.', // 85 7F7F7F7F7FD50000
    'Walton Chaintech', // 86 7F7F7F7F7FD60000
    'AENEON', // 87 7F7F7F7F7F570000
    'Lorom Industrial Co. Ltd.', // 88 7F7F7F7F7F580000
    'Radiospire Networks', // 89 7F7F7F7F7FD90000
    'Sensio Technologies, Inc.', // 90 7F7F7F7F7FDA0000
    'Nethra Imaging', // 91 7F7F7F7F7F5B0000
    'Hexon Technology Pte Ltd', // 92 7F7F7F7F7FDC0000
    'CompuStocx (CSX)', // 93 7F7F7F7F7F5D0000
    'Methode Electronics, Inc.', // 94 7F7F7F7F7F5E0000
    'Connect One Ltd.', // 95 7F7F7F7F7FDF0000
    'Opulan Technologies', // 96 7F7F7F7F7FE00000
    'Septentrio NV', // 97 7F7F7F7F7F610000
    'Goldenmars Technology Inc.', // 98 7F7F7F7F7F620000
    'Kreton Corporation', // 99 7F7F7F7F7FE30000
    'Cochlear Ltd.', // 100 7F7F7F7F7F640000
    'Altair Semiconductor', // 101 7F7F7F7F7FE50000
    'NetEffect, Inc.', // 102 7F7F7F7F7FE60000
    'Spansion, Inc.', // 103 7F7F7F7F7F670000
    'Taiwan Semiconductor Mfg', // 104 7F7F7F7F7F680000
    'Emphany Systems Inc.', // 105 7F7F7F7F7FE90000
    'ApaceWave Technologies', // 106 7F7F7F7F7FEA0000
    'Mobilygen Corporation', // 107 7F7F7F7F7F6B0000
    'Tego', // 108 7F7F7F7F7FEC0000
    'Cswitch Corporation', // 109 7F7F7F7F7F6D0000
    'Haier (Beijing) IC Design Co.', // 110 7F7F7F7F7F6E0000
    'MetaRAM', // 111 7F7F7F7F7FEF0000
    'Axel Electronics Co. Ltd.', // 112 7F7F7F7F7F700000
    'Tilera Corporation', // 113 7F7F7F7F7FF10000
    'Aquantia', // 114 7F7F7F7F7FF20000
    'Vivace Semiconductor', // 115 7F7F7F7F7F730000
    'Redpine Signals', // 116 7F7F7F7F7FF40000
    'Octalica', // 117 7F7F7F7F7F750000
    'InterDigital Communications', // 118 7F7F7F7F7F760000
    'Avant Technology', // 119 7F7F7F7F7FF70000
    'Asrock, Inc.', // 120 7F7F7F7F7FF80000
    'Availink', // 121 7F7F7F7F7F790000
    'Quartics, Inc.', // 122 7F7F7F7F7F7A0000
    'Element CXI', // 123 7F7F7F7F7FFB0000
    'Innovaciones Microelectronicas', // 124 7F7F7F7F7F7C0000
    'VeriSilicon Microelectronics', // 125 7F7F7F7F7FFD0000
    'W5 Networks' // 126 7F7F7F7F7FFE0000
    ),
    // Bank 7
    ('MOVEKING', // 1 7F7F7F7F7F7F0100
    'Mavrix Technology, Inc.', // 2 7F7F7F7F7F7F0200
    'CellGuide Ltd.', // 3 7F7F7F7F7F7F8300
    'Faraday Technology', // 4 7F7F7F7F7F7F0400
    'Diablo Technologies, Inc.', // 5 7F7F7F7F7F7F8500
    'Jennic', // 6 7F7F7F7F7F7F8600
    'Octasic', // 7 7F7F7F7F7F7F0700
    'Molex Incorporated', // 8 7F7F7F7F7F7F0800
    '3Leaf Networks', // 9 7F7F7F7F7F7F8900
    'Bright Micron Technology', // 10 7F7F7F7F7F7F8A00
    'Netxen', // 11 7F7F7F7F7F7F0B00
    'NextWave Broadband Inc.', // 12 7F7F7F7F7F7F8C00
    'DisplayLink', // 13 7F7F7F7F7F7F0D00
    'ZMOS Technology', // 14 7F7F7F7F7F7F0E00
    'Tec-Hill', // 15 7F7F7F7F7F7F8F00
    'Multigig, Inc.', // 16 7F7F7F7F7F7F1000
    'Amimon', // 17 7F7F7F7F7F7F9100
    'Euphonic Technologies, Inc.', // 18 7F7F7F7F7F7F9200
    'BRN Phoenix', // 19 7F7F7F7F7F7F1300
    'InSilica', // 20 7F7F7F7F7F7F9400
    'Ember Corporation', // 21 7F7F7F7F7F7F1500
    'Avexir Technologies Corporation', // 22 7F7F7F7F7F7F1600
    'Echelon Corporation', // 23 7F7F7F7F7F7F9700
    'Edgewater Computer Systems', // 24 7F7F7F7F7F7F9800
    'XMOS Semiconductor Ltd.', // 25 7F7F7F7F7F7F1900
    'GENUSION, Inc.', // 26 7F7F7F7F7F7F1A00
    'Memory Corp NV', // 27 7F7F7F7F7F7F9B00
    'SiliconBlue Technologies', // 28 7F7F7F7F7F7F1C00
    'Rambus Inc.', // 29 7F7F7F7F7F7F9D00
    'Andes Technology Corporation', // 30 7F7F7F7F7F7F9E00
    'Coronis Systems', // 31 7F7F7F7F7F7F1F00
    'Achronix Semiconductor', // 32 7F7F7F7F7F7F2000
    'Siano Mobile Silicon Ltd.', // 33 7F7F7F7F7F7FA100
    'Semtech Corporation', // 34 7F7F7F7F7F7FA200
    'Pixelworks Inc.', // 35 7F7F7F7F7F7F2300
    'Gaisler Research AB', // 36 7F7F7F7F7F7FA400
    'Teranetics', // 37 7F7F7F7F7F7F2500
    'Toppan Printing Co. Ltd.', // 38 7F7F7F7F7F7F2600
    'Kingxcon', // 39 7F7F7F7F7F7FA700
    'Silicon Integrated Systems', // 40 7F7F7F7F7F7FA800
    'I-O Data Device, Inc.', // 41 7F7F7F7F7F7F2900
    'NDS Americas Inc.', // 42 7F7F7F7F7F7F2A00
    'Solomon Systech Limited', // 43 7F7F7F7F7F7FAB00
    'On Demand Microelectronics', // 44 7F7F7F7F7F7F2C00
    'Amicus Wireless Inc.', // 45 7F7F7F7F7F7FAD00
    'SMARDTV SNC', // 46 7F7F7F7F7F7FAE00
    'Comsys Communication Ltd.', // 47 7F7F7F7F7F7F2F00
    'Movidia Ltd.', // 48 7F7F7F7F7F7FB000
    'Javad GNSS, Inc.', // 49 7F7F7F7F7F7F3100
    'Montage Technology Group', // 50 7F7F7F7F7F7F3200
    'Trident Microsystems', // 51 7F7F7F7F7F7FB300
    'Super Talent', // 52 7F7F7F7F7F7F3400
    'Optichron, Inc.', // 53 7F7F7F7F7F7FB500
    'Future Waves UK Ltd.', // 54 7F7F7F7F7F7FB600
    'SiBEAM, Inc.', // 55 7F7F7F7F7F7F3700
    'Inicore,Inc.', // 56 7F7F7F7F7F7F3800
    'Virident Systems', // 57 7F7F7F7F7F7FB900
    'M2000, Inc.', // 58 7F7F7F7F7F7FBA00
    'ZeroG Wireless, Inc.', // 59 7F7F7F7F7F7F3B00
    'Gingle Technology Co. Ltd.', // 60 7F7F7F7F7F7FBC00
    'Space Micro Inc.', // 61 7F7F7F7F7F7F3D00
    'Wilocity', // 62 7F7F7F7F7F7F3E00
    'Novafora, Ic.', // 63 7F7F7F7F7F7FBF00
    'iKoa Corporation', // 64 7F7F7F7F7F7F4000
    'ASint Technology', // 65 7F7F7F7F7F7FC100
    'Ramtron', // 66 7F7F7F7F7F7FC200
    'Plato Networks Inc.', // 67 7F7F7F7F7F7F4300
    'IPtronics AS', // 68 7F7F7F7F7F7FC400
    'Infinite-Memories', // 69 7F7F7F7F7F7F4500
    'Parade Technologies Inc.', // 70 7F7F7F7F7F7F4600
    'Dune Networks', // 71 7F7F7F7F7F7FC700
    'GigaDevice Semiconductor', // 72 7F7F7F7F7F7FC800
    'Modu Ltd.', // 73 7F7F7F7F7F7F4900
    'CEITEC', // 74 7F7F7F7F7F7F4A00
    'Northrop Grumman', // 75 7F7F7F7F7F7FCB00
    'XRONET Corporation', // 76 7F7F7F7F7F7F4C00
    'Sicon Semiconductor AB', // 77 7F7F7F7F7F7FCD00
    'Atla Electronics Co. Ltd.', // 78 7F7F7F7F7F7FCE00
    'TOPRAM Technology', // 79 7F7F7F7F7F7F4F00
    'Silego Technology Inc.', // 80 7F7F7F7F7F7FD000
    'Kinglife', // 81 7F7F7F7F7F7F5100
    'Ability Industries Ltd.', // 82 7F7F7F7F7F7F5200
    'Silicon Power Computer & Communications', // 83 7F7F7F7F7F7FD300
    'Augusta Technology, Inc.', // 84 7F7F7F7F7F7F5400
    'Nantronics Semiconductors', // 85 7F7F7F7F7F7FD500
    'Hilscher Gesellschaft', // 86 7F7F7F7F7F7FD600
    'Quixant Ltd.', // 87 7F7F7F7F7F7F5700
    'Percello Ltd.', // 88 7F7F7F7F7F7F5800
    'NextIO Inc.', // 89 7F7F7F7F7F7FD900
    'Scanimetrics Inc.', // 90 7F7F7F7F7F7FDA00
    'FS-Semi Company Ltd.', // 91 7F7F7F7F7F7F5B00
    'Infinera Corporation', // 92 7F7F7F7F7F7FDC00
    'SandForce Inc.', // 93 7F7F7F7F7F7F5D00
    'Lexar Media', // 94 7F7F7F7F7F7F5E00
    'Teradyne Inc.', // 95 7F7F7F7F7F7FDF00
    'Memory Exchange Corp.', // 96 7F7F7F7F7F7FE000
    'Suzhou Smartek Electronics', // 97 7F7F7F7F7F7F6100
    'Avantium Corporation', // 98 7F7F7F7F7F7F6200
    'ATP Electronics Inc.', // 99 7F7F7F7F7F7FE300
    'Valens Semiconductor Ltd', // 100 7F7F7F7F7F7F6400
    'Agate Logic, Inc.', // 101 7F7F7F7F7F7FE500
    'Netronome', // 102 7F7F7F7F7F7FE600
    'Zenverge, Inc.', // 103 7F7F7F7F7F7F6700
    'N-trig Ltd', // 104 7F7F7F7F7F7F6800
    'SanMax Technologies Inc.', // 105 7F7F7F7F7F7FE900
    'Contour Semiconductor Inc.', // 106 7F7F7F7F7F7FEA00
    'TwinMOS', // 107 7F7F7F7F7F7F6B00
    'Silicon Systems, Inc.', // 108 7F7F7F7F7F7FEC00
    'V-Color Technology Inc.', // 109 7F7F7F7F7F7F6D00
    'Certicom Corporation', // 110 7F7F7F7F7F7F6E00
    'JSC ICC Milandr', // 111 7F7F7F7F7F7FEF00
    'PhotoFast Global Inc.', // 112 7F7F7F7F7F7F7000
    'InnoDisk Corporation', // 113 7F7F7F7F7F7FF100
    'Muscle Power', // 114 7F7F7F7F7F7FF200
    'Energy Micro', // 115 7F7F7F7F7F7F7300
    'Innofidei', // 116 7F7F7F7F7F7FF400
    'CopperGate Communications', // 117 7F7F7F7F7F7F7500
    'Holtek Semiconductor Inc.', // 118 7F7F7F7F7F7F7600
    'Myson Century, Inc.', // 119 7F7F7F7F7F7FF700
    'FIDELIX', // 120 7F7F7F7F7F7FF800
    'Red Digital Cinema', // 121 7F7F7F7F7F7F7900
    'Densbits Technology', // 122 7F7F7F7F7F7F7A00
    'Zempro', // 123 7F7F7F7F7F7FFB00
    'MoSys', // 124 7F7F7F7F7F7F7C00
    'Provigent', // 125 7F7F7F7F7F7FFD00
    'Triad Semiconductor, Inc.' // 126 7F7F7F7F7F7FFE00
    ),
    // Bank 8
    ('Siklu Communication Ltd.', // 1 7F7F7F7F7F7F7F01
    'A Force Manufacturing Ltd.', // 2 7F7F7F7F7F7F7F02
    'Strontium', // 3 7F7F7F7F7F7F7F83
    'Abilis Systems', // 4 7F7F7F7F7F7F7F04
    'Siglead, Inc.', // 5 7F7F7F7F7F7F7F85
    'Ubicom, Inc.', // 6 7F7F7F7F7F7F7F86
    'Unifosa Corporation', // 7 7F7F7F7F7F7F7F07
    'Stretch, Inc.', // 8 7F7F7F7F7F7F7F08
    'Lantiq Deutschland GmbH', // 9 7F7F7F7F7F7F7F89
    'Visipro.', // 10 7F7F7F7F7F7F7F8A
    'EKMemory', // 11 7F7F7F7F7F7F7F0B
    'Microelectronics Institute ZTE', // 12 7F7F7F7F7F7F7F8C
    'Cognovo Ltd.', // 13 7F7F7F7F7F7F7F0D
    'Carry Technology Co. Ltd.', // 14 7F7F7F7F7F7F7F0E
    'Nokia', // 15 7F7F7F7F7F7F7F8F
    'King Tiger Technology', // 16 7F7F7F7F7F7F7F10
    'Sierra Wireless', // 17 7F7F7F7F7F7F7F91
    'HT Micron', // 18 7F7F7F7F7F7F7F92
    'Albatron Technology Co. Ltd.', // 19 7F7F7F7F7F7F7F13
    'Leica Geosystems AG', // 20 7F7F7F7F7F7F7F94
    'BroadLight', // 21 7F7F7F7F7F7F7F15
    'AEXEA', // 22 7F7F7F7F7F7F7F16
    'ClariPhy Communications, Inc.', // 23 7F7F7F7F7F7F7F97
    'Green Plug', // 24 7F7F7F7F7F7F7F98
    'Design Art Networks', // 25 7F7F7F7F7F7F7F19
    'Mach Xtreme Technology Ltd.', // 26 7F7F7F7F7F7F7F1A
    'ATO Solutions Co. Ltd.', // 27 7F7F7F7F7F7F7F9B
    'Ramsta', // 28 7F7F7F7F7F7F7F1C
    'Greenliant Systems, Ltd.', // 29 7F7F7F7F7F7F7F9D
    'Teikon', // 30 7F7F7F7F7F7F7F9E
    'Antec Hadron', // 31 7F7F7F7F7F7F7F1F
    'NavCom Technology, Inc.', // 32 7F7F7F7F7F7F7F20
    'Shanghai Fudan Microelectronics', // 33 7F7F7F7F7F7F7FA1
    'Calxeda, Inc.', // 34 7F7F7F7F7F7F7FA2
    'JSC EDC Electronics', // 35 7F7F7F7F7F7F7F23
    'Kandit Technology Co. Ltd.', // 36 7F7F7F7F7F7F7FA4
    'Ramos Technology', // 37 7F7F7F7F7F7F7F25
    'Goldenmars Technology', // 38 7F7F7F7F7F7F7F26
    'XeL Technology Inc.', // 39 7F7F7F7F7F7F7FA7
    'Newzone Corporation', // 40 7F7F7F7F7F7F7FA8
    'ShenZhen MercyPower Tech', // 41 7F7F7F7F7F7F7F29
    'Nanjing Yihuo Technology', // 42 7F7F7F7F7F7F7F2A
    'Nethra Imaging Inc.', // 43 7F7F7F7F7F7F7FAB
    'SiTel Semiconductor BV', // 44 7F7F7F7F7F7F7F2C
    'SolidGear Corporation', // 45 7F7F7F7F7F7F7FAD
    'Topower Computer Ind Co Ltd.', // 46 7F7F7F7F7F7F7FAE
    'Wilocity', // 47 7F7F7F7F7F7F7F2F
    'Profichip GmbH', // 48 7F7F7F7F7F7F7FB0
    'Gerad Technologies', // 49 7F7F7F7F7F7F7F31
    'Ritek Corporation', // 50 7F7F7F7F7F7F7F32
    'Gomos Technology Limited', // 51 7F7F7F7F7F7F7FB3
    'Memoright Corporation', // 52 7F7F7F7F7F7F7F34
    'D-Broad, Inc.', // 53 7F7F7F7F7F7F7FB5
    'HiSilicon Technologies', // 54 7F7F7F7F7F7F7FB6
    'Syndiant Inc..', // 55 7F7F7F7F7F7F7F37
    'Enverv Inc.', // 56 7F7F7F7F7F7F7F38
    'Cognex', // 57 7F7F7F7F7F7F7FB9
    'Xinnova Technology Inc.', // 58 7F7F7F7F7F7F7FBA
    'Ultron AG', // 59 7F7F7F7F7F7F7F3B
    'Concord Idea Corporation', // 60 7F7F7F7F7F7F7FBC
    'AIM Corporation', // 61 7F7F7F7F7F7F7F3D
    'Lifetime Memory Products', // 62 7F7F7F7F7F7F7F3E
    'Ramsway', // 63 7F7F7F7F7F7F7FBF
    'Recore Systems B.V.', // 64 7F7F7F7F7F7F7F40
    'Haotian Jinshibo Science Tech', // 65 7F7F7F7F7F7F7FC1
    'Being Advanced Memory', // 66 7F7F7F7F7F7F7FC2
    'Adesto Technologies', // 67 7F7F7F7F7F7F7F43
    'Giantec Semiconductor, Inc.', // 68 7F7F7F7F7F7F7FC4
    'HMD Electronics AG', // 69 7F7F7F7F7F7F7F45
    'Gloway International (HK)', // 70 7F7F7F7F7F7F7F46
    'Kingcore', // 71 7F7F7F7F7F7F7FC7
    'Anucell Technology Holding', // 72 7F7F7F7F7F7F7FC8
    'Accord Software & Systems Pvt. Ltd.', // 73 7F7F7F7F7F7F7F49
    'Active-Semi Inc.', // 74 7F7F7F7F7F7F7F4A
    'Denso Corporation', // 75 7F7F7F7F7F7F7FCB
    'TLSI Inc.', // 76 7F7F7F7F7F7F7F4C
    'Qidan', // 77 7F7F7F7F7F7F7FCD
    'Mustang', // 78 7F7F7F7F7F7F7FCE
    'Orca Systems', // 79 7F7F7F7F7F7F7F4F
    'Passif Semiconductor', // 80 7F7F7F7F7F7F7FD0
    'GigaDevice Semiconductor(Beijing) Inc.', // 81 7F7F7F7F7F7F7F51
    'Memphis Electronic', // 82 7F7F7F7F7F7F7F52
    'Beckhoff Automation GmbH', // 83 7F7F7F7F7F7F7FD3
    'Harmony Semiconductor Corp', // 84 7F7F7F7F7F7F7F54
    'Air Computers SRL', // 85 7F7F7F7F7F7F7FD5
    'TMT Memory', // 86 7F7F7F7F7F7F7FD6
    'Eorex Corporation', // 87 7F7F7F7F7F7F7F57
    'Xingtera', // 88 7F7F7F7F7F7F7F58
    'Netsol', // 89 7F7F7F7F7F7F7FD9
    'Bestdon Technology Co. Ltd.', // 90 7F7F7F7F7F7F7FDA
    'Baysand Inc.', // 91 7F7F7F7F7F7F7F5B
    'Uroad Technology Co. Ltd', // 92 7F7F7F7F7F7F7FDC
    'Wilk Elektronik S.A.', // 93 7F7F7F7F7F7F7F5D
    'AAI', // 94 7F7F7F7F7F7F7F5E
    '', // 95 7F7F7F7F7F7F7FDF
    '', // 96 7F7F7F7F7F7F7FE0
    '', // 97 7F7F7F7F7F7F7F61
    '', // 98 7F7F7F7F7F7F7F62
    '', // 99 7F7F7F7F7F7F7FE3
    '', // 100 7F7F7F7F7F7F7F64
    '', // 101 7F7F7F7F7F7F7FE5
    '', // 102 7F7F7F7F7F7F7FE6
    '', // 103 7F7F7F7F7F7F7F67
    '', // 104 7F7F7F7F7F7F7F68
    '', // 105 7F7F7F7F7F7F7FE9
    '', // 106 7F7F7F7F7F7F7FEA
    '', // 107 7F7F7F7F7F7F7F6B
    '', // 108 7F7F7F7F7F7F7FEC
    '', // 109 7F7F7F7F7F7F7F6D
    '', // 110 7F7F7F7F7F7F7F6E
    '', // 111 7F7F7F7F7F7F7FEF
    '', // 112 7F7F7F7F7F7F7F70
    '', // 113 7F7F7F7F7F7F7FF1
    '', // 114 7F7F7F7F7F7F7FF2
    '', // 115 7F7F7F7F7F7F7F73
    '', // 116 7F7F7F7F7F7F7FF4
    '', // 117 7F7F7F7F7F7F7F75
    '', // 118 7F7F7F7F7F7F7F76
    '', // 119 7F7F7F7F7F7F7FF7
    '', // 120 7F7F7F7F7F7F7FF8
    '', // 121 7F7F7F7F7F7F7F79
    '', // 122 7F7F7F7F7F7F7F7A
    '', // 123 7F7F7F7F7F7F7FFB
    '', // 124 7F7F7F7F7F7F7F7C
    '', // 125 7F7F7F7F7F7F7FFD
    '' // 126 7F7F7F7F7F7F7FFE
    ),
    // Bank 9
    ('3D PLUS', // 01
    'Diehl Aerospace', // 02
    'Fairchild', // 83
    'Mercury Systems', // 04
    'Sonics, Inc.', // 85
    '6 GE Intelligent Platforms GmbH & Co.', // 86
    '7 Shenzhen Jinge Information Co. Ltd.', // 07
    '8 SCWW', // 08
    '9 Silicon Motion Inc.', // 89
    '10 Anurag', // 8A
    '11 King Kong', // 0B
    '12 FROM30 Co. Ltd.', // 8C
    '13 Gowin Semiconductor Corp', // 0D
    '14 Fremont Micro Devices Ltd.', // 0E
    '15 Ericsson Modems', // 8F
    '16 Exelis', // 10
    '17 Satixfy Ltd.', // 91
    '18 Galaxy Microsystems Ltd.', // 92
    '19 Gloway International Co. Ltd.', // 13
    '20 Lab', // 94
    '21 Smart Energy Instruments', // 15
    '22 Approved Memory Corporation', // 16
    '23 Axell Corporation', // 97
    '24 ISD Technology Limited', // 98
    '25 Phytium', // 19
    '26 Xi’an SinoChip Semiconductor', // 1A
    '27 Ambiq Micro', // 9B
    '28 eveRAM Technology, Inc.', // 1C
    '29 Infomax', // 9D
    '30 Butterfly Network, Inc.', // 9E
    '31 Shenzhen City Gcai Electronics', // 1F
    '32 Stack Devices Corporation', // 20
    '33 ADK Media Group', // A1
    '34 TSP Global Co., Ltd.', // A2
    '35 HighX', // 23
    '36 Shenzhen Elicks Technology', // A4
    '37 ISSI/Chingis', // 25
    '38 Google, Inc.', // 26
    '39 Dasima International Development', // A7
    '40 Leahkinn Technology Limited', // A8
    '41 HIMA Paul Hildebrandt GmbH Co KG', // 29
    '42 Keysight Technologies', // 2A
    '43 Techcomp International Fastable)', // AB
    '44 Ancore Technology Corporation', // 2C
    '45 Nuvoton', // AD
    '46 Korea Uhbele International Group Ltd.', // AE
    '47 Ikegami Tsushinki Co Ltd.', // 2F
    '48 RelChip, Inc.', // B0
    '49 Baikal Electronics', // 31
    '50 Nemostech Inc.', // 32
    '51 Memorysolution GmbH', // B3
    '52 Silicon Integrated Systems Corporation', // 34
    '53 Xiede', // B5
    '54 Multilaser Components', // B6
    '55 Flash Chi', // 37
    '56 Jone', // 38
    '57 GCT Semiconductor Inc.', // B9
    '58 Hong Kong Zetta Device Technology', // BA
    '59 Unimemory Technologys) Pte Ltd.', // 3B
    '60 Cuso', // BC
    '61 Kuso', // 3D
    '62 Uniquify Inc.', // 3E
    '63 Skymedi Corporation', // BF
    '64 Core Chance Co. Ltd.', // 40
    '65 Tekism Co. Ltd.', // C1
    '66 Seagate Technology PLC', // C2
    '67 Hong Kong Gaia Group Co. Limited', // 43
    '68 Gigacom Semiconductor LLC', // C4
    '69 V2 Technologies', // 45
    '70 TLi', // 46
    '71 Neotion', // C7
    '72 Lenovo', // C8
    '73 Shenzhen Zhongteng Electronic Corp. Ltd.', // 49
    '74 Compound Photonics', // 4A
    '75 Cognimem Technologies, Inc.', // CB
    '76 Shenzhen Pango Microsystems Co. Ltd', // 4C
    '77 Vasekey', // CD
    '78 Cal-Comp Industria de Semicondutores', // CE
    '79 Eyenix Co., Ltd.', // 4F
    '80 Heoriady', // D0
    '81 Accelerated Memory Production Inc.', // 51
    '82 INVECAS, Inc.', // 52
    '83 AP Memory', // D3
    '84 Douqi Technology', // 54
    '85 Etron Technology, Inc.', // D5
    '86 Indie Semiconductor', // D6
    '87 Socionext Inc.', // 57
    '88 HGST', // 58
    '89 EVGA', // D9
    '90 Audience Inc.', // DA
    '91 EpicGear', // 5B
    '92 Vitesse Enterprise Co.', // DC
    '93 Foxtronn International Corporation', // 5D
    '94 Bretelon Inc.', // 5E
    '95 Zbit Semiconductor, Inc.', // DF
    '', // 96 7F7F7F7F7F7F7FE0
    '', // 97 7F7F7F7F7F7F7F61
    '', // 98 7F7F7F7F7F7F7F62
    '', // 99 7F7F7F7F7F7F7FE3
    '', // 100 7F7F7F7F7F7F7F64
    '', // 101 7F7F7F7F7F7F7FE5
    '', // 102 7F7F7F7F7F7F7FE6
    '', // 103 7F7F7F7F7F7F7F67
    '', // 104 7F7F7F7F7F7F7F68
    '', // 105 7F7F7F7F7F7F7FE9
    '', // 106 7F7F7F7F7F7F7FEA
    '', // 107 7F7F7F7F7F7F7F6B
    '', // 108 7F7F7F7F7F7F7FEC
    '', // 109 7F7F7F7F7F7F7F6D
    '', // 110 7F7F7F7F7F7F7F6E
    '', // 111 7F7F7F7F7F7F7FEF
    '', // 112 7F7F7F7F7F7F7F70
    '', // 113 7F7F7F7F7F7F7FF1
    '', // 114 7F7F7F7F7F7F7FF2
    '', // 115 7F7F7F7F7F7F7F73
    '', // 116 7F7F7F7F7F7F7FF4
    '', // 117 7F7F7F7F7F7F7F75
    '', // 118 7F7F7F7F7F7F7F76
    '', // 119 7F7F7F7F7F7F7FF7
    '', // 120 7F7F7F7F7F7F7FF8
    '', // 121 7F7F7F7F7F7F7F79
    '', // 122 7F7F7F7F7F7F7F7A
    '', // 123 7F7F7F7F7F7F7FFB
    '', // 124 7F7F7F7F7F7F7F7C
    '', // 125 7F7F7F7F7F7F7FFD
    '' // 126 7F7F7F7F7F7F7FFE
    ));

implementation

function DecodeMan(s: string): string;
var
  Tab: Integer;
  i: Integer;
begin
  Tab := 0;
  if TryStrToInt(Copy(s, 2, 1), Tab) then
    for i := 1 to 126 do
      if ManArr[i] = Copy(s, 3, 2) then
        Result := JedecManufacturerTable[Tab + 1, i];
end;

function JedecManufacturerFromBinary(const AData; ASize: Integer): String;
const
  // Pre-calculated list of odd parity bits
  ParityBits: array [0 .. 15] of Byte = ($96, $69, $69, $96, $69, $96, $96, $69,
    $69, $96, $96, $69, $96, $69, $69, $96);
var
  Data: PByte;
  Bank: Integer;
  Code: Byte;
begin
  Result := '';
  Data := Addr(AData);
  if not Assigned(Data) then
    Exit;
  if (ASize < 0) or (ASize > MaximumJedecManufacturerBank) then
    ASize := MaximumJedecManufacturerBank;
  for Bank := 1 to ASize do
  begin
    Code := Data^ and not $80;
    if (Code = InvalidJedecManufacturerCode) or
      (((ParityBits[Code shr 3] shl (Code and 7) xor Data^) and $80) <> 0) then
    begin
      Break;
    end;
    if Code = ContinuationManufacturerCode then
    begin
      Inc(Data);
      Continue;
    end;
    Result := JedecManufacturerTable[Bank, Code];
    Break;
  end;
end;

function JedecManufacturerFromString(const AText: String): String;
var
  Size: Integer;
  Loop: Integer;
  ChrA: Char;
  Data: array [0 .. MaximumJedecManufacturerBank] of Byte;
begin
  Result := '[Empty]';
  Size := Length(AText) div 2;
  if Size > MaximumJedecManufacturerBank then
    Size := MaximumJedecManufacturerBank;
  FillChar(Data, Sizeof(Data), 0);
  for Loop := 0 to Size - 1 do
  begin
    ChrA := AText[Loop * 2 + 1];
    case ChrA of
      '0' .. '9':
        Data[Loop] := (Ord(ChrA) - Ord('0')) shl 4;
      'A' .. 'F':
        Data[Loop] := (Ord(ChrA) - Ord('A') + 10) shl 4;
      'a' .. 'f':
        Data[Loop] := (Ord(ChrA) - Ord('a') + 10) shl 4;
    else
      Break;
    end;
    ChrA := AText[Loop * 2 + 2];
    case ChrA of
      '0' .. '9':
        Data[Loop] := Data[Loop] or (Ord(ChrA) - Ord('0'));
      'A' .. 'F':
        Data[Loop] := Data[Loop] or (Ord(ChrA) - Ord('A') + 10);
      'a' .. 'f':
        Data[Loop] := Data[Loop] or (Ord(ChrA) - Ord('a') + 10);
    else
      Break;
    end;
    if Data[Loop] = ContinuationManufacturerCode then
      Continue;
    Result := JedecManufacturerFromBinary(Data, Loop + 1);
    Break;
  end;
end;

end.
