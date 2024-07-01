//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable13;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, System.Classes;

{$REGION 'Header'}
type
  PDmiType13 = ^TDmiType13;

  TDmiType13 = packed record
    Header: TDmiHeader;
    InstallableLanguages: Byte; // Varies
    Flags: Byte; // Bit Field
    Reserved: array [1 .. 9] of Byte; // Reserved - 15 BYTEs
    CurrentLanguage: Byte; // STRING
  end;
{$ENDREGION}

Procedure DecodeTable13(Dump: TRomBiosDump);

var
  Dmi13: TDmiType13;
  MemoTab13: TStringList;

implementation

Procedure DecodeTable13(Dump: TRomBiosDump);
begin
if not Assigned(MemoTab13) then
  MemoTab13 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi13, SizeOf(TDmiType13));
  if Dmi13.Header.Length < $16 then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 13 wrong Length : ' + IntToStr(Dmi13.Header.Length));
  end;
  MemoTab13.Add('Installable Languages     : ' +
    IntToStr(Dmi13.InstallableLanguages));
  if Dmi13.Flags = 1 then
    MemoTab13.Add
      ('Flags     : Current Language strings use the abbreviated format')
  else
    MemoTab13.Add('Flags     : Current Language strings use the long format');
  MemoTab13.Add('Current Language      : ' + SmBiosGetString(Dump, Addr,
    Dmi13.CurrentLanguage));
end;

end.
