//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable36;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, WinAPI.Windows, System.Classes;

{$REGION 'Header'}

type
  PDmiType36 = ^TDmiType36;

  TDmiType36 = packed record
    Header: TDmiHeader;
    LowThresNonCrit: Word; // Varies
    UppThresNonCrit: Word; // Varies
    LowThresCrit: Word; // Varies
    UppThresCrit: Word; // Varies
    LowThresNonRecover: Word; // Varies
    UppThresNonRecover: Word; // Varies
  end;
{$ENDREGION}

Procedure DecodeTable36(Dump: TRomBiosDump);

var
  Dmi36: TDmiType36;
  MemoTab36: TStringList;

implementation

uses umain;

Procedure DecodeTable36(Dump: TRomBiosDump);
begin
  if not Assigned(MemoTab36) then
    MemoTab36 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi36, SizeOf(TDmiType36));
  if Dmi36.Header.Length < $10 then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 36 wrong Length : ' + IntToStr(Dmi36.Header.Length));
  end;
  //  If the value is unavailable, the field is set to 0x8000.
  MemoTab36.Add('Lower Threshold – Non - critical: $ ' +
    IntToHex(Dmi36.LowThresNonCrit, 4));
  MemoTab36.Add('Upper Threshold –Non-critical: $' +
    IntToHex(Dmi36.UppThresNonCrit, 4));
  MemoTab36.Add('Lower Threshold –Critical: $' +
    IntToHex(Dmi36.LowThresCrit, 4));
  MemoTab36.Add('Upper Threshold –Critical: $' +
    IntToHex(Dmi36.UppThresCrit, 4));
  MemoTab36.Add('Lower Threshold –Non-recoverable: $' +
    IntToHex(Dmi36.LowThresNonRecover, 4));
  MemoTab36.Add('Upper Threshold –Non-recoverable: $' +
    IntToHex(Dmi36.UppThresNonRecover, 4));
  MemoTab36.Add('');
end;

end.
