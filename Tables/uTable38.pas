//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable38;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, WinAPI.Windows, System.Classes;

{$REGION 'Header'}

type
  // PDmiType38 = ^TDmiType38;

  TDmiType38 = packed record
    Header: TDmiHeader;
    InterfaceType: Byte; // Enum
    IPMIRevision: Byte; // Varies
    I2CSlaveAddress: Byte; // Varies
    NVStorageAddress: Byte; // Varies
    BaseAddress: QWord; // Varies
    BaseAddressModifier: Byte; // Varies
    InterruptNumber: Byte; // Varies
  end;
{$ENDREGION}

Procedure DecodeTable38(Dump: TRomBiosDump);

Const
  InterfaceTypeField: Array [0 .. 4] of string = ('Unknown',
    'KCS: Keyboard Controller Style', 'SMIC: Server Management Interface Chip',
    'BT: Block Transfer',
    'Reserved for future assignment by this specification');

var
  Dmi38: TDmiType38;
  MemoTab38: TStringList;

implementation

uses umain;

Procedure DecodeTable38(Dump: TRomBiosDump);
begin
  if not Assigned(MemoTab38) then
    MemoTab38 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi38, SizeOf(TDmiType38));
  if Dmi38.Header.Length < $10 then
  begin
    Showmessage('Table 38 wrong Length : ' + IntToStr(Dmi38.Header.Length));
    //Addr := SmBiosGetNextEntry(Dump, Addr);
    //Continue;
  end;
  if (Dmi38.InterfaceType >= $00) and (Dmi38.InterfaceType <= $04) then
    MemoTab38.Add('Interface Type : ' + InterfaceTypeField[Dmi38.InterfaceType])
  else
    MemoTab38.Add('Interface Type : ' + InterfaceTypeField[4]);
  MemoTab38.Add('I2C Slave Address : $' + IntToHex(Dmi38.I2CSlaveAddress, 2));
  if Dmi38.NVStorageAddress < $FF then
    MemoTab38.Add('NV Storage Device Address : $' +
      IntToHex(Dmi38.NVStorageAddress, 2))
  else
    MemoTab38.Add('No NV Storage Device exist');
  MemoTab38.Add('');

  if Dmi38.InterruptNumber > $00 then
    MemoTab38.Add('InterruptNumber : $' + IntToHex(Dmi38.InterruptNumber, 2))
  else
    MemoTab38.Add('InterruptNumber unspecified/unsupported');
  MemoTab38.Add('');
end;

end.
