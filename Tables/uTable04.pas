//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable04;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, WinAPI.Windows, System.Classes;

{$REGION 'Header'}

type
  PDmiType4 = ^TDmiType4;

  TDmiType4 = packed record
    Header: TDmiHeader;
    SocketDesignation: Byte; // STRING
    ProcessorType: Byte; // ENUM
    ProcessorFamily: Byte; // ENUM
    ProcessorManufacturer: Byte; // STRING
    ProcessorID: Int64; // Varies
    ProcessorVersion: Byte; // STRING
    ProcessorVoltage: Byte; // Varies
    ExternalClock: WORD; // Varies
    MaxSpeed: WORD; // Varies
    CurrentSpeed: WORD; // Varies
    Status: Byte; // Varies
    Upgrade: Byte; // ENUM
    L1CacheHandle: WORD; // Varies
    L2CacheHandle: WORD; // Varies
    L3CacheHandle: WORD; // Varies
    SerialNumber: Byte; // STRING
    AssetTag: Byte; // STRING
    PartNumber: Byte; // STRING
    CoreCount: Byte; // Varies
    CoreEnabled: Byte; // Varies
    ThreadCount: Byte; // Varies
    ProcessorCharacteristics: WORD; // Bit Field
    ProcessorFamily2: WORD; // ENUM
  end;
{$ENDREGION}

Procedure DecodeTable4(Dump: TRomBiosDump);

var
  Dmi4: TDmiType4;
  MemoTab4: TStringList;

const
  ProcessorTypes: array [1 .. 6] of string = ('OTHER', 'UNKNOWN',
    'CENTRAL PROCESSOR', 'MATH PROCESSOR', 'DSP PROCESSOR', 'VIDEO PROCESSOR');

  ProcessorFam: array [1 .. 255] of string = ('OTHER', 'UNKNOWN', '8086 ', // 03
    '80286 ', // 04
    'Intel386™ processor', // 05
    'Intel486™ processor', // 06
    '8087 ', // 07
    '80287 ', // 08
    '80387 ', // 09
    '80487 ', // 0A
    'Intel® Pentium® processor', // 0B
    'Pentium® Pro processor', // 0C
    'Pentium® II processor', // 0D
    'Pentium® processor with MMX™ technology', // 0E
    'Intel® Celeron® processor', // 0F
    'Pentium® II Xeon™ processor', // 10
    'Pentium® III processor', // 11
    'M1Family', // 12
    'M2Family', // 13
    'Intel® Celeron® M processor', // 14
    'Intel® Pentium® 4 HT processor', // 15
    'Reserved', // 16
    'Reserved', // 17
    'AMD Duron™ Processor Family', // 18
    'K5 Family', // 19
    'K6 Family', // 1A
    'K6-2', // 1B
    'K6-3', // 1C
    'AMD Athlon™ Processor Family', // 1D
    'AMD29000 Family', // 1E
    'K6-2+', // 1F
    'Power PC Family', // 20
    'POWERPC601 ', // 21
    'POWERPC603 ', // 22
    'POWERPC603PLUS ', // 23
    'POWERPC604 ', // 24
    'POWERPC620 ', // 25
    'POWERPCX704 ', // 26
    'POWERPC750 ', // 27
    'Intel® Core™ Duo processor', // 28
    'Intel® Core™ Duo mobile processor', // 29
    'Intel® Core™ Solo mobile processor', // 2a
    'Intel® Atom™ processor', // 2B
    'Intel® Core™ M processor', // 2C
    'Reserved', // 2D
    'Reserved', // 2E
    'Reserved', // 2F
    'Alpha Family', // 30
    // Some version 2.0 specification implementations used Processor Family
    // type value 30h to represent a Pentium® Pro processor.
    'ALPHA21064 ', // 31
    'ALPHA21066 ', // 32
    'ALPHA21164 ', // 33
    'ALPHA21164PC ', // 34
    'ALPHA21164A ', // 35
    'ALPHA21264 ', // 36
    'ALPHA21364 ', // 37
    'AMD Turion™ II Ultra Dual-Core Mobile M Processor Family', // 38
    'AMD Turion™ II Dual-Core Mobile M Processor Family', // 39
    'AMD Athlon™ II Dual-Core M Processor Family', // 3A
    'AMD Opteron™ 6100 Series Processor', // 3B
    'AMD Opteron™ 4100 Series Processor', // 3C
    'AMD Opteron™ 6200 Series Processor', // 3D
    'AMD Opteron™ 4200 Series Processor', // 3E
    'AMD FX™ Series Processor', // 3F
    'MIPS ', // 40
    'MIPSR4000 ', // 41
    'MIPSR4200 ', // 42
    'MIPSR4400 ', // 43
    'MIPSR4600 ', // 44
    'MIPSR10000 ', // 45
    'AMD C-Series Processor', // 46
    'AMD E-Series Processor', // 47
    'AMD S-Series Processor', // 48
    'AMD G-Series Processor', // 49
    'AMD Z-Series Processor', // 4A
    'AMD R-Series Processor', // 4B
    'AAMD Opteron™ 4300 Series Processor', // 4C
    'AMD Opteron™ 6300 Series Processor', // 4D
    'AMD Opteron™ 3300 Series Processor', // 4E
    'AMD FirePro™ Series Processor', // 4F
    'SPARC ', // 50
    'SUPERSPARC ', // 51
    'MICROSPARC2 ', // 52
    'MICROSPARC2EP ', // 53
    'ULTRASPARC ', // 54
    'ULTRASPARC2 ', // 55
    'ULTRASPARC2PLUS ', // 56
    'ULTRASPARC3 ', // 57
    'ULTRASPARC3PLUS ', // 58
    'Available for assignment', 'Available for assignment',
    'Available for assignment', 'Available for assignment',
    'Available for assignment', 'Available for assignment',
    'Available for assignment',
    '68040 Family', // 60
    '68xxx ', // 61
    '68000 ', // 62
    '68010 ', // 63
    '68020 ', // 64
    '68030 ', // 65
    'AMD Athlon(TM) X4 Quad-Core Processor Family',
    'AMD Opteron(TM) X1000 Series Processor',
    'AMD Opteron(TM) X2000 Series APU',
    'Available for assignment',
    'Available for assignment', 'Available for assignment',
    'Available for assignment', 'Available for assignment',
    'Available for assignment', 'Available for assignment',
    'HOBBIT ', // 70
    'Available for assignment', 'Available for assignment',
    'Available for assignment', 'Available for assignment',
    'Available for assignment', 'Available for assignment',
    'Available for assignment',
    'Crusoe™ TM5000 Family', // 78
    'Crusoe™ TM3000 Family', // 79
    'Efficeon™ TM8000 Family', // 7A
    'Available for assignment', 'Available for assignment',
    'Available for assignment', 'Available for assignment',
    'Available for assignment',
    'WEITEK ', // 80
    'Available for assignment',
    'Itanium™ processor', // 82
    'AMD Athlon™ 64 Processor Family', // 83
    'AMD Opteron™ Processor Family', // 84
    'AMD Sempron™ Processor Family', // 85
    'AMD Turion™ 64 Mobile Technology', // 86
    'Dual-Core AMD Opteron™ Processor Family', // 87
    'AMD Athlon™ 64 X2 Dual-Core Processor Family', // 88
    'AMD Turion™ 64 X2 Mobile Technology', // 89
    'Quad-Core AMD Opteron™ Processor Family',
    'Third-Generation AMD Opteron™ Processor Family',
    'AMD Phenom™ FX Quad-Core Processor Family',
    'AMD Phenom™ X4 Quad-Core Processor Family',
    'AMD Phenom™ X2 Dual-Core Processor Family',
    'AMD Athlon™ X2 Dual-Core Processor Family',
    'PARISC ', // 90
    'PARISC8500 ', // 91
    'PARISC8000 ', // 92
    'PARISC7300LC ', // 93
    'PARISC7200 ', // 94
    'PARISC7100LC ', // 95
    'PARISC7100 ', // 96
    'Available for assignment', // 97
    'Available for assignment', 'Available for assignment',
    'Available for assignment', 'Available for assignment',
    'Available for assignment', 'Available for assignment',
    'Available for assignment', // 9E
    'Available for assignment', // 9F
    'V30 ', // A0
    'Quad-Core Intel® Xeon® processor 3200 Series',
    'Dual-Core Intel® Xeon® processor 3000 Series',
    'Quad-Core Intel® Xeon® processor 5300 Series',
    'Dual-Core Intel® Xeon® processor 5100 Series',
    'Dual-Core Intel® Xeon® processor 5000 Series',
    'Dual-Core Intel® Xeon® processor LV',
    'Dual-Core Intel® Xeon® processor ULV',
    'Dual-Core Intel® Xeon® processor 7100 Series',
    'Quad-Core Intel® Xeon® processor 5400 Series',
    'Quad-Core Intel® Xeon® processor',
    'Dual-Core Intel® Xeon® processor 5200 Series',
    'Dual-Core Intel® Xeon® processor 7200 Series',
    'Quad-Core Intel® Xeon® processor 7300 Series',
    'Quad-Core Intel® Xeon® processor 7400 Series',
    'Multi-Core Intel® Xeon® processor 7400 Series',
    'Pentium® III Xeon™ processor', // B0
    'Pentium® III Processor with Intel® SpeedStep™ Technology', // B1
    'Pentium® 4 Processor', // B2
    'Intel® Xeon® processor', 'AS400 Family', 'Intel® Xeon™ processor MP',
    'AMD Athlon™ XP Processor Family', 'AMD Athlon™ MP Processor Family',
    'Intel® Itanium® 2 processor', 'Intel® Pentium® M processor',
    'Intel® Celeron® D processor', 'Intel® Pentium® D processor',
    'Intel® Pentium® Processor Extreme Edition', 'Intel® Core™ Solo Processor',
    'Reserved [3]',
    // Version 2.5 of this specification listed this value as “available for assignment”.
    // CIM_Processor.mof files assigned this value to AMD K7 processors in the CIM_Processor.
    // Family property, and an SMBIOS change request assigned it to Intel Core 2
    // processors. Some implementations of the SMBIOS version 2.5 specification are
    // known to use BEh to indicate Intel Core 2 processors. Some implementations of
    // SMBIOS and some implementations of CIM-based software may also have used BEh
    // to indicate AMD K7 processors.
    'Intel® Core™ 2 Duo Processor', 'Intel® Core™ 2 Solo processor',
    'Intel® Core™ 2 Extreme processor', 'Intel® Core™ 2 Quad processor',
    'Intel® Core™ 2 Extreme mobile processor',
    'Intel® Core™ 2 Duo mobile processor',
    'Intel® Core™ 2 Solo mobile processor', 'Intel® Core™ i7 processor',
    'Dual-Core Intel® Celeron® processor', 'IBM390 Family', 'G4', 'G5',
    'ESA/390 G6', 'z/Architectur base', 'Intel® Core™ i5 processor',
    'Intel® Core™ i3 processor', // 206
    'Available for assignment', 'Available for assignment',
    'Available for assignment', 'VIA C7™-M Processor Family', // 210
    'VIA C7™-D Processor Family', 'VIA C7™ Processor Family',
    'VIA Eden™ Processor Family', 'Multi-Core Intel® Xeon® processor',
    'Dual-Core Intel® Xeon® processor 3xxx Series',
    'Quad-Core Intel® Xeon® processor 3xxx Series',
    'VIA Nano™ Processor Family',
    'Dual-Core Intel® Xeon® processor 5xxx Series',
    'Quad-Core Intel® Xeon® processor 5xxx Series', 'Available for assignment',
    // 220
    'Dual-Core Intel® Xeon® processor 7xxx Series', // 221
    'Quad-Core Intel® Xeon® processor 7xxx Series', // 222
    'Multi-Core Intel® Xeon® processor 7xxx Series', // 223
    'Multi-Core Intel® Xeon® processor 3400 Series', // 224
    'Available for assignment', 'Available for assignment',
    'Available for assignment', 'AMD Opteron™ 3000 Series Processor',
    'AMD Sempron™ II Processor',
    'Embedded AMD Opteron™ Quad-Core Processor Family', // 230
    'AMD Phenom™ Triple-Core Processor Family',
    'AMD Turion™ Ultra Dual-Core Mobile Processor Family',
    'AMD Turion™ Dual-Core Mobile Processor Family',
    'AMD Athlon™ Dual-Core Processor Family',
    'AMD Sempron™ SI Processor Family', 'AMD Phenom™ II Processor Family',
    'AMD Athlon™ II Processor Family', 'Six-Core AMD Opteron™ Processor Family',
    'AMD Sempron™ M Processor Family', // 239
    'Available for assignment', 'Available for assignment',
    'Available for assignment', 'Available for assignment',
    'Available for assignment', 'Available for assignment',
    'Available for assignment', 'Available for assignment',
    'Available for assignment', 'Available for assignment',
    'i860', // 250
    'i960',
    'Available for assignment', 'Available for assignment',
    'Indicator to obtain the processor family from the Processor Family 2 field.',
    'Reserved'
    // 100h-1FFh 256-511 These values are available for assignment, except for the following:
    // 'SH-3',
    // 'SH-4',
    // 'ARM',
    // 'StrongARM',
    // '6x86',
    // 'MediaGX',
    // 'MII',
    // 'WinChip',
    // 'DSP',
    // 'Video Processor'
    );
  // 200h-FFFDh 512- 65533 Available for assignment
  // FFFEh-FFFFh 65534-65535 Reserved

  ProzVoltage: array [1 .. 8] of string = ('5V', // 01
    '3.3V', // 02
    '2.9V', // 04
    'Reserved', 'Reserved', 'Reserved', 'Reserved', '(Legacy Mode)');

  CPUStatus: array [0 .. 7] of string = ('Unknown', 'CPU Enabled',
    'CPU Disabled by User via BIOS Setup', 'CPU Disabled by BIOS (POST Error)',
    'CPU is Idle, waiting to be enabled', 'Reserved', 'Reserved', 'Other');

  CPUUpgrade: array [1 .. 48] of string = ('OTHER', 'UNKNOWN', 'Daughter Board',
    // 03
    'ZIF SOCKET ', // 04
    'Replaceable Piggy Back', // 05
    'NONE', // 06
    'LIF SOCKET ', // 07
    'SLOT 1 ', // 08
    'SLOT 2 ', // 09
    '370-pin socket', // 0A
    'SLOT A ', // 0B
    'SLOT M ', // 0C
    'Socket 423 ', // 0D
    'Socket A (Socket 462)', // 0E
    'Socket 478 ', // 0F
    'Socket 754 ', // 10
    'Socket 940 ', // 11
    'Socket 939 ', // 12
    'Socket MPGA604 ', // 13
    'Socket LGA771 ', // 14
    'Socket LGA775 ', // 15
    'Socket S1 ', // 16
    'Socket AM2 ', // 17
    'Socket F (1207) ', // 18
    'Socket LGA1366 ', // 19
    'Socket G34 ', // 1A
    'Socket AM3 ', // 1B
    'Socket C32 ', // 1C
    'Socket LGA1156 ', // 1D
    'Socket LGA1567 ', // 1E
    'Socket PGA988A ', // 1F
    'Socket BGA1288 ', // 20
    'Socket rPGA988B ', // 21
    'Socket BGA1023 ', // 22
    'Socket BGA1224 ', // 23
    'Socket BGA1155 ', // 24
    'Socket LGA1356 ', // 25
    'Socket LGA2011 ', // 26
    'Socket FS1 ', // 27
    'Socket FS2 ', // 28
    'Socket FM1 ', // 29
    'Socket FM2 ', // 2A
    'Socket LGA2011-3 ', // 2B
    'Socket LGA1356-3 ', // 2C;
    'Socket LGA1150 ', // 2D;
    'Socket BGA1168 ', // 2E;
    'Socket BGA1234 ', // 2F;
    'Socket BGA1364'); // 30;

  Characteristics: array [1 .. 16] of string = ('Reserved', // 01
    'Unknown', // 02
    '64-bit Capable', // 04
    'Multi-Core', // 08
    'Hardware Thread', // 10
    'Execute Protection', // 20
    'Enhanced Virtualization', // 40
    'Power/Performance Control', // 80
    'Reserved', 'Reserved', 'Reserved', 'Reserved', 'Reserved', 'Reserved',
    'Reserved', 'Reserved');
  // Bits 8:15 Reserved

implementation
{ ToDo -cnicht wichtig : Core Count news in 3.0 }
Procedure DecodeTable4(Dump: TRomBiosDump);
var
  i: Integer;
  Temp: String;
begin
  if not Assigned(MemoTab4) then
    MemoTab4 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi4, SizeOf(TDmiType4));
  if Dmi4.Header.Length < $1A then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 4 wrong Length : ' + IntToStr(Dmi4.Header.Length));
  end;
  MemoTab4.Add('SocketDesignation       : ' + SmBiosGetString(Dump, Addr,
    Dmi4.SocketDesignation));
  MemoTab4.Add('Processor Type     : ' + ProcessorTypes[Dmi4.ProcessorType]);
  MemoTab4.Add('Processor Family     : ' + ProcessorFam[Dmi4.ProcessorFamily]);
  MemoTab4.Add('Manufacturer       : ' + SmBiosGetString(Dump, Addr,
    Dmi4.ProcessorManufacturer));
  MemoTab4.Add('Processor ID     : ' + IntToHex(Dmi4.ProcessorID, 4));
  MemoTab4.Add('Processor Version      : ' + SmBiosGetString(Dump, Addr,
    Dmi4.ProcessorVersion));
  Text := { ReverseString } (ByteToBin(Dmi4.ProcessorVoltage));
  if Length(Text) = 8 then
  { ToDo -cnicht wichtig : CPU Voltage Fix }
  begin
    for i := 1 to 7 do
      if Text[i] = '1' then
      begin
        MemoTab4.Add('Processor Voltage0    7 : ' + ProzVoltage[i]);
        if Text[8] = '0' then
          MemoTab4.Add('Processor Voltage     : ' + ProzVoltage[i] + '  -  ' +
            ProzVoltage[8]);
      end;
  end;
  MemoTab4.Add('External clock     : ' + IntToStr(Dmi4.ExternalClock) + ' Mhz');
  MemoTab4.Add('Max Speed     : ' + IntToStr(Dmi4.MaxSpeed) + ' Mhz');
  MemoTab4.Add('Current Speed     : ' + IntToStr(Dmi4.CurrentSpeed) + ' Mhz');
  // Status
  if Dmi4.Status and $40 = $40 then
    MemoTab4.Add('Status     : ' + 'CPU Socket Populated / ' +
      CPUStatus[Dmi4.Status and $07])
  else
    MemoTab4.Add('Status     : ' + 'CPU Socket Unpopulated / ' +
      CPUStatus[Dmi4.Status and $07]);
  MemoTab4.Add('Processor Upgrade     : ' + CPUUpgrade[Dmi4.Upgrade]);
  MemoTab4.Add('L1CacheHandle     : ' + IntToStr(Dmi4.L1CacheHandle));
  MemoTab4.Add('L2CacheHandle     : ' + IntToStr(Dmi4.L2CacheHandle));
  MemoTab4.Add('L3CacheHandle     : ' + IntToStr(Dmi4.L3CacheHandle));
  MemoTab4.Add('Serial       : ' + SmBiosGetString(Dump, Addr,
    Dmi4.SerialNumber));
  MemoTab4.Add('Asset Type       : ' + SmBiosGetString(Dump, Addr,
    Dmi4.AssetTag));
  MemoTab4.Add('Part Number       : ' + SmBiosGetString(Dump, Addr,
    Dmi4.PartNumber));
  MemoTab4.Add('Core Count     : ' + IntToStr(Dmi4.CoreCount));
  MemoTab4.Add('Core Enabled     : ' + IntToStr(Dmi4.CoreEnabled));
  MemoTab4.Add('Thread Count     : ' + IntToStr(Dmi4.ThreadCount));
  Text := WordtoBinReverse(Dmi4.ProcessorCharacteristics);
  if Length(Text) = 16 then
  begin
    MemoTab4.Add('Processor Characteristics     : ' { + Text } );
    for i := 1 to 16 do
      if Text[i] = '1' then
        MemoTab4.Add(Characteristics[i]);
  end;
  if Dmi4.ProcessorFamily2 <= 265 then
    MemoTab4.Add('Processor Family 2     : ' + ProcessorFam
      [Dmi4.ProcessorFamily2]);
end;

end.
