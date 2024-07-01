//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable14;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, System.Classes;

{$REGION 'Header'}

type
  PDmiType14 = ^TDmiType14;

  TDmiType14 = packed record
    Header: TDmiHeader;
    GroupName: Byte; // STRING
    ItemType: Byte; // Varies
    ItemHandle: Word; // Varies
  end;
{$ENDREGION}

Procedure DecodeTable14(Dump: TRomBiosDump);

var
  Dmi14: TDmiType14;
  MemoTab14: TStringList;

implementation

Procedure DecodeTable14(Dump: TRomBiosDump);
begin
  if not Assigned(MemoTab14) then
    MemoTab14 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi14, SizeOf(TDmiType14));
  if Dmi14.Header.Length < $05 then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 14 wrong Length : ' + IntToStr(Dmi14.Header.Length));
  end;
  MemoTab14.Add('Groups     : ' + IntToStr((Dmi14.Header.Length - 5) div 3));
    MemoTab14.Add('Group Name       : ' + SmBiosGetString(Dump, Addr,
    Dmi14.GroupName));
end;

end.
