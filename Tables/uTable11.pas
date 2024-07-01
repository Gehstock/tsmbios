//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable11;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, System.Classes;

{$REGION 'Header'}
type
  PDmiType11 = ^TDmiType11;
  TDmiType11 = packed record
    Header: TDmiHeader; // $06
    Count: Byte; // varies
  end;
{$ENDREGION}

Procedure DecodeTable11(Dump: TRomBiosDump);

var
  Dmi11: TDmiType11;
  MemoTab11 : TStringList;

implementation

Procedure DecodeTable11(Dump: TRomBiosDump);
begin
if not Assigned(MemoTab11) then
  MemoTab11 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi11, SizeOf(TDmiType11));
  if Dmi11.Header.Length < $05 then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 11 wrong Length : ' + IntToStr(Dmi11.Header.Length));
  end;
  MemoTab11.Add('OEM Strings Count : ' + IntToStr(Dmi11.Count));
end;

end.
