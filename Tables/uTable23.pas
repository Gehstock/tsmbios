//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable23;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils, VCL.Dialogs,
  System.StrUtils, WinAPI.Windows, System.Classes;

  {$REGION 'Header'}
type
  PDmiType23 = ^TDmiType23;
  TDmiType23 = packed record
    Header: TDmiHeader;
    Capabilities: Byte;
    ResetCount: WORD;
    ResetLimit: WORD;
    Timeout: WORD;
  end;
{$ENDREGION}

Procedure DecodeTable23(Dump: TRomBiosDump);
Function Decode23(Inp : String):String;

var
  Dmi23: TDmiType23;
  MemoTab23: TStringList;

implementation

Procedure DecodeTable23(Dump: TRomBiosDump);
begin
  //
end;

Function Decode23(Inp : String):String;
var i : Integer;
begin
  Case i of
  1 : if Inp[1] = '1' then Result := 'system reset is enabled by the user' else
       if Inp[1] = '0' then Result := 'system reset is not enabled by the user';

  End;
end;

end.


//dentifies the system-reset capabilities for the system.
//Bits 7:6 Reserved for future assignment by this
//specification; set to 00b
//Bit 5 System contains a watchdog timer; either True (1)
//or False (0)
//Bits 4:3 Boot Option on Limit. Identifies one of the following
//system actions to be taken when the Reset Limit is
//reached:
//00b Reserved, do not use.
//01b Operating system
//10b System utilities
//11b Do not reboot
//Bits 2:1 Boot Option. Indicates one of the following actions
//to be taken after a watchdog reset:
//00b Reserved, do not use.
//01b Operating system
//10b System utilities
//11b Do not reboot
//Bit 0 Status. Identifies whether (1) or not (0) the system
//reset is enabled by the user.
