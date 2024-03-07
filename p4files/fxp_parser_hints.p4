/**********************************************************
* Copyright(c) 2020 - 2021 Intel Corporation
*
* For licensing information, see the file ‘LICENSE’ in the root folder
***********************************************************/
//=============================================================================
//          WCM PROFILES
//=============================================================================
typedef bit<10> wcm_prof_t;
const wcm_prof_t WCM_PROF_IPV4_L2 = 1;
//=============================================================================
//            FIXED FUNCTION PIDS
//=============================================================================
@intel_config("pid_set_mac", MAC_IN0, MAC_IN1, MAC_IN2,
    "hdrs.mac[0]", "hdrs.mac[1]", "hdrs.mac[2]")
@intel_config("pid_set_etype", ETYPE_IN0, ETYPE_IN1, ETYPE_IN2,
    "hdrs.etype[0]", "hdrs.etype[1]", "hdrs.etype[2]")

@intel_config("pid_set_ipv4", IPV4_IN0, IPV4_IN1, IPV4_IN2,
    "hdrs.ipv4[0]", "hdrs.ipv4[1]", "hdrs.ipv4[2]")

@intel_config("pid_set_ip_nhl",
    IP_NEXT_HDR_LAST_IN0, IP_NEXT_HDR_LAST_IN1, IP_NEXT_HDR_LAST_IN2,
    "hdrs.ipv4[0].protocol", "hdrs.ipv4[1].protocol", "hdrs.ipv4[2].protocol")
@intel_config("pid_set_vlan_int", VLAN_INT_IN0, VLAN_INT_IN1,
                                    VLAN_INT_IN2, "hdrs.vlan_int[0].hdr","hdrs.vlan_int[1].hdr","hdrs.vlan_int[2].hdr")
@intel_config("pid_set_vlan_ext", VLAN_EXT_IN0, VLAN_EXT_IN1,
                                    VLAN_EXT_IN2, "hdrs.vlan_ext[0].hdr", "hdrs.vlan_ext[1].hdr", "hdrs.vlan_ext[2].hdr")

@intel_config("pid_set_udp", UDP_IN0, UDP_IN1, UDP_IN2,
    "hdrs.udp[0]", "hdrs.udp[1]", "hdrs.udp[2]")
@intel_config("pid_tcp", TCP, "hdrs.tcp")

// referencing the pid 200 for outer mac header
@intel_config("pid", 200, "hdrs.outer_mac")
@intel_config("set_proto_next", 0, 200, 200, 200, "Parse_MAC_Done_Depth0")

@intel_config("pid_arp", ARP, "hdrs.arp")

@intel_config("pid_crypto_start", CRYPTO_START)

@intel_config("pid_pay", PAY)

@intel_config("pid_gtp", GTP, "hdrs.gtp.gtp1")
//=============================================================================
//            GENERIC PIDS
//=============================================================================
@intel_config("pid_set", VXLAN_IN0, VXLAN_IN1, VXLAN_IN2,
    "hdrs.vxlan[0]")
@intel_config("pid", VLAN_EXT_IN0, "hdrs.vlan_ext[0].hdr")
@intel_config("pid", VLAN_EXT_IN0, "hdrs.vlan_ext[1].hdr")
@intel_config("pid", VLAN_EXT_IN0, "hdrs.vlan_ext[2].hdr")
//TODO: Use PROTO_INVAL once HSD 22012954355 is resolved
@intel_config("pid", reserved4, "hdrs.inval")

@intel_config("extraction_depth", "hdrs.inval", 0, 0)
@intel_config("extraction_depth", "hdrs.inval", 1, 1)

//=============================================================================
//            MIN_BYTES
//=============================================================================
@intel_config("min_bytes", GTP_MIN_LENGTH, "Parse_GTPU_Depth0") //required by HW
@intel_config("min_bytes", GTP_MIN_LENGTH, "Parse_GTPU_Depth1") //required by HW

//=============================================================================
//            DEPTH
//=============================================================================
@intel_config("depth", 1, "Parse_MAC_Depth1")
@intel_config("depth", 2, "Parse_MAC_Depth2")
@intel_config("depth", 1, "Parse_IPv4_Depth1")
@intel_config("depth", 2, "Parse_IPv4_Depth2")

//=============================================================================
//            MARKERS
//=============================================================================
@intel_config("marker", "MARKER_MAC_D1", "_A")

@intel_config("marker", "MARKER_IPV4_D0", "_C")
@intel_config("marker", "MARKER_IPV4_D1", "_D")
@intel_config("marker", "MARKER_IPV4_D2", "_K")
@intel_config("marker", "MARKER_VLAN_D0", "_V")
@intel_config("marker", "MARKER_TUN_D0", "_I")
@intel_config("marker", "MARKER_TUN_D1", "_B")


//=============================================================================
//            MARKERS - SET
//=============================================================================
@intel_config("set_marker", "MARKER_MAC_D1", "Parse_MAC_Depth1")

@intel_config("set_marker", "MARKER_IPV4_D0", "Parse_IPv4_Depth0")
@intel_config("set_marker", "MARKER_IPV4_D1", "Parse_IPv4_Depth1")
@intel_config("set_marker", "MARKER_IPV4_D2", "Parse_IPv4_Depth2")
@intel_config("set_marker", "MARKER_VLAN_D0", "Parse_CTag_Depth0")

@intel_config("set_marker", "MARKER_TUN_D0", "Parse_VXLAN_Depth0")

@intel_config("set_marker", "MARKER_TUN_D1", "Parse_GTPU_Depth0")
@intel_config("set_marker", "MARKER_TUN_D1", "Parse_GTPU_Depth1")

//=============================================================================
//            NODE ID
//=============================================================================
@intel_config("node_id", "NODE_ARP", "Parse_ARP_PAY")
@intel_config("node_id", "NODE_TCP", "Parse_TCP_Pay")
@intel_config("node_id", "NODE_UDP", "Parse_UDP_PAY")
@intel_config("node_id", "NODE_PAY", "Parse_PAY")
//@intel_config("node_id", "NODE_VLAN", "Parse_CTag_Depth0")

//=============================================================================
//            PTYPES
//=============================================================================
@intel_config("default_ptype", PTYPE_ERROR)

#define DEFAULT_CSUM    \
    L4_IN0_AS_0 | L4_IN1_AS_1 | L4_IN2_AS_2 |   \
    L3_IN0_CSUM_ENABLE | L3_IN1_CSUM_ENABLE | L3_IN2_CSUM_ENABLE

@intel_config("ptype", PTYPE_MAC_PAY,
    "NODE_PAY", DEFAULT_CSUM)
@intel_config("ptype", PTYPE_MAC_ARP,
    "NODE_ARP", DEFAULT_CSUM)
@intel_config("ptype", PTYPE_MAC_VLAN_ARP,
    "MARKER_VLAN_D0", "NODE_ARP", DEFAULT_CSUM)

@intel_config("ptype", PTYPE_MAC_VLAN_EXT_IN0,
    "MARKER_VLAN_D0", "MARKER_IPV4_D0","NODE_PAY", DEFAULT_CSUM)
@intel_config("ptype", PTYPE_MAC_VLAN_EXT_IN0_UDP,
    "MARKER_VLAN_D0", "MARKER_IPV4_D0","NODE_UDP", DEFAULT_CSUM)
@intel_config("ptype", PTYPE_MAC_VLAN_EXT_IN0_TCP,
    "MARKER_VLAN_D0", "MARKER_IPV4_D0","NODE_TCP", DEFAULT_CSUM)

@intel_config("ptype", PTYPE_MAC_IPV4_PAY,
    "MARKER_IPV4_D0", "NODE_PAY", DEFAULT_CSUM)
@intel_config("ptype", PTYPE_MAC_IPV4_UDP,
    "MARKER_IPV4_D0", "NODE_UDP", DEFAULT_CSUM)
@intel_config("ptype", PTYPE_MAC_IPV4_TCP,
    "MARKER_IPV4_D0", "NODE_TCP", DEFAULT_CSUM)


@intel_config("ptype", PTYPE_MAC_IPV4_TUN_MAC_PAY,
    "MARKER_IPV4_D0", "MARKER_TUN_D0", "MARKER_MAC_D1", "NODE_PAY", DEFAULT_CSUM)
@intel_config("ptype", PTYPE_MAC_IPV4_TUN_MAC_ARP,
    "MARKER_IPV4_D0", "MARKER_TUN_D0", "MARKER_MAC_D1", "NODE_ARP", DEFAULT_CSUM)

@intel_config("ptype", PTYPE_MAC_IPV4_TUN_MAC_IPV4_PAY,
    "MARKER_IPV4_D0", "MARKER_TUN_D0", "MARKER_MAC_D1", "MARKER_IPV4_D1", "NODE_PAY", DEFAULT_CSUM)
@intel_config("ptype", PTYPE_MAC_IPV4_TUN_MAC_IPV4_UDP,
    "MARKER_IPV4_D0", "MARKER_TUN_D0", "MARKER_MAC_D1", "MARKER_IPV4_D1", "NODE_UDP", DEFAULT_CSUM)
@intel_config("ptype", PTYPE_MAC_IPV4_TUN_MAC_IPV4_TCP,
    "MARKER_IPV4_D0", "MARKER_TUN_D0", "MARKER_MAC_D1", "MARKER_IPV4_D1", "NODE_TCP", DEFAULT_CSUM)

@intel_config("ptype", PTYPE_MAC_VLAN_IPV4_TUN_MAC_IPV4_PAY,
    "MARKER_VLAN_D0","MARKER_IPV4_D0", "MARKER_TUN_D0", "MARKER_MAC_D1", "MARKER_IPV4_D1", "NODE_PAY", DEFAULT_CSUM)
@intel_config("ptype", PTYPE_MAC_VLAN_IPV4_TUN_MAC_IPV4_UDP,
    "MARKER_VLAN_D0","MARKER_IPV4_D0", "MARKER_TUN_D0", "MARKER_MAC_D1", "MARKER_IPV4_D1", "NODE_UDP", DEFAULT_CSUM)
@intel_config("ptype", PTYPE_MAC_VLAN_IPV4_TUN_MAC_IPV4_TCP,
    "MARKER_VLAN_D0","MARKER_IPV4_D0", "MARKER_TUN_D0", "MARKER_MAC_D1", "MARKER_IPV4_D1", "NODE_TCP", DEFAULT_CSUM)

@intel_config("ptype", PTYPE_MAC_IPV4_TUN_IPV4_PAY,
    "MARKER_IPV4_D0", "MARKER_TUN_D1", "MARKER_IPV4_D1", "NODE_PAY", DEFAULT_CSUM)
@intel_config("ptype", PTYPE_MAC_IPV4_TUN_IPV4_UDP,
    "MARKER_IPV4_D0", "MARKER_TUN_D1", "MARKER_IPV4_D1", "NODE_UDP", DEFAULT_CSUM)
@intel_config("ptype", PTYPE_MAC_IPV4_TUN_IPV4_TCP,
    "MARKER_IPV4_D0", "MARKER_TUN_D1", "MARKER_IPV4_D1", "NODE_TCP", DEFAULT_CSUM)

@intel_config("ptype", PTYPE_MAC_IPV4_TUN_MAC_IPV4_TUN_PAY,
   "MARKER_IPV4_D0", "MARKER_TUN_D0", "MARKER_MAC_D1", "MARKER_IPV4_D1", "MARKER_TUN_D1", "NODE_PAY", DEFAULT_CSUM)

@intel_config("ptype", PTYPE_MAC_IPV4_TUN_PAY,
    "MARKER_IPV4_D0", "MARKER_TUN_D1", "NODE_PAY", DEFAULT_CSUM)
