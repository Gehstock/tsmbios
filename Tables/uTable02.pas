//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable02;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, System.Classes;

{$REGION 'Header'}

type
  PDmiType2 = ^TDmiType2;

  TDmiType2 = packed record
    Header: TDmiHeader; // $08
    Manufacturer: Byte; // STRING
    ProductName: Byte; // STRING
    Version: Byte; // STRING
    SerialNumber: Byte; // STRING
    AssetTag: Byte; // STRING
    FeatureFlags: Byte; // Bit Field
    Location: Byte; // STRING
    ChassisHandle: Word; // Varies
    BoardType: Byte; // ENUM
    NumberContainedObject: Byte; // Varies
    // ContainedObjectHandles : Array of Word;  // n Words - Varies
  end;
{$ENDREGION}

Procedure DecodeTable2(Dump: TRomBiosDump);

var
  Dmi2: TDmiType2;
  MemoTab2 : TStringList;

const
  FeatFlags: array [1 .. 8] of String = (
  'The Board is a Hosting Board',
  'The board requires at least one daughter board or auxiliary card to function properly',
  'The Board is removable',
  'The Board is replaceable;',
  'The Board is hot swappable',
  'Reserved',
  'Reserved',
  'Reserved');

  BoardTyp: array [1 .. 13] of String = (
  'Unknown',
  'Other',
  'Server Blade',
  'Connectivity Switch',
  'System Management Module',
  'Processor Module',
  'I/O Module',
  'Memory Module',
  'Daughter board',
  'Motherboard (includes processor, memory, and I/O)',
  'Processor/Memory Module',
  'Processor/IO Module',
  'Interconnect Board');

implementation


Procedure DecodeTable2(Dump: TRomBiosDump);
var
  i: Integer;
begin
if not Assigned(MemoTab2) then
  MemoTab2 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi2, SizeOf(TDmiType2));
  if Dmi2.Header.Length < $08 then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 2 wrong Length : ' + IntToStr(Dmi2.Header.Length));
  end;
  MemoTab2.Add('Manufacturer       : ' + SmBiosGetString(Dump, Addr,
    Dmi2.Manufacturer));
  MemoTab2.Add('Product Name       : ' + SmBiosGetString(Dump, Addr,
    Dmi2.ProductName));
  MemoTab2.Add('System Version     : ' + SmBiosGetString(Dump, Addr,
    Dmi2.Version));
  MemoTab2.Add('Serial Number      : ' + SmBiosGetString(Dump, Addr,
    Dmi2.SerialNumber));
  MemoTab2.Add('Asset Tag      : ' + SmBiosGetString(Dump, Addr,
    Dmi2.AssetTag));
  MemoTab2.Add('');
  Text := ReverseString(Byte2bit(Dmi2.FeatureFlags));
  if Length(Text) >= High(FeatFlags) then
  begin
    MemoTab2.Add('Feature Flags     : '  +
        Byte2bit(Dmi2.FeatureFlags)  );
    for i := 1 to 8 do
      if Text[i] = '1' then
        MemoTab2.Add(FeatFlags[i]);
    MemoTab2.Add('');
  end;
  MemoTab2.Add('Location      : ' + SmBiosGetString(Dump, Addr,
    Dmi2.Location));
  MemoTab2.Add('Board Type     : ' + BoardTyp[Dmi2.BoardType]);
  // if High(Dmi2.ContainedObjectHandles) <= (Dmi2.NumberContainedObject) then
  // begin
  // SetLength(Dmi2.ContainedObjectHandles, Dmi2.NumberContainedObject);
  // ReadRomDumpBuffer(Dump, Addr, Dmi2, SizeOf(TDmiType2));
  // end;
  // MemoBase.Lines.Add('NumberContainedObject     : ' +
  // IntToStr(Dmi2.NumberContainedObject));
end;

end.
