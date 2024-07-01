//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable28;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, WinAPI.Windows, System.Classes;

{$REGION 'Header'}
type
  PDmiType28 = ^TDmiType28;
  TDmiType28 = packed record
    Header: TDmiHeader; // $14
    Description: Byte; // STRING
    LocationandStatus: Byte; // Bit-field
    MaximumValue: Word; // Varies
    MinimumValue: Word; // Varies
    Resolution: Word; // Varies
    Tolerance: Word; // Varies
    Accuracy: Word; // Varies
    OEMdefined: DWord; // Varies
    NominalValue: Word; // Varies
  end;
{$ENDREGION}

Procedure DecodeTable28(Dump: TRomBiosDump);
Function DecodeStatus28(s: String): String;
Function DecodeLocation28(s: String): String;

var
  Dmi28: TDmiType28;
  MemoTab28: TStringList;

implementation

uses uTable27;

Procedure DecodeTable28(Dump: TRomBiosDump);
begin
  Text := '';
  if not Assigned(MemoTab28) then
  MemoTab28 := TStringList.Create;
  Dmi28.Header.Handle := Dmi27.TemperatureProbeHandle;
  ReadRomDumpBuffer(Dump, Addr, Dmi28, SizeOf(TDmiType28));
  if Dmi28.Header.Length < $14 then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 28 wrong Length : ' + IntToStr(Dmi28.Header.Length));
  end;
  if { (Dmi27.TemperatureProbeHandle > $00) and }
    (Dmi27.TemperatureProbeHandle < $FFFF) then
  begin
    MemoTab28.Add('Description2      : ' + SmBiosGetString(Dump,
      Addr, Dmi28.Description));
    Text := IntToBIN(Dmi28.LocationandStatus);
    MemoTab28.Add('Status :' + DecodeStatus28(Text));
    MemoTab28.Add('Location :' + DecodeLocation28(Text));
    if Dmi28.MaximumValue <> $8000 then
      MemoTab28.Add('Maximum Value     : ' +
        IntToStr(Dmi28.MaximumValue) + ' °C')
    else
      MemoTab28.Add('Maximum Value     : not Set');
    // 1/10 Degrees
    if Dmi28.MinimumValue <> $8000 then
      MemoTab28.Add('Minimum Value     : ' +
        IntToStr(Dmi28.MinimumValue) + ' °C')
    else
      MemoTab28.Add('Minimum Value     : not Set');
    // 1/10 Degrees
    if Dmi28.Resolution <> $8000 then
      MemoTab28.Add('Resolution     : ' +
        IntToStr(Dmi28.Resolution) + ' °C')
    else
      MemoTab28.Add('Resolution     : not Set');
    // 1/1000 Degrees
    if Dmi28.Tolerance <> $8000 then
      MemoTab28.Add('Tolerance     : ' +
        IntToStr(Dmi28.Tolerance) + ' °C')
    else
      MemoTab28.Add('Tolerance     : not Set');
    // 1/10 Degrees
    if Dmi28.Accuracy <> $8000 then
      MemoTab28.Add('Accuracy     : ' +
        IntToStr(Dmi28.Accuracy) + ' %')
    else
      MemoTab28.Add('Accuracy     : not Set');
    // Percent
    MemoTab28.Add('OEMdefined     : ' + IntToStr(Dmi28.OEMdefined));
    if Dmi28.Header.Length > $14 then
      if Dmi28.NominalValue <> $8000 then
        MemoTab28.Add('Nominal Value     : ' +
          IntToStr(Dmi28.NominalValue) + ' °C')
      else
        MemoTab28.Add('Nominal Value     : not Set');
    // 1/10 Degrees
  end;
  MemoTab28.Add('');
end;

Function DecodeStatus28(s: String): String;
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

Function DecodeLocation28(s: String): String;
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
    01100:
      Result := ' Front Panel Board';
    01101:
      Result := ' Back Panel Board';
    01110:
      Result := ' Power System Board';
    01111:
      Result := ' Drive Back Plane';
  end;
end;

end.
