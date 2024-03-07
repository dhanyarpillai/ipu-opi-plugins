/**********************************************************
* Copyright(c) 2020 - 2021 Intel Corporation
*
* For licensing information, see the file ‘LICENSE’ in the root folder
***********************************************************/
//#ifdef __TARGET_IDPF_FXP__

typedef bit<24> tunnel_id_t;
typedef bit<24> vni_id_t;
typedef bit<8> vrf_id_t;
typedef bit<16> router_interface_id_t;
typedef bit<20> neighbor_id_t;
//typedef bit<32> ipv4_addr_t;
//typedef bit<48> ethernet_addr_t;
struct parser_meta_t {

    @intel_pflag(2) bit<1> pflag_2;
    @intel_pflag(8) bit<1> pflag_8;
    @intel_pflag(9) bit<1> pflag_9;
    @intel_pflag(10) bit<1> pflag_10;
    @intel_pflag(11) bit<1> pflag_11;
    //tunnel_id_t tunnel_id;

    //bits 14-15
    bit<1> pkt_is_roce;
    bit<1> rsvd15;

    //bits 16-23
    bit<1> stag;
    bit<1> evlan_8100;
    bit<1> evlan_9100;
    bit<1> vlan;
    bit<1> vlan_d1;
    bit<1> vlan_d2;
    bit<1> ipv6_no_next_hdr;
    //bit<1> gtp_teid; //set if TEID is present in GTP pkt
    bit<1> tcp;

    //bits 24-31
    bit<1> tcp_fin;
    bit<1> tcp_rst;
    bit<1> tcp_syn;
    bit<1> tcp_ack;
    bit<1> gtp_eh_pdu; //set when pkt contains ext 0x85
    bit<1> gtp_eh_pdu_link; //equal to PDU type
    bit<1> gtp; //set if GTP hdr is present in pkt
    bit<1> rsvd31;

    //bits 32-39
    bit<2> tun_flag1_d0; //uses TUN_FLAG1_* definitions
    bit<1> gre_d0;
    bit<2> tun_flag1_d1; //uses TUN_FLAG1_* definitions
    bit<1> gre_d1;
    bit<1> oam_d0;
    bit<1> oam_d1;

    //bits 40-47
    bit<1> mplsu_d0;
    bit<1> mplsm_d0;
    //bit<1> mplsu_d1;
    //bit<1> mplsm_d1;
    //bit<1> mpls_multiple_present_d1;
    //bit<1> mplsu_d2;
    //bit<1> mplsm_d2;
}

struct control_meta_t {
    bit<16> hash;
/*    bit<1>  admit_to_l3;
    bit<11> rif_mod_map_id;
    bit<16> ecmp_group_id;
    bit<16> nexthop_id;
    bit<1>  is_tunnel;
    bit<1>  ecmp_group_id_valid;
    bit<1>  nexthop_id_valid;
    bit<32> ipv4_dst_match;*/
    bit<32> bit32_zeros;

    //bits 48-55
    bit<1> mpls_multiple_present_d2;
    bit<7> rsvd49;

    //bits 56-63
    bit<1> do_add_on_miss;
    bit<1> update_aging_info;
    bit<1> update_expire_time;
    bit<2> rsvd56;
    bit<16> vrf_id;
    bit<16> nexthop;
    bit<1> routing;
    bit<1> l2;
    bit<1> p2p;
    bit<8> dummy;
    bit<32> tcam_prefix;
    bit<1> send_to_port_mux;
    bit<16> vlan_id;
    //bit<1> reserved4_0;
    //bit<1> reserved4_1;
    bit<1> wcm_link;
}

/*struct control_meta_t {
    bit<32> bit32_zeros;
    bit<16> vrf_id;
    bit<16> nexthop;
    bit<1> routing;
    bit<1> l2;
    bit<8> dummy;
    bit<1> send_to_port_mux;
    bit<16> vlan_id;
}*/
struct user_metadata_t {
    parser_meta_t pmeta;
    control_meta_t cmeta;
}

const bit<2> TUN_FLAG1_GENEVE = 0b01;
const bit<2> TUN_FLAG1_VXLAN = 0b10;
const bit<2> TUN_FLAG1_VXLAN_GPE = 0b11;
const bit<2> TUN_FLAG1_GRE_K = 0b01;
const bit<2> TUN_FLAG1_GRE_C = 0b10;
const bit<2> TUN_FLAG1_GRE_KC = 0b11;

//used when setting HW-defined parser flags (bits 0-13)
#define FLAG_HEADER_TRUNCATED   2

#define FLAG_CHECKSUM_VALIDATION_DISABLE_OUT0 5
#define FLAG_CHECKSUM_VALIDATION_DISABLE_OUT1 6
#define FLAG_CHECKSUM_VALIDATION_DISABLE_OUT2 7

#define FLAG_IN0_HEAD_FRAG_V    8
#define FLAG_IN0_PAYLOAD_FRAG_V 9
#define FLAG_MC                 10
#define FLAG_BC                 11

//#else //!__TARGET_IDPF_FXP

//struct user_metadata_t {}

//#endif
