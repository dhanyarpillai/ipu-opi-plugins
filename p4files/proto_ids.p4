/**********************************************************
* Copyright(c) 2018 - 2021 Intel Corporation
*
* For licensing information, see the file ‘LICENSE’ in the root folder
***********************************************************/

typedef bit<8> protocol_id_t;
const protocol_id_t PROTO_INVAL = 0xFF;

// MAC in depth N header group
const protocol_id_t MAC_IN0            = 1;
const protocol_id_t MAC_IN1            = 2;
const protocol_id_t MAC_IN2            = 3;

const protocol_id_t reserved4          = 4;
const protocol_id_t reserved5          = 5;
const protocol_id_t reserved6          = 6;
const protocol_id_t reserved7          = 7;
const protocol_id_t reserved8          = 8;

// Effective ETYPE in depth N header group.
// When optional VLAN tags exist, this protocol ID points into the ETYPE
// field of the CTAG.
const protocol_id_t ETYPE_IN0          = 9;
const protocol_id_t ETYPE_IN1          = 10;
const protocol_id_t ETYPE_IN2          = 11;

const protocol_id_t reserved12         = 12;
const protocol_id_t reserved13         = 13;
const protocol_id_t reserved14         = 14;

// Payloads of all types
const protocol_id_t PAY                = 15;

const protocol_id_t VLAN_EXT_IN0       = 16;
const protocol_id_t VLAN_EXT_IN1       = 17;
const protocol_id_t VLAN_EXT_IN2       = 18;
const protocol_id_t VLAN_INT_IN0       = 19;
const protocol_id_t VLAN_INT_IN1       = 20;
const protocol_id_t VLAN_INT_IN2       = 21;

const protocol_id_t reserved22         = 22;
const protocol_id_t reserved23         = 23;
const protocol_id_t reserved24         = 24;
const protocol_id_t reserved25         = 25;
const protocol_id_t reserved26         = 26;

// Top of MPLS Stack in depth N header group.
const protocol_id_t MPLS_TOS_IN0       = 27;
const protocol_id_t MPLS_TOS_IN1       = 28;
const protocol_id_t MPLS_TOS_IN2       = 29;

const protocol_id_t reserved30         = 30;
const protocol_id_t reserved31         = 31;

// IPv4 in depth N header group.
const protocol_id_t IPV4_IN0           = 32;
const protocol_id_t IPV4_IN1           = 33;
const protocol_id_t IPV4_IN2           = 34;

const protocol_id_t reserved35         = 35;

// Effective IPv4 or IPv6 Next Protocol field.
// When optional extensions exist, this protocol
// points to the Next Header field of the last extension.
const protocol_id_t IP_NEXT_HDR_LAST_IN0 = 36;
const protocol_id_t IP_NEXT_HDR_LAST_IN1 = 37;
const protocol_id_t IP_NEXT_HDR_LAST_IN2 = 38;

const protocol_id_t reserved39         = 39;

// IPv6 in depth N header group.
const protocol_id_t IPV6_IN0           = 40;
const protocol_id_t IPV6_IN1           = 41;
const protocol_id_t IPV6_IN2           = 42;

const protocol_id_t reserved43         = 43;
const protocol_id_t reserved44         = 44;
const protocol_id_t reserved45         = 45;
const protocol_id_t reserved46         = 46;

const protocol_id_t IPV6_FRAG          = 47;

const protocol_id_t reserved48         = 48;

const protocol_id_t TCP                = 49;

const protocol_id_t reserved50         = 50;
const protocol_id_t reserved51         = 51;

// UDP in depth N header group.
const protocol_id_t UDP_IN0            = 52;
const protocol_id_t UDP_IN1            = 53;
const protocol_id_t UDP_IN2            = 54;

const protocol_id_t reserved55         = 55;
const protocol_id_t reserved56         = 56;
const protocol_id_t reserved57         = 57;
const protocol_id_t reserved58         = 58;
const protocol_id_t reserved59         = 59;
const protocol_id_t reserved60         = 60;
const protocol_id_t reserved61         = 61;
const protocol_id_t reserved62         = 62;
const protocol_id_t reserved63         = 63;

// A header in the GRE tunnel family, includes NVGRE.
const protocol_id_t GRE_IN1            = 64;
const protocol_id_t GRE_IN2            = 65;

const protocol_id_t reserved66         = 66;
const protocol_id_t reserved67         = 67;
const protocol_id_t reserved68         = 68;
const protocol_id_t reserved69         = 69;
const protocol_id_t reserved70         = 70;
const protocol_id_t reserved71         = 71;
const protocol_id_t reserved72         = 72;
const protocol_id_t reserved73         = 73;
const protocol_id_t reserved74         = 74;
const protocol_id_t reserved75         = 75;
const protocol_id_t reserved76         = 76;
const protocol_id_t reserved77         = 77;
const protocol_id_t reserved78         = 78;
const protocol_id_t reserved79         = 79;
const protocol_id_t reserved80         = 80;
const protocol_id_t reserved81         = 81;
const protocol_id_t reserved82         = 82;
const protocol_id_t reserved83         = 83;
const protocol_id_t reserved84         = 84;
const protocol_id_t reserved85         = 85;
const protocol_id_t reserved86         = 86;
const protocol_id_t reserved87         = 87;
const protocol_id_t reserved88         = 88;
const protocol_id_t reserved89         = 89;
const protocol_id_t reserved90         = 90;
const protocol_id_t reserved91         = 91;
const protocol_id_t reserved92         = 92;
const protocol_id_t reserved93         = 93;
const protocol_id_t reserved94         = 94;
const protocol_id_t reserved95         = 95;

const protocol_id_t SCTP               = 96;

const protocol_id_t reserved97         = 97;

// ICMP differs between V4 and V6
// MNG block requires the ICMPV6 protocol ID.
const protocol_id_t ICMP               = 98;
const protocol_id_t reserved99         = 99;
const protocol_id_t ICMPV6             = 100;

const protocol_id_t reserved101        = 101;
const protocol_id_t reserved102        = 102;
const protocol_id_t reserved103        = 103;
const protocol_id_t reserved104        = 104;
const protocol_id_t reserved105        = 105;
const protocol_id_t reserved106        = 106;
const protocol_id_t reserved107        = 107;
const protocol_id_t reserved108        = 108;
const protocol_id_t reserved109        = 109;
const protocol_id_t reserved110        = 110;
const protocol_id_t reserved111        = 111;
const protocol_id_t reserved112        = 112;
const protocol_id_t reserved113        = 113;
const protocol_id_t reserved114        = 114;
const protocol_id_t reserved115        = 115;

const protocol_id_t CTRL               = 116;
const protocol_id_t LLDP               = 117;
const protocol_id_t ARP                = 118;
const protocol_id_t PTP                = 119;

const protocol_id_t reserved120        = 120;

const protocol_id_t CRYPTO_START       = 121;
const protocol_id_t ROCEV2             = 122;
const protocol_id_t GTP                = 123;

const protocol_id_t L4_IN0             = 124;

const protocol_id_t VXLAN_IN0          = 127;
const protocol_id_t VXLAN_IN1          = 125;
const protocol_id_t VXLAN_IN2          = 126;

//222+ are HW-defined
const protocol_id_t PREPEND_PMD        = 222;
const protocol_id_t PREPEND_ACTION_BUS = 223;

//224+ defined as part of compiler source in idpf-lib/idpf.p4
