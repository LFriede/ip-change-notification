unit def_NDIS_Interface_Types;

// Checks interface types by the following list (retrieved on 05.01.24)
// https://learn.microsoft.com/en-us/windows-hardware/drivers/network/ndis-interface-types

interface

uses
  System.SysUtils;

function InterfaceTypeToStr(IfType:Cardinal):string;

const
  NDIS_Interface_Types: Array[0..195] Of String = (
    'IF_TYPE_OTHER',                             // 1 (Consts are 1 based!)
    'IF_TYPE_REGULAR_1822',
    'IF_TYPE_HDH_1822',
    'IF_TYPE_DDN_X25',
    'IF_TYPE_RFC877_X25',
    'IF_TYPE_ETHERNET_CSMACD',
    'IF_TYPE_IS088023_CSMACD',
    'IF_TYPE_ISO88024_TOKENBUS',
    'IF_TYPE_ISO88025_TOKENRING',
    'IF_TYPE_ISO88026_MAN',                      // 10
    'IF_TYPE_STARLAN',
    'IF_TYPE_PROTEON_10MBIT',
    'IF_TYPE_PROTEON_80MBIT',
    'IF_TYPE_HYPERCHANNEL',
    'IF_TYPE_FDDI',
    'IF_TYPE_LAP_B',
    'IF_TYPE_SDLC',
    'IF_TYPE_DS1',
    'IF_TYPE_E1',
    'IF_TYPE_BASIC_ISDN',                        // 20
    'IF_TYPE_PRIMARY_ISDN',
    'IF_TYPE_PROP_POINT2POINT_SERIAL',
    'IF_TYPE_PPP',
    'IF_TYPE_SOFTWARE_LOOPBACK',
    'IF_TYPE_EON',
    'IF_TYPE_ETHERNET_3MBIT',
    'IF_TYPE_NSIP',
    'IF_TYPE_SLIP',
    'IF_TYPE_ULTRA',
    'IF_TYPE_DS3',                               // 30
    'IF_TYPE_SIP',
    'IF_TYPE_FRAMERELAY',
    'IF_TYPE_RS232',
    'IF_TYPE_PARA',
    'IF_TYPE_ARCNET',
    'IF_TYPE_ARCNET_PLUS',
    'IF_TYPE_ATM',
    'IF_TYPE_MIO_X25',
    'IF_TYPE_SONET',
    'IF_TYPE_X25_PLE',                           // 40
    'IF_TYPE_ISO88022_LLC',
    'IF_TYPE_LOCALTALK',
    'IF_TYPE_SMDS_DXI',
    'IF_TYPE_FRAMERELAY_SERVICE',
    'IF_TYPE_V35',
    'IF_TYPE_HSSI',
    'IF_TYPE_HIPPI',
    'IF_TYPE_MODEM',
    'IF_TYPE_AAL5',
    'IF_TYPE_SONET_PATH',                        // 50
    'IF_TYPE_SONET_VT',
    'IF_TYPE_SMDS_ICIP',
    'IF_TYPE_PROP_VIRTUAL',
    'IF_TYPE_PROP_MULTIPLEXOR',
    'IF_TYPE_IEEE80212',
    'IF_TYPE_FIBRECHANNEL',
    'IF_TYPE_HIPPIINTERFACE',
    'IF_TYPE_FRAMERELAY_INTERCONNECT',
    'IF_TYPE_AFLANE_8023',
    'IF_TYPE_AFLANE_8025',                       // 60
    'IF_TYPE_CCTEMUL',
    'IF_TYPE_FASTETHER',
    'IF_TYPE_ISDN',
    'IF_TYPE_V11',
    'IF_TYPE_V36',
    'IF_TYPE_G703_64K',
    'IF_TYPE_G703_2MB',
    'IF_TYPE_QLLC',
    'IF_TYPE_FASTETHER_FX',
    'IF_TYPE_CHANNEL',                           // 70
    'IF_TYPE_IEEE80211',
    'IF_TYPE_IBM370PARCHAN',
    'IF_TYPE_ESCON',
    'IF_TYPE_DLSW',
    'IF_TYPE_ISDN_S',
    'IF_TYPE_ISDN_U',
    'IF_TYPE_LAP_D',
    'IF_TYPE_IPSWITCH',
    'IF_TYPE_RSRB',
    'IF_TYPE_ATM_LOGICAL',                       // 80
    'IF_TYPE_DS0',
    'IF_TYPE_DS0_BUNDLE',
    'IF_TYPE_BSC',
    'IF_TYPE_ASYNC',
    'IF_TYPE_CNR',
    'IF_TYPE_ISO88025R_DTR',
    'IF_TYPE_EPLRS',
    'IF_TYPE_ARAP',
    'IF_TYPE_PROP_CNLS',
    'IF_TYPE_HOSTPAD',                           // 90
    'IF_TYPE_TERMPAD',
    'IF_TYPE_FRAMERELAY_MPI',
    'IF_TYPE_X213',
    'IF_TYPE_ADSL',
    'IF_TYPE_RADSL',
    'IF_TYPE_SDSL',
    'IF_TYPE_VDSL',
    'IF_TYPE_ISO88025_CRFPRINT',
    'IF_TYPE_MYRINET',
    'IF_TYPE_VOICE_EM',                          // 100
    'IF_TYPE_VOICE_FXO',
    'IF_TYPE_VOICE_FXS',
    'IF_TYPE_VOICE_ENCAP',
    'IF_TYPE_VOICE_OVERIP',
    'IF_TYPE_ATM_DXI',
    'IF_TYPE_ATM_FUNI',
    'IF_TYPE_ATM_IMA',
    'IF_TYPE_PPPMULTILINKBUNDLE',
    'IF_TYPE_IPOVER_CDLC',
    'IF_TYPE_IPOVER_CLAW',                       // 110
    'IF_TYPE_STACKTOSTACK',
    'IF_TYPE_VIRTUALIPADDRESS',
    'IF_TYPE_MPC',
    'IF_TYPE_IPOVER_ATM',
    'IF_TYPE_ISO88025_FIBER',
    'IF_TYPE_TDLC',
    'IF_TYPE_GIGABITETHERNET',
    'IF_TYPE_HDLC',
    'IF_TYPE_LAP_F',
    'IF_TYPE_V37',                               // 120
    'IF_TYPE_X25_MLP',
    'IF_TYPE_X25_HUNTGROUP',
    'IF_TYPE_TRANSPHDLC',
    'IF_TYPE_INTERLEAVE',
    'IF_TYPE_FAST',
    'IF_TYPE_IP',
    'IF_TYPE_DOCSCABLE_MACLAYER',
    'IF_TYPE_DOCSCABLE_DOWNSTREAM',
    'IF_TYPE_DOCSCABLE_UPSTREAM',
    'IF_TYPE_A12MPPSWITCH',                      // 130
    'IF_TYPE_TUNNEL',
    'IF_TYPE_COFFEE',
    'IF_TYPE_CES',
    'IF_TYPE_ATM_SUBINTERFACE',
    'IF_TYPE_L2_VLAN',
    'IF_TYPE_L3_IPVLAN',
    'IF_TYPE_L3_IPXVLAN',
    'IF_TYPE_DIGITALPOWERLINE',
    'IF_TYPE_MEDIAMAILOVERIP',
    'IF_TYPE_DTM',                               // 140
    'IF_TYPE_DCN',
    'IF_TYPE_IPFORWARD',
    'IF_TYPE_MSDSL',
    'IF_TYPE_IEEE1394',
    'IF_TYPE_IF_GSN',
    'IF_TYPE_DVBRCC_MACLAYER',
    'IF_TYPE_DVBRCC_DOWNSTREAM',
    'IF_TYPE_DVBRCC_UPSTREAM',
    'IF_TYPE_ATM_VIRTUAL',
    'IF_TYPE_MPLS_TUNNEL',                       // 150
    'IF_TYPE_SRP',
    'IF_TYPE_VOICEOVERATM',
    'IF_TYPE_VOICEOVERFRAMERELAY',
    'IF_TYPE_IDSL',
    'IF_TYPE_COMPOSITELINK',
    'IF_TYPE_SS7_SIGLINK',
    'IF_TYPE_PROP_WIRELESS_P2P',
    'IF_TYPE_FR_FORWARD',
    'IF_TYPE_RFC1483',
    'IF_TYPE_USB',                               // 160
    'IF_TYPE_IEEE8023AD_LAG',
    'IF_TYPE_BGP_POLICY_ACCOUNTING',
    'IF_TYPE_FRF16_MFR_BUNDLE',
    'IF_TYPE_H323_GATEKEEPER',
    'IF_TYPE_H323_PROXY',
    'IF_TYPE_MPLS',
    'IF_TYPE_MF_SIGLINK',
    'IF_TYPE_HDSL2',
    'IF_TYPE_SHDSL',
    'IF_TYPE_DS1_FDL',                           // 170
    'IF_TYPE_POS',
    'IF_TYPE_DVB_ASI_IN',
    'IF_TYPE_DVB_ASI_OUT',
    'IF_TYPE_PLC',
    'IF_TYPE_NFAS',
    'IF_TYPE_TR008',
    'IF_TYPE_GR303_RDT',
    'IF_TYPE_GR303_IDT',
    'IF_TYPE_ISUP',
    'IF_TYPE_PROP_DOCS_WIRELESS_MACLAYER',       // 180
    'IF_TYPE_PROP_DOCS_WIRELESS_DOWNSTREAM',
    'IF_TYPE_PROP_DOCS_WIRELESS_UPSTREAM',
    'IF_TYPE_HIPERLAN2',
    'IF_TYPE_PROP_BWA_P2MP',
    'IF_TYPE_SONET_OVERHEAD_CHANNEL',
    'IF_TYPE_DIGITAL_WRAPPER_OVERHEAD_CHANNEL',
    'IF_TYPE_AAL2',
    'IF_TYPE_RADIO_MAC',
    'IF_TYPE_ATM_RADIO',
    'IF_TYPE_IMT',                               // 190
    'IF_TYPE_MVL',
    'IF_TYPE_REACH_DSL',
    'IF_TYPE_FR_DLCI_ENDPT',
    'IF_TYPE_ATM_VCI_ENDPT',
    'IF_TYPE_OPTICAL_CHANNEL',
    'IF_TYPE_OPTICAL_TRANSPORT'
  );

implementation

function InterfaceTypeToStr(IfType:Cardinal):string;
begin
  case IfType of
    1..Length(NDIS_Interface_Types): begin
      Result := NDIS_Interface_Types[IfType - 1];
    end;
    243: begin
      Result := 'IF_TYPE_WWANPP';
    end;
    244: begin
      Result := 'IF_TYPE_WWANPP2';
    end else begin
      Result := 'Unknown, check MSDN!'
    end;
  end;

  Result := Result + ' (' + IntToStr(IfType) + ')';
end;

end.
