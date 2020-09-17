unit my_nldef;

interface

type
  NL_ROUTER_DISCOVERY_BEHAVIOR = (
    RouterDiscoveryDisabled = 0,
    RouterDiscoveryEnabled,
    RouterDiscoveryDhcp,
    RouterDiscoveryUnchanged = -1
  );

  NL_LINK_LOCAL_ADDRESS_BEHAVIOR = (
    LinkLocalAlwaysOff = 0,
    LinkLocalDelayed,
    LinkLocalAlwaysOn,
    LinkLocalUnchanged = -1
  );

implementation

end.
