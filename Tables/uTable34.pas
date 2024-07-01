//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable34;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, WinAPI.Windows, System.Classes;

{$REGION 'Header'}
type
  PDmiType34 = ^TDmiType34;
  TDmiType34 = packed record
    Header: TDmiHeader;
    Description: Byte;
    Typ: Byte;
    Address: DWord;
    AddressType: Byte;
  end;
{$ENDREGION}

Procedure DecodeTable34(Dump: TRomBiosDump);

var
  Dmi34: TDmiType34;
  MemoTab34 : TStringList;
const
  MemTypeField: array [1 .. 13] of String = (
  'Other',
  'Unknown',
  'National Semiconductor LM75',
  'National Semiconductor LM78',
  'National Semiconductor LM79',
  'National Semiconductor LM80',
  'National Semiconductor LM81',
  'Analog Devices ADM9240',
  'Dallas Semiconductor DS1780',
  'Maxim 1617',
  'Genesys GL518SM',
  'Winbond W83781D',
  'Holtek HT82H791');

  MemAddressType: array [1 .. 5] of String = (
  'Other',
  'Unknown',
  'I/O Port',
  'Memory',
  'SM Bus');

implementation

uses umain;

Procedure DecodeTable34(Dump: TRomBiosDump);
begin
if not Assigned(MemoTab34) then
  MemoTab34 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi34, SizeOf(TDmiType34));
  if Dmi34.Header.Length < $0B then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 34 wrong Length : ' + IntToStr(Dmi34.Header.Length));
  end;
  MemoTab34.Add('Description      : ' + SmBiosGetString(Dump, Addr,
    Dmi34.Description));
  MemoTab34.Add('Management Device Type     : ' + MemTypeField
    [Dmi34.Typ]);
  MemoTab34.Add('Address: $' + IntToHex(Dmi34.Address, 4) + ':0000');
  MemoTab34.Add('AddressType     : ' + MemAddressType[Dmi34.AddressType]);
  MemoTab34.Add('');
end;

end.
