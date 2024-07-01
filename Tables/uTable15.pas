//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable15;

interface

uses uCommon, uBiosDump, WinAPI.Windows, WinAPI.CommCtrl,
  System.SysUtils, VCL.Dialogs, System.StrUtils, System.Classes;

{$REGION 'Header'}

type
  PDmiType15 = ^TDmiType15;

  TDmiType15 = packed record
    Header: TDmiHeader; // $06
    LogAreaLength: Word; // Varies
    LogHeaderStartOffset: Word; // Varies
    LogDataStartOffset: Word; // Varies
    AccessMethod: Byte; // Varies
    LogStatus: Byte; // Varies
    LogChangeToken: DWord; // Varies
    AccessMethodAddress: DWord; // Varies
    LogHeaderFormat: Byte; // Varies
    NumberLogTypeDescr: Byte; // Varies
    LengthLogTypeDescr: Byte; // Hard-coded "2"
    // ListLogTypeDescr: Varies; // Varies
  end;
{$ENDREGION}

Procedure DecodeTable15(Dump: TRomBiosDump);

var
  Dmi15: TDmiType15;
  MemoTab15: TStringList;

const
  AccessMethod: array [$00 .. $04] of String =
    ('8-Bit Index Port + 8-Bit Data Port',
    '2 8-Bit Index Ports + 8-Bit Data Port',
    '16-Bit Index Port + 8-Bit Data Port',
    'Memory mapped physical 32-Bit Address',
    'Available though General Purpose');

implementation

Procedure DecodeTable15(Dump: TRomBiosDump);
begin
  if not Assigned(MemoTab15) then
    MemoTab15 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi15, SizeOf(TDmiType15));
//  if (not(SmEP32.MajorVersion = 2) and (SmEP32.MinorVersion = 0) and
//    (Dmi15.Header.Length <> $15)) or
//    (not(SmEP32.MajorVersion = 2) and (SmEP32.MinorVersion >= 1) and
//    (Dmi15.Header.Length <> $17 + Dmi15.NumberLogTypeDescr *
//    Dmi15.LengthLogTypeDescr)) then
   if Dmi15.Header.Length < $05 then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 15 wrong Length : ' + IntToStr(Dmi15.Header.Length));
  end;
  MemoTab15.Add('Log Area Length : ' + IntToStr(Dmi15.LogAreaLength));
  MemoTab15.Add('Log Header Start Offset : ' +
    IntToStr(Dmi15.LogHeaderStartOffset));
  MemoTab15.Add('Log Data Start Offset : ' +
    IntToStr(Dmi15.LogDataStartOffset));
  MemoTab15.Add('Access Method : ' + AccessMethod[Dmi15.AccessMethod]);
  { TODO -cwichtig : tab15  , Continue}
  MemoTab15.Add('');
end;

end.
