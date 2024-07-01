//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable00;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, System.Classes;

Procedure DecodeTable0(Dump: TRomBiosDump);

{$REGION 'Header'}

type
  TDmiType0 = packed record
    { h00 } Header: TDmiHeader; // min $12
    { h04 } Vendor: Byte; // STRING
    { h05 } Version: Byte; // STRING
    { h06 } StartingSegment: Word; // Varies
    { h08 } ReleaseDate: Byte; // STRING
    { h09 } BiosRomSize: Byte; // Varies (n)
    { h0A } Characteristics: Int64; // QWORD Bit Field
    { h0C } ExtensionBytes: Array [0 .. 1] of Byte; // 2.4+ - 2 Bytes
    { h0E } Major: Byte; // Varies
    { h0F } Minor: Byte; // Varies
    { h10 } ContFirmMajor: Byte; // Varies
    { h11 } ContFirmMinor: Byte; // Varies
  end;

  PDmiType0 = ^TDmiType0;
{$ENDREGION}
{$REGION 'var/const'}

var
  Dmi0: TDmiType0;
  MemoTab0: TStringList;
  Table0 : Array of PtableDataStr;

const
test : Array[0..6] of String=('BIOS Vendor', 'BIOS Version', 'BIOS Release Date',
'BIOS Start Address', 'ROM-BIOS Size', 'Extension 1', 'Extension 2');

  ExtensionByte1: array [1 .. 8] of string = ('ACPI supported',
    'USB Legacy is supported', 'AGP is supported', 'I2O boot is supported',
    'LS-120 boot is supported', 'ATAPI ZIP Drive boot is supported',
    '1394 boot is supported', 'Smart Battery supported');

  ExtensionByte2: array [1 .. 8] of string =
    ('BIOS Boot Specification supported',
    'Function key-initiated Network Service boot supported',
    'Enable Targeted Content Distribution', 'UEFI Specification is supported.',
    'The SMBIOS table describes a virtual machine.', 'Reserved', 'Reserved',
    'Reserved');

  BiosChar: array [1 .. 32] of string = ('Reserved', 'Reserved', 'Unknown',
    'BIOS Characteristics are not supported.', 'ISA is supported.',
    'MCA is supported.', 'EISA is supported.', 'PCI is supported.',
    'PC Card (PCMCIA) is supported.', 'Plug and Play is supported.',
    'APM is supported.', 'BIOS is Upgradeable (Flash).',
    'BIOS shadowing is allowed.', 'VL-VESA is supported.',
    'ESCD support is available.', 'Boot from CD is supported.',
    'Selectable Boot is supported.', 'BIOS ROM is socketed.',
    'Boot From PC Card (PCMCIA) is supported.',
    'EDD Specification is supported',
    'Int 13h — Japanese Floppy for NEC 9800 1.2 MB (3.5”, 1K Bytes/Sector, 360 RPM) is supported.',
    'Int 13h — Japanese Floppy for Toshiba 1.2 MB (3.5”, 360 RPM) is supported.',
    'Int 13h — 5.25” / 360 KB Floppy Services are supported.',
    'Int 13h — 5.25” /1.2 MB Floppy Services are supported.',
    'Int 13h — 3.5” / 720 KB Floppy Services are supported.',
    'Int 13h — 3.5” / 2.88 MB Floppy Services are supported.',
    'Int 5h, Print Screen Service is supported.',
    'Int 9h, 8042 Keyboard services are supported.',
    'Int 14h, Serial Services are supported.',
    'Int 17h, Printer Services are supported.',
    'Int 10h, CGA/Mono Video Services are supported.', 'NEC PC-98');
  // Bits32:47 Reserved for BIOS Vendor
  // Bits 48:63 Reserved for System Vendor
{$ENDREGION}

implementation

{$REGION 'Decode old'}

Procedure DecodeTable0(Dump: TRomBiosDump);
var
  i: Integer;
begin
  if not Assigned(MemoTab0) then
    MemoTab0 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi0, SizeOf(TDmiType0));
//   if not ((SmEP32.MajorVersion = 2) and (SmEP32.MinorVersion = 0) and
//    (Dmi0.Header.Length = $12))
//    or not
//    ((SmEP32.MajorVersion = 2) and ((SmEP32.MinorVersion = 1) or
//    (SmEP32.MinorVersion = 2)) and (Dmi0.Header.Length <> $13))
//    or not
//    ((SmEP32.MajorVersion = 2) and (SmEP32.MinorVersion = 3) and
//     (Dmi0.Header.Length = $14))
//    or not
//   (((SmEP32.MajorVersion = 2) and (SmEP32.MinorVersion >= 4)) and
//    (Dmi0.Header.Length = $18)) then

  if Dmi0.Header.Length < $12 then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 0 wrong Length : ' + IntToStr(Dmi0.Header.Length));
  end;
  MemoTab0.Add('BIOS Vendor       : ' + SmBiosGetString(Dump, Addr,
    Dmi0.Vendor));
  MemoTab0.Add('BIOS Version      : ' + SmBiosGetString(Dump, Addr,
    Dmi0.Version));
  MemoTab0.Add('BIOS Release Date : ' + SmBiosGetString(Dump, Addr,
    Dmi0.ReleaseDate));
  MemoTab0.Add('SM BIOS Start Address: ' + IntToHex(Dmi0.StartingSegment, 4) +
    ':0000 (' + IntToStr(($10000 - Dmi0.StartingSegment) div 64) + ' KB)');
  MemoTab0.Add('ROM-BIOS Size     : ' + IntToStr((Dmi0.BiosRomSize + 1) *
    64) + ' KB');
  MemoTab0.Add('');
  // Characteristics
  Text := (IntToBinReverse(Dmi0.Characteristics));
  if Length(Text) >= High(BiosChar) then
  begin
    MemoTab0.Add('Characteristics     : ' + Text);
    for i := 1 to High(BiosChar) do
      if Text[i] = '1' then
        MemoTab0.Add(BiosChar[i]);
    MemoTab0.Add('');
  end;
  // Extension 1
  Text := ReverseString(Byte2bit(Dmi0.ExtensionBytes[0]));
  if Length(Text) >= High(ExtensionByte1) then
  begin
    MemoTab0.Add('Extension 1     : ' + Byte2bit(Dmi0.ExtensionBytes[0]));
    for i := 1 to High(ExtensionByte1) do
      if Text[i] = '1' then
        MemoTab0.Add(ExtensionByte1[i]);
    MemoTab0.Add('');
  end;
  // Extension 2
  Text := ReverseString(Byte2bit(Dmi0.ExtensionBytes[1]));
  if Length(Text) >= High(ExtensionByte2) then
  begin
    MemoTab0.Add('Extension 2     : ' + Byte2bit(Dmi0.ExtensionBytes[1]));
    for i := 1 to High(ExtensionByte2) do
      if Text[i] = '1' then
        MemoTab0.Add(ExtensionByte2[i]);
    MemoTab0.Add('');
  end;
  if (Dmi0.Major = $FF) { and (Dmi0.Minor = $FF) } then
    Text := 'not used'
  else
    Text := IntToStr(Dmi0.Major) + '.' + IntToStr(Dmi0.Minor);
  MemoTab0.Add('System BIOS       : ' + Text);
  if (Dmi0.ContFirmMajor = $FF) and (Dmi0.ContFirmMinor = $FF) then
    Text := 'is not upgradeable'
  else
    Text := IntToStr(Dmi0.ContFirmMajor) + '.' + IntToStr(Dmi0.ContFirmMinor);
  MemoTab0.Add('Embedded Controller Firmware       : ' + Text);
end;
{$ENDREGION}

//{$REGION 'Decode new'}
//
//Procedure DecodeTable00(Dump: TRomBiosDump);
//var
//  i: Integer;
//begin
//// Table0
//  ReadRomDumpBuffer(Dump, Addr, Dmi0, SizeOf(TDmiType0));
//  if Dmi0.Header.Length < $12 then
//  begin
//    Showmessage('Table 0 wrong Length : ' + IntToStr(Dmi0.Header.Length));
//   // CreateTable(Table0,1);
//    Table0[0].Name :=  'Table 0 wrong Length : ';
//    Table0[0].Name :=  IntToStr(Dmi0.Header.Length);
//  end else
// // CreateTable(Table0,11);
//
//  MemoTab0.Add('BIOS Vendor       : ' + SmBiosGetString(Dump, Addr,
//    Dmi0.Vendor));
//  MemoTab0.Add('BIOS Version      : ' + SmBiosGetString(Dump, Addr,
//    Dmi0.Version));
//  MemoTab0.Add('BIOS Release Date : ' + SmBiosGetString(Dump, Addr,
//    Dmi0.ReleaseDate));
//  MemoTab0.Add('SM BIOS Start Address: ' + IntToHex(Dmi0.StartingSegment, 4) +
//    ':0000 (' + IntToStr(($10000 - Dmi0.StartingSegment) div 64) + ' KB)');
//  MemoTab0.Add('ROM-BIOS Size     : ' + IntToStr((Dmi0.BiosRomSize + 1) *
//    64) + ' KB');
//  MemoTab0.Add('');
//  // Characteristics
//  Text := ReverseString(IntToBIN(Dmi0.Characteristics));
//  if Length(Text) >= High(BiosChar) then
//  begin
//    MemoTab0.Add('Characteristics     : ' + Text);
//    for i := 1 to High(BiosChar) do
//      if Text[i] = '1' then
//        MemoTab0.Add(BiosChar[i]);
//    MemoTab0.Add('');
//  end;
//  // Extension 1
//  Text := ReverseString(Byte2bit(Dmi0.ExtensionBytes[0]));
//  if Length(Text) >= High(ExtensionByte1) then
//  begin
//    MemoTab0.Add('Extension 1     : ' + Byte2bit(Dmi0.ExtensionBytes[0]));
//    for i := 1 to High(ExtensionByte1) do
//      if Text[i] = '1' then
//        MemoTab0.Add(ExtensionByte1[i]);
//    MemoTab0.Add('');
//  end;
//  // Extension 2
//  Text := ReverseString(Byte2bit(Dmi0.ExtensionBytes[1]));
//  if Length(Text) >= High(ExtensionByte2) then
//  begin
//    MemoTab0.Add('Extension 2     : ' + Byte2bit(Dmi0.ExtensionBytes[1]));
//    for i := 1 to High(ExtensionByte2) do
//      if Text[i] = '1' then
//        MemoTab0.Add(ExtensionByte2[i]);
//    MemoTab0.Add('');
//  end;
//  if (Dmi0.Major = $FF) { and (Dmi0.Minor = $FF) } then
//    Text := 'not used'
//  else
//    Text := IntToStr(Dmi0.Major) + '.' + IntToStr(Dmi0.Minor);
//  MemoTab0.Add('System BIOS       : ' + Text);
//  if (Dmi0.ContFirmMajor = $FF) and (Dmi0.ContFirmMinor = $FF) then
//    Text := 'is not upgradeable'
//  else
//    Text := IntToStr(Dmi0.ContFirmMajor) + '.' + IntToStr(Dmi0.ContFirmMinor);
//  MemoTab0.Add('Embedded Controller Firmware       : ' + Text);
//end;
//{$ENDREGION}

end.
