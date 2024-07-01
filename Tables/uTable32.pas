//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable32;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, System.Classes;

{$REGION 'Header'}

type
  PDmiType32 = ^TDmiType32;

  TDmiType32 = packed record
    Header: TDmiHeader;
    Reserved: Array [0 .. 5] of Byte; // HardCoded to $00
    BootStatus: Array of Byte;
  end;
{$ENDREGION}

Procedure DecodeTable32(Dump: TRomBiosDump);
Function Decode32(val: Byte): String;

var
  Dmi32: TDmiType32;
  MemoTab32: TStringList;

implementation

uses umain;

Procedure DecodeTable32(Dump: TRomBiosDump);
var
s : String;
i : Integer;
begin
  { TODO -cwichtig : Table32 check }
  if not Assigned(MemoTab32) then
    MemoTab32 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi32, SizeOf(TDmiType32));
  if Dmi32.Header.Length < $0B then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 32 wrong Length : ' + IntToStr(Dmi32.Header.Length));
  end;
    Showmessage(inttoStr(Dmi32.Header.Length));
  // We now know the Lenght of Status
  SetLength(Dmi32.BootStatus, Integer(Dmi32.Header.Length) - 10);
    Showmessage(inttostr(SizeOf(Dmi32.BootStatus)));
  // Read again with the Correct Status Length
  ReadRomDumpBuffer(Dump, Addr, Dmi32, SizeOf(TDmiType32));
  for I := low(Dmi32.BootStatus) to High(Dmi32.BootStatus) do
    s := s + IntToHex(Dmi32.BootStatus[i],2);
  MemoTab32.Add('System Boot Information     : ' + s);
  MemoTab32.Add('System Boot Information     : ' +
    Decode32(low(Dmi32.BootStatus)));
end;

Function Decode32(val: Byte): String;
begin
  case val of
    0:
      Result := 'No errors detected';
    1:
      Result := 'No bootable media';
    2:
      Result := 'The “normal” operating system failed to load.';
    3:
      Result := 'Firmware-detected hardware failure, including “unknown” failure types';
    4:
      Result := 'Operating system-detected hardware failure. ';
    5:
      Result := 'User-requested boot, usually through a keystroke';
    6:
      Result := 'System security violation';
    7:
      Result := 'Previously-requested image. This reason code allows coordination between OS-present software and the OS-absent environment.';
    8:
      Result := 'A system watchdog timer expired, causing the system to reboot.';
    9 .. 127:
      Result := 'Reserved for future assignment by this specification';
    128 .. 191:
      Result := 'Vendor/OEM-specific implementations. The Vendor/OEM identifier is the “Manufacturer” string found in the System Information structure.';
    192 .. 255:
      Result := 'Product-specific implementations. The product identifier is formed by the concatenation of the “Manufacturer” and “Product Name” strings found in the System Information structure.';
  end;
end;

end.
