//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable42;
interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, System.Classes;

{$REGION 'Header'}


type
  PDmiType42 = ^TDmiType42;
  TDmiType42 = packed record
    Header: TDmiHeader;
    InterfaceType: Byte; //enum
    HostInterface: {n*}Byte;
  end;
{$ENDREGION}


Procedure DecodeTable42(Dump: TRomBiosDump);

var
  Dmi42: TDmiType42;
  MemoTab42 : TStringList;


implementation

uses umain;

Procedure DecodeTable42(Dump: TRomBiosDump);
begin
  Text := '';
  if not Assigned(MemoTab42) then
  MemoTab42 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi42, SizeOf(TDmiType42));
  if Dmi42.Header.Length < $09 then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 42 wrong Length : ' + IntToStr(Dmi42.Header.Length));
  end;
  {Code here}
//Name                      Length        Value       Description
//Interface Type            BYTE          ENUM        Host Interface Information
//Interface Specific Data   Varies        Varies      Host Interface Information
//Number of Protocols       BYTE          n           n number of Protocols for this Host Interface
//Protocol 1 Type           BYTE          ENUM        Protocol 1 Information
//Protocol 1 Specific Data  Varies        Varies      Protocol 1 Information
////...............................................................................................
//Protocol n Type           BYTE          ENUM        Protocol n Information
//Protocol n Specific Data  Varies        Varies      Protocol n Information
end;

end.
