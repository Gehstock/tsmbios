//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable09;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, System.Classes;

{$REGION 'Header'}

type
  PDmiType9 = ^TDmiType9;

  TDmiType9 = packed record
    Header: TDmiHeader; // $11
    SlotDesignation: Byte; // STRING
    SlotTypes: Byte; // ENUM
    SlotDataBusWidth: Byte; // ENUM
    CurrentUsage: Byte; // ENUM
    SlotLength: Byte; // ENUM
    SlotID: Word; // Varies
    SlotCharacteristics1: Byte; // BIT FIELD
    SlotCharacteristics2: Byte; // BIT FIELD
    SegmentGroupNumber: Word; // Varies
    BusNumber: Byte; // Varies
    DeviceFunctionNumber: Byte; // BIT FIELD
  end;
{$ENDREGION}

Procedure DecodeTable9(Dump: TRomBiosDump);

var
  Dmi9: TDmiType9;
  MemoTab9: TStringList;

const
  CurrentUsageField: array [1 .. 4] of String = ('Other', 'Unknown',
    'Available', 'In use');
  SlotLength: array [1 .. 4] of String = ('Other', 'Unknown', 'Short Length',
    'Long Length');

  SlotChar1: array [1 .. 8] of String = ('Characteristics Unknown',
    'Provides 5.0 Volts', 'Provides 3.3 Volts',
    'Slot’s opening is shared with another slot (for example, PCI/EISA shared slot).',
    'PC Card slot supports PC Card-16.', 'PC Card slot supports CardBus.',
    'PC Card slot supports Zoom Video.',
    'PC Card slot supports Modem Ring Resume.');

  SlotChar2: array [1 .. 8] of String =
    ('PCI slot supports Power Management Event (PME#) signal.',
    'Slot supports hot-plug devices', 'PCI slot supports SMBus signal',
    'Reserved', 'Reserved', 'Reserved', 'Reserved', 'Reserved');

implementation

Function DecodeSlotTypeFieldDecode(i: Byte): String;
begin
  case i of
    $01:
      result := 'Other';
    $02:
      result := 'Unknown';
    $03:
      result := 'ISA';
    $04:
      result := 'MCA';
    $05:
      result := 'EISA';
    $06:
      result := 'PCI';
    $07:
      result := 'PC Card (PCMCIA)';
    $08:
      result := 'VL-VESA';
    $09:
      result := 'Proprietary';
    $0A:
      result := 'Processor Card Slot';
    $0B:
      result := 'Proprietary Memory Card Slot';
    $0C:
      result := 'I/O Riser Card Slot';
    $0D:
      result := 'NuBus';
    $0E:
      result := 'PCI – 66MHz Capable';
    $0F:
      result := 'AGP';
    $10:
      result := 'AGP 2X';
    $11:
      result := 'AGP 4X';
    $12:
      result := 'PCI-X';
    $13:
      result := 'AGP 8X';
    $14:
      result := 'M.2 Socket 1-DP (Mechanical Key A)';
    $15:
      result := 'M.2 Socket 1-SD (Mechanical Key E)';
    $16:
      result := 'M.2 Socket 2 (Mechanical Key B)';
    $17:
      result := 'M.2 Socket 3 (Mechanical Key M)';
    $18:
      result := 'MXM Type I';
    $19:
      result := 'MXM Type II';
    $1A:
      result := 'MXM Type III (standard connector)';
    $1B:
      result := 'MXM Type III (HE connector)';
    $1C:
      result := 'MXM Type IV';
    $1D:
      result := 'MXM 3.0 Type A';
    $1E:
      result := 'MXM 3.0 Type B';
    $1F:
      result := 'U.2 Express Gen 2 (SFF-8639)';
    $20:
      result := 'U.2 PCI Express Gen 3 (SFF-8639)';
    $A0:
      result := 'PC-98/C20';
    $A1:
      result := 'PC-98/C24';
    $A2:
      result := 'PC-98/E';
    $A3:
      result := 'PC-98/Local Bus';
    $A4:
      result := 'PC-98/Card';
    $A5:
      result := 'PCI Express';
    $A6:
      result := 'PCI Express x1';
    $A7:
      result := 'PCI Express x2';
    $A8:
      result := 'PCI Express x4';
    $A9:
      result := 'PCI Express x8';
    $AA:
      result := 'PCI Express x16';
    $AB:
      result := 'PCI Express Gen 2';
    $AC:
      result := 'PCI Express Gen 2 x1';
    $AD:
      result := 'PCI Express Gen 2 x2';
    $AE:
      result := 'PCI Express Gen 2 x4';
    $AF:
      result := 'PCI Express Gen 2 x8';
    $B0:
      result := 'PCI Express Gen 2 x16';
    $B1:
      result := 'PCI Express Gen 3';
    $B2:
      result := 'PCI Express Gen 3 x1';
    $B3:
      result := 'PCI Express Gen 3 x2';
    $B4:
      result := 'PCI Express Gen 3 x4';
    $B5:
      result := 'PCI Express Gen 3 x8';
    $B6:
      result := 'PCI Express Gen 3 x16';
  end;
end;

Function DecodeSlotDataBusWidthField(i: Byte): String;
begin
  case i of
    $01:
      result := 'Other';
    $02:
      result := 'Unknown';
    $03:
      result := '8 bit';
    $04:
      result := '16 bit';
    $05:
      result := '32 bit';
    $06:
      result := '64 bit';
    $07:
      result := '128 bit';
    $08:
      result := '1x or x1';
    $09:
      result := '2x or x2';
    $0A:
      result := '4x or x4';
    $0B:
      result := '8x or x8';
    $0C:
      result := '12x or x12';
    $0D:
      result := '16x or x16';
    $0E:
      result := '32x or x32';
  end;
end;

Procedure DecodeTable9(Dump: TRomBiosDump);
var
  i: Integer;
begin
  if not Assigned(MemoTab9) then
    MemoTab9 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi9, SizeOf(TDmiType9));
//  if ((SmEP32.MajorVersion = 2) and (SmEP32.MinorVersion = 0) and
//    (Dmi9.Header.Length <> $0C)) or
//    ((SmEP32.MajorVersion = 2) and (SmEP32.MinorVersion = 1) and
//    (SmEP32.MinorVersion <= 5) and (Dmi9.Header.Length <> $0D)) or
//    ((SmEP32.MajorVersion = 2) and (SmEP32.MinorVersion >= 6) and
//    (Dmi9.Header.Length <> $11)) then
if Dmi9.Header.Length < $11 then
    begin
      // Addr := SmBiosGetNextEntry(Dump, Addr);
      // Continue;
      Showmessage('Table 9 wrong Length : ' + IntToStr(Dmi9.Header.Length));
    end;
  MemoTab9.Add(#13#10 + 'Slot ID    : ' + IntToStr(Dmi9.SlotID));
  MemoTab9.Add('Slot Designaton      : ' + SmBiosGetString(Dump, Addr,
    Dmi9.SlotDesignation));
  MemoTab9.Add('Slot Type    : ' + DecodeSlotTypeFieldDecode(Dmi9.SlotTypes));
  MemoTab9.Add('Slot Data Bus Width    : ' + DecodeSlotDataBusWidthField
    (Dmi9.SlotDataBusWidth));
  MemoTab9.Add('Current Usage    : ' + CurrentUsageField[Dmi9.CurrentUsage]);
  MemoTab9.Add('Slot Length    : ' + SlotLength[Dmi9.SlotLength] + #13#10);
  // Slot Characteristics 1
  Text := ByteToBinReverse(Dmi9.SlotCharacteristics1);
  if Length(Text) >= High(SlotChar1) then
  begin
    MemoTab9.Add('Slot Characteristics 1    : ' { + Text } );
    for i := 1 to 8 do
      if Text[i] = '1' then
        MemoTab9.Add(SlotChar1[i]);
  end;
  // Slot Characteristics 2
  Text := ByteToBinReverse(Dmi9.SlotCharacteristics2);
  if Length(Text) >= High(SlotChar2) then
  begin
    MemoTab9.Add(#13#10 + 'Slot Characteristics 2    : ' { + Text } );
    for i := 1 to High(SlotChar2) do
      if Text[i] = '1' then
        MemoTab9.Add(SlotChar2[i]);
  end;
  MemoTab9.Add(#13#10 + 'Segment Group Number    : ' +
    IntToStr(Dmi9.SegmentGroupNumber));
  MemoTab9.Add('Bus Number    : ' + IntToStr(Dmi9.BusNumber));
  // Device/Function Number
  Text := ByteToBin(Dmi9.DeviceFunctionNumber);
  if Length(Text) = 8 then
  begin
    MemoTab9.Add('Device Number: ' + IntToStr(BinToInt(Copy(Text, 1, 5))));
    MemoTab9.Add('Function Number: ' + IntToStr(BinToInt(Copy(Text, 6, 3))));
  end;
  MemoTab9.Add('');
end;

end.
