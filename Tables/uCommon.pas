//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uCommon;

interface

uses umain, uBiosDump, WinAPI.CommCtrl, WinAPI.Windows, System.SysUtils,
  Generics.Collections,
  System.Math, Vcl.Dialogs, System.StrUtils;

type
  QWord = UInt64;

{$REGION 'Header'}

type
  PSmBiosEntryPoint32 = ^TSmBiosEntryPoint32;

  TSmBiosEntryPoint32 = packed record
    AnchorString: array [0 .. 3] of AnsiChar; // 00   // _SM_
    Checksum: Byte; // 04
    BLength: Byte; // 05
    MajorVersion: Byte; // 06
    MinorVersion: Byte; // 07
    MaxStructSize: Word; // 08
    Revision: Byte; // 0A
    FormattedArea: array [0 .. 4] of Byte; // 0B

    Intermediate: packed record
      AnchorString: array [0 .. 4] of AnsiChar; // 10   _DMI_
      Checksum: Byte; // 15
      TableLength: Word; // 16
      TableAddress: Longword; // 18
      NumStructs: Word; // 1C
      Revision: Byte; // 1E
    end; // 1F

  end;

  PSmBiosEntryPoint64 = ^TSmBiosEntryPoint64;

  TSmBiosEntryPoint64 = packed record
    AnchorString: array [0 .. 4] of AnsiChar; // _SM3_
    Checksum: Byte; // 05
    BLength: Byte; // 06
    MajorVersion: Byte; // 07
    MinorVersion: Byte; // 08
    Docrev: Byte; // 09
    Revision: Byte; // 0A
    Reserved: Byte; // 0B
    StrTabMaxSize: Dword; // 0C
    StrTabAdd: QWord; // 10
  end;

  TDmiHeader = packed record
    Type_: Byte;
    Length: Byte;
    Handle: Word;
  end;

{$ENDREGION}

type
  tabledec = record
    Typ: Byte;
    Name: String;
  end;

type
  tableDataStr = record
    Name: String;
    Value: String;
  end;

  PtableDataStr = ^tableDataStr;

const

  SMB_BIOSINFO = 0; // BIOS Information
  SMB_SYSINFO = 1; // System Information
  SMB_BASEINFO = 2; // Base Board Information
  SMB_SYSENC = 3; // System Enclosure or Chassis
  SMB_CPU = 4; // Processor Information
  SMB_MEMCTRL = 5; // Memory Controller Information
  SMB_MEMMOD = 6; // Memory Module Information
  SMB_CACHE = 7; // Cache Information
  SMB_PORTCON = 8; // Port Connector Information
  SMB_SLOTS = 9; // System Slots
  SMB_ONBOARD = 10; // On Board Devices Information
  SMB_OEMSTR = 11; // OEM Strings
  SMB_SYSCFG = 12; // System Configuration Options
  SMB_LANG = 13; // BIOS Language Information
  SMB_GRP = 14; // Group Associations
  SMB_EVENT = 15; // System Event Log
  SMB_PHYSMEM = 16; // Physical Memory Array
  SMB_MEMDEV = 17; // Memory Device
  SMB_MEMERR32 = 18; // 32-bit Memory Error Information
  SMB_MEMMAP = 19; // Memory Array Mapped Address
  SMB_MEMDEVMAP = 20; // Memory Device Mapped Address
  SMB_POINTER = 21; // Built-in Pointing Device
  SMB_BATTERY = 22; // Portable Battery
  SMB_RESET = 23; // System Reset
  SMB_SECURITY = 24; // Hardware Security
  SMB_POWER = 25; // System Power Controls
  SMB_VOLTAGE = 26; // Voltage Probe
  SMB_COOL = 27; // Cooling Device
  SMB_TEMP = 28; // Tempature Probe
  SMB_CURRENT = 29; // Electrical Current Probe
  SMB_OOBREM = 30; // Out-of-Band Remote Access
  SMB_BIS = 31; // Boot Integrity Services (BIS) Entry Point
  SMB_SYSBOOT = 32; // System Boot Information
  SMB_MEMERR64 = 33; // 64-bit Memory Error Information
  SMB_MGT = 34; // Management Device
  SMB_MGTCMP = 35; // Management Device Component
  SMB_MGTTHR = 36; // Management Device Threshold Data
  SMB_MEMCHAN = 37; // Memory Channel
  SMB_IPMI = 38; // IPMI Device Information
  SMB_SPS = 39; // System Power Supply
  SMB_ADDInfo = 40; // Additional Information
  SMB_OBDev = 41; // Onboard Device Extended Information
  SMB_ManCont = 42; // Management Controller Host Interface
  SMB_TPM = 43; // TPM Device'
  SMB_CPUINF = 44; // Processor Additional Information
  SMB_FirmInf = 45; // Firmware Inventory Information
  SMB_StrProp = 46; // String Property
  SMB_INACTIVE = 126; // Inactive
  SMB_EOT = 127; // End-of-Table
  SMB_FWV = 128; // FirmwareVolume (Apple)
  SMB_MSPD = 130; // MemorySPD (Apple)
  SMB_ACPU = 131; // Processor (Apple)
  SMB_BusTR = 132; // Bus transfer rate (Apple)
  SMB_BusTR = 133; // Platform_Feature (Apple)
  SMB_BusTR = 134; // SMC_Information (Apple)

  SMB_TableTypes: array [0 .. 48] of tabledec = ((Typ: SMB_BIOSINFO;
    Name: 'BIOS Information'), (Typ: SMB_SYSINFO; Name: 'System Information'),
    (Typ: SMB_BASEINFO; Name: 'Base Board Information'), (Typ: SMB_SYSENC;
    Name: 'System Enclosure or Chassis'), (Typ: SMB_CPU;
    Name: 'Processor Information'), (Typ: SMB_MEMCTRL;
    Name: 'Memory Controller Information'), (Typ: SMB_MEMMOD;
    Name: 'Memory Module Information'), (Typ: SMB_CACHE;
    Name: 'Cache Information'), (Typ: SMB_PORTCON;
    Name: 'Port Connector Information'), (Typ: SMB_SLOTS; Name: 'System Slots'),
    (Typ: SMB_ONBOARD; Name: 'On Board Devices Information'), (Typ: SMB_OEMSTR;
    Name: 'OEM Strings'), (Typ: SMB_SYSCFG;
    Name: 'System Configuration Options'), (Typ: SMB_LANG;
    Name: 'BIOS Language Information'), (Typ: SMB_GRP;
    Name: 'Group Associations'), (Typ: SMB_EVENT; Name: 'System Event Log'),
    (Typ: SMB_PHYSMEM; Name: 'Physical Memory Array'), (Typ: SMB_MEMDEV;
    Name: 'Memory Device'), (Typ: SMB_MEMERR32;
    Name: '32-bit Memory Error Information'), (Typ: SMB_MEMMAP;
    Name: 'Memory Array Mapped Address'), (Typ: SMB_MEMDEVMAP;
    Name: 'Memory Device Mapped Address'), (Typ: SMB_POINTER;
    Name: 'Built-in Pointing Device'), (Typ: SMB_BATTERY;
    Name: 'Portable Battery'), (Typ: SMB_RESET; Name: 'System Reset'),
    (Typ: SMB_SECURITY; Name: 'Hardware Security'), (Typ: SMB_POWER;
    Name: 'System Power Controls'), (Typ: SMB_VOLTAGE; Name: 'Voltage Probe'),
    (Typ: SMB_COOL; Name: ' Cooling Device'), (Typ: SMB_TEMP;
    Name: 'Temperature Probe'), (Typ: SMB_CURRENT;
    Name: 'Electrical Current Probe'), (Typ: SMB_OOBREM;
    Name: 'Out-of-Band Remote Access'), (Typ: SMB_BIS;
    Name: 'Boot Integrity Services (BIS) Entry Point'), (Typ: SMB_SYSBOOT;
    Name: 'System Boot Information'), (Typ: SMB_MEMERR64;
    Name: '64-bit Memory Error Information'), (Typ: SMB_MGT;
    Name: 'Management Device'), (Typ: SMB_MGTCMP;
    Name: 'Management Device Component'), (Typ: SMB_MGTTHR;
    Name: 'Management Device Threshold Data'), (Typ: SMB_MEMCHAN;
    Name: 'Memory Channel'), (Typ: SMB_IPMI; Name: 'IPMI Device Information'),
    (Typ: SMB_SPS; Name: 'System Power Supply'), (Typ: SMB_ADDInfo;
    Name: 'Additional Information'), (Typ: SMB_OBDev; Name: 'Onboard Device'),
    (Typ: SMB_ManCont; Name: 'Management Controller Host Interface'),
    (Typ: SMB_INACTIVE; Name: 'Inactive'), (Typ: SMB_EOT; Name: 'End-of-Table'),
    (Typ: SMB_FWV; Name: 'FirmwareVolume (Apple)'), (Typ: SMB_MSPD;
    Name: 'MemorySPD (Apple)'), (Typ: SMB_ACPU; Name: 'Processor (Apple)'),
    (Typ: SMB_BusTR; Name: 'Bus transfer rate (Apple)'));

  DateOffset = Pointer($000FFFF5);
  hexes: array [0 .. 15] of char = ('0', '1', '2', '3', '4', '5', '6', '7', '8',
    '9', 'A', 'B', 'C', 'D', 'E', 'F');

  Binary: array [0 .. 15] of string = ('0000', '0001', '0010', '0011', '0100',
    '0101', '0110', '0111', '1000', '1001', '1010', '1011', '1100', '1101',
    '1110', '1111');

  Tables: Array [0 .. 132] of String = (' BIOS Information ',
    ' System Information ', ' Base Board or Module Information ',
    ' System Enclosure or Chassis ', ' Processor Information ',
    ' Memory Controller Information ', ' Memory Module Information ',
    ' Cache Information ', ' Port Connector Information ', ' System Slots ',
    ' On Board Devices Information ', ' OEM Strings ',
    ' System Configuration Options ', ' BIOS Language Information ',
    ' Group Associations ', ' System Event Log ', ' Physical Memory Array ',
    ' Memory Device ', ' 32bit Memory Error Information ',
    ' Memory Array Mapped Address ', ' Memory Device Mapped Address ',
    ' Builtin Pointing Device ', ' Portable Battery ', ' System Reset ',
    ' Hardware Security ', ' System Power Controls ', ' Voltage Probe ',
    ' Cooling Device ', ' Temperature Probe ', ' Electrical Current Probe ',
    'Out - of - Band Remote Access ', ' Boot Integrity Services ',
    ' System Boot Information ', ' 64bit Memory Error Information ',
    ' Management Device ', ' Management Device Component ',
    ' Management Device Threshold Data ', ' Memory Channel ',
    ' IPMI Device Information ', ' System Power Supply ',
    ' Additional Information ', ' Onboard Devices Extended Information ', ' ',
    ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
    ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
    ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
    ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
    ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ',
    ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' Inactive ', ' End - of - Table ',
    ' FirmwareVolume (Apple)', ' ', ' Memory SPD Data (Apple)',
    ' OEM Processor Type (Apple)', ' OEM Processor Bus Speed (Apple)');

var
  FoundDmi0Hack: Boolean = False;
  Dump: TRomBiosDump;
  Text: string;
  SmEP32: TSmBiosEntryPoint32;
  SmEP64: TSmBiosEntryPoint64;
  Addr: Pointer;
  TEnd: NativeUInt;
  BitArray: array [0 .. 7] of ShortInt;
  S: string = 'SixteenBytesLong';
  TableArray: Array of Byte;

function SmBiosGetEntryPoint32(var Dump: TRomBiosDump;
  out SmEP32: TSmBiosEntryPoint32): PSmBiosEntryPoint32;
function SmBiosGetEntryPoint64(var Dump: TRomBiosDump;
  out SmEP64: TSmBiosEntryPoint64): PSmBiosEntryPoint64;
function SmBiosGetNextEntry(var Dump: TRomBiosDump; Entry: Pointer): Pointer;
function SmBiosGetString(var Dump: TRomBiosDump; Entry: Pointer;
  Index: Byte): string;
function SmBiosGetBitString(var Dump: TRomBiosDump; Entry: Pointer;
  Index: Byte): string;
function DezToBin(Z: Integer): String;
function IntToBIN(Value: Integer): String;
function IntToBINReverse(Value: Integer): String;
function HexToByte(hex: string): Byte;
function WordToBin(w: Word): string;
function WordToBinReverse(w: Word): string;
function BinToByte(S: String): Byte;
function ByteToBin(b: Byte): String;
function ByteToBinReverse(b: Byte): String;
function HexToBin(Hexadecimal: string): string;
procedure BubbleSort;
Function GetTablename(TableID: Integer): String;
function BinToInt(const AsValue: string): Integer;
function BinToIntStr(const AsValue: string): String;
procedure DelDup;
function byte2bit(Z: Byte): String;
function GetBit(const AValue: Dword; const Bit: Byte): Boolean;
function ClearBit(const AValue: Dword; const Bit: Byte): Dword;
function SetBit(const AValue: Dword; const Bit: Byte): Dword;
function EnableBit(const AValue: Dword; const Bit: Byte;
  const Enable: Boolean): Dword;

// Procedure CreateTable(Table : Array of PtableDataStr; TabSize : SmallInt);
Procedure AddTable(Table: Array of PtableDataStr; ItemIndex: SmallInt;
  Name: String; Value: String);

implementation

{$REGION 'HexUtils'}

function BinToInt(const AsValue: string): Integer;
const
  _aBinDigits = ['0', '1'];
var
  iPowerOfTwo: Integer;
  i: Integer;
begin
  Result := 0;
  iPowerOfTwo := 1;
  for i := Length(AsValue) downto 1 do
  begin
    if AsValue[i] = '1' then
      Result := Result or iPowerOfTwo;
    iPowerOfTwo := iPowerOfTwo shl 1;
  end;
end;

function BinToIntStr(const AsValue: string): String;
const
  _aBinDigits = ['0', '1'];
var
  iPowerOfTwo: Integer;
  i, Temp: Integer;
begin
  Result := '';
  Temp := 0;
  iPowerOfTwo := 1;
  for i := Length(AsValue) downto 1 do
  begin
    if AsValue[i] = '1' then
      Temp := Temp or iPowerOfTwo;
    iPowerOfTwo := iPowerOfTwo shl 1;
  end;
  Result := Inttostr(Temp);
end;

procedure BubbleSort;
var
  i, j, h: Integer;
begin
  for i := Length(TableArray) downto 1 do
    for j := 1 to i do
      if (TableArray[j - 1] > TableArray[j]) then
      begin
        // SwapValues( j-1, j );
        h := TableArray[j - 1];
        TableArray[j - 1] := TableArray[j];
        TableArray[j] := h;
      end;
end;

procedure DelDup;
var
  i, j: Integer;
begin
  j := 0;
  i := 1;
  while i <= Length(TableArray) - 1 do
    if TableArray[i] <> TableArray[j] then
    begin
      inc(j);
      TableArray[j] := TableArray[i];
    end
    else
      inc(i);
  SetLength(TableArray, j + 1);
end;

function HexToBin(Hexadecimal: string): string;
var
  i: Integer;
begin
  for i := Length(Hexadecimal) downto 1 do
    Result := Binary[StrToInt('$' + Hexadecimal[i])] + Result;
end;

function WordToBin(w: Word): string;
const
  OI: array [Boolean] of char = '01';
var
  i: Byte;
begin
  for i := 16 downto 1 do
  begin
    S[i] := OI[Odd(w)];
    w := w shr 1
  end;
  Result := S
end;

function WordToBinReverse(w: Word): string;
const
  OI: array [Boolean] of char = '01';
var
  i: Byte;
begin
  for i := 1 to 16 do
  begin
    S[i] := OI[Odd(w)];
    w := w shr 1
  end;
  Result := S
end;

function BinToByte(S: String): Byte;
var
  i: Byte;
begin
  Result := 0;
  for i := 7 downto 0 do
    if S[8 - i] = '1' then
      inc(Result, Trunc(Power(2, i)));
end;

function ByteToBin(b: Byte): String;
var
  i: Word;
begin
  Result := '';
  for i := 7 downto 0 do
    if (b and (1 shl i)) > 0 then
      Result := Result + '1'
    else
      Result := Result + '0';
end;

function ByteToBinReverse(b: Byte): String;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to 7 do
    if (b and (1 shl i)) > 0 then
      Result := Result + '1'
    else
      Result := Result + '0';
end;

function HexToByte(hex: string): Byte;
var
  i: Integer;
begin
  Result := $00;
  for i := 0 to 15 do
    if hexes[i] = hex[1] then
      Result := 16 * i;
  for i := 0 to 15 do
    if hexes[i] = hex[2] then
      Result := Result + i;
end;

function IntToBIN(Value: Integer): String;
var
  i: Integer;
  Temp: String;
begin
  Temp := StringOfChar('0', 32);
  i := 32;
  while Value <> 0 do
  begin
    if Odd(Value) then
      Temp[i] := '1';
    Dec(i);
    Value := Value shr 1;
  end;
  // Result := Copy(temp, 17, 16);
  Result := Temp;
end;

function IntToBINReverse(Value: Integer): String;
var
  i: Integer;
  Temp: String;
begin
  Temp := StringOfChar('0', 32);
  i := 32;
  while Value <> 0 do
  begin
    if Odd(Value) then
      Temp[i] := '1';
    Dec(i);
    Value := Value shr 1;
  end;
  // Result := Copy(temp, 17, 16);
  Result := ReverseString(Temp);
end;

function byte2bit(Z: Byte): String;
var
  i: Integer;
  Bit: Array [0 .. 7] of char;
begin
  for i := 7 Downto 0 do
  begin
    if (Z - Power(2, i) >= 0) then
    begin
      Bit[i] := '1';
      Z := Z - Round(Power(2, i));
    end
    else
      Bit[i] := '0';
  end;
  for i := 7 Downto 0 do
    Result := Result + Bit[i]
end;

function DezToBin(Z: Integer): String;
var
  BinString: String;
  v, Index: Integer;
begin
  Index := 1;
  v := 0;
  BinString := '';
  Repeat
    if index > v then
      v := v + 4;
    BinString := Inttostr(Z mod 2) + BinString;
    if (Index mod 4 = 0) then
      BinString := ' ' + BinString;
    Z := Z div 2;
    inc(Index);
  Until (Z = 0) and (Index > v);

  Result := TrimLeft(BinString);
end;

function GetBit(const AValue: Dword; const Bit: Byte): Boolean;
begin
  Result := (AValue and (1 shl Bit)) <> 0;
end;

function ClearBit(const AValue: Dword; const Bit: Byte): Dword;
begin
  Result := AValue and not(1 shl Bit);
end;

function SetBit(const AValue: Dword; const Bit: Byte): Dword;
begin
  Result := AValue or (1 shl Bit);
end;

function EnableBit(const AValue: Dword; const Bit: Byte;
  const Enable: Boolean): Dword;
begin
  Result := (AValue or (1 shl Bit)) xor (Dword(not Enable) shl Bit);
end;

{$ENDREGION}
{$REGION 'SMBios Functions'}

function SmBiosGetEntryPoint32(var Dump: TRomBiosDump;
  out SmEP32: TSmBiosEntryPoint32): PSmBiosEntryPoint32;
var
  Addr: Pointer;
  Loop: Integer;
  Csum: Byte;
begin
  Result := nil;
  Addr := Pointer(RomBiosDumpBase - $10);
  while NativeUInt(Addr) < RomBiosDumpEnd - SizeOf(TSmBiosEntryPoint32) do
  begin
    inc(NativeUInt(Addr), $10);
    if (PLongword(GetRomDumpAddr(Dump, Addr))^ = $5F4D535F) then // '_SM_'
    begin
      ReadRomDumpBuffer(Dump, Addr, SmEP32, SizeOf(TSmBiosEntryPoint32));
      if SmEP32.BLength < $1F then
        Continue;
      if SmEP32.BLength > SizeOf(TSmBiosEntryPoint32) then
        Continue;
{$R-}
      Csum := 0;
      for Loop := 0 to SmEP32.BLength - 1 do
        Csum := Csum + PByteArray(@SmEP32)^[Loop];
      if Csum <> 0 then
        Continue;
{$R+}
      if SmEP32.Intermediate.AnchorString <> '_DMI_' then
        Continue;
{$R-}
      Csum := 0;
      for Loop := 0 to SizeOf(SmEP32.Intermediate) - 1 do
        Csum := Csum + PByteArray(@SmEP32.Intermediate)^[Loop];
      if Csum <> 0 then
        Continue;
{$R+}
      Result := Addr;
      Break;
    end;
  end;
end;

function SmBiosGetEntryPoint64(var Dump: TRomBiosDump;
  out SmEP64: TSmBiosEntryPoint64): PSmBiosEntryPoint64;
var
  Addr: Pointer;
  Loop: Integer;
  Csum: Byte;
begin
  Result := nil;
  Addr := Pointer(RomBiosDumpBase - $10);
  while NativeUInt(Addr) < RomBiosDumpEnd - SizeOf(TSmBiosEntryPoint64) do
  begin
    inc(NativeUInt(Addr), $10);
    if (PLongword(GetRomDumpAddr(Dump, Addr))^ = $5F334D535F) then // '_SM3_'
    begin
      ReadRomDumpBuffer(Dump, Addr, SmEP64, SizeOf(TSmBiosEntryPoint64));
      if SmEP64.BLength < $18 then
        Continue;
      if SmEP64.BLength > SizeOf(TSmBiosEntryPoint64) then
        Continue;
{$R-}
      Csum := 0;
      for Loop := 0 to SmEP64.BLength - 1 do
        Csum := Csum + PByteArray(@SmEP64)^[Loop];
      if Csum <> 0 then
        Continue;
{$R+}
//      if SmEP64.Intermediate.AnchorString <> '_DMI_' then
//        Continue;
{$R-}
//      Csum := 0;
//      for Loop := 0 to SizeOf(SmEP64.Intermediate) - 1 do
//        Csum := Csum + PByteArray(@SmEP64.Intermediate)^[Loop];
//      if Csum <> 0 then
//        Continue;
{$R+}
      Result := Addr;
      Break;
    end;
  end;
end;

function SmBiosGetNextEntry(var Dump: TRomBiosDump; Entry: Pointer): Pointer;
var
  Head: TDmiHeader;
begin
  Result := nil;
  ReadRomDumpBuffer(Dump, Entry, Head, SizeOf(TDmiHeader));
  if Head.Type_ = 0 then
    FoundDmi0Hack := True;
  if (Head.Type_ <> $7F) and (Head.Length <> 0) then
  begin
    Result := Pointer(NativeUInt(Entry) + Head.Length);
    while PWord(GetRomDumpAddr(Dump, Result))^ <> 0 do
      inc(NativeUInt(Result));
    inc(NativeUInt(Result), 2);
    if FoundDmi0Hack then
      while PByte(GetRomDumpAddr(Dump, Result))^ = 0 do
        inc(NativeUInt(Result));
  end;
end;

function SmBiosGetString(var Dump: TRomBiosDump; Entry: Pointer;
  Index: Byte): string;
var
  Head: TDmiHeader;
  Addr: Pointer;
  Loop: Integer;
begin
  Result := '';
  ReadRomDumpBuffer(Dump, Entry, Head, SizeOf(TDmiHeader));
  if Head.Length <> 0 then
  begin
    Addr := Pointer(NativeUInt(Entry) + Head.Length);
    for Loop := 1 to Index - 1 do
      inc(NativeUInt(Addr), Length(PAnsiChar(GetRomDumpAddr(Dump, Addr))) + 1);
    // Result := String(StrPas(PAnsiChar(GetRomDumpAddr(Dump, Addr))));
    Result := String(PAnsiChar(GetRomDumpAddr(Dump, Addr)));
  end;
end;

function SmBiosGetBitString(var Dump: TRomBiosDump; Entry: Pointer;
  Index: Byte): string;
var
  Head: TDmiHeader;
  Addr: Pointer;
  Loop: Integer;
begin
  Result := '';
  ReadRomDumpBuffer(Dump, Entry, Head, SizeOf(TDmiHeader));
  if Head.Length <> 0 then
  begin
    Addr := Pointer(NativeUInt(Entry) + Head.Length);
    for Loop := 1 to Index - 1 do
      inc(NativeUInt(Addr), Length(PAnsiChar(GetRomDumpAddr(Dump, Addr))) + 1);
    Result := DezToBin
      (StrToInt(String(StrPas(PChar(GetRomDumpAddr(Dump, Addr))))));
  end;
end;

{$ENDREGION}
{$REGION 'Tables'}

Function GetTablename(TableID: Integer): String;
begin
  case TableID of
    0:
      Result := 'Bios Information (Full supported)';
    1:
      Result := 'System Information (Full supported)';
    2:
      Result := 'Base Board Information (Full supported)';
    // Handles behandeln
    3:
      Result := 'Chassis Information (Full supported)';
    4:
      Result := 'Processor Information'; // needs a fix Voltage
    5:
      Result := 'Memory Controller Information (Obsolete)';
    // needs many work //Obsolete
    6:
      Result := 'Memory Module Information (Obsolete)';
    // needs many work //Obsolete
    7:
      Result := 'Cache Information'; // needs many work
    8:
      Result := 'Port Connector Information (Full supported)';
    9:
      Result := 'System Slots Information (Full supported)';
    10:
      Result := 'On Board Devices(Full supported - Obsolete)';
    11:
      Result := 'OEM Strings (Full supported)';
    12:
      Result := 'System Configuration Options (Full supported)';
    13:
      Result := 'BIOS Language (Full supported)';
    14:
      Result := 'Group Associations';
    15:
      Result := 'System Event Log';
    16:
      Result := 'Physical Memory Array';
    17:
      Result := 'Memory Device';
    18:
      Result := '32-bit Memory Error (Full supported)';
    19:
      Result := 'Memory Array Mapped Address';
    20:
      Result := 'Memory Device Mapped Address';
    21:
      Result := 'Built-in Pointing Device';
    22:
      Result := 'Portable Battery Information';
    23:
      Result := 'System Reset Information';
    24:
      Result := 'Hardware Security Information';
    25:
      Result := 'System Power Controls (Full supported)';
    26:
      Result := 'Voltage Probe';
    27:
      Result := 'Cooling Device Information';
    28:
      Result := 'Temperature Probe (Full supported)';
    // eventuell Maﬂeinheiten anpassen
    29:
      Result := 'Electrical Current Probe (Full supported)';
    // LocationandStatus Bugfix
    30:
      Result := 'Out-of-band Remote Access';
    31:
      Result := 'Boot Integrity Services';
    32:
      Result := 'System Boot';
    // needs a fix if i Know the correct Structure
    33:
      Result := '64-bit Memory Error (Full supported)';
    34:
      Result := 'Management Device (Full supported)';
    35:
      Result := 'Management Device Component (Full supported)';
    36:
      Result := 'Management Device Threshold Data (Full supported)';
    37:
      Result := 'Memory Channel';
    38:
      Result := 'IPMI Device';
    39:
      Result := 'Power Supply (Full supported)';
    40:
      Result := 'Additional Information'; // nicht implementiert
    41:
      Result := 'Onboard Device (Full supported)';
    42:
      Result := 'Management Controller Host Interface';
    126:
      Result := 'Inactive Table';
    127:
      Result := 'end-of-table marker';
    128:
      if frmMain.cbApple.Checked then
        Result := 'FirmwareVolume (Apple)'
      else
        Result := 'OEM Table Type';
    130:
      if frmMain.cbApple.Checked then
        Result := 'MemorySPD (Apple)'
      else
        Result := 'OEM Table Type';
    131:
      if frmMain.cbApple.Checked then
        Result := 'Processor (Apple)'
      else
        Result := 'OEM Table Type';
    132:
      if frmMain.cbApple.Checked then
        Result := 'Bus transfer rate (Apple)'
      else
        Result := 'OEM Table Type';
  else
    Result := 'OEM Table Type';
  end;
end;

Procedure CreateTable(Table: Pointer; TabSize: SmallInt);
begin
  // Setlength(@Table,TabSize);
end;

Procedure AddTable(Table: Array of PtableDataStr; ItemIndex: SmallInt;
  Name: String; Value: String);
begin
  Table[ItemIndex].Name := Name;
  Table[ItemIndex].Name := Value;
end;

{$ENDREGION}

end.
