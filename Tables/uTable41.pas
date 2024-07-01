//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable41;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, System.Classes;

{$REGION 'Header'}

type
  PDmiType41 = ^TDmiType41;

  TDmiType41 = packed record
    Header: TDmiHeader;
    ReferenceDesignation: Byte; // string
    DeviceType: Byte;
    DeviceTypeInstance: Byte;
    SegmentGroupNumber: Word;
    BusNumber: Byte;
    DevFuncNum: Byte;
  end;
{$ENDREGION}

Procedure DecodeTable41(Dump: TRomBiosDump);

var
  Dmi41: TDmiType41;
  MemoTab41: TStringList;

const
  OnboardDeviceTypes41: array [1 .. 10] of string = ('Other', 'Unknown',
    'Video', 'SCSI Controller', 'Ethernet', 'Token Ring', 'Sound',
    'PATA Controller', 'SATA Controller', 'SAS Controller');

implementation

uses umain;

Procedure DecodeTable41(Dump: TRomBiosDump);
var
  Temp: String;
begin
  if not Assigned(MemoTab41) then
    MemoTab41 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi41, SizeOf(TDmiType41));
  if Dmi41.Header.Length < $0B then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 41 wrong Length : ' + IntToStr(Dmi41.Header.Length));
  end;
  MemoTab41.Add('Reference Designation      : ' + SmBiosGetString(Dump, Addr,
    Dmi41.ReferenceDesignation));
  Text := ByteToBIN(Dmi41.DeviceType);
  {$IFDEF DEBUG}
  MemoTab41.Add(Text);
  {$ENDIF}
  if Length(Text) = 8 then
  begin
    if Text[1] = '1' then
      Temp := ' (enabled)'
    else
      Temp := ' (disabled)';
    MemoTab41.Add('Device Type: ' + OnboardDeviceTypes41
      [BinToInt('0' + Copy(Text, 2, 7))] + Temp);
  end;
  MemoTab41.Add('Device Type Instance: ' + IntToStr(Dmi41.DeviceTypeInstance));
  MemoTab41.Add('Segment Group Number: ' + IntToStr(Dmi41.SegmentGroupNumber));
  MemoTab41.Add('BusNumber: ' + IntToStr(Dmi41.BusNumber));
  Text := ByteToBIN(Dmi41.DevFuncNum);
  MemoTab41.Add('Device Number: ' + BinToIntStr(Copy(Text, 1, 5)));
  MemoTab41.Add('Function Number: ' + BinToIntStr(Copy(Text, 6, 3)));
  MemoTab41.Add('');
end;

end.
