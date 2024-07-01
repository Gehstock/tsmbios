//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable08;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, WinAPI.Windows, System.Classes;

{$REGION 'Header'}
type
  PDmiType8 = ^TDmiType8;
  TDmiType8 = packed record
    Header: TDmiHeader; // $09
    IntRefDes: Byte; // STRING
    IntConnTyp: Byte; // ENUM
    ExtRefDes: Byte; // STRING
    ExtConnTyp: Byte; // ENUM
    PortType: Byte; // ENUM
  end;
{$ENDREGION}

Procedure DecodeTable8(Dump: TRomBiosDump);

var
  Dmi8: TDmiType8;
  MemoTab8 : TStringList;

const
ConnectorTypes: array [0 .. 39] of String = (
  'None',
  'Centronics',
  'Mini Centronics',
  'Proprietary',
  'DB-25 pin male',
  'DB-25 pin female',
  'DB-15 pin male',
  'DB-15 pin female',
  'DB-9 pin male',
  'DB-9 pin female',
  'RJ-11',
  'RJ-45',
  '0Ch 50-pin MiniSCSI',
  'Mini-DIN',
  '0Eh Micro-DIN',
  'PS/2',
  'Infrared',
  'HP-HIL',
  '12h Access Bus (USB)',
  '13h SSA SCSI',
  '14h Circular DIN-8 male',
  '15h Circular DIN-8 female',
  'On Board IDE',
  'On Board Floppy',
  '9-pin Dual Inline (pin 10 cut)',
  '25-pin Dual Inline (pin 26 cut)',
  '50-pin Dual Inline',
  '68-pin Dual Inline',
  'On Board Sound Input from CD-ROM',
  'Mini-Centronics Type-14',
  'Mini-Centronics Type-26',
  'Mini-jack (headphones)',
  'BNC',
  '1394',
  'SAS/SATA Plug Receptacle',
  'PC-98',
  'PC-98Hireso',
  'PC-H98',
  'PC-98Note',
  'PC-98Full');
//FFh Other – Use Reference Designator Strings to supply information.

PortTypes: array [0 .. 35] of String = (
'None',
'Parallel Port XT/AT Compatible',
'Parallel Port PS/2',
'Parallel Port ECP',
'Parallel Port EPP',
'Parallel Port ECP/EPP',
'Serial Port XT/AT Compatible',
'Serial Port 16450 Compatible',
'Serial Port 16550 Compatible',
'Serial Port 16550A Compatible',
'SCSI Port',
'MIDI Port',
'Joy Stick Port',
'Keyboard Port',
'Mouse Port',
'0Fh SSA SCSI',
'USB',
'FireWire (IEEE P1394)',
'PCMCIA Type I2',
'PCMCIA Type II',
'PCMCIA Type III',
'Cardbus',
'Access Bus Port',
'SCSI II',
'SCSI Wide',
'PC-98',
'PC-98-Hireso',
'PC-H98',
'Video Port',
'Audio Port',
'Modem Port',
'Network Port',
'SATA',
'SAS',
'8251 Compatible',
'8251 FIFO Compatible');
//0FFh Other');

implementation

Procedure DecodeTable8(Dump: TRomBiosDump);
begin
if not Assigned(MemoTab8) then
  MemoTab8 := TStringList.Create;
  ReadRomDumpBuffer(Dump, Addr, Dmi8, SizeOf(TDmiType8));
  if Dmi8.Header.Length < $09 then
  begin
    // Addr := SmBiosGetNextEntry(Dump, Addr);
    // Continue;
    Showmessage('Table 8 wrong Length : ' + IntToStr(Dmi8.Header.Length));
  end;
  MemoTab8.Add('Internal Reference Designator      : ' +
    SmBiosGetString(Dump, Addr, Dmi8.IntRefDes));
  if Dmi8.IntConnTyp < 255 then
    MemoTab8.Add('Internal Connector Type    : ' + ConnectorTypes
      [Dmi8.IntConnTyp])
  else
    MemoTab8.Add('Internal Connector Type    : Other');
  MemoTab8.Add('External Reference Designator      : ' +
    SmBiosGetString(Dump, Addr, Dmi8.ExtRefDes));
  if Dmi8.ExtConnTyp < 255 then
    MemoTab8.Add('External Connector Type    : ' + ConnectorTypes
      [Dmi8.ExtConnTyp])
  else
    MemoTab8.Add('External Connector Type    : Other');
  if Dmi8.PortType < 255 then
    MemoTab8.Add('Port Type    : ' + PortTypes[Dmi8.PortType])
  else
    MemoTab8.Add('Port Type    : Other');
  MemoTab8.Add('');
end;

end.
