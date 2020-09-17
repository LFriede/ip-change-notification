unit my_iphlpapi;

interface

uses
  Windows, IdWinsock2, my_ifdef, my_nldef, Winapi.IpTypes;

type
  MIB_NOTIFICATION_TYPE = (
    MibParameterNotification,
    MibAddInstance,
    MibDeleteInstance,
    MibInitialNotification
  );

  MIB_IPINTERFACE_ROW = record
    Family:ADDRESS_FAMILY;
    InterfaceLuid:NET_LUID;
    InterfaceIndex:NET_IFINDEX;
    MaxReassemblySize:ULONG;
    InterfaceIdentifier:ULONG64;
    MinRouterAdvertisementInterval:ULONG;
    MaxRouterAdvertisementInterval:ULONG;
    AdvertisingEnabled:BOOLEAN;
    ForwardingEnabled:BOOLEAN;
    WeakHostSend:BOOLEAN;
    WeakHostReceive:BOOLEAN;
    UseAutomaticMetric:BOOLEAN;
    UseNeighborUnreachabilityDetection:BOOLEAN;
    ManagedAddressConfigurationSupported:BOOLEAN;
    OtherStatefulConfigurationSupported:BOOLEAN;
    AdvertiseDefaultRoute:BOOLEAN;
    RouterDiscoveryBehavior:NL_ROUTER_DISCOVERY_BEHAVIOR;
    DadTransmits:ULONG;
    BaseReachableTime:ULONG;
    RetransmitTime:ULONG;
    PathMtuDiscoveryTimeout:ULONG;
    LinkLocalAddressBehavior:NL_LINK_LOCAL_ADDRESS_BEHAVIOR;
    LinkLocalAddressTimeout:ULONG;
    ZoneIndices:Array[0..15] Of ULONG;
    SitePrefixLength:ULONG;
    Metric:ULONG;
    NlMtu:ULONG;
    Connected:BOOLEAN;
    SupportsWakeUpPatterns:BOOLEAN;
    SupportsNeighborDiscovery:BOOLEAN;
    SupportsRouterDiscovery:BOOLEAN;
    ReachableTime:ULONG;
    TransmitOffload:Byte;           //TransmitOffload:NL_INTERFACE_OFFLOAD_ROD;
    ReceiveOffload:Byte;            //ReceiveOffload:NL_INTERFACE_OFFLOAD_ROD;
    DisableDefaultRoutes:BOOLEAN;
  end;
  PMIB_IPINTERFACE_ROW = ^MIB_IPINTERFACE_ROW;

  PIPINTERFACE_CHANGE_CALLBACK = Pointer;

function ConvertIpv4MaskToLength(Mask:ULONG; var MaskLength:UINT8):Integer; stdcall; external 'Iphlpapi.dll';
function GetIpInterfaceEntry(var Row:MIB_IPINTERFACE_ROW):Integer; stdcall; external 'Iphlpapi.dll';
function NotifyIpInterfaceChange(
  Family:ADDRESS_FAMILY;
  Callback:PIPINTERFACE_CHANGE_CALLBACK;
  CallerContext:PVOID;
  InitialNotification:Boolean;
  var NotificationHandle:THandle
):Integer; stdcall; external 'Iphlpapi.dll';

implementation

end.
