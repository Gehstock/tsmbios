//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable40;
interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, System.Classes;

{$REGION 'Header'}
type
  PDmiType40 = ^TDmiType40;
  TDmiType40 = packed record
    Header: TDmiHeader;
    Entrylength: Byte;
    Handle: Word;
    Offset: Byte;
    Str: Byte; //String
    Value : Byte;//String
  end;
{$ENDREGION}


Procedure DecodeTable40(Dump: TRomBiosDump);

var
  Dmi40: TDmiType40;
  MemoTab40 : TStringList;


implementation

uses umain;

Procedure DecodeTable40(Dump: TRomBiosDump);
begin
if not Assigned(MemoTab40) then
  MemoTab40 := TStringList.Create;
  //
end;

end.
