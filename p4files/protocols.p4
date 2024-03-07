/**********************************************************
* Copyright(c) 2018 - 2021 Intel Corporation
*
* For licensing information, see the file ‘LICENSE’ in the root folder
***********************************************************/

/******************************************************************************
 *
 *   !!!   A T T E N T I O N   !!!
 *
 * Content in this file should depend *only* on wire protocol definitions.
 * Do not add product specific declarations here.
 *
*******************************************************************************/
#ifndef _PROTOCOLS_H_
#define _PROTOCOLS_H_

/*******************************************************************************
  Ethernet header and constants

  Size (bits):  |    48    |    48    |   16   |   16   |   16   |   16   |   16   |
  No VLAN:      |    DA    |    SA    | type_1 |        |        |        |        |
  Single VLAN:  |    DA    |    SA    | 0x8100 |  tci_1 | type_2 |        |        |
  Double VLAN:  |    DA    |    SA    | 0x88A8 |  tci_1 | 0x8100 |  tci_2 | type_3 |

  In the double VLAN case:
  * The first (outer) 802.1Q header is the Service Tag (STAG).
  * The second (inner) 802.1Q header is the Customer Tag (CTAG).

*******************************************************************************/
header eth_t {
    bit<48> da;
    bit<48> sa;
}

header eth_type_t {
    bit<16> type;
}

#define MAC_DMAC_LEN 6
#define MAC_DMAC_OFF 0

header vlan_hdr_t {
    bit<16> type;
    bit<3>  pcp;
    bit<1>  dei;
    bit<12> vid;
}

header vlan_pri_t {
    bit<16> type;
    bit<4>  pri;
    bit<12> vid;
}

header_union vlan_t {
    vlan_hdr_t     hdr; //aligns with VLAN_INx offset, used in downstream blocks
    vlan_pri_t     pri; //used for meter block
}

//TODO: remove these structures once HSD 22011622041 is resolved
//      For now, lookahead ignores extract so need padding
header eth_etype_t {
    bit<96> data;
    bit<16> type;
}

header vlan_etype_t {
    bit<32> data;
    bit<16> type;
}

// Ethernet types defined in https://tools.ietf.org/html/rfc7042, Appendix B
const bit<16> ETYPE_MAC             = 0x6558; // Another MAC
const bit<16> ETYPE_VLAN_CTAG       = 0x8100; // double VALN inner VLAN tag
const bit<16> ETYPE_VLAN_STAG       = 0x88A8; // double VALN outer VLAN tag
const bit<16> ETYPE_VLAN_CTAG9100   = 0x9100; // double VALN inner VLAN tag
const bit<16> ETYPE_IPV4            = 0x0800;
const bit<16> ETYPE_IPV6            = 0x86DD;
const bit<16> ETYPE_MPLSU           = 0x8847; // unicast
const bit<16> ETYPE_MPLSM           = 0x8848; // multicast
const bit<16> ETYPE_PTP             = 0x88F7; // 1588 precision time protocol
const bit<16> ETYPE_ARP             = 0x0806;
const bit<16> ETYPE_LLDP            = 0x88CC;
const bit<16> ETYPE_CONTROL         = 0x8808; // CONTROL

/*******************************************************************************
  MPLS header and constants
  MPLS headers exist in a variable length stack, 32-bits each.
  We currently define max of 2 MPLS labels.

  https://tools.ietf.org/html/rfc3031
  https://tools.ietf.org/html/rfc6658 Ethernet over MPLS
  https://tools.ietf.org/html/rfc4448
  https://tools.ietf.org/html/rfc5462

  Size (bits):  |   20    |  3    |  1    |   8    |   20    |  3    |  1    |   8    |
  1 x MPLS:     | label_1 |  TC_1 | BoS_1 |  TTL_1 |         |       |       |        |
  2 x MPLS:     | label_1 |  TC_1 | BoS_1 |  TTL_1 | label_2 |  TC_2 | BoS_2 |  TTL_2 |

*******************************************************************************/
header mpls_t {
    bit<20> label;
    bit<3>  tc;  // traffic class
    bit<1>  bos; // bottom-of-stack flag
    bit<8>  ttl;
}

header mpls_next {
    bit<24> mpls_hdr;
    //Defined like this so can force compiler to use offset 3 vs 4 when reading ip_ver,
    // so can process MPLS packet with 1 byte payload w/out exception
    bit<12> ip_ver; //[mpls_ttl(8):ip_ver(4)]
}

#define IPV4_VER 0x004 &&& 0x00F
#define IPV6_VER 0x006 &&& 0x00F

/*******************************************************************************
  IP headers and constants
*******************************************************************************/
header ipv4_t {
    bit<4>  version;
    bit<4>  ihl;
    bit<6>  dscp;
    bit<2>  ecn;
    bit<16> length;
    bit<16> identification;
    bit<1>  rsvd;
    bit<1>  df;
    bit<1>  mf;
    bit<13> frag_off;
    bit<8>  ttl;
    bit<8>  protocol;
    bit<16> csum;
    bit<32> src_ip;
    bit<32> dst_ip;
}

header ipv4_opt_t {
    varbit<320> data;
}

#define IPV4_IP_LEN 4
#define IPV4_SIP_OFF 12
#define IPV4_DIP_OFF 16

header ipv6_t {
    bit<4>   version;
    bit<6>   ds;
    bit<2>   ecn;
    bit<20>  flow_label;
    bit<16>  pay_length;
    bit<8>   next_header;
    bit<8>   hop_limit;
    bit<128> src_ip;
    bit<128> dst_ip;
}

#define IPV6_IP_LEN 16
#define IPV6_SIP_OFF 8
#define IPV6_DIP_OFF 24

header ipv6_ext_hdr_t {
    bit<8> next_header;
    bit<8> length;
    bit<48> other;     // remainder of 64-bit extension header
}

header ipv6_ext_t {
    bit<8> next_header;
    bit<8> length;      //length of 'data' in 8-byte chunks (4-byte chunks for AH)
    bit<48> other;      // remainder of 64-bit extension header
    varbit<16320> data; // extension data, max of 255*8 bytes (255*4 for AH)
}

header ipv6_frag_t {
    bit<8>  next_header;
    bit<8>  rsvd1;
    bit<13> frag_off;
    bit<2>  rsvd2;
    bit<1>  m;
    bit<32> id;
}

const bit<8> IP_PROTO_ICMP              = 1;
const bit<8> IP_PROTO_IPV4              = 4;
const bit<8> IP_PROTO_TCP               = 6;
const bit<8> IP_PROTO_UDP               = 17;
const bit<8> IP_PROTO_IPV6              = 41;  // IP-in-IP
const bit<8> IP_PROTO_GRE               = 47;  // All GRE forms
const bit<8> IP_PROTO_ESP               = 50;
const bit<8> IP_PROTO_ICMPV6            = 58;
const bit<8> IP_PROTO_IPV6_NO_NEXT_HDR  = 59;
const bit<8> IP_PROTO_SCTP              = 132;

// IPv6 extension headers.  Each one is 8 bytes long, except ESP.
const bit<8> IP_PROTO_EXT_HOP     = 0;   // Hop-by-hop options
const bit<8> IP_PROTO_EXT_ROUTING = 43;  // Routing
const bit<8> IP_PROTO_EXT_FRAG    = 44;  // Fragment
const bit<8> IP_PROTO_EXT_ESP     = 50;  // Encap Security Protocol
const bit<8> IP_PROTO_EXT_AH      = 51;  // Authentication header
const bit<8> IP_PROTO_EXT_DESTOPT = 60;  // Dest options
const bit<8> IP_PROTO_EXT_MOBL    = 135; // Mobile IPv6
const bit<8> IP_PROTO_EXT_HIPV2   = 139; // Host Identity Protocol v2
const bit<8> IP_PROTO_EXT_SHIM6   = 140; // Site Multi-homing

header ip_proto_t {
    bit<8> next_header;
}

/*******************************************************************************
  ARP (IPv4 Only)
*******************************************************************************/
header arp_t {
    bit<16> htype;
    bit<16> ptype;
    bit<8>  hlen;
    bit<8>  plen;
    bit<16> oper;
    bit<48> sha;
    bit<32> spa;
    bit<48> tha;
    bit<32> tpa;
}

/*******************************************************************************
  ICMP
*******************************************************************************/
header icmp_hdr_t {
    bit<16> type_code;
    bit<16> csum;
    // ICMP Payload follows, but not parsing
}

header icmpv6_hdr_t {
    bit<16> type_code;
    bit<16> csum;
    // ICMPv6 Payload follows, but not parsing
}

header_union icmp_t {
    icmp_hdr_t      v4;
    icmpv6_hdr_t    v6;
}

/*******************************************************************************
  UDP header and constants
*******************************************************************************/
header udp_t {
    bit<16>  sport;
    bit<16>  dport;
    bit<16>  length;
    bit<16>  csum;
}

// These are the IETF assigned UDP ports.  Real deployments
// may use different numbers.
const bit<16> UDP_PORT_VXLAN     = 4789;
const bit<16> UDP_PORT_VXLAN_GPE = 4790;
const bit<16> UDP_PORT_ROCEV2    = 4791;
const bit<16> UDP_PORT_ROCEV2_2  = 1021;
const bit<16> UDP_PORT_GENEVE    = 6081;
const bit<16> UDP_PORT_MPLS      = 6635;

//parser ensures first 12 bytes present for RDMA block
header rocev2_t {
    bit<40> data0;
    bit<24> destination_queue_pair;
    bit<32> data1;
}

/*******************************************************************************
  TCP header and constants
*******************************************************************************/
// fixed length TCP header
header tcp_t {
    bit<16>  sport;
    bit<16>  dport;
    bit<32>  seqno;
    bit<32>  ackno;
    bit<4>   offset;
    bit<6>   reserved;
    bit<1>   urg;
    bit<1>   ack;
    bit<1>   psh;
    bit<1>   rst;
    bit<1>   syn;
    bit<1>   fin;
    bit<16>  window;
    bit<16>  csum;
    bit<16>  urgptr;
}

header tcp_opt_t {
    varbit<320> data;
}

#define TCP_PORT_LEN 2
#define TCP_SPORT_OFF 0
#define TCP_DPORT_OFF 2

/*******************************************************************************
  SCTP header and constants
*******************************************************************************/
header sctp_t {
    bit<16>  sport;
    bit<16>  dport;
    bit<32>  vtag;
    bit<32>  csum;
}

header generic_l4_t {
    bit<16>  sport;
    bit<16>  dport;
}

/*******************************************************************************
  VXLAN header and constants
*******************************************************************************/
header vxlan_t {
    bit<4> reserved_1;
    bit<1> instance; // 1 = valid VNI
    bit<3> reserved_2;
    bit<24> reserved_3;
    bit<24> vni;
    bit<8> reserved_4;
}

/*******************************************************************************
  VXLAN_GPE header and constants
*******************************************************************************/
// https://tools.ietf.org/html/draft-ietf-nvo3-vxlan-gpe-04
header vxlan_gpe_t {
    bit<2> reserved_1;
    bit<2> version;
    bit<1> vni_valid;    // 1 = valid VNI
    bit<1> nextp_valid;  // 1 = valid next proto field
    bit<1> bum;          // broadcast, unicast, multicast
    bit<1> oam;          // 1 = oam packet
    bit<16> reserved_2;
    bit<8> protocol;
    bit<24> vni;
    bit<8> reserved_3;
}

const bit<8> VXLAN_GPE_PROTO_IPv4 = 1;
const bit<8> VXLAN_GPE_PROTO_IPv6 = 2;
const bit<8> VXLAN_GPE_PROTO_MAC  = 3;
const bit<8> VXLAN_GPE_PROTO_MPLS = 5;

/*******************************************************************************
  ESP header and constants
  https://tools.ietf.org/html/rfc4303
*******************************************************************************/
header esp_t {
    bit<32> spi;
    // seqno comes next in clear text, but is don't care
    // everything after seqno is possibly ciphertext.
    bit<224> data;
}

/*******************************************************************************
  GRE header and constants
*******************************************************************************/
// https://tools.ietf.org/html/rfc1701
// https://tools.ietf.org/html/rfc2784
// https://tools.ietf.org/html/rfc2890
//
header gre_t {
    bit<1> csum;
    bit<1> rsvd0;
    bit<1> key;
    bit<1> seqno;
    bit<9> rsvd1;
    bit<3> ver;
    bit<16> protocol;
}

//options supported are csum, key, seqno, in that order
//can be any combination of the three
header gre_hdr_opt_t {
    varbit<96> data;
}
const bit<32> GRE_OPT_LEN_IN_BYTES = 4;

const bit<16> GRE_PROTO_MAC   = ETYPE_MAC; // transparent Eth bridging
const bit<16> GRE_PROTO_IPV4  = ETYPE_IPV4;
const bit<16> GRE_PROTO_IPV6  = ETYPE_IPV6;
const bit<16> GRE_PROTO_MPLSU = ETYPE_MPLSU;
const bit<16> GRE_PROTO_MPLSM = ETYPE_MPLSM;

/*******************************************************************************
  NVGRE header and constants
*******************************************************************************/
// https://tools.ietf.org/html/rfc7637
//
// NVGRE is a specific subset of GRE.  For a GRE frame to be NVGRE,
// all of the following must be true:
// 1) csum_preset = 0
// 2) seqno_preset = 0
// 3) key_preset = 1
// 4) Protocol = ETYPE_MAC (0x6558)
// 5) No VLAN tags allowed after the inner MAC
// The key field contains the NVGRE VSID and Flow ID.
header nvgre_vsid_t {
    bit<24> vsid;
    bit<8> flow_id;
}

header_union gre_opt_t {
    gre_hdr_opt_t   gre_options;
    nvgre_vsid_t    nvgre;
}

/*******************************************************************************
  Geneve header and constants
*******************************************************************************/
// https://tools.ietf.org/html/draft-ietf-nvo3-geneve-13
header geneve_hdr_t {
    bit<2> version;
    bit<6> opt_length;
    bit<1> oam;  // 1 = oam packet
    bit<1> crit; // 1 = critical metadata TLV
    bit<6> reserved_0;
    bit<16> protocol;
    bit<24> vni;
    bit<8> reserved_1;
}

header geneve_t {
    bit<2> version;
    bit<6> opt_length;
    bit<1> oam;
    bit<1> crit;
    bit<6> reserved_0;
    bit<16> protocol;
    bit<24> vni;
    bit<8> reserved_1;
    varbit<2016> data;
}

// By definition, all Geneve protocol numbers are the same as
// Ethernet types.

/*******************************************************************************
  GTP (GPRS) header and constant
*******************************************************************************/
// http://www.3gpp.org/ftp//Specs/archive/29_series/29.060/
header gtp1_hdr_t {
    bit<3> version;
    bit<1> proto_type;
    bit<1> rsvd0;
    bit<1> E; //ext hdr flag
    bit<1> S;
    bit<1> PN;
    bit<8> msg_type;
    bit<16> length;
    bit<32> teid;
}

header gtp1_opt_t {
    bit<16> seqno;
    bit<8> npdu;
    //bit<8> next_hdr; //truncate last byte so ext parsing works
}

//used for lookahead, once compiler bug is added should be able to remove seqno/npdu
header gtp1_pdu_ext_t {
    bit<16> seqno;
    bit<8> npdu;
    bit<8> next_hdr;
    bit<8> ext_len;
    bit<4> pdu_type;
    bit<6> spare;
    bit<6> QFI;
}

header gtp1_ext_hdr_t {
    bit<8> next_hdr;
    bit<8> ext_len;
    //variable contents
}

header gtp1_ext_var_t {
    varbit<8160> data; // extension data, max of 255*4 bytes
}

header gtp1_ext_ip_t {
    bit<8> gtp_next_hdr;
    bit<4> ip_ver;
}

//This is setup to be ext - 8 bytes...includes prev 'next_hdr' but not curr 'next_hdr'
header_union gtp1_ext_t {
    gtp1_ext_hdr_t fixed;
    gtp1_ext_var_t variable;
}

header gtp2_hdr_t {
    bit<3> version;
    bit<1> P;
    bit<1> T;
    bit<3> rsvd0;
    bit<8> msg_type;
    bit<16> length;
}

header gtp2_opt_no_teid_t {
    bit<24> seqno;
    bit<8> rsvd0;
}

header gtp2_opt_teid_t {
    bit<32> teid;
    bit<24> seqno;
    bit<8> rsvd0;
}

header_union gtp_t {
    gtp1_hdr_t gtp1;
    gtp2_hdr_t gtp2;
}

header_union gtp_opt_t {
    gtp1_opt_t gtp1_opt;
    gtp2_opt_no_teid_t gtp2_opt_no_teid;
    gtp2_opt_teid_t gtp2_opt_teid;
}

const bit<16> UDP_PORT_GTPC = 2123;
const bit<16> UDP_PORT_GTPU = 2152;

const bit<8> GTP_EXT_NONE                   = 0x00;
const bit<8> GTP_EXT_LONG_PDCP_PDU_NUM_0    = 0x03;
const bit<8> GTP_EXT_SERVICE_CLASS          = 0x20;
const bit<8> GTP_EXT_UDP_PORT               = 0x40;
const bit<8> GTP_EXT_RAN                    = 0x81;
const bit<8> GTP_EXT_LONG_PDCP_PDU_NUM_1    = 0x82;
const bit<8> GTP_EXT_XW_RAN                 = 0x83;
const bit<8> GTP_EXT_NR_RAN                 = 0x84;
const bit<8> GTP_EXT_PDU_SESSION            = 0x85;
const bit<8> GTP_EXT_PDCP_PDU_NUM           = 0xC0;

#define GTP_MIN_LENGTH 4 //up to and including length field

#endif // _PROTOCOLS_H_
