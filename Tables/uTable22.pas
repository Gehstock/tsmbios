//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable22;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, WinAPI.Windows, System.Classes;

{$REGION 'Header'}
type
  PDmiType22 = ^TDmiType22;
  TDmiType22 = packed record
    Header: TDmiHeader;
    Loacation: Byte;
    Manufacturer: Byte;
    ManufactureDate: Byte;
    SerialNumber: Byte;
    DeviceName: Byte;
    DeviceChemistry: Byte;
    DesignCapacity: Word;
    DesignVoltage: Word;
    SBDSVersionNumber: Byte;
    MaximumErrorinBatteryData: Byte;
    SBDSSerialNumber: Word;
    SBDSManufactureDate: Word;
    SBDSDeviceChemistry: Byte;
    DesignCapacityMultiplier: Byte;
    OEMSpec: DWORD;
  end;
{$ENDREGION}

Procedure DecodeTable22(Dump: TRomBiosDump);

var
  Dmi22: TDmiType22;
  MemoTab22: TStringList;
const
  DeviceChemistryField: array [1 .. 8] of String = (
  'Other',
  'Unknown',
  'Lead Acid',
  'Nickel Cadmium',
  'Nickel metal hydride',
  'Lithium-ion',
  'Zinc air',
  'Lithium Polymer');

implementation

Procedure DecodeTable22(Dump: TRomBiosDump);
begin
if not Assigned(MemoTab22) then
  MemoTab22 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi22, SizeOf(TDmiType22));
  if Dmi22.Header.Length < $1A then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 22 wrong Length : ' + IntToStr(Dmi22.Header.Length));
  end;
  { TODO -cwichtig : ungültige Batt ausschließen }
  MemoTab22.Add('Loacation      : ' + SmBiosGetString(Dump, Addr,
    Dmi22.Loacation));
  MemoTab22.Add('Manufacturer      : ' + SmBiosGetString(Dump, Addr,
    Dmi22.Manufacturer));
  MemoTab22.Add('Manufacture Date      : ' + SmBiosGetString(Dump,
    Addr, Dmi22.ManufactureDate));
  MemoTab22.Add('Serial Number      : ' + SmBiosGetString(Dump, Addr,
    Dmi22.SerialNumber));
  MemoTab22.Add('Device Name      : ' + SmBiosGetString(Dump, Addr,
    Dmi22.DeviceName));
  MemoTab22.Add('Device Chemistry    : ' + DeviceChemistryField
    [Dmi22.DeviceChemistry]);
  MemoTab22.Add('Design Capacity     : ' +
    IntToStr(Dmi22.DesignCapacity * Dmi22.DesignCapacityMultiplier) + ' mWatt');
  MemoTab22.Add('Design Voltage     : ' +
    IntToStr(Dmi22.DesignVoltage) + ' mVolt');
  MemoTab22.Add('SBDS Version Number      : ' + SmBiosGetString(Dump,
    Addr, Dmi22.SBDSVersionNumber));
  MemoTab22.Add('Maximum Error in Battery Data     : ' +
    IntToStr(Dmi22.MaximumErrorinBatteryData));
  MemoTab22.Add('SBDS Serial Number     : ' +
    IntToStr(Dmi22.SBDSSerialNumber));
  MemoTab22.Add('SBDS Manufacture Date     : ' +
    IntToStr(Dmi22.SBDSManufactureDate));
  { TODO -cwichtig : SBDS Manufacture Date Fixen }
  MemoTab22.Add('SBDS Device Chemistry      : ' +
    SmBiosGetString(Dump, Addr, Dmi22.SBDSDeviceChemistry));
  MemoTab22.Add('');
end;

end.
