//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable39;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, System.Classes;

{$REGION 'Header'}

type
  PDmiType39 = ^TDmiType39;

  TDmiType39 = packed record
    Header: TDmiHeader; // $0A
    PowerUnitGroup: Byte; // Varies
    Location: Byte; // String
    DeviceName: Byte; // String
    Manufacturer: Byte; // String
    SerialNumber: Byte; // String
    AssetTagNumber: Byte; // String
    ModelPartNumber: Byte; // String
    RevisionLevel: Byte; // String
    MaxPowerCapacity: Word; // Varies
    PowerSupplyCharacteristics: Word; // Varies
    InputVoltageProbeHandle: Word; // Varies
    CoolingDeviceHandle: Word; // Varies
    InputCurrentProbeHandle: Word; // Varies
  end;
{$ENDREGION}

Procedure DecodeTable39(Dump: TRomBiosDump);

var
  Dmi39: TDmiType39;
  MemoTab39: TStringList;

const
  DMTFPowerSupply: Array [1 .. 16] of String = ('Other', 'Unknown', 'Linear',
    'Switching', 'Battery', 'UPS', 'Converter', 'Regulator', 'Reserved',
    'Reserved', 'Reserved', 'Reserved', 'Reserved', 'Reserved', 'Reserved',
    'Reserved');

  Status39: Array [1 .. 5] of String = ('Other', 'Unknown', 'Ok',
    'Non-critical',
    'Critical; power supply has failed and has been taken off-line.');

  VoltageRangeSwitching: Array [1 .. 16] of String = ('Other', 'Unknown',
    'Manual', 'Auto-switch', 'Wide range', 'Not applicable', 'Reserved',
    'Reserved', 'Reserved', 'Reserved', 'Reserved', 'Reserved', 'Reserved',
    'Reserved', 'Reserved', 'Reserved');

implementation

uses umain;

Procedure DecodeTable39(Dump: TRomBiosDump);
var
  temp: string;
  i: Integer;
begin
  if not Assigned(MemoTab39) then
    MemoTab39 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi39, SizeOf(TDmiType39));
  if Dmi39.Header.Length < $0A then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 39 wrong Length : ' + IntToStr(Dmi39.Header.Length));
  end;
  MemoTab39.Add('Power Unit Group     : ' + IntToStr(Dmi39.PowerUnitGroup));
  MemoTab39.Add('Location      : ' + SmBiosGetString(Dump, Addr,
    Dmi39.Location));
  MemoTab39.Add('Device Name      : ' + SmBiosGetString(Dump, Addr,
    Dmi39.DeviceName));
  MemoTab39.Add('Manufacturer      : ' + SmBiosGetString(Dump, Addr,
    Dmi39.Manufacturer));
  MemoTab39.Add('Serial Number      : ' + SmBiosGetString(Dump, Addr,
    Dmi39.SerialNumber));
  MemoTab39.Add('Asset Tag Number      : ' + SmBiosGetString(Dump, Addr,
    Dmi39.AssetTagNumber));
  MemoTab39.Add('Model Part Number      : ' + SmBiosGetString(Dump, Addr,
    Dmi39.ModelPartNumber));
  MemoTab39.Add('Revision Level      : ' + SmBiosGetString(Dump, Addr,
    Dmi39.RevisionLevel));
  if Dmi39.MaxPowerCapacity <> $8000 then
    MemoTab39.Add('Max Power Capacity     : ' + IntToStr(Dmi39.MaxPowerCapacity)
      + 'mWatts')
  else
    MemoTab39.Add('Max Power Capacity     : Unknown');
  temp := WordToBin(Dmi39.PowerSupplyCharacteristics);
  MemoTab39.Add('Power Supply Characteristic     : ' + temp);
  if temp[1] = '1' then
    MemoTab39.Add('Power supply is hot replaceable');
  if temp[2] = '1' then
    MemoTab39.Add('Power supply is present');
  if temp[3] = '1' then
    MemoTab39.Add('Power supply is unplugged from the wall');
  i := BinToInt(Copy(temp, 4, 4));
  if i = 0 then
    exit;
  MemoTab39.Add('DMTF Imput Voltage Range Switching' +
    VoltageRangeSwitching[i]);
  if i = 0 then
    exit;
  i := BinToInt(Copy(temp, 8, 3));
  MemoTab39.Add('Status' + Status39[i]);
  if i = 0 then
    exit;
  i := BinToInt(Copy(temp, 11, 4));
  MemoTab39.Add('DMTF Power Supply type' + DMTFPowerSupply[i]);
end;

end.
