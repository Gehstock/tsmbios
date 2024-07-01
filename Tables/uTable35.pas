//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable35;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, WinAPI.Windows, System.Classes;

{$REGION 'Header'}

type
  PDmiType35 = ^TDmiType35;

  TDmiType35 = packed record
    Header: TDmiHeader;
    Description: Byte; // String
    DeviceHandle: Word; // Varies
    ComponentHandle: Word; // Varies
    ThresholdHandle: Word; // Varies
  end;
{$ENDREGION}

Procedure DecodeTable35(Dump: TRomBiosDump);

var
  Dmi35: TDmiType35;
  MemoTab35: TStringList;

implementation

uses umain;

Procedure DecodeTable35(Dump: TRomBiosDump);
begin
  if not Assigned(MemoTab35) then
    MemoTab35 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi35, SizeOf(TDmiType35));
  if Dmi35.Header.Length < $0B then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 35 wrong Length : ' + IntToStr(Dmi35.Header.Length));
  end;
  MemoTab35.Add('Description     : ' + SmBiosGetString(Dump, Addr,
    Dmi35.Description));
  MemoTab35.Add('Device Handle     : $' + IntToHex(Dmi35.DeviceHandle, 4));
  MemoTab35.Add('Component Handle     : $' +
    IntToHex(Dmi35.ComponentHandle, 4));
  MemoTab35.Add('Threshold Handle     : $' +
    IntToHex(Dmi35.ThresholdHandle, 4));
  MemoTab35.Add('');
end;

end.
