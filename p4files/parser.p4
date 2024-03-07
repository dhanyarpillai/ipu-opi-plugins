/**********************************************************
* Copyright(c) 2018 - 2021 Intel Corporation
*
* For licensing information, see the file ‘LICENSE’ in the root folder
***********************************************************/

parser IDPFParser(packet_in pkt,
                  out parsed_headers_t hdrs,
                  inout user_metadata_t user_meta,
                  inout vendor_meta_t  meta,
                  in pna_main_parser_input_metadata_t istd)
{
//#ifdef __TARGET_IDPF_FXP__
    state start {
        bit<16> w0 = pkt.lookahead<eth_t>().da[15:0];
        bit<16> w1 = pkt.lookahead<eth_t>().da[31:16];
        transition select (w0, w1) {
            (0xFFFF, 0xFFFF)       : Parse_MAC_Maybe_BC_Depth0;
            (0x0100 &&& 0x0100, _) : Parse_MAC_MC_Depth0;
                           default : Parse_MAC_Done_Depth0;
        }
    }

    state Parse_MAC_Maybe_BC_Depth0 {
        bit<16> w2 = pkt.lookahead<eth_t>().da[47:32];
        transition select (w2) {
            0xFFFF  : Parse_MAC_BC_Depth0;
            default : Parse_MAC_Done_Depth0;
        }
    }

    state Parse_MAC_BC_Depth0 {
        //meta.fxp_internal.parser_flags =
          //  meta.fxp_internal.parser_flags | 1 << FLAG_BC;
        user_meta.pmeta.pflag_11 = 1;
        pkt.extract(hdrs.mac[0]);
        bit<16> etype = pkt.lookahead<eth_etype_t>().type;
        transition select(etype) {
            ETYPE_VLAN_CTAG     : Parse_CTag_Depth0;
            ETYPE_VLAN_STAG     : Parse_STag_Depth0;
                        default : Parse_ETYPE_Depth0;
        }
    }

    state Parse_MAC_MC_Depth0 {
        //meta.fxp_internal.parser_flags =
          //  meta.fxp_internal.parser_flags | 1 << FLAG_MC;
        user_meta.pmeta.pflag_10 = 1;
        transition Parse_MAC_Done_Depth0;
    }

    state Parse_MAC_Done_Depth0 {
        pkt.extract(hdrs.mac[0]);
        bit<16> etype = pkt.lookahead<eth_etype_t>().type;
        transition select(etype) {
            ETYPE_VLAN_CTAG     : Parse_CTag_Depth0;
            ETYPE_VLAN_STAG     : Parse_STag_Depth0;
                        default : Parse_ETYPE_Depth0;
        }
    }
/*#else //!__TARGET_IDPF_FXP__

    state start {
        pkt.extract(hdrs.mac[0]);
        bit<16> etype = pkt.lookahead<eth_etype_t>().type;
        transition select(etype) {
            ETYPE_VLAN_CTAG     : Parse_CTag_Depth0;
            ETYPE_VLAN_STAG     : Parse_STag_Depth0;
                        default : Parse_ETYPE_Depth0;
        }
    }
#endif*/

    // Could be Single or Double VLAN 0x88A8 + 0x8100
    state Parse_STag_Depth0 {
//#ifdef __TARGET_IDPF_FXP__
        user_meta.pmeta.stag = 1;
//#endif
        pkt.extract(hdrs.vlan_ext[0].hdr);
        bit<16> etype = pkt.lookahead<vlan_etype_t>().type;
        transition select(etype) {
            ETYPE_VLAN_CTAG : Parse_CTag_DoubleVLAN_Depth0;
                    default : Parse_ETYPE_Depth0;
        }
    }

    // Could be Single VLAN or Double VLAN
    state Parse_CTag_Depth0 {
//#ifdef __TARGET_IDPF_FXP__
        user_meta.pmeta.evlan_8100 = 1;
//#endif
        pkt.extract(hdrs.vlan_ext[0].hdr);
        bit<16> etype = pkt.lookahead<vlan_etype_t>().type;
        transition select(etype) {
            ETYPE_VLAN_CTAG : Parse_CTag_DoubleVLAN_Depth0;
                    default : Parse_ETYPE_Depth0;
        }
    }

    // Double VLAN case 0xXXXX + 0x8100
    state Parse_CTag_DoubleVLAN_Depth0 {
//#ifdef __TARGET_IDPF_FXP__
        user_meta.pmeta.vlan = 1;
//#endif
        pkt.extract(hdrs.vlan_int[0].hdr);
        pkt.extract(hdrs.etype[0]);
        transition select(hdrs.etype[0].type) {
            ETYPE_IPV4    : Parse_IPv4_Depth0;
//#ifdef __TARGET_IDPF_FXP__
            ETYPE_ARP     : Parse_ARP;
//#endif
                  default : Parse_PAY;
        }
    }

    state Parse_ETYPE_Depth0 {
        pkt.extract(hdrs.etype[0]);
        transition select(hdrs.etype[0].type) {
            ETYPE_IPV4          : Parse_IPv4_Depth0;
//#ifdef __TARGET_IDPF_FXP__
            ETYPE_ARP           : Parse_ARP;
//#endif
                        default : Parse_PAY;
        }
    }

//#ifdef __TARGET_IDPF_FXP__
    state Parse_ARP {
        pkt.extract(hdrs.arp);
        transition Parse_ARP_PAY;
    }

    state Parse_ARP_PAY {
        transition accept;
    }

    state Parse_Hdr_Too_Short {
        user_meta.pmeta.pflag_2 = 1;
        transition Parse_PAY;
    }
//#endif // __TARGET_IDPF_FXP__

    state Parse_PAY {
        transition accept;
    }

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
//          IPv4 Parsing
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
//#ifdef __TARGET_IDPF_FXP__
    state Parse_IPv4_Depth0 {
        bit<4> ihl = pkt.lookahead<ipv4_t>().ihl;
        transition select (ihl) {
            0x0 &&& 0xC : Parse_Hdr_Too_Short; //0-3
                    0x4 : Parse_Hdr_Too_Short;
                default : Parse_IPv4_Check_Frag_Depth0;
        }
    }

    state Parse_IPv4_Depth1 {
        bit<4> ihl = pkt.lookahead<ipv4_t>().ihl;
        transition select (ihl) {
            0x0 &&& 0xC : Parse_Hdr_Too_Short; //0-3
                    0x4 : Parse_Hdr_Too_Short;
                default : Parse_IPv4_Check_Frag_Depth1;
        }
    }
    state Parse_IPv4_Depth2 {
        bit<4> ihl = pkt.lookahead<ipv4_t>().ihl;
        transition select (ihl) {
            0x0 &&& 0xC : Parse_Hdr_Too_Short; //0-3
                    0x4 : Parse_Hdr_Too_Short;
                default : Parse_IPv4_Check_Frag_Depth2;
        }
    }

    state Parse_IPv4_Check_Frag_Depth0 {
        bit<1> mf = pkt.lookahead<ipv4_t>().mf;
        bit<13> frag_off = pkt.lookahead<ipv4_t>().frag_off;
        transition select(mf, frag_off) {
             (0, 0) : Parse_IPv4_NextProto_Depth0;
             (1, 0) : Parse_IPv4_Frag_Head_Depth0; //first fragment
            default : Parse_IPv4_Frag_Depth0;
        }
    }

    state Parse_IPv4_Check_Frag_Depth1 {
        bit<1> mf = pkt.lookahead<ipv4_t>().mf;
        bit<13> frag_off = pkt.lookahead<ipv4_t>().frag_off;
        transition select(mf, frag_off) {
             (0, 0) : Parse_IPv4_NextProto_Depth1;
             (1, 0) : Parse_IPv4_Frag_Head_Depth1; //first fragment
            default : Parse_IPv4_Frag_Depth1;
        }
    }
    state Parse_IPv4_Check_Frag_Depth2 {
        bit<1> mf = pkt.lookahead<ipv4_t>().mf;
        bit<13> frag_off = pkt.lookahead<ipv4_t>().frag_off;
        transition select(mf, frag_off) {
             (0, 0) : Parse_IPv4_NextProto_Depth2;
             (1, 0) : Parse_IPv4_Frag_Head_Depth2; //first fragment
            default : Parse_IPv4_Frag_Depth2;
        }
    }

/*#else //__TARGET_IDPF_CXP__
    state Parse_IPv4_Depth0 {
        bit<1> mf = pkt.lookahead<ipv4_t>().mf;
        bit<13> frag_off = pkt.lookahead<ipv4_t>().frag_off;
        transition select(mf, frag_off) {
             (0, 0) : Parse_IPv4_NextProto_Depth0;
            default : Parse_PAY;
        }
    }

    state Parse_IPv4_Depth1 {
        bit<1> mf = pkt.lookahead<ipv4_t>().mf;
        bit<13> frag_off = pkt.lookahead<ipv4_t>().frag_off;
        transition select(mf, frag_off) {
             (0, 0) : Parse_IPv4_NextProto_Depth1;
            default : Parse_PAY;
        }
    }
#endif*/

    state Parse_IPv4_NextProto_Depth0 {
        pkt.extract(hdrs.ipv4[0]);
        bit<32> len = (((bit<32>)hdrs.ipv4[0].ihl) << 2) - 20;
        pkt.extract(hdrs.ipv4_opt[0], len << 3);
        transition select(hdrs.ipv4[0].protocol) {
            IP_PROTO_UDP  : Parse_UDP_Depth0;
//#ifdef __TARGET_IDPF_FXP__
            IP_PROTO_TCP  : Parse_TCP;
//#endif
                  default : Parse_PAY;
        }
    }

    state Parse_IPv4_NextProto_Depth1 {
        pkt.extract(hdrs.ipv4[1]);
        bit<32> len = (((bit<32>)hdrs.ipv4[1].ihl) << 2) - 20;
        pkt.extract(hdrs.ipv4_opt[1], len << 3);
        transition select(hdrs.ipv4[1].protocol) {
//#ifdef __TARGET_IDPF_FXP__
            IP_PROTO_UDP  : Parse_UDP_Depth1;
            IP_PROTO_TCP  : Parse_TCP;
//#endif
                       default : Parse_PAY;
        }
    }
    state Parse_IPv4_NextProto_Depth2 {
        pkt.extract(hdrs.ipv4[2]);
        bit<32> len = (((bit<32>)hdrs.ipv4[2].ihl) << 2) - 20;
        pkt.extract(hdrs.ipv4_opt[2], len << 3);
        transition select(hdrs.ipv4[2].protocol) {
//#ifdef __TARGET_IDPF_FXP__
            IP_PROTO_UDP  : Parse_UDP_Depth2;
            IP_PROTO_TCP  : Parse_TCP;
//#endif
                       default : Parse_PAY;
        }
    }

    

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
//          IP Frag and IP + PAY - outer and inner
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
//#ifdef __TARGET_IDPF_FXP__
    state Parse_IPv4_Frag_Head_Depth0 {
        user_meta.pmeta.pflag_9 = 1;
        transition Parse_IPv4_Frag_Depth0;
    }

    state Parse_IPv4_Frag_Head_Depth1 {
        user_meta.pmeta.pflag_8 = 1;
        transition Parse_IPv4_Frag_Depth1;
    }
    state Parse_IPv4_Frag_Head_Depth2 {
        user_meta.pmeta.pflag_8 = 1;
        transition Parse_IPv4_Frag_Depth1;
    }

    state Parse_IPv4_Frag_Depth0 {
        pkt.extract(hdrs.ipv4[0]);
        bit<32> len = (((bit<32>)hdrs.ipv4[0].ihl) << 2) - 20;
        pkt.extract(hdrs.ipv4_opt[0], len << 3);
        transition Parse_IP_Frag;
    }

    state Parse_IPv4_Frag_Depth1 {
        pkt.extract(hdrs.ipv4[1]);
        bit<32> len = (((bit<32>)hdrs.ipv4[1].ihl) << 2) - 20;
        pkt.extract(hdrs.ipv4_opt[1], len << 3);
        transition Parse_IP_Frag;
    }
    state Parse_IPv4_Frag_Depth2 {
        pkt.extract(hdrs.ipv4[2]);
        bit<32> len = (((bit<32>)hdrs.ipv4[2].ihl) << 2) - 20;
        pkt.extract(hdrs.ipv4_opt[2], len << 3);
        transition Parse_IP_Frag;
    }

    state Parse_IP_Frag {
        user_meta.pmeta.pflag_9 = 1;
        transition Parse_PAY;
    }

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
//          Layer 4 Headers ( TCP, SCTP, ICMP) - outer and inner
//          - UDP handled separately
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
    state Parse_TCP {
        user_meta.pmeta.tcp = 1;
        bit<4> offset = pkt.lookahead<tcp_t>().offset;
        bit<1> fin = pkt.lookahead<tcp_t>().fin;
        bit<1> syn = pkt.lookahead<tcp_t>().syn;
        transition select (offset, fin, syn) {
            (0x0 &&& 0xC, _, _) : Parse_Hdr_Too_Short; //0-3
            (0x4, _, _)         : Parse_Hdr_Too_Short;
            (_, 1, 0)           : Parse_TCP_FIN;
            (_, 0, 1)           : Parse_TCP_SYN;
            (_, 1, 1)           : Parse_TCP_FIN_SYN;
                        default : Parse_TCP_No_FIN_SYN;
        }
    }

    state Parse_TCP_FIN {
        user_meta.pmeta.tcp_fin = 1;
        pkt.extract(hdrs.tcp);
        bit<32> len = ((bit<32>)hdrs.tcp.offset << 2) - 20;
        pkt.extract(hdrs.tcp_opt, len << 3);
        transition select (hdrs.tcp.rst, hdrs.tcp.ack,hdrs.tcp.dport) {
             (1, 0, _) : Parse_TCP_RST;
             (0, 1, _) : Parse_TCP_ACK;
             (1, 1, _) : Parse_TCP_RST_ACK;
             (_, _, UDP_PORT_GTPU) : Parse_GTPU_Depth0;
            default : Parse_TCP_Pay;
        }
    }

    state Parse_TCP_SYN {
        user_meta.pmeta.tcp_syn = 1;
        pkt.extract(hdrs.tcp);
        bit<32> len = ((bit<32>)hdrs.tcp.offset << 2) - 20;
        pkt.extract(hdrs.tcp_opt, len << 3);
        transition select (hdrs.tcp.rst, hdrs.tcp.ack,hdrs.tcp.dport) {
             (1, 0, _) : Parse_TCP_RST;
             (0, 1, _) : Parse_TCP_ACK;
             (1, 1, _) : Parse_TCP_RST_ACK;
             (_, _, UDP_PORT_GTPU) : Parse_GTPU_Depth0;
            default : Parse_TCP_Pay;
        }
    }

    state Parse_TCP_FIN_SYN {
        user_meta.pmeta.tcp_fin = 1;
        user_meta.pmeta.tcp_syn = 1;
        pkt.extract(hdrs.tcp);
        bit<32> len = ((bit<32>)hdrs.tcp.offset << 2) - 20;
        pkt.extract(hdrs.tcp_opt, len << 3);
        transition select (hdrs.tcp.rst, hdrs.tcp.ack,hdrs.tcp.dport) {
             (1, 0, _) : Parse_TCP_RST;
             (0, 1, _) : Parse_TCP_ACK;
             (1, 1, _) : Parse_TCP_RST_ACK;
             (_, _, UDP_PORT_GTPU) : Parse_GTPU_Depth0;
            default : Parse_TCP_Pay;
        }
    }

    state Parse_TCP_No_FIN_SYN {
        pkt.extract(hdrs.tcp);
        bit<32> len = ((bit<32>)hdrs.tcp.offset << 2) - 20;
        pkt.extract(hdrs.tcp_opt, len << 3);
        transition select (hdrs.tcp.rst, hdrs.tcp.ack,hdrs.tcp.dport) {
             (1, 0, _) : Parse_TCP_RST;
             (0, 1, _) : Parse_TCP_ACK;
             (1, 1, _) : Parse_TCP_RST_ACK;
             (_, _, UDP_PORT_GTPU) : Parse_GTPU_Depth0;
            default : Parse_TCP_Pay;
        }
    }

    state Parse_TCP_RST {
        user_meta.pmeta.tcp_rst = 1;
        transition Parse_TCP_Pay;
    }

    state Parse_TCP_ACK {
        user_meta.pmeta.tcp_ack = 1;
        transition Parse_TCP_Pay;
    }

    state Parse_TCP_RST_ACK {
        user_meta.pmeta.tcp_rst = 1;
        user_meta.pmeta.tcp_ack = 1;
        transition Parse_TCP_Pay;
    }

    state Parse_TCP_Pay {
        transition accept;
    }
//#endif // __TARGET_IDPF_FXP__

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
//          UDP
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------

    state Parse_UDP_Depth0 {
        pkt.extract(hdrs.udp[0]);
        transition select(hdrs.udp[0].dport) {
            UDP_PORT_VXLAN     : Parse_VXLAN_Depth0;     // Tunnel
            UDP_PORT_GTPU      : Parse_GTPU_Depth0;
            
//#ifdef __TARGET_IDPF_FXP__
                       default : Parse_UDP_PAY;
/*#else
                       default : Parse_PAY;
#endif*/
        }
    }

//#ifdef __TARGET_IDPF_FXP__
    state Parse_UDP_Depth1 {
        pkt.extract(hdrs.udp[1]);
        transition select(hdrs.udp[1].dport) {
            UDP_PORT_GTPU      : Parse_GTPU_Depth1;
        
        default : Parse_UDP_PAY;
    }
    }
    state Parse_UDP_Depth2 {
        pkt.extract(hdrs.udp[2]);
        transition Parse_UDP_PAY;
        
    }

    state Parse_UDP_PAY {
        transition accept;
    }
//#endif // __TARGET_IDPF_FXP__

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
//          UDP Tunnels
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
    state Parse_VXLAN_Depth0 {
//#ifdef __TARGET_IDPF_FXP__
        user_meta.pmeta.tun_flag1_d0 = TUN_FLAG1_VXLAN;
//#endif
        pkt.extract(hdrs.vxlan[0]);
        transition Parse_MAC_Depth1;
    }

    state Parse_GTPU_Depth0 {
	user_meta.pmeta.gtp = 1;
        //user_meta.pmeta.gtp_teid = 1;
        //user_meta.pmeta.tun_flag1_d0 = TUN_FLAG1_GTPU;
        //user_meta.cmeta.tcam_key = TUN_CMETA_FLAG_GTPU;
        pkt.extract(hdrs.gtp.gtp1);
        transition select(hdrs.gtp.gtp1.E, hdrs.gtp.gtp1.S, hdrs.gtp.gtp1.PN, hdrs.gtp.gtp1.msg_type) {
                (0, 0, 0, 0xFF) : Parse_GTPU_Check_IP_Ver_Depth0;
            (0, _, _, 0xFF) : Parse_GTPU_Opt_Keep_Parsing_Depth0;
	    (1, _, _, 0xFF) : Parse_GTPU_Opt_Ext_Depth0;
            (0, _, 1, _)    : Parse_GTPU_Opt_No_Ext_Depth0;
            (0, 1, _, _)    : Parse_GTPU_Opt_No_Ext_Depth0;
            (1, _, _, _)    : Parse_GTPU_Opt_No_Ext_Depth0;
                    //default : Parse_TUN_PAY_Depth1;
                    default : Parse_PAY;
        }

    }
  
     state Parse_GTPU_Opt_No_Ext_Depth0 {
        pkt.extract(hdrs.gtp_opt.gtp1_opt);
        pkt.advance(8); //next_hdr
        //transition Parse_TUN_PAY_Depth1;
        transition Parse_PAY;
    }

    state Parse_GTPU_Opt_Keep_Parsing_Depth0 {
        pkt.extract(hdrs.gtp_opt.gtp1_opt);
        pkt.advance(8); //next_hdr
        transition Parse_GTPU_Check_IP_Ver_Depth0;
    }

    state Parse_GTPU_Check_IP_Ver_Depth0 {
          bit<4> ip_ver = pkt.lookahead<ipv4_t>().version;
          transition select(ip_ver){
                  //4 : Parse_IPv4_Depth1;
              //    6 : Parse_IPv6_Depth1;
            //default : Parse_TUN_PAY_Depth1;
            default : Parse_PAY;
        }
    }

    state Parse_GTPU_Opt_Ext_Depth0 {
        pkt.extract(hdrs.gtp_opt.gtp1_opt);
        bit<8> next_hdr = pkt.lookahead<gtp1_pdu_ext_t>().next_hdr;
        bit<4> pdu_type = pkt.lookahead<gtp1_pdu_ext_t>().pdu_type;
        transition select (next_hdr, pdu_type) {
            (GTP_EXT_NONE, _)                : Parse_GTPU_ExtLast_NextHdr_Depth0;
            (GTP_EXT_LONG_PDCP_PDU_NUM_0, _) : Parse_GTPU_Ext1_Depth0;
            (GTP_EXT_SERVICE_CLASS, _)       : Parse_GTPU_Ext1_Depth0;
            (GTP_EXT_UDP_PORT, _)            : Parse_GTPU_Ext1_Depth0;
            (GTP_EXT_RAN, _)                 : Parse_GTPU_Ext1_Depth0;
            (GTP_EXT_LONG_PDCP_PDU_NUM_1, _) : Parse_GTPU_Ext1_Depth0;
            (GTP_EXT_XW_RAN, _)              : Parse_GTPU_Ext1_Depth0;
            (GTP_EXT_NR_RAN, _)              : Parse_GTPU_Ext1_Depth0;
            (GTP_EXT_PDU_SESSION, 0)         : Parse_GTPU_Ext1_PDU_SESSION_Type0_Depth0;
            (GTP_EXT_PDU_SESSION, 1)         : Parse_GTPU_Ext1_PDU_SESSION_Type1_Depth0;
            (GTP_EXT_PDCP_PDU_NUM, _)        : Parse_GTPU_Ext1_Depth0;
                                     default : Parse_GTPU_Ext_NotRecognized_Depth0;
        }
    }

    state Parse_GTPU_Ext1_PDU_SESSION_Type0_Depth0 {
        user_meta.pmeta.gtp_eh_pdu = 1;
        bit<32> len = (bit<32>)(pkt.lookahead<gtp1_ext_hdr_t>().ext_len) << 2;
        pkt.extract(hdrs.gtp_ext[0].variable, len << 3);
        transition Parse_GTPU_Ext1_NextHdr_Depth0;
    }

    state Parse_GTPU_Ext1_PDU_SESSION_Type1_Depth0 {
        user_meta.pmeta.gtp_eh_pdu = 1;
        user_meta.pmeta.gtp_eh_pdu_link = 1;
        bit<32> len = (bit<32>)(pkt.lookahead<gtp1_ext_hdr_t>().ext_len) << 2;
        pkt.extract(hdrs.gtp_ext[0].variable, len << 3);
        transition Parse_GTPU_Ext1_NextHdr_Depth0;
    }

    state Parse_GTPU_Ext1_Depth0 {
        bit<32> len = (bit<32>)(pkt.lookahead<gtp1_ext_hdr_t>().ext_len) << 2;
        pkt.extract(hdrs.gtp_ext[0].variable, len << 3);
        transition Parse_GTPU_Ext1_NextHdr_Depth0;
    }

    state Parse_GTPU_Ext1_NextHdr_Depth0 {
        bit<8> next_hdr = pkt.lookahead<gtp1_ext_hdr_t>().next_hdr;
        transition select (next_hdr) {
            GTP_EXT_NONE                : Parse_GTPU_ExtLast_NextHdr_Depth0;
            GTP_EXT_LONG_PDCP_PDU_NUM_0 : Parse_GTPU_ExtLast_Depth0;
            GTP_EXT_SERVICE_CLASS       : Parse_GTPU_ExtLast_Depth0;
            GTP_EXT_UDP_PORT            : Parse_GTPU_ExtLast_Depth0;
            GTP_EXT_RAN                 : Parse_GTPU_ExtLast_Depth0;
            GTP_EXT_LONG_PDCP_PDU_NUM_1 : Parse_GTPU_ExtLast_Depth0;
            GTP_EXT_XW_RAN              : Parse_GTPU_ExtLast_Depth0;
            GTP_EXT_NR_RAN              : Parse_GTPU_ExtLast_Depth0;
            GTP_EXT_PDCP_PDU_NUM        : Parse_GTPU_ExtLast_Depth0;
                                default : Parse_GTPU_Ext_NotRecognized_Depth0;
        }
    }

    state Parse_GTPU_ExtLast_Depth0 {
        bit<32> len = (bit<32>)(pkt.lookahead<gtp1_ext_hdr_t>().ext_len) << 2;
        pkt.extract(hdrs.gtp_ext[1].variable, len << 3);
        transition Parse_GTPU_ExtLast_NextHdr_Depth0;
    }

    state Parse_GTPU_ExtLast_NextHdr_Depth0 {
        bit<8> gtp_next_hdr = pkt.lookahead<gtp1_ext_ip_t>().gtp_next_hdr;
        pkt.advance(8); //move past nxt_hdr
        bit<4> ip_ver = pkt.lookahead<gtp1_ext_ip_t>().ip_ver;
        transition select (gtp_next_hdr, ip_ver) {
            //(GTP_EXT_NONE, 4) : Parse_IPv4_Depth1;
//            (GTP_EXT_NONE, 6) : Parse_IPv6_Depth1;
                      //default : Parse_TUN_PAY_Depth1;
                      default : Parse_PAY;
        }
    }

    state Parse_GTPU_Ext_NotRecognized_Depth0 {
        pkt.advance(8); //next_hdr
        //transition Parse_TUN_PAY_Depth1;
        transition Parse_PAY;
    }
state Parse_GTPU_Depth1 {
	//after_gtp = 1;
    user_meta.pmeta.gtp = 1;
        //user_meta.pmeta.gtp_teid = 1;
        //user_meta.pmeta.tun_flag1_d0 = TUN_FLAG1_GTPU;
        //user_meta.cmeta.tcam_key = TUN_CMETA_FLAG_GTPU;
        pkt.extract(hdrs.gtp.gtp1);
        transition select(hdrs.gtp.gtp1.E, hdrs.gtp.gtp1.S, hdrs.gtp.gtp1.PN, hdrs.gtp.gtp1.msg_type) {
            (0, 0, 0, 0xFF) : Parse_GTPU_Check_IP_Ver_Depth1;
            (0, _, _, 0xFF) : Parse_GTPU_Opt_Keep_Parsing_Depth1;
	    (1, _, _, 0xFF) : Parse_GTPU_Opt_Ext_Depth1;
            (0, _, 1, _)    : Parse_GTPU_Opt_No_Ext_Depth0;
            (0, 1, _, _)    : Parse_GTPU_Opt_No_Ext_Depth0;
            (1, _, _, _)    : Parse_GTPU_Opt_No_Ext_Depth0;
                    //default : Parse_TUN_PAY_Depth1;
                    default : Parse_PAY;
        }

    }
  
     
    state Parse_GTPU_Opt_Keep_Parsing_Depth1 {
        pkt.extract(hdrs.gtp_opt.gtp1_opt);
        pkt.advance(8); //next_hdr
        transition Parse_GTPU_Check_IP_Ver_Depth1;
    }

    state Parse_GTPU_Check_IP_Ver_Depth1 {
          bit<4> ip_ver = pkt.lookahead<ipv4_t>().version;
          transition select(ip_ver){
                  //4 : Parse_IPv4_Depth2;
              //    6 : Parse_IPv6_Depth1;
            //default : Parse_TUN_PAY_Depth1;
            default : Parse_PAY;
        }
    }

    state Parse_GTPU_Opt_Ext_Depth1 {
        pkt.extract(hdrs.gtp_opt.gtp1_opt);
        bit<8> next_hdr = pkt.lookahead<gtp1_pdu_ext_t>().next_hdr;
        bit<4> pdu_type = pkt.lookahead<gtp1_pdu_ext_t>().pdu_type;
        transition select (next_hdr, pdu_type) {
            (GTP_EXT_NONE, _)                : Parse_GTPU_ExtLast_NextHdr_Depth1;
            (GTP_EXT_LONG_PDCP_PDU_NUM_0, _) : Parse_GTPU_Ext1_Depth1;
            (GTP_EXT_SERVICE_CLASS, _)       : Parse_GTPU_Ext1_Depth1;
            (GTP_EXT_UDP_PORT, _)            : Parse_GTPU_Ext1_Depth1;
            (GTP_EXT_RAN, _)                 : Parse_GTPU_Ext1_Depth1;
            (GTP_EXT_LONG_PDCP_PDU_NUM_1, _) : Parse_GTPU_Ext1_Depth1;
            (GTP_EXT_XW_RAN, _)              : Parse_GTPU_Ext1_Depth1;
            (GTP_EXT_NR_RAN, _)              : Parse_GTPU_Ext1_Depth1;
            (GTP_EXT_PDU_SESSION, 0)         : Parse_GTPU_Ext1_PDU_SESSION_Type0_Depth1;
            (GTP_EXT_PDU_SESSION, 1)         : Parse_GTPU_Ext1_PDU_SESSION_Type1_Depth1;
            (GTP_EXT_PDCP_PDU_NUM, _)        : Parse_GTPU_Ext1_Depth1;
                                     default : Parse_GTPU_Ext_NotRecognized_Depth0;
        }
    }

    state Parse_GTPU_Ext1_PDU_SESSION_Type0_Depth1 {
        //user_meta.gtp_eh_pdu = 1;
        bit<32> len = (bit<32>)(pkt.lookahead<gtp1_ext_hdr_t>().ext_len) << 2;
        pkt.extract(hdrs.gtp_ext[0].variable, len << 3);
        transition Parse_GTPU_Ext1_NextHdr_Depth1;
    }

    state Parse_GTPU_Ext1_PDU_SESSION_Type1_Depth1 {
        //user_meta.gtp_eh_pdu = 1;
        //user_meta.gtp_eh_pdu_link = 1;
        bit<32> len = (bit<32>)(pkt.lookahead<gtp1_ext_hdr_t>().ext_len) << 2;
        pkt.extract(hdrs.gtp_ext[0].variable, len << 3);
        transition Parse_GTPU_Ext1_NextHdr_Depth1;
    }

    state Parse_GTPU_Ext1_Depth1 {
        bit<32> len = (bit<32>)(pkt.lookahead<gtp1_ext_hdr_t>().ext_len) << 2;
        pkt.extract(hdrs.gtp_ext[0].variable, len << 3);
        transition Parse_GTPU_Ext1_NextHdr_Depth1;
    }

    state Parse_GTPU_Ext1_NextHdr_Depth1 {
        bit<8> next_hdr = pkt.lookahead<gtp1_ext_hdr_t>().next_hdr;
        transition select (next_hdr) {
            GTP_EXT_NONE                : Parse_GTPU_ExtLast_NextHdr_Depth1;
            GTP_EXT_LONG_PDCP_PDU_NUM_0 : Parse_GTPU_ExtLast_Depth1;
            GTP_EXT_SERVICE_CLASS       : Parse_GTPU_ExtLast_Depth1;
            GTP_EXT_UDP_PORT            : Parse_GTPU_ExtLast_Depth1;
            GTP_EXT_RAN                 : Parse_GTPU_ExtLast_Depth1;
            GTP_EXT_LONG_PDCP_PDU_NUM_1 : Parse_GTPU_ExtLast_Depth1;
            GTP_EXT_XW_RAN              : Parse_GTPU_ExtLast_Depth1;
            GTP_EXT_NR_RAN              : Parse_GTPU_ExtLast_Depth1;
            GTP_EXT_PDCP_PDU_NUM        : Parse_GTPU_ExtLast_Depth1;
                                default : Parse_GTPU_Ext_NotRecognized_Depth0;
        }
    }

    state Parse_GTPU_ExtLast_Depth1 {
        bit<32> len = (bit<32>)(pkt.lookahead<gtp1_ext_hdr_t>().ext_len) << 2;
        pkt.extract(hdrs.gtp_ext[1].variable, len << 3);
        transition Parse_GTPU_ExtLast_NextHdr_Depth1;
    }

    state Parse_GTPU_ExtLast_NextHdr_Depth1 {
        bit<8> gtp_next_hdr = pkt.lookahead<gtp1_ext_ip_t>().gtp_next_hdr;
        pkt.advance(8); //move past nxt_hdr
        bit<4> ip_ver = pkt.lookahead<gtp1_ext_ip_t>().ip_ver;
        transition select (gtp_next_hdr, ip_ver) {
            //(GTP_EXT_NONE, 4) : Parse_IPv4_Depth2;
//            (GTP_EXT_NONE, 6) : Parse_IPv6_Depth1;
                      //default : Parse_TUN_PAY_Depth1;
                      default : Parse_PAY;
        }
    }


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
//          INNER MAC and INNER MAC + VLAN
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
    state Parse_MAC_Depth1 {
        pkt.extract(hdrs.mac[1]);
        bit<16> etype = pkt.lookahead<eth_etype_t>().type;
        transition select(etype) {
                        default : Parse_ETYPE_Depth1;
        }
    }

    state Parse_ETYPE_Depth1 {
        pkt.extract(hdrs.etype[1]);
        transition select(hdrs.etype[1].type) {
            ETYPE_IPV4          : Parse_IPv4_Depth1;
//#ifdef __TARGET_IDPF_FXP__
            ETYPE_ARP           : Parse_ARP;
//#endif
                        default : Parse_PAY;
        }
    }
    state Parse_MAC_Depth2 {
        pkt.extract(hdrs.mac[2]);
        bit<16> etype = pkt.lookahead<eth_etype_t>().type;
        transition select(etype) {
                        default : Parse_ETYPE_Depth2;
        }
    }

    state Parse_ETYPE_Depth2 {
        pkt.extract(hdrs.etype[2]);
        transition select(hdrs.etype[2].type) {
            ETYPE_IPV4          : Parse_IPv4_Depth2;
//#ifdef __TARGET_IDPF_FXP__
            ETYPE_ARP           : Parse_ARP;
//#endif
                        default : Parse_PAY;
        }
    }
}
