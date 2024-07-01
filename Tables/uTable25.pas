//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable25;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, WinAPI.Windows, System.Classes;

{$REGION 'Header'}

type
  PDmiType25 = ^TDmiType25;

  TDmiType25 = packed record
    Header: TDmiHeader;
    ScheduledPowerOnMonth: Byte; // Varies
    ScheduledPowerOnDay: Byte; // Varies
    ScheduledPowerOnHour: Byte; // Varies
    ScheduledPowerOnMinute: Byte; // Varies
    ScheduledPowerOnSecond: Byte; // Varies
  end;
{$ENDREGION}

Procedure DecodeTable25(Dump: TRomBiosDump);

var
  Dmi25: TDmiType25;
  MemoTab25: TStringList;

implementation

Procedure DecodeTable25(Dump: TRomBiosDump);
begin
  if not Assigned(MemoTab25) then
    MemoTab25 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi25, SizeOf(TDmiType25));
  if Dmi25.Header.Length < $09 then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 25 wrong Length : ' + IntToStr(Dmi25.Header.Length));
  end;
  MemoTab25.Add('Next ScheduledPower-on Month : $' +
    IntToHex(Dmi25.ScheduledPowerOnMonth, 2));
  MemoTab25.Add('Next ScheduledPower-on Day-ofmonth : $' +
    IntToHex(Dmi25.ScheduledPowerOnDay, 2));
  MemoTab25.Add('Next ScheduledPower-on Hour : $' +
    IntToHex(Dmi25.ScheduledPowerOnHour, 2));
  MemoTab25.Add('Next ScheduledPower-on Minute : $' +
    IntToHex(Dmi25.ScheduledPowerOnMinute, 2));
  MemoTab25.Add('Next ScheduledPower-on Second : $' +
    IntToHex(Dmi25.ScheduledPowerOnSecond, 2));
end;

end.
