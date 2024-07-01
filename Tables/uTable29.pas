//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable29;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, WinAPI.Windows, System.Classes;

{$REGION 'Header'}
type
  PDmiType29 = ^TDmiType29;
  TDmiType29 = packed record
    Header: TDmiHeader;
    Description: Byte;
    LocationandStatus: Byte;
    MaximumValue: Word;
    MinimumValue: Word;
    Resolution: Word;
    Tolerance: Word;
    Accuracy: Word;
    OEMdefined: DWord;
    NominalValue: Word;
  end;
{$ENDREGION}

var
  Dmi29: TDmiType29;
  MemoTab29: TStringList;

Procedure DecodeTable29(Dump: TRomBiosDump);
Function DecodeStatus29(s: String): String;
Function DecodeLocation29(s: String): String;

implementation


Procedure DecodeTable29(Dump: TRomBiosDump);
begin
if not Assigned(MemoTab29) then
  MemoTab29 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi29, SizeOf(TDmiType29));
  if Dmi29.Header.Length < $14 then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 29 wrong Length : ' + IntToStr(Dmi29.Header.Length));
  end;
  MemoTab29.Add('Description      : ' + SmBiosGetString(Dump,
    Addr, Dmi29.Description));
  Text := IntToBIN(Dmi29.LocationandStatus);
  // text := Copy(text,24,8);
  // Showmessage(Text);
  MemoTab29.Add('Status :' + DecodeStatus29(Text));
  MemoTab29.Add('Location :' + DecodeLocation29(Text));
  { TODO -cwichtig : LocationandStatus Bugfix }
  if Dmi29.MaximumValue <> $8000 then
    MemoTab29.Add('MaximumValue     : ' +
      IntToStr(Dmi29.MaximumValue) + ' mA')
  else
    MemoTab29.Add('MaximumValue     : not Set');
  if Dmi29.MinimumValue <> $8000 then
    MemoTab29.Add('MinimumValue     : ' +
      IntToStr(Dmi29.MinimumValue) + ' mA')
  else
    MemoTab29.Add('Minimum Value     : not Set');
  if Dmi29.Resolution <> $8000 then
    MemoTab29.Add('Resolution     : ' +
      IntToStr(Dmi29.Resolution) + ' mA')
  else
    MemoTab29.Add('Resolution     : not Set');
  if Dmi29.Tolerance <> $8000 then
    MemoTab29.Add('Tolerance     : ' +
      IntToStr(Dmi29.Tolerance) + ' mA')
  else
    MemoTab29.Add('Tolerance     : not Set');
  if Dmi29.Accuracy <> $8000 then
    MemoTab29.Add('Accuracy     : ' +
      IntToStr(Dmi29.Accuracy) + ' %')
  else
    MemoTab29.Add('Accuracy     : not Set');
  MemoTab29.Add('OEMdefined     : ' +
    IntToStr(Dmi29.OEMdefined));
  if Dmi29.Header.Length > $14 then
    if Dmi29.NominalValue <> $8000 then
      MemoTab29.Add('NominalValue     : ' +
        IntToStr(Dmi29.NominalValue) + ' mA')
    else
      MemoTab29.Add('NominalValue     : not Set');
end;

Function DecodeStatus29(s: String): String;
begin
  case Strtoint(copy(s, 1, 3)) of
    000:
      Result := ' not Set';
    001:
      Result := ' Other';
    010:
      Result := ' Unknown';
    011:
      Result := ' OK';
    100:
      Result := ' Non-critical';
    101:
      Result := ' Critical';
    110:
      Result := ' Non-recoverable';
  end;
end;

Function DecodeLocation29(s: String): String;
begin
  case Strtoint(copy(s, 4, 8)) of
    00000:
      Result := ' not Set';
    00001:
      Result := ' Other';
    00010:
      Result := ' Unknown';
    00011:
      Result := ' Processor';
    00100:
      Result := ' Disk';
    00101:
      Result := ' Peripheral Bay';
    00110:
      Result := ' System Management Module';
    00111:
      Result := ' Motherboard';
    01000:
      Result := ' Memory Module';
    01001:
      Result := ' Processor Module';
    01010:
      Result := ' Power Unit';
    01011:
      Result := ' Add-in Card';
  end;
end;

end.


//7: 5 Status 001 .. .. .Other 010 .. .. .Unknown 011 .. .. .OK 100 .. .. .Non
//  - critical 101 .. .. .critical 110 .. .. .Non - recoverable 4
//  : 0 Location .. .00001 Other .. .00010 Unknown .. .00011 Processor .. .00100
//  Disk .. .00101 Peripheral Bay .. .00110 System Management Module .. .00111
//  Motherboard .. .01000 Memory Module .. .01001 Processor Module .. .01010 Power
//Unit .. .01011 Add - in Card
