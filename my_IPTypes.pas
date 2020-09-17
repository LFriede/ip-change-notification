unit my_IPTypes;

interface

const
  GAA_FLAG_SKIP_UNICAST                = $0001;
  GAA_FLAG_SKIP_ANYCAST                = $0002;
  GAA_FLAG_SKIP_MULTICAST              = $0004;
  GAA_FLAG_SKIP_DNS_SERVER             = $0008;
  GAA_FLAG_INCLUDE_PREFIX              = $0010;
  GAA_FLAG_SKIP_FRIENDLY_NAME          = $0020;
  GAA_FLAG_INCLUDE_WINS_INFO           = $0040;
  GAA_FLAG_INCLUDE_GATEWAYS            = $0080;
  GAA_FLAG_INCLUDE_ALL_INTERFACES      = $0100;
  GAA_FLAG_INCLUDE_ALL_COMPARTMENTS    = $0200;
  GAA_FLAG_INCLUDE_TUNNEL_BINDINGORDER = $0400;

implementation

end.
