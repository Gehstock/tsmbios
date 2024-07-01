//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable27;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, WinAPI.Windows, System.Classes;

{$REGION 'Header'}
type
  PDmiType27 = ^TDmiType27;
  TDmiType27 = packed record
    Header: TDmiHeader; // $0C
    TemperatureProbeHandle: Word; // VARIES
    DeviceTypeandStatus: Byte; // BIT FIELD
    CoolingUnitGroup: Byte; // VARIES
    OEMdefined: DWord; // VARIES
    NominalSpeed: Word; // VARIES
    Description: Byte; // STRING
  end;
{$ENDREGION}

Procedure DecodeTable27(Dump: TRomBiosDump);

var
  Dmi27: TDmiType27;
  MemoTab27: TStringList;

const
  DeviceStatusField : Array[1..17] of String =(
  'Other',
  'Unknown',
  'Fan',
  'Centrifugal Blower',
  'Chip Fan',
  'Cabinet Fan',
  'Power Supply Fan',
  'Heat Pipe', //8
  'Integrated Refrigeration', //9
  'Unknown',
  'Unknown',
  'Unknown',
  'Unknown',
  'Unknown',
  'Unknown',
  'Active Cooling', //16
  'Passive Cooling');  //17

  CoolStatusField : Array[1..6] of String =(
  'Other',
  'Unknown',
  'OK',
  'Non-critical',
  'Critical',
  'Non-recoverable');

implementation

uses umain;

Procedure DecodeTable27(Dump: TRomBiosDump);
begin
  Text := '';
  if not Assigned(MemoTab27) then
  MemoTab27 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi27, SizeOf(TDmiType27));
  if Dmi27.Header.Length < $0C then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 27 wrong Length : ' + IntToStr(Dmi27.Header.Length));
  end;
  if Dmi27.TemperatureProbeHandle <> $FFFF then
  begin
    MemoTab27.Add('Temperature Probe Handle     : ' +
      IntToStr(Dmi27.TemperatureProbeHandle));
    TempProbe := True;
  end
  else
    TempProbe := False;
  Text := '';
  Text := ReverseString(Byte2bit(Dmi27.DeviceTypeandStatus));
  if Length(Text) = 8 then
  begin
    MemoTab27.Add('Status    : ' + CoolStatusField
      [BinToInt(Copy(Text, 1, 3))]);
    MemoTab27.Add('Device Type    : ' + DeviceStatusField
      [BinToInt(Copy(Text, 4, 8))]);
  end;
  MemoTab27.Add('Cooling Unit Group     : ' +
    IntToStr(Dmi27.CoolingUnitGroup));
  MemoTab27.Add('OEM defined     : ' + IntToStr(Dmi27.OEMdefined));
  if Dmi27.Header.Length > $0C then
    if Dmi27.NominalSpeed = $8000 then
      MemoTab27.Add('Nominal Speed unknown or not set')
    else
      MemoTab27.Add('Nominal Speed     : ' + IntToStr(Dmi27.NominalSpeed)
        + ' rpm');
  if Dmi27.Header.Length >= $0F then
    MemoTab27.Add('Description      : ' + SmBiosGetString(Dump, Addr,
      Dmi27.Description));
  MemoTab27.Add('');
end;

// Function Decode27 (n : Integer):String;
// begin
// case n of
// 1 : 'Other';
// 2 : 'Unknown',
// 3 : 'Fan',
// 4 : 'Centrifugal Blower',
// 1 : 'Chip Fan',
// 1 : 'Cabinet Fan',
// 1 :  'Power Supply Fan',
// 1 :  'Heat Pipe', //8
// 1 :  'Integrated Refrigeration', //9
// 1 :  'Unknown',
// 1 :  'Unknown',
// 1 :  'Unknown',
// 1 :  'Unknown',
// 1 :  'Unknown',
// 1 :  'Unknown',
// 16 : 'Active Cooling', //16
// 17 : 'Passive Cooling');  //17
// end;
// end;

end.
