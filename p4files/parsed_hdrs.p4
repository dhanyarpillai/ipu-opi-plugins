/**********************************************************
* Copyright(c) 2018 - 2021 Intel Corporation
*
* For licensing information, see the file ‘LICENSE’ in the root folder
***********************************************************/
//Used for extracting zeros
header inval_t {
    bit<16> data;
}

//Used for referencing 'PAY' protocol ID
header payload_t {
    bit<16> data;
}

#define MAX_LAYERS 3

struct parsed_headers_t {
    eth_t[MAX_LAYERS]       mac;
    eth_t  outer_mac;
    eth_type_t[MAX_LAYERS]  etype;

    vlan_t[MAX_LAYERS]      vlan_ext;
    vlan_t[MAX_LAYERS]      vlan_int;

    ipv4_t[MAX_LAYERS]      ipv4;
    ipv4_opt_t[MAX_LAYERS]  ipv4_opt;

    udp_t[MAX_LAYERS]       udp;

    vxlan_t[MAX_LAYERS]     vxlan;
    gtp_t                   gtp;
    gtp_opt_t               gtp_opt;
    gtp1_ext_t[2]           gtp_ext;
    tcp_t                   tcp;
    tcp_opt_t               tcp_opt;
    arp_t                   arp;

    ip_proto_t[MAX_LAYERS]  ip_proto; //IP_NEXT_HDR_LAST
    inval_t                 inval;

    payload_t              pay;
}
