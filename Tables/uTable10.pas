//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable10;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, System.Classes;

{$REGION 'Header'}

type
  PDmiType10 = ^TDmiType10;

  TDmiType10 = packed record
    Header: TDmiHeader;
    DeviceType: Byte; // Varies
    DescriptionString: Byte; // STRING
  end;
{$ENDREGION}

Procedure DecodeTable10(Dump: TRomBiosDump);

var
  Dmi10: TDmiType10;
  MemoTab10: TStringList;

const
  OnboardDeviceTypes10: array [1 .. 10] of string = ('Other', 'Unknown',
    'Video', 'SCSI Controller', 'Ethernet', 'Token Ring', 'Sound',
    'PATA Controller', 'SATA Controller', 'SAS Controller');

implementation

Procedure DecodeTable10(Dump: TRomBiosDump);
var
  i: Integer;
  Devices: Integer;
  temp: String;
begin
  if not Assigned(MemoTab10) then
    MemoTab10 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi10, SizeOf(TDmiType10));
  if Dmi10.Header.Length < $04 then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 10 wrong Length : ' + IntToStr(Dmi10.Header.Length));
  end;
  Devices := (Dmi10.Header.Length - $04) div 2;
  MemoTab10.Add('Devices     : ' + IntToStr(Devices));
  Text := ByteToBin(Dmi10.DeviceType);
  if Text[1] = '1' then
    temp := ' enabled'
  else
    temp := ' disabled';
  MemoTab10.Add('DeviceType     : ' + OnboardDeviceTypes10
    [BinToByte('0' + Copy(Text, 2, 7))] + temp);
  MemoTab10.Add('Description      : ' + SmBiosGetString(Dump, Addr,
    Dmi10.DescriptionString));
end;

end.
