unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, my_iphlpapi, Winsock, Winapi.IpHlpApi, Winapi.IpRtrMib,
  Vcl.Menus, Vcl.ExtCtrls, Generics.Collections, my_ifdef, Winapi.IpTypes,
  my_IPTypes, ShellAPI, System.ImageList, Vcl.ImgList, Registry,
  System.Notification, Form_Popup, Vcl.ComCtrls, Form_About, config, Form_Config,
  Form_PingGraph, Form_PWGen;

type
  TIPInterface = record
    addr:Array Of DWORD;
    mask:Array Of DWORD;
    dns:Array Of DWORD;
    gateway:DWORD;
    name:string;
    OperStatus:IF_OPER_STATUS;
    DHCP:Boolean;
  end;

  TForm1 = class(TForm)
    TrayIcon1: TTrayIcon;
    pmTrayIcon: TPopupMenu;
    Exit1: TMenuItem;
    NetworkConnections1: TMenuItem;
    imgTrayIcons: TImageList;
    tvInterfaces: TTreeView;
    MainMenu1: TMainMenu;
    Refresh1: TMenuItem;
    Exit2: TMenuItem;
    N1: TMenuItem;
    About1: TMenuItem;
    Menu1: TMenuItem;
    N2: TMenuItem;
    Networkconnections2: TMenuItem;
    Settings1: TMenuItem;
    N3: TMenuItem;
    Settings2: TMenuItem;
    SwissArmyKnive1: TMenuItem;
    menuReleaseRenew: TMenuItem;
    imgTrayMenuIcons: TImageList;
    Connectionproperties1: TMenuItem;
    Pinggraph1: TMenuItem;
    menuPWGen: TMenuItem;
    procedure CheckTrayIcon;
    procedure ConnectionPropertiesOnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure NetworkConnections1Click(Sender: TObject);
    procedure WndProc(var msg:TMessage);override;
    procedure Button1Click(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure ReloadConnectionProperties;
    procedure ReloadTools;
    procedure About1Click(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
    procedure ToolOnClick(Sender: TObject);
    procedure menuReleaseRenewClick(Sender: TObject);
    procedure Pinggraph1Click(Sender: TObject);
    procedure menuPWGenClick(Sender: TObject);
    procedure TrayIcon1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private-Deklarationen }
    IpChangeHandle:THandle;
    CloseMe:Boolean;
    AddressDict:TDictionary<NET_IFINDEX, TIPInterface>;
    procedure FillTreeView;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function BytesToMAC(b:Array Of Byte):string;
var
  I:Integer;
begin
  Result := '';
  for I := 0 to 5 do begin
    Result := Result + IntToHex(b[I], 2);
    if (I <> 5) then Result := Result + ':';
  end;
end;

function InterfaceTypeToStr(IfType:Cardinal):string;
begin
  case IfType of
    1: begin
      Result := 'IF_TYPE_OTHER (';
    end;
    6: begin
      Result := 'IF_TYPE_ETHERNET_CSMACD (';
    end;
    9: begin
      Result := 'IF_TYPE_ISO88025_TOKENRING (';
    end;
    23: begin
      Result := 'IF_TYPE_PPP (';
    end;
    24: begin
      Result := 'IF_TYPE_SOFTWARE_LOOPBACK (';
    end;
    37: begin
      Result := 'IF_TYPE_ATM (';
    end;
    71: begin
      Result := 'IF_TYPE_IEEE80211 (WLAN) (';
    end;
    131: begin
      Result := 'IF_TYPE_TUNNEL (';
    end;
    144: begin
      Result := 'IF_TYPE_IEEE1394 (Firewire) (';
    end else begin
      Result := 'Unknown, check MSDN! ('
    end;
  end;

  Result := Result + IntToStr(IfType) + ')';
end;

function OperStatusToStr(OperStatus:IF_OPER_STATUS):string;
begin
  case OperStatus of
    IfOperStatusUp: begin
      Result := 'IfOperStatusUp (1)';
    end;
    IfOperStatusDown: begin
      Result := 'IfOperStatusDown (2)';
    end;
    IfOperStatusTesting: begin
      Result := 'IfOperStatusTesting (3)';
    end;
    IfOperStatusUnknown: begin
      Result := 'IfOperStatusUnknown (4)';
    end;
    IfOperStatusDormant: begin
      Result := 'IfOperStatusDormant (5)';
    end;
    IfOperStatusNotPresent: begin
      Result := 'IfOperStatusNotPresent (6)';
    end;
    IfOperStatusLowerLayerDown: begin
      Result := 'IfOperStatusLowerLayerDown (7)';
    end else begin
      Result := 'Unknown status (' + IntToStr(Integer(OperStatus)) + '), check MSDN!';
    end;
  end;
end;

procedure FillIPInterfaceInfo(luid:Int64; var info:TIPInterface);
var
  buffer:Array Of Byte;
  size:ULONG;
  c:Cardinal;
  struct:PIP_ADAPTER_ADDRESSES;
  DnsStruct:PIP_ADAPTER_DNS_SERVER_ADDRESS;
const
  flags =
    GAA_FLAG_INCLUDE_GATEWAYS or
    GAA_FLAG_SKIP_UNICAST or
    GAA_FLAG_SKIP_ANYCAST or
    GAA_FLAG_SKIP_MULTICAST
  ;
begin
  info.name := 'Adaptername';

  size := 0;
  c := GetAdaptersAddresses(AF_INET, flags, nil, @buffer[0], @size);
  if (c <> ERROR_BUFFER_OVERFLOW) then Exit;

  SetLength(buffer, size);
  c := GetAdaptersAddresses(AF_INET, flags, nil, @buffer[0], @size);
  if (c <> ERROR_SUCCESS) then Exit;

  struct := @buffer[0];
  while True do begin
    if (struct.Luid.Value = luid) then begin
      info.name := struct.FriendlyName;
      if (struct.FirstGatewayAddress <> nil) then begin
        info.gateway := struct.FirstGatewayAddress.Address.lpSockaddr.sin_addr.S_addr;
      end else info.gateway := 0;
      info.OperStatus := struct.OperStatus;
      info.DHCP := (struct.Flags OR IP_ADAPTER_DHCP_ENABLED) = struct.Flags;

      DnsStruct := struct.FirstDnsServerAddress;
      while (DnsStruct <> nil) do begin
        SetLength(info.dns, Length(info.dns)+1);

        info.dns[Length(info.dns)-1] := DnsStruct^.Address.lpSockaddr.sin_addr.S_addr;

        DnsStruct := DnsStruct.Next;
      end;

      Exit;
    end;

    if (struct.Next = nil) then begin
      break;
    end else begin
      struct := struct.Next;
    end;
  end;
end;

procedure MainThread_IpChangeCallback(CallerContext:PVOID; Row:PMIB_IPINTERFACE_ROW; NotificationType:MIB_NOTIFICATION_TYPE);
var
  table:MIB_IPADDRTABLE;
  c, count:Cardinal;
  buffer:Array Of Byte;
  i:Integer;
  index:NET_IFINDEX;
  changed:Boolean;
  newInterface:TIPInterface;
  masklen:UINT8;
  dhcpText, balloonHint:string;
begin
  index := Row.InterfaceIndex;
  FillIPInterfaceInfo(Row.InterfaceLuid.Value, newInterface);
  changed := False;

  count := 0;
  c := GetIpAddrTable(@table, count, False);
  if (c <> ERROR_INSUFFICIENT_BUFFER) then Exit;

  SetLength(buffer, count);
  c := GetIpAddrTable(@buffer[0], count, False);
  if (c <> NO_ERROR) then Exit;

  for I := 0 to PMIB_IPADDRTABLE(@buffer[0]).dwNumEntries-1 do begin
    if PMIB_IPADDRROW(@buffer[4+SizeOf(MIB_IPADDRROW)*i]).dwIndex = index then begin
      SetLength(newInterface.addr, Length(newInterface.addr)+1);
      SetLength(newInterface.mask, Length(newInterface.mask)+1);

      newInterface.addr[Length(newInterface.addr)-1] := PMIB_IPADDRROW(@buffer[4+SizeOf(MIB_IPADDRROW)*i]).dwAddr;
      newInterface.mask[Length(newInterface.mask)-1] := PMIB_IPADDRROW(@buffer[4+SizeOf(MIB_IPADDRROW)*i]).dwMask;
    end;
  end;

  if (Form1.AddressDict.ContainsKey(index)) then begin
    if (Length(Form1.AddressDict[index].addr) <> Length(newInterface.addr)) then begin
      changed := True;
    end else begin
      for I := 0 to Length(newInterface.addr)-1 do begin
        if (Form1.AddressDict[index].addr[I] <> newInterface.addr[I]) then begin
          changed := True;
          break;
        end;

        if (Form1.AddressDict[index].mask[I] <> newInterface.mask[I]) then begin
          changed := True;
          break;
        end;
      end;
    end;

    Form1.AddressDict.AddOrSetValue(index, newInterface);
  end else begin
    changed := True;

    Form1.AddressDict.AddOrSetValue(index, newInterface);
  end;

  if (changed) then begin
    // Mainform refresh on changed interfaces
    Form1.Refresh1Click(Form1);

    // Check if user want's a popup for this interface, exit if not
    if (globalConfig.TestInterfaceRegex(newInterface.name)) then
      Exit;

    OutputDebugString(PChar('Interface changed: ' + newInterface.name + ' | Status: ' + IntToStr(Integer(newInterface.OperStatus))));
    if (newInterface.OperStatus = IF_OPER_STATUS.IfOperStatusDown) then begin
      PopupForm.Popup(newInterface.name, 'Disconnected');
    end else begin
      if (newInterface.DHCP) then begin
        dhcpText := 'DHCP';
      end else begin
        dhcpText := 'static';
      end;

      balloonHint := 'IPs: (' + dhcpText + ')'#13#10;
      for I := 0 to Length(newInterface.addr)-1 do begin
        ConvertIpv4MaskToLength(newInterface.mask[I], masklen);
        balloonHint := balloonHint + string(inet_ntoa(in_addr(newInterface.addr[I]))) + #9' /' + IntToStr(masklen) + #13#10;
      end;

      balloonHint := balloonHint + #13#10'DNS: '#13#10;
      for I := 0 to Length(newInterface.dns)-1 do begin
        balloonHint := balloonHint + string(inet_ntoa(in_addr(newInterface.dns[I]))) + #13#10;
      end;

      PopupForm.Popup(newInterface.name,
        balloonHint + #13#10 +
        'Gateway:'#13#10 + string(inet_ntoa(in_addr(newInterface.gateway)))
      );
    end;
  end;
end;

procedure IpChangeCallback(CallerContext:PVOID; Row:PMIB_IPINTERFACE_ROW; NotificationType:MIB_NOTIFICATION_TYPE); stdcall;
begin
  // Synchronize should never be called by the main thread, can cause infinite loops.
  if (GetCurrentThreadId = MainThreadID) then exit;

  // This callback is not called by the main thread, we call synchronize to make the main thread do the work.
  // Causes trouble if you don't ;)
  TThread.Synchronize(nil, procedure begin MainThread_IpChangeCallback(CallerContext, Row, NotificationType); end);
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  FormAbout.Show;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Exit;
end;

procedure TForm1.CheckTrayIcon;
var
  reg:TRegistry;
  lightTheme:Boolean;
  icon:TIcon;
  iconIndex:Integer;
begin
  if (LOBYTE(LOWORD(GetVersion)) = 10) then begin // If Win10
    reg := TRegistry.Create;
    try
      reg.RootKey := HKEY_CURRENT_USER;
      reg.OpenKeyReadOnly('Software\Microsoft\Windows\CurrentVersion\Themes\Personalize');
      lightTheme := reg.ReadBool('SystemUsesLightTheme');
      if lightTheme then begin
        iconIndex := 1;
      end else begin
        iconIndex := 0;
      end;
    except
      lightTheme := False;
      iconIndex := 0;
    end;
    reg.Free;
  end else begin
    lightTheme := True;
    iconIndex := 2;      // Colored Win7 style
  end;

  PopupForm.DarkMode := not lightTheme;

  icon := TIcon.Create;
  imgTrayIcons.GetIcon(iconIndex, icon);
  TrayIcon1.Icon := icon;
  icon.Free;
end;

procedure TForm1.ConnectionPropertiesOnClick(Sender: TObject);
var
  item:TMenuItem;
begin
  item := Sender as TMenuItem;

  ShellExecute(
    0,
    nil,
    'rundll32.exe',
    PChar('net_properties.dll,ShowConnectionProperties ' + item.Caption),
    PChar(ExtractFilePath(Application.ExeName)),
    SW_SHOWNORMAL
  );
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  CloseMe := True;
  Close;
end;

procedure TForm1.FillTreeView;
var
  c, count:Cardinal;
  AddrBuffer, IfBuffer:Array Of Byte;
  I:Integer;
  Addresses:PIP_ADAPTER_ADDRESSES;
  node, childNode:TTreeNode;
  dns:PIP_ADAPTER_DNS_SERVER_ADDRESS;
  masklen:Byte;
const
  flags =
    GAA_FLAG_INCLUDE_GATEWAYS or
    GAA_FLAG_SKIP_UNICAST or
    GAA_FLAG_SKIP_ANYCAST or
    GAA_FLAG_SKIP_MULTICAST
  ;
begin
  // Get IP Address Table, iterated later
  count := 0;
  c := GetIpAddrTable(@AddrBuffer[0], count, False);
  if (c <> ERROR_INSUFFICIENT_BUFFER) then Exit;

  SetLength(AddrBuffer, count);
  c := GetIpAddrTable(@AddrBuffer[0], count, False);
  if (c <> NO_ERROR) then Exit;

  // Get Adapters
  count := 0;
  c := GetAdaptersAddresses(AF_INET, flags, nil, @IfBuffer[0], @count);
  if (c <> ERROR_BUFFER_OVERFLOW) then Exit;

  SetLength(IfBuffer, count);
  c := GetAdaptersAddresses(AF_INET, flags, nil, @IfBuffer[0], @count);
  if (c <> ERROR_SUCCESS) then Exit;

  Addresses := @IfBuffer[0];
  while (Addresses <> nil) do begin
    node := tvInterfaces.Items.Add(nil, Addresses.FriendlyName);
    tvInterfaces.Items.AddChild(node, 'Description: ' + Addresses.Description);
    tvInterfaces.Items.AddChild(node, 'MAC Address: ' + BytesToMAC(Addresses.PhysicalAddress));
    tvInterfaces.Items.AddChild(node, 'DHCP enabled: ' + BoolToStr((Addresses.Flags OR IP_ADAPTER_DHCP_ENABLED) = Addresses.Flags, True));

    childNode := tvInterfaces.Items.AddChild(node, 'IPs');
    for I := 0 to PMIB_IPADDRTABLE(@AddrBuffer[0]).dwNumEntries-1 do begin
      if PMIB_IPADDRROW(@AddrBuffer[4+SizeOf(MIB_IPADDRROW)*i]).dwIndex = Addresses.Union.IfIndex then begin
        ConvertIpv4MaskToLength(PMIB_IPADDRROW(@AddrBuffer[4+SizeOf(MIB_IPADDRROW)*i]).dwMask, masklen);
        tvInterfaces.Items.AddChild(childNode,
          'IP: ' + string(inet_ntoa(in_addr(PMIB_IPADDRROW(@AddrBuffer[4+SizeOf(MIB_IPADDRROW)*i]).dwAddr))) +
          ' | Mask: ' + string(inet_ntoa(in_addr(PMIB_IPADDRROW(@AddrBuffer[4+SizeOf(MIB_IPADDRROW)*i]).dwMask))) +
          ' /' + IntToStr(masklen)
        );
      end;
    end;
    if (childNode.HasChildren = False) then childNode.Free;

    if (Addresses.FirstGatewayAddress <> nil) then
      tvInterfaces.Items.AddChild(node, 'Default gateway: ' + inet_ntoa(Addresses.FirstGatewayAddress.Address.lpSockaddr.sin_addr));

    if (Addresses.FirstDnsServerAddress <> nil) then begin
      childNode := tvInterfaces.Items.AddChild(node, 'DNS servers');
      dns := Addresses.FirstDnsServerAddress;
      while (dns <> nil) do begin
        tvInterfaces.Items.AddChild(childNode, string(inet_ntoa(dns.Address.lpSockaddr.sin_addr)));
        dns := dns.Next;
      end;
    end;

    if (Addresses.Dhcpv4Server.lpSockaddr <> nil) then
      tvInterfaces.Items.AddChild(node, 'DHCP server: ' + string(inet_ntoa(Addresses.Dhcpv4Server.lpSockaddr.sin_addr)));

    tvInterfaces.Items.AddChild(node, 'Interface type: ' + InterfaceTypeToStr(Addresses.IfType));
    tvInterfaces.Items.AddChild(node, 'Operational status: ' + OperStatusToStr(Addresses.OperStatus));

    if (Addresses.DnsSuffix <> '') then
      tvInterfaces.Items.AddChild(node, 'DNS suffix: ' + Addresses.DnsSuffix);

    // Only expand "interesting" nodes, filtered by config
    if (globalConfig.TestInterfaceRegex(Addresses.FriendlyName) = False) then
      node.Expand(True);

    Addresses := Addresses.Next;
  end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := CloseMe;
  Hide;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  AddressDict := TDictionary<NET_IFINDEX, TIPInterface>.Create;
  CloseMe := False;

  ReloadTools;
  ReloadConnectionProperties;

  NotifyIpInterfaceChange(AF_INET, @IpChangeCallback, nil, False, IpChangeHandle);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  AddressDict.Free;
end;

procedure TForm1.menuPWGenClick(Sender: TObject);
begin
  PWGenForm.Show;
end;

procedure TForm1.menuReleaseRenewClick(Sender: TObject);
begin
  ShellExecute(0, nil, 'cmd.exe', '/K "ipconfig /release & ipconfig /renew"', nil, SW_SHOWNORMAL);
end;

procedure TForm1.NetworkConnections1Click(Sender: TObject);
begin
  ShellExecute(0, nil, 'ncpa.cpl', nil, nil, SW_SHOWNORMAL);
end;

procedure TForm1.Pinggraph1Click(Sender: TObject);
var
  frm:TPingGraphForm;
begin
  frm := TPingGraphForm.Create(Self);
  frm.Show;
end;

procedure TForm1.Refresh1Click(Sender: TObject);
begin
  tvInterfaces.Items.BeginUpdate;
  tvInterfaces.Items.Clear;
  FillTreeView;
  tvInterfaces.Items.EndUpdate;
end;

procedure TForm1.ReloadConnectionProperties;
var
  c, count:Cardinal;
  IfBuffer:Array Of Byte;
  Addresses:PIP_ADAPTER_ADDRESSES;
  item:TMenuItem;
  visible:Boolean;
const
  flags =
    GAA_FLAG_INCLUDE_GATEWAYS or
    GAA_FLAG_SKIP_UNICAST or
    GAA_FLAG_SKIP_ANYCAST or
    GAA_FLAG_SKIP_MULTICAST
  ;
begin
  // Clear old ConnectionProperties items
  ConnectionProperties1.Clear;
  visible := False;

  count := 0;
  c := GetAdaptersAddresses(AF_INET, flags, nil, @IfBuffer[0], @count);
  if (c <> ERROR_BUFFER_OVERFLOW) then Exit;

  SetLength(IfBuffer, count);
  c := GetAdaptersAddresses(AF_INET, flags, nil, @IfBuffer[0], @count);
  if (c <> ERROR_SUCCESS) then Exit;

  Addresses := @IfBuffer[0];
  while (Addresses <> nil) do begin
    // Add only "interesting" interfaces to the menu
    if (globalConfig.TestInterfaceRegex(Addresses.FriendlyName) = False) then begin
      item := TMenuItem.Create(pmTrayIcon);
      item.Caption := Addresses.FriendlyName;
      item.OnClick := ConnectionPropertiesOnClick;

      ConnectionProperties1.Add(item);
      visible := True;
    end;

    Addresses := Addresses.Next;
  end;

  ConnectionProperties1.Visible := visible;
end;

procedure TForm1.ReloadTools;
var
  item:TMenuItem;
  icon:TIcon;
  I:Integer;
begin
  // Clear old tools items (tag property > 1)
  for I:=SwissArmyKnive1.Count-1 downto 0 do begin
    item := SwissArmyKnive1.Items[I];
    if (item.Tag > 0) then SwissArmyKnive1.Remove(item);
  end;
  imgTrayMenuIcons.Clear;

  // Add Items
  item := TMenuItem.Create(pmTrayIcon);
  item.Caption := '-';
  item.Tag := 1;
  SwissArmyKnive1.Add(item);

  icon := TIcon.Create;

  for I:=0 to globalconfig.InstalledTools.Count-1 do begin
    item := TMenuItem.Create(pmTrayIcon);
    item.Caption := globalconfig.InstalledTools[I].Name;
    item.OnClick := ToolOnClick;
    item.Tag := I+1;

    icon.Handle := globalconfig.InstalledTools[I].Icon;
    imgTrayMenuIcons.AddIcon(icon);
    item.ImageIndex := imgTrayMenuIcons.Count - 1;

    SwissArmyKnive1.Add(item);
  end;

  icon.Free;
end;

procedure TForm1.Settings1Click(Sender: TObject);
begin
  ConfigForm.Show;
end;

procedure TForm1.ToolOnClick(Sender: TObject);
var
  item:TMenuItem;
begin
  item := Sender as TMenuItem;
  ShellExecute(0, nil, PChar(globalConfig.InstalledTools[item.Tag-1].Path), nil, nil, SW_SHOWNORMAL);
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  Show;
end;

procedure TForm1.TrayIcon1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  r:SmallInt;
begin
  r := GetAsyncKeyState(VK_CONTROL);
  if ((r and $8000) = $8000) then begin
    PopupForm.ShowAgain;
  end;
end;

procedure TForm1.WndProc(var msg:TMessage);
begin
  if (msg.Msg = WM_SETTINGCHANGE) then begin
    if (PChar(Pointer(msg.LParam)) = 'ImmersiveColorSet') then begin
      CheckTrayIcon;
    end;
  end;

  inherited WndProc(msg);
end;

end.
