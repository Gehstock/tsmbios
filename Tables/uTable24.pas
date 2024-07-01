//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable24;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, WinAPI.Windows, System.Classes;

{$REGION 'Header'}
type
  PDmiType24 = ^TDmiType24;
  TDmiType24 = packed record
    Header: TDmiHeader;
    HardwareSecuritySettings: Byte; // Varies
  end;
{$ENDREGION}

Procedure DecodeTable24(Dump: TRomBiosDump);

var
  Dmi24: TDmiType24;
  MemoTab24: TStringList;

const
  Statusvalue: Array [1 .. 4] of String = (
  'Disabled',
  'Enabled',
  'Not Implemented',
  'Unknown');

implementation

Procedure DecodeTable24(Dump: TRomBiosDump);
begin
if not Assigned(MemoTab24) then
  MemoTab24 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi24, SizeOf(TDmiType24));
  if Dmi24.Header.Length < $05 then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 24 wrong Length : ' +
      IntToStr(Dmi24.Header.Length));
  end;
end;

end.

//  04 h Hardware Security Settings Byte Bit - field Identifies the password and
//  reset status for the System:
//
//  Bits 7: 6 Power - on password status value
//  : 00 b Disabled 01 b Enabled 10 b Not Implemented 11 b Unknown
//
//  Bits 5: 4 Keyboard password status value
//  : 00 b Disabled 01 b Enabled 10 b Not Implemented 11 b Unknown
//
//  Bits 3: 2 Administrator password status value
//  : 00 b Disabled 01 b Enabled 10 b Not Implemented 11 b Unknown
//
//  Bits 1: 0 Front Panel reset status value
//  : 00 b Disabled 01 b Enabled 10 b Not Implemented 11 b Unknown
