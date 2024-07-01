//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable33;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, WinAPI.Windows, System.Classes;

{$REGION 'Header'}

type
  PDmiType33 = ^TDmiType33;

  TDmiType33 = packed record
    Header: TDmiHeader; // 1F
    ErrorType: Byte; // ENUM
    ErrorGranularity: Byte; // ENUM
    ErrorOperation: Byte; // ENUM
    VendorSyndrome: DWord; // Varies
    MemoryArrayErrorAddress: QWord; // Varies
    DeviceErrorAddress: QWord; // Varies
    ErrorResolution: DWord; // Varies
  end;
{$ENDREGION}

Procedure DecodeTable33(Dump: TRomBiosDump);

var
  Dmi33: TDmiType33;
  MemoTab33: TStringList;

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

uses umain;

Procedure DecodeTable33(Dump: TRomBiosDump);
begin
  if not Assigned(MemoTab33) then
    MemoTab33 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi33, SizeOf(TDmiType33));
  if Dmi33.Header.Length < $1F then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 33 wrong Length : ' + IntToStr(Dmi33.Header.Length));
  end;
  MemoTab33.Add('Error type     : ' + ErrorTypeField[Dmi33.ErrorType]);
  MemoTab33.Add('Error Granularity     : ' + ErrorGranularityField
    [Dmi33.ErrorGranularity]);
  MemoTab33.Add('Error Operation     : ' + ErrorOperationField
    [Dmi33.ErrorOperation]);
  if Dmi33.VendorSyndrome = 0 then
    MemoTab33.Add('Vendor Syndrome     : unknown')
  else
    MemoTab33.Add('Vendor Syndrome     : ' + IntToHex(Dmi33.VendorSyndrome, 1));
  if Dmi33.MemoryArrayErrorAddress = $8000000000000000 then
    MemoTab33.Add('Memory Array Error Address     : unknown')
  else
    MemoTab33.Add('Memory Array Error Address     : ' +
      IntToHex(Dmi33.MemoryArrayErrorAddress, 1));
  if Dmi33.DeviceErrorAddress = $8000000000000000 then
    MemoTab33.Add('Device Error Address     : unknown')
  else
    MemoTab33.Add('Device Error Address     : ' +
      IntToHex(Dmi33.DeviceErrorAddress, 1));
  if Dmi33.ErrorResolution = $80000000 then
    MemoTab33.Add('Error Resolution     : unknown')
  else
    MemoTab33.Add('Error Resolution     : ' +
      IntToHex(Dmi33.ErrorResolution, 1));
end;

end.
