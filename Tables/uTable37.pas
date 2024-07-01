//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable37;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, WinAPI.Windows, System.Classes;

{$REGION 'Header'}

type
  PDmiType37 = ^TDmiType37;

  TDmiType37 = packed record
    Header: TDmiHeader;
    ChannelType: Byte; // Varies
    MaximumChannelLoad: Byte; // Varies
    MemorydeviceCount: Byte; // Varies
    Memory1DeviceLoad: Byte; // Varies
    MemoryDevice1Handle: Word; // Varies
    MemorynDeviceLoad: Byte; // Varies
    MemoryDevicenHandle: Word; // Varies
  end;
{$ENDREGION}

Procedure DecodeTable37(Dump: TRomBiosDump);

Const
  ChannelTypeField: Array [1 .. 4] of string = ('Other', 'Unknown', 'RamBus',
    'SyncLink');
var
  Dmi37: TDmiType37;
  MemoTab37: TStringList;

implementation

uses umain;

Procedure DecodeTable37(Dump: TRomBiosDump);
begin
  if not Assigned(MemoTab37) then
    MemoTab37 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi37, SizeOf(TDmiType37));
  if Dmi37.Header.Length < $10 then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 37 wrong Length : ' + IntToStr(Dmi37.Header.Length));
  end;
  MemoTab37.Add('Channel Type : ' + ChannelTypeField[Dmi37.ChannelType]);
  { Code Here }
  MemoTab37.Add('');
end;

end.
