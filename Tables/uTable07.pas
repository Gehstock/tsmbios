//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable07;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, WinAPI.Windows, System.Classes;

{$REGION 'Header'}
type
  PDmiTyp7 = ^TDmiType7;
  TDmiType7 = packed record
    Header: TDmiHeader;
    SocketDesignation: Byte;
    CacheConfiguration: Word;
    MaximumCacheSize: Word;
    InstalledSize: Word;
    SupportedSRAMType: Word;
    CurrentSRAMType: Word;
    CacheSpeed: Byte;
    ErrorCorrectionType: Byte;
    SystemCacheType: Byte;
    Associativity: Byte;
  end;
{$ENDREGION}

Procedure DecodeTable7(Dump: TRomBiosDump);
Function DecodeCacheConfiguration(s: String): String;

var
  Dmi7: TDmiType7;
  MemoTab7 : TStringList;

const
  SRAMTypeField: array [1 .. 16] of String = (
  'Other',
  'Unknown',
  'Non-Burst',
  'Burst',
  'Pipeline Burst',
  'Synchronous',
  'Asynchronous',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved');

  ErrorCorrectionTypeField: array [1 .. 8] of String = (
  'Other',
  'Unknown',
  'None',
  'Parity',
  'Single-bit ECC',
  'Multi-bit ECC',
  'Reserved',
  'Reserved');

  SystemCacheTypeField: array [1 .. 8] of String = (
  'Other',
  'Unknown',
  'Instruction',
  'Data',
  'Unified',
  'Reserved',
  'Reserved',
  'Reserved');

  AssociativityField: array [1 .. 16] of String = (
  'Other',
  'Unknown',
  'Direct Mapped',
  '2-way Set-Associative',
  '4-way Set-Associative',
  'Fully Associative',
  '8-way Set-Associative',
  '16-way Set-Associative',
  '12-way Set-Associative',
  '24-way Set-Associative',
  '32-way Set-Associative',
  '48-way Set-Associative',
  '64-way Set-Associative',
  '20-way Set-Associative',
  'Reserved',
  'Reserved');

implementation

Procedure DecodeTable7(Dump: TRomBiosDump);
var
  i: Integer;
  temp : String;
begin
if not Assigned(MemoTab7) then
  MemoTab7 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi7, SizeOf(TDmiType7));
  if Dmi7.InstalledSize <> 0 then
  Begin
//  if (not (SmEP32.MajorVersion = 2) and (SmEP32.MinorVersion = 0)and (Dmi7.Header.Length <> $0F)) or
//  (not (SmEP32.MajorVersion = 2) and (SmEP32.MinorVersion >= 1)and (Dmi7.Header.Length <> $13)) then
if Dmi7.Header.Length < $13 then
    begin
      // Addr := SmBiosGetNextEntry(Dump, Addr);
      // Continue;
      Showmessage('Table 7 wrong Length : ' + IntToStr(Dmi7.Header.Length));
    end;
    MemoTab7.Add('[Cache Information]');
    MemoTab7.Add('Socket Designation      : ' +
      SmBiosGetString(Dump, Addr, Dmi7.SocketDesignation));
    // Cache Configuration
    MemoTab7.Add('DecodeCacheConfiguration    : ' + IntToBIN(Dmi7.CacheConfiguration));
    MemoTab7.Add(DecodeCacheConfiguration(IntToBIN(Dmi7.CacheConfiguration)));

    MemoTab7.Add('Maximum Cache Size    : ' +
      IntToStr(Dmi7.MaximumCacheSize) + ' Kb');
    MemoTab7.Add('Installed Size    : ' +
      IntToStr(Dmi7.InstalledSize) + ' Kb');
    { TODO -cwichtig : Hier haut nix hin }
    Text := ReverseString(IntToBIN(Dmi7.SupportedSRAMType));
    if Length(Text) >= High(SRAMTypeField) then
    begin
      for i := 1 to 16 do
        if Text[i] = '1' then
          MemoTab7.Add('Supported SRAM Type     : ' +
            SRAMTypeField[i]);
    end;
    Text := ReverseString(IntToBIN(Dmi7.CurrentSRAMType));
    if Length(Text) >= High(SRAMTypeField) then
    begin
      for i := 1 to 16 do
        if Text[i] = '1' then
          MemoTab7.Add('Current SRAM Type     : ' +
            SRAMTypeField[i]);
    end;
    MemoTab7.Add('Cache Speed    : ' + IntToStr(Dmi7.CacheSpeed)
      + ' Mhz');
    Text := ReverseString(IntToBIN(Dmi7.ErrorCorrectionType));
    if Length(Text) >= High(ErrorCorrectionTypeField) then
    begin
      for i := 1 to 8 do
        if Text[i] = '1' then
          MemoTab7.Add('Error Correction Type    : ' +
            ErrorCorrectionTypeField[i]);
    end;
    Text := ReverseString(IntToBIN(Dmi7.SystemCacheType));
    if Length(Text) >= High(SystemCacheTypeField) then
    begin
      for i := 1 to 8 do
        if Text[i] = '1' then
          MemoTab7.Add('System Cache Type    : ' +
            SystemCacheTypeField[i]);
    end;
    Text := ReverseString(IntToBIN(Dmi7.Associativity));
    if Length(Text) >= High(AssociativityField) then
    begin
      for i := 1 to 16 do
        if Text[i] = '1' then
          MemoTab7.Add('Associativity    : ' { + Text } +
            AssociativityField[i]);
    end;
  End;
  MemoTab7.Add('');
end;

Function DecodeCacheConfiguration(s: String): String;
begin
  // s[1] zu fixen
    // s[2] zu fixen
  if s[3] = '1' then
    Result := Result + 'Cache Socketed'+#13#10
  else
    Result := Result + 'Cache not Socketed'+#13#10;
      // s[4] Reserved
  case StrtoInt(s[5]+s[6]) of
    00 : Result := Result + 'Cache Internal'+#13#10;
    01 : Result := Result + 'Cache External'+#10#13+#13#10;
    10 : Result := Result + 'Reserved'+#10#13+#13#10;
    11 : Result := Result + 'Cache Unknown'+#10#13+#13#10;
  end;
  if s[7] = '1' then
    Result := Result + 'Cache Enabled (at boot time)'+#13#10
  else
    Result := Result + 'Cache Disabled (at boot time)'+#13#10;
  // s[11] Reserved
  // s[12] Reserved
  // s[13] Reserved
  // s[14] Reserved
  // s[15] Reserved
  // s[16] Reserved
end;

end.
