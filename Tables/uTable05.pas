//Based on BiosInfo by Nico Bendlin
//http://www.bendlins.de/nico/delphi/
//2024 Gehstock

unit uTable05;

interface

uses uCommon, uBiosDump, WinAPI.CommCtrl, System.SysUtils;

{$Region 'Header'}
type
  PDmiType5 = ^TDmiType5;
  TDmiType5 = packed record
    Header: TDmiHeader;
    ErrorDetectingMethod: Byte; //ENUM
    ErrorCorrectingCapability: Byte; //Bit Field
    SupportedInterleave: Byte; //ENUM
    CurrentInterleave: Byte; //ENUM
    MaximumMemoryModuleSize: Byte; //Varies
    SupportedSpeeds: Word; //Bit Field
    SupportedMemoryTypes: Word; //Bit Field
    MemoryModuleVoltage: Byte; //Bit Field
    NumberofAssociatedMemorySlots: Byte; //Varies
    MemoryModuleConfigurationHandles: Byte; //Varies
    EnabledErrorCorrectingCapabilities: Byte; //Bit Field
  end;
{$EndRegion}

var
  Dmi5: TDmiType5;

const
  ErrDetMode5: array [1 .. 8] of String = (
  'Other',
  'Unknown',
  'None',
  '8-bit Parity',
  '32-bit ECC',
  '64-bit ECC',
  '128-bit ECC',
  'CRC');

  MemoryECCField5: array [1 .. 8] of String = (
  'Other',
  'Unknown',
  'None',
  'Single-Bit Error Correcting',
  'Double-Bit Error Correcting',
  'Error Scrubbing',
  'Unknown',
  'Unknown');

  InterleaveSupportField5: array [1 .. 8] of String = (
  'Other',
  'Unknown',
  'One-Way Interleave',
  'Two-Way Interleave',
  'Four-Way Interleave',
  'Eight-Way Interleave',
  'Sixteen-Way Interleave',
  'Thirty two-Way Interleave');

  MemorySpeedsBitField5: array [1 .. 32] of String = (
  'Other',
  'Unknown',
  '70ns',
  '60ns',
  '50ns',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved',
  'Reserved');

implementation

end.

