unit my_ifdef;

interface

uses
  Windows;

type
  NET_IFINDEX = ULONG;
  NET_LUID = record
    case Integer of
      0: (
          Value: ULONG64);
      1: (
          Info: ULONG64);
  end;

implementation

end.
