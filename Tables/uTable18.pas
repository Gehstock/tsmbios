//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable18;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, WinAPI.Windows, System.Classes;

{$REGION 'Header'}

type
  PDmiType18 = ^TDmiType18;

  TDmiType18 = packed record
    Header: TDmiHeader; // 17h
    ErrorType: Byte; // ENUM
    ErrorGranularity: Byte; // ENUM
    ErrorOperation: Byte; // ENUM
    VendorSyndrome: DWord; // Varies
    MemoryArrayErrorAddress: DWord; // Varies
    DeviceErrorAddress: DWord; // Varies
    ErrorResolution: DWord; // Varies
  end;
{$ENDREGION}

Procedure DecodeTable18(Dump: TRomBiosDump);

var
  Dmi18: TDmiType18;
  MemoTab18: TStringList;

const
  ErrorTypeField: array [1 .. 16] of string = ('Other', 'Unknown', 'OK',
    'Bad read', 'Parity error', 'Single-bit error', 'Double-bit error',
    'Multi-bit error', 'Nibble error', 'Checksum error', 'CRC error',
    'Corrected single-bit error', 'Corrected error', 'Uncorrectable error',
    'Reserved', 'Reserved');

  ErrorGranularityField: array [1 .. 8] of string = ('Other', 'Unknown',
    'Device level', 'Memory partition level', 'Reserved', 'Reserved',
    'Reserved', 'Reserved');

  ErrorOperationField: array [1 .. 8] of string = ('Other', 'Unknown', 'Read',
    'Write', 'Partial write', 'Reserved', 'Reserved', 'Reserved');

implementation

Procedure DecodeTable18(Dump: TRomBiosDump);
begin
  if not Assigned(MemoTab18) then
    MemoTab18 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi18, SizeOf(TDmiType18));
  if Dmi18.Header.Length < $17 then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 18 wrong Length : ' + IntToStr(Dmi18.Header.Length));
  end;
  MemoTab18.Add('Error type     : ' + ErrorTypeField[Dmi18.ErrorType]);
  MemoTab18.Add('Error Granularity     : ' + ErrorGranularityField
    [Dmi18.ErrorGranularity]);
  MemoTab18.Add('Error Operation     : ' + ErrorOperationField
    [Dmi18.ErrorOperation]);
  if Dmi18.VendorSyndrome = 0 then
    MemoTab18.Add('Vendor Syndrome     : unknown')
  else
    MemoTab18.Add('Vendor Syndrome     : ' + IntToHex(Dmi18.VendorSyndrome, 1));
  if Dmi18.MemoryArrayErrorAddress = $80000000 then
    MemoTab18.Add('Memory Array Error Address     : unknown')
  else
    MemoTab18.Add('Memory Array Error Address     : ' +
      IntToHex(Dmi18.MemoryArrayErrorAddress, 1));
  if Dmi18.DeviceErrorAddress = $80000000 then
    MemoTab18.Add('Device Error Address     : unknown')
  else
    MemoTab18.Add('Device Error Address     : ' +
      IntToHex(Dmi18.DeviceErrorAddress, 1));
  if Dmi18.ErrorResolution = $80000000 then
    MemoTab18.Add('Error Resolution     : unknown')
  else
    MemoTab18.Add('Error Resolution     : ' +
      IntToHex(Dmi18.ErrorResolution, 1));
  MemoTab18.Add('');
end;

end.
