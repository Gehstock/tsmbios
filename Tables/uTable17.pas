//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable17;

interface

uses uCommon, uJedec, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, WinAPI.Windows, System.Classes;

{$REGION 'Header'}

type
  PDmiType17 = ^TDmiType17;

  TDmiType17 = packed record
    Header: TDmiHeader; // 15h
    PhysicalMemoryArrayHandle: Word;
    MemoryErrorInformationHandle: Word;
    TotalWidth: Word;
    DataWidth: Word;
    Size: Word;
    FormFactor: Byte;
    DeviceSet: Byte;
    DeviceLocator: Byte;
    BankLocator: Byte;
    MemoryType: Byte;
    TypeDetail: Word;
    Speed: Word;
    Manufacturer: Byte;
    SerialNumber: Byte;
    AssetTag: Byte;
    PartNumber: Byte;
    Attributes: Byte;
    ExtendedSize: DWORD;
    ConfiguredMemoryClockSpeed: Word;
    MinimumVoltage: Word;
    MaximumVoltage: Word;
    ConfiguredVoltage: Word;
  end;
{$ENDREGION}

var
  Dmi17: TDmiType17;
  MemoTab17: TStringList;

const
  MemoryFormFactors: array [1 .. 15] of string = ('Other', 'Unknown', 'SIMM',
    'SIP', 'Chip', 'DIP', 'ZIP', 'Proprietary Card', 'DIMM', 'TSOP',
    'Row of chips', 'RIMM', 'SODIMM', 'SRIMM', 'FB-DIMM');

  MemoryDeviceTypes: array [1 .. 30] of string = ('Other', 'Unknown', 'DRAM',
    'EDRAM', 'VRAM', 'SRAM', 'RAM', 'ROM', 'FLASH', 'EEPROM', 'FEPROM', 'EPROM',
    'CDRAM', '3DRAM', 'SDRAM', 'SGRAM', 'RDRAM', 'DDR', 'DDR2', 'DDR2 FB-DIMM',
    'Reserved', // 15
    'Reserved', // 15
    'Reserved', // 15
    'DDR3', // 18
    'FBD2',
    'DDR4',
    'LPDDR',
    'LPDDR2',
    'LPDDR3',
    'LPDDR4');

  MemoryTypeDetails: array [1 .. 16] of string = ('Reserved', 'Other',
    'Unknown', 'Fast Paged', 'Static Column', 'Pseudo Static', 'RAMBUS',
    'Synchronous', 'CMOS', 'EDO', 'WindowDRAM', 'CacheDRAM', 'NonVolatile',
    'Registered (Buffered)', 'Unbuffered (Unregistered)', 'LRDIMM');

Procedure DecodeTable17(Dump: TRomBiosDump);

implementation

Procedure DecodeTable17(Dump: TRomBiosDump);
var
  i: Integer;
  ram_addr_t: uint64;
  size_mb: uint64;
const
  // ONE_KB =(ram_addr_t shl 10);
  // ONE_MB =(ram_addr_t shl 20);
  // ONE_GB =(ram_addr_t shl 30);
  MAX_T16_STD_SZ = $80000000; // 2T in Kilobytes */
  MAX_T17_STD_SZ = $7FFF; // (32G - 1M), in Megabytes
  MAX_T18_EXT_SZ = $80000000; // in Megabytes
begin
  if not Assigned(MemoTab17) then
    MemoTab17 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi17, SizeOf(TDmiType17));
  if Dmi17.Header.Length < $16 then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 17 wrong Length : ' + IntToStr(Dmi17.Header.Length));
  end;
  MemoTab17.Add('[Memory Device - ' + SmBiosGetString(Dump, Addr,
    Dmi17.BankLocator) + ']');
  Text := SmBiosGetString(Dump, Addr, Dmi17.Manufacturer);
  if { (Text <> '[Empty]') or } (Dmi17.Size <> 0) then
  begin
    MemoTab17.Add('Manufacturer      :' { +text+'-------' } + DecodeMan(Text));
    MemoTab17.Add('Serial Number    : ' + SmBiosGetString(Dump, Addr,
      Dmi17.SerialNumber));
    MemoTab17.Add('Asset Tag    : ' + SmBiosGetString(Dump, Addr,
      Dmi17.AssetTag));
    MemoTab17.Add('Part Number   : ' + SmBiosGetString(Dump, Addr,
      Dmi17.PartNumber));
    MemoTab17.Add('TotalWidth     : ' + IntToStr(Dmi17.TotalWidth));
    MemoTab17.Add('DataWidth     : ' + IntToStr(Dmi17.DataWidth));
    // MemoTab17.Add('Size     : ' + IntToStr(Dmi17.Size) + ' Mb');
    if Dmi17.Size = 0 then
      MemoTab17.Add('Size     : Unknown')
    else if Dmi17.Size = $7FFF then
      MemoTab17.Add('Size     : ' + IntToStr(Dmi17.ExtendedSize) + ' Mb')
    else begin
      if GetBit(Dmi17.Size, 15) then
        MemoTab17.Add('Size     : ' + IntToStr(Dmi17.Size div 1024) + ' Mb')
      else
        MemoTab17.Add('Size     : ' + IntToStr(Dmi17.Size) + ' Mb')
    end;
    MemoTab17.Add('Speed    : ' + IntToStr(Dmi17.Speed) + ' Mhz');

    { TODO -cwichtig : Attributes }

    MemoTab17.Add('Configured Memory Clock Speed    : ' +
      FloatToStr(Dmi17.ConfiguredMemoryClockSpeed) + ' Mhz');
    { TODO -cwichtig : Configured Memory Clock Speed Bugfix }

    MemoTab17.Add('Minimum operating voltage    : ' +
      FloatToStr(Dmi17.MinimumVoltage div 1000) + ' V');
    { TODO -cwichtig : Minimum operating voltage Bugfix }

    MemoTab17.Add('Maximum operating voltage    : ' +
      FloatToStr(Dmi17.MaximumVoltage div 1000) + ' V');
    { TODO -cwichtig : Maximum operating voltage Bugfix }

    MemoTab17.Add('Configured voltage     : ' +
      FloatToStr(Dmi17.ConfiguredVoltage div 1000) + ' V');
    { TODO -cwichtig : Configured voltage Bugfix }

    MemoTab17.Add('Memory type     : ' + MemoryDeviceTypes[Dmi17.MemoryType]);
    MemoTab17.Add('Form Factors     : ' + MemoryFormFactors[Dmi17.FormFactor]);
    case Dmi17.DeviceSet of
      0:
        MemoTab17.Add('Device is not part of a set');
      255:
        MemoTab17.Add('Attribute is unknown.');
    else
      MemoTab17.Add('Device is part of set: ' + IntToStr(Dmi17.DeviceSet));
    end;
    MemoTab17.Add('Device Locator    : ' + SmBiosGetString(Dump, Addr,
      Dmi17.DeviceLocator));
    // Memo1.Lines.Add('Bank Locator    : ' +
    // SmBiosGetString(Dump, Addr, Dmi17.BankLocator));
    Text := ReverseString(IntToBIN(Dmi17.TypeDetail));
    if Length(Text) >= High(MemoryTypeDetails) then
    begin
      MemoTab17.Add('Memory Device Type Detail     : ' { + Text } );
      for i := 1 to High(MemoryTypeDetails) do
        if Text[i] = '1' then
          MemoTab17.Add(MemoryTypeDetails[i]);
    end;
  end
  else
    MemoTab17.Add('Empty');
  MemoTab17.Add('');
end;

end.
