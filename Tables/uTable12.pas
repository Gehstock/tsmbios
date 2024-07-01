//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable12;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, System.Classes;

{$REGION 'Header'}
type
  PDmiType12 = ^TDmiType12;
  TDmiType12 = packed record
    Header: TDmiHeader; // $06
    Count: Byte; // varies
  end;
{$ENDREGION}

Procedure DecodeTable12(Dump: TRomBiosDump);

var
  Dmi12: TDmiType12;
  MemoTab12 : TStringList;

implementation

Procedure DecodeTable12(Dump: TRomBiosDump);
begin
if not Assigned(MemoTab12) then
  MemoTab12 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi12, SizeOf(TDmiType12));
  if Dmi12.Header.Length < $05 then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 12 wrong Length : ' + IntToStr(Dmi12.Header.Length));
  end;
  MemoTab12.Add('System Configuration Options Count : ' + IntToStr(Dmi12.Count));
end;

end.
