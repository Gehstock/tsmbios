//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable01;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, System.Classes;

{$REGION 'Header'}

type
  PDmiType1 = ^TDmiType1;

  TDmiType1 = packed record
    Header: TDmiHeader; // $08
    Manufacturer: Byte; // STRING
    ProductName: Byte; // STRING
    Version: Byte; // STRING
    SerialNumber: Byte; // STRING
    UUID: array [0 .. 15] of Byte; // Varies
    WakeUpType: Byte; // ENUM
    SKUNumber: Byte; // STRING
    Family: Byte; // STRING
  end;
{$ENDREGION}

Procedure DecodeTable1(Dump: TRomBiosDump);

var
  Dmi1: TDmiType1;
  MemoTab1: TStringList;

const
  UuidNone: array [0 .. 15] of Byte = (
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00);

  UuidUnset: array [0 .. 15] of Byte = (
    $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
    $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF);

  wakeUp: array [0 .. 8] of String = (
  'Reserved',
  'Other',
  'Unknown',
  'APM Timer',
  'Modem Ring',
  'LAN Remote',
  'Power Switch',
  'PCI PME#',
  'AC Power Restored');

implementation

Procedure DecodeTable1(Dump: TRomBiosDump);
var
  i: Integer;
begin
  if not Assigned(MemoTab1) then
    MemoTab1 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi1, SizeOf(TDmiType1));
  if Dmi1.Header.Length < $08 then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 1 wrong Length : ' + IntToStr(Dmi1.Header.Length));
  end;
  MemoTab1.Add('Manufacturer       : ' + SmBiosGetString(Dump, Addr,
    Dmi1.Manufacturer));
  MemoTab1.Add('Product Name       : ' + SmBiosGetString(Dump, Addr,
    Dmi1.ProductName));
  MemoTab1.Add('System Version     : ' + SmBiosGetString(Dump, Addr,
    Dmi1.Version));
  MemoTab1.Add('Serial Number      : ' + SmBiosGetString(Dump, Addr,
    Dmi1.SerialNumber));
  Text := 'Universal Unique ID: ';
  if (Dmi1.Header.Length >= $19) then
  begin
    if CompareMem(@Dmi1.UUID, @UuidNone, SizeOf(Dmi1.UUID)) then
      Text := Text + '<not present>'
    else if CompareMem(@Dmi1.UUID, @UuidUnset, SizeOf(Dmi1.UUID)) then
      MemoTab1.Add('<not set>')
    else
    begin
      for i := 0 to 3 do
        Text := Text + IntToHex(Dmi1.UUID[i], 2) + '';
      Text := Text + '- ';
      for i := 4 to 5 do
        Text := Text + IntToHex(Dmi1.UUID[i], 2) + '';
      Text := Text + '-';
      for i := 6 to 7 do
        Text := Text + IntToHex(Dmi1.UUID[i], 2) + '';
      Text := Text + '-';
      for i := 8 to 9 do
        Text := Text + IntToHex(Dmi1.UUID[i], 2) + '';
      Text := Text + '-';
      for i := 10 to 15 do
        Text := Text + IntToHex(Dmi1.UUID[i], 2) + '';
      MemoTab1.Add(Text);
    end;
    MemoTab1.Add('Wake-up Type       : ' + wakeUp[Dmi1.WakeUpType]);
    MemoTab1.Add('SKU Number       : ' + SmBiosGetString(Dump, Addr,
      Dmi1.SKUNumber));
    MemoTab1.Add('Family       : ' + SmBiosGetString(Dump, Addr, Dmi1.Family));
  end;
end;

end.
