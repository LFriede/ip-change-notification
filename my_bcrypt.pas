unit my_bcrypt;

interface

uses
  Windows;

type
  NTSTATUS = Cardinal;
  BCRYPT_ALG_HANDLE = PVOID;

function BCryptGenRandom(hAlgorithm:BCRYPT_ALG_HANDLE; pbBuffer:PUCHAR; cbBuffer:ULONG; dwFlags:ULONG):NTSTATUS; stdcall; external 'bcrypt.dll';

implementation

end.
