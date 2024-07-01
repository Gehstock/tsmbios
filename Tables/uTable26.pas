//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable26;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, WinAPI.Windows, System.Classes;

{$REGION 'Header'}
type
  PDmiType26 = ^TDmiType26;
  TDmiType26 = packed record
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

Procedure DecodeTable26(Dump: TRomBiosDump);
Function DecodeStatus26(s: String): String;
Function DecodeLocation26(s: String): String;

var
  Dmi26: TDmiType26;
  MemoTab26: TStringList;

implementation

uses uTable27;

Procedure DecodeTable26(Dump: TRomBiosDump);
begin
  Text := '';
  if not Assigned(MemoTab26) then
  MemoTab26 := TStringList.Create;
  // Dmi26.Header.Handle := Dmi26.TemperatureProbeHandle;
  ReadRomDumpBuffer(Dump, Addr, Dmi26, SizeOf(TDmiType26));
  if Dmi26.Header.Length < $14 then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 26 wrong Length : ' + IntToStr(Dmi26.Header.Length));
  end;
  if { (Dmi27.TemperatureProbeHandle > $00) and }
    (Dmi27.TemperatureProbeHandle < $FFFF) then
  begin
    // MemoCool.Lines.Add('Description2      : ' + SmBiosGetString(Dump,
    // Addr, Dmi28.Description));
    // Text := IntToBIN(Dmi28.LocationandStatus);
    // MemoCool.Lines.Add('Status :' + DecodeStatus28(Text));
    // MemoCool.Lines.Add('Location :' + DecodeLocation28(Text));
    //
    // { TODO -cwichtig : Filter Unset Values }
    // MemoCool.Lines.Add('Maximum Value     : ' +
    // IntToStr(Dmi28.MaximumValue));
    // MemoCool.Lines.Add('Minimum Value     : ' +
    // IntToStr(Dmi28.MinimumValue));
    // MemoCool.Lines.Add('Resolution     : ' +
    // IntToStr(Dmi28.Resolution));
    // MemoCool.Lines.Add('Tolerance     : ' +
    // IntToStr(Dmi28.Tolerance));
    // MemoCool.Lines.Add('Accuracy     : ' + IntToStr(Dmi28.Accuracy));
    // MemoCool.Lines.Add('OEMdefined     : ' +
    // IntToStr(Dmi28.OEMdefined));
    // MemoCool.Lines.Add('Nominal Value     : ' +
    // IntToStr(Dmi28.NominalValue));
  end;
  MemoTab26.Add('');
end;

Function DecodeStatus26(s: String): String;
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

Function DecodeLocation26(s: String): String;
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
