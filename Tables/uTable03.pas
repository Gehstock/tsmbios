//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable03;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, WinAPI.Windows, System.Classes;

{$REGION 'Header'}

type
  PDmiType3 = ^TDmiType3;

  TDmiType3 = packed record
    Header: TDmiHeader; // $09
    Manufacturer: Byte; // STRING
    Typ: Byte; // Varies
    Version: Byte; // STRING
    SerialNumber: Byte; // STRING
    AssetTagNumber: Byte; // STRING
    BootupState: Byte; // ENUM
    PowerSupplyState: Byte; // ENUM
    ThermalState: Byte; // ENUM
    SecurityStatus: Byte; // ENUM
    OEMdefined: DWORD; // Varies
    Height: Byte; // Varies
    NumberofPowerCords: Byte; // Varies
    ContainedElementCount: Byte; // Varies
    ContainedElementRecordLength: Byte; // Varies
    ContainedElements: Byte; // Varies
    SKUNumber: Byte; // STRING
  end;
{$ENDREGION}

Procedure DecodeTable3(Dump: TRomBiosDump);

var
  Dmi3: TDmiType3;
  MemoTab3: TStringList;

const
  ChassisTypes: array [1 .. 32] of string = ('Other', 'Unknown', 'Desktop',
    'Low Profile Desktop', 'Pizza Box', 'Mini Tower', 'Tower', 'Portable',
    'LapTop', 'Notebook', 'Hand Held', 'Docking Station', 'All in One',
    'SubNotebook', 'Space-Saving', 'Lunch Box', 'Main Server Chassis',
    'Expansion Chassis', 'SubChassis', 'Bus Expansion Chassis',
    'Peripheral Chassis', 'RAID Chassis', 'Rack-Mount Chassis',
    'Sealed-case PC', 'Multi-system Chassis', 'Compact PCI', 'Advanced TCA',
    'Blade', 'Blade Enclosure', 'Tablet', 'Convertible', 'Detachable');

  States: array [1 .. 6] of string = ('Other', 'Unknown', 'Safe', 'Warning',
    'Critical', 'Non-recoverable');

  SecStates: array [1 .. 5] of string = ('Other', 'Unknown', 'None',
    'External interface locked out', 'External interface enabled');

implementation

Procedure DecodeTable3(Dump: TRomBiosDump);
begin
  if not Assigned(MemoTab3) then
    MemoTab3 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi3, SizeOf(TDmiType3));
  if Dmi3.Header.Length < $0D then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 3 wrong Length : ' + IntToStr(Dmi3.Header.Length));
  end;
  MemoTab3.Add('Manufacturer       : ' + SmBiosGetString(Dump, Addr,
    Dmi3.Manufacturer));
  Text := (Byte2bit(Dmi3.Typ));
  // MemoTab3.Add('Typ       : ' + Text);
  if Length(Text) = 8 then
  begin
    MemoTab3.Add('Chassis Type     : ' + ChassisTypes
      [BinToInt(Copy(Text, 2, 8))]);
    if Text[1] = '1' then
      MemoTab3.Add('Chassis Lock : active')
    else
      MemoTab3.Add('Chassis Lock : not active')
  end;
  MemoTab3.Add('System Version     : ' + SmBiosGetString(Dump, Addr,
    Dmi3.Version));
  MemoTab3.Add('Serial Number      : ' + SmBiosGetString(Dump, Addr,
    Dmi3.SerialNumber));
  MemoTab3.Add('Asset Tag Number      : ' + SmBiosGetString(Dump, Addr,
    Dmi3.AssetTagNumber));
  MemoTab3.Add('Bootup State     : ' + States[Dmi3.BootupState]);
  MemoTab3.Add('Power Supply State     : ' + States[Dmi3.PowerSupplyState]);
  MemoTab3.Add('Thermal State     : ' + States[Dmi3.ThermalState]);
  MemoTab3.Add('Security Status     : ' + SecStates[Dmi3.SecurityStatus]);
  MemoTab3.Add('OEM defined     : ' + IntToStr(Dmi3.OEMdefined));
  if Dmi3.Height > 0 then
    // Reads Standart-Unit = 1.75 inch or 4.445 cm
    MemoTab3.Add('Height     : ' + floatToStr(Dmi3.Height * 4.445) + ' cm')
  else
    MemoTab3.Add('Height is unspecified');
  MemoTab3.Add('Number of Power Cords     : ' +
    IntToStr(Dmi3.NumberofPowerCords));
  MemoTab3.Add('Contained Element Count     : ' +
    IntToStr(Dmi3.ContainedElementCount));
  MemoTab3.Add('Contained Element Record Length     : ' +
    IntToStr(Dmi3.ContainedElementRecordLength));
  Dmi3.ContainedElements := Dmi3.ContainedElementCount *
    Dmi3.ContainedElementRecordLength;
  { TODO -cnicht wichtig : Table3 SKU berechnung }
//  MemoTab3.Add('Contained Elements      : ' + IntToStr(Dmi3.ContainedElements));

//  SetLength(Dmi3.SKUNumber,Dmi3.ContainedElementCount*Dmi3.ContainedElementRecordLength);
//  MemoTab3.Add('SKU Number      : ' + SmBiosGetString(Dump, Addr,
//    {Dmi3.SKUNumber}Dmi3.ContainedElementCount*Dmi3.ContainedElementRecordLength));

end;

end.
