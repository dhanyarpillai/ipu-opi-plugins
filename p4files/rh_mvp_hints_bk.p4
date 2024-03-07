/**********************************************************
* Copyright(c) 2018 - 2021 Intel Corporation
*
* For licensing information, see the file ‘LICENSE’ in the root folder
***********************************************************/
#define ACT_MISS_DBG_PORT 0x24020009
//=============================================================================
//            PTYPE GROUPS
//=============================================================================
@intel_config("sem_ptype_group", PTYPE_ERROR, PTYPE_ERROR)
@intel_config("sem_ptype_group", PTYPE_MAC_PAY, PTYPE_MAC_PAY)
@intel_config("sem_ptype_group", PTYPE_MAC_ARP, PTYPE_MAC_ARP)
@intel_config("sem_ptype_group", PTYPE_MAC_VLAN_ARP, PTYPE_MAC_VLAN_ARP)
@intel_config("sem_ptype_group", PTYPE_MAC_VLAN_EXT_IN0, PTYPE_MAC_VLAN_EXT_IN0)
@intel_config("sem_ptype_group", PTYPE_MAC_VLAN_EXT_IN0_UDP, PTYPE_MAC_VLAN_EXT_IN0_UDP)
@intel_config("sem_ptype_group", PTYPE_MAC_VLAN_EXT_IN0_TCP, PTYPE_MAC_VLAN_EXT_IN0_TCP)
@intel_config("sem_ptype_group", PTYPE_MAC_IPV4_PAY, PTYPE_MAC_IPV4_PAY)
@intel_config("sem_ptype_group", PTYPE_MAC_IPV4_UDP, PTYPE_MAC_IPV4_UDP)
@intel_config("sem_ptype_group", PTYPE_MAC_IPV4_TCP, PTYPE_MAC_IPV4_TCP)
@intel_config("sem_ptype_group", PTYPE_MAC_IPV4_TUN_MAC_PAY, PTYPE_MAC_IPV4_TUN_MAC_PAY)
@intel_config("sem_ptype_group", PTYPE_MAC_IPV4_TUN_MAC_ARP, PTYPE_MAC_IPV4_TUN_MAC_ARP)
@intel_config("sem_ptype_group", PTYPE_MAC_IPV4_TUN_MAC_IPV4_PAY, PTYPE_MAC_IPV4_TUN_MAC_IPV4_PAY)
@intel_config("sem_ptype_group", PTYPE_MAC_IPV4_TUN_MAC_IPV4_UDP, PTYPE_MAC_IPV4_TUN_MAC_IPV4_UDP)
@intel_config("sem_ptype_group", PTYPE_MAC_IPV4_TUN_MAC_IPV4_TCP, PTYPE_MAC_IPV4_TUN_MAC_IPV4_TCP)

@intel_config("sem_ptype_group", PTYPE_MAC_VLAN_IPV4_TUN_MAC_IPV4_PAY, PTYPE_MAC_VLAN_IPV4_TUN_MAC_IPV4_PAY)
@intel_config("sem_ptype_group", PTYPE_MAC_VLAN_IPV4_TUN_MAC_IPV4_UDP, PTYPE_MAC_VLAN_IPV4_TUN_MAC_IPV4_UDP)
@intel_config("sem_ptype_group", PTYPE_MAC_VLAN_IPV4_TUN_MAC_IPV4_TCP, PTYPE_MAC_VLAN_IPV4_TUN_MAC_IPV4_TCP)

@intel_config("sem_ptype_group", PTYPE_MAC_IPV4_TUN_IPV4_PAY, PTYPE_MAC_IPV4_TUN_IPV4_PAY)
@intel_config("sem_ptype_group", PTYPE_MAC_IPV4_TUN_IPV4_UDP, PTYPE_MAC_IPV4_TUN_IPV4_UDP)
@intel_config("sem_ptype_group", PTYPE_MAC_IPV4_TUN_IPV4_TCP, PTYPE_MAC_IPV4_TUN_IPV4_TCP)

@intel_config("sem_ptype_group", PTYPE_MAC_IPV4_TUN_MAC_IPV4_TUN_PAY, PTYPE_MAC_IPV4_TUN_MAC_IPV4_TUN_PAY)

@intel_config("sem_ptype_group", PTYPE_MAC_IPV4_TUN_PAY, PTYPE_MAC_IPV4_TUN_PAY)

//=============================================================================
//            MD DIGEST
//=============================================================================
@intel_config("sem_digest_tx", 0, "istd.direction")
@intel_config("sem_digest_tx", 1, "istd.loopedback")
@intel_config("sem_digest_tx", 2, "istd.pass[0:0]")
@intel_config("sem_digest_tx", 3, "istd.pass[1:1]")
@intel_config("sem_digest_tx", 4, "user_meta.pmeta.evlan_8100")
@intel_config("sem_digest_tx", 5, "user_meta.cmeta.routing")
@intel_config("sem_digest_tx", 6, "user_meta.pmeta.stag")
@intel_config("sem_digest_tx", 7, "user_meta.pmeta.pflag_10")
@intel_config("sem_digest_tx", 8, "user_meta.pmeta.pflag_11")
@intel_config("sem_digest_rx", 0, "istd.direction")
@intel_config("sem_digest_rx", 1, "istd.loopedback")
@intel_config("sem_digest_rx", 2, "istd.pass[0:0]")
@intel_config("sem_digest_rx", 3, "istd.pass[1:1]")
@intel_config("sem_digest_rx", 4, "user_meta.pmeta.evlan_8100")
@intel_config("sem_digest_rx", 5, "user_meta.cmeta.routing")
@intel_config("sem_digest_rx", 6, "user_meta.pmeta.stag")
@intel_config("sem_digest_rx", 7, "user_meta.pmeta.pflag_10")
@intel_config("sem_digest_rx", 8, "user_meta.pmeta.pflag_11")

//=============================================================================
//            OWNERSHIP
//=============================================================================
@intel_config("owner", "SEM_PROFILE_CFG", 0, 1023)
@intel_config("owner", "SEM_PROFILE", 12, 250)
@intel_config("owner", "SEM_OBJECT_CACHE_CFG", 0, 5)
@intel_config("owner", "SEM_CACHE_BANK", 0, 5)

//=============================================================================
//            OBJECT CONFIGURATION
//=============================================================================
#define SEM_OBJ_0 0
#define SEM_OBJ_1 1
#define SEM_OBJ_2 2
#define SEM_OBJ_3 3

@intel_config("sem_objcache", SEM_OBJ_0, 0, 64, 0, 2)
@intel_config("sem_objcache", SEM_OBJ_1, 0x1050000, 64, 2, 2)
@intel_config("sem_objcache", SEM_OBJ_2, 0x20A0000, 64, 4, 2)

//base 1 = base_0 + size of HASH (128B * (1024 + 256 * 5))
//base 1 = base_0 + size of HASH (64B * (262144 + 1024 * 5))
//96B entry size still uses 128B of memory for alignment

//=============================================================================
//            ACTION DEFINES
//=============================================================================
//SET10_1b {PREC=1, INDEX=0, ENABLE=VALUE=0x1}
#define ACT_DROP 0x21000401

//SET10_1b {PREC=1, INDEX=0, ENABLE=0b00_0111_0000 VALUE=0b00_0100_0000}
#define ACT_RECIRC 0x2101C040

//SET1_16b {prec=2, indexa2, value=0b0000_0000_0000_1001}
#define ACT_MISS 0x24020009

//SET1B_24 [prec=2, index=0, value={type-id=4, offset=6, mask=4, value=4}]
#define ACT_MD0 0x48460404

#define ACT_DEFAULTVSI 0xE402000a

#define ACT_TCAM_BASE 0xE8654312
#define ACT_TCAM_AUX 0x20440E78
#define ACT_P2P_Flag 0xE94C0404
#define ACT_ROUTING_FLAG 0xE94C0101

#define ACT_DEFAULTVSI_PREC6 0xC4020009

#define ACT_TCAM_BASE_PREC6 0xC8654312
#define ACT_TCAM_AUX_PREC6 0x20440E78
#define ACT_P2P_Flag_PREC6 0xC94C0404
#define ACT_P2P_Flag_PREC6 0xC94C0404
//=============================================================================
//            TABLE HINTS
//=============================================================================
#define SEM_SWID_0 0
#define SEM_SWID_1 1
#define SEM_SWID_DERIVE 256

#define FIRST_LUT 0
#define SECOND_LUT 1
#define THIRD_LUT 2

#define NUM_ACTION8 8
#define NUM_ACTION4 4
#define NUM_ACTION1 1
#define NUM_ACTION2 2

#define SEM_COMMON_TABLE_CFG(tbl, prof, lut)    \
    @intel_config("sem_compress_key", 0, tbl)   \
    @intel_config("sem_aux_prec", 0, tbl)       \
    @intel_config("sem_hash_size0", 18, tbl)    \
    @intel_config("sem_hash_size1", 10, tbl)     \
    @intel_config("sem_hash_size2", 10, tbl)     \
    @intel_config("sem_hash_size3", 10, tbl)     \
    @intel_config("sem_hash_size4", 10, tbl)     \
    @intel_config("sem_hash_size5", 10, tbl)     \
    @intel_config("sem_pinned", 0, tbl)         \
    @intel_config("sem_inv_action", 0, tbl)     \
    @intel_config("hardware_sem", tbl)          \
    @intel_config("sem_profile", tbl, prof, lut)

#define SEM_EMPTY_TABLE_CFG(tbl, swid, prof, obj, lut)    \
    SEM_COMMON_TABLE_CFG(tbl, prof, lut)  \
    @intel_config("sem_aging_mode", 0, tbl)     \
    @intel_config("sem_swid_src", swid, tbl)    \
    @intel_config("sem_vsi_list_en", 0, tbl)    \
    @intel_config("sem_objid", obj, tbl)          \
    @intel_config("sem_num_actions", 1, tbl)    \

#define SEM_DEF_TABLE_CFG(tbl, obj, prof, lut, num_action)\
    SEM_COMMON_TABLE_CFG(tbl, prof, lut)                \
    @intel_config("sem_aging_mode", 0, tbl)             \
    @intel_config("sem_swid_src", SEM_SWID_DERIVE, tbl) \
    @intel_config("sem_vsi_list_en", 1, tbl)            \
    @intel_config("sem_objid", obj, tbl)                \
    @intel_config("sem_num_actions", num_action, tbl)   \
    @intel_config("table_depth", 0, tbl)

//=============================================================================
//            SEM PROFILE cONFIG
//=============================================================================

SEM_DEF_TABLE_CFG("comms_channel_table", SEM_OBJ_0, 1, FIRST_LUT, NUM_ACTION8)
SEM_DEF_TABLE_CFG("phy_ingress_arp_req_table", SEM_OBJ_2, 2, FIRST_LUT, NUM_ACTION8)
SEM_DEF_TABLE_CFG("phy_ingress_arp_resp_table", SEM_OBJ_2, 3, FIRST_LUT, NUM_ACTION8)
SEM_DEF_TABLE_CFG("vport_egress_dmac_vsi_table", SEM_OBJ_2, 4 , FIRST_LUT, NUM_ACTION8)
SEM_DEF_TABLE_CFG("vport_egress_vsi_table", SEM_OBJ_2, 4 , SECOND_LUT, NUM_ACTION8)
SEM_DEF_TABLE_CFG("ingress_loopback_table", SEM_OBJ_1, 5, FIRST_LUT, NUM_ACTION8)
SEM_DEF_TABLE_CFG("phy_ingress_vlan_dmac_table", SEM_OBJ_2, 6 , FIRST_LUT, NUM_ACTION8)
SEM_DEF_TABLE_CFG("vport_arp_egress_req_table", SEM_OBJ_2, 7 , FIRST_LUT, 12)
SEM_DEF_TABLE_CFG("vport_arp_egress_resp_table", SEM_OBJ_1, 8 , FIRST_LUT, 12)
SEM_DEF_TABLE_CFG("portmux_ingress_loopback_table", SEM_OBJ_1, 9, FIRST_LUT, NUM_ACTION8)
SEM_DEF_TABLE_CFG("portmux_egress_req_table", SEM_OBJ_1, 10, FIRST_LUT, NUM_ACTION8)
SEM_DEF_TABLE_CFG("portmux_egress_resp_dmac_vsi_table", SEM_OBJ_1, 11, FIRST_LUT, NUM_ACTION8)
SEM_DEF_TABLE_CFG("portmux_egress_resp_vsi_table", SEM_OBJ_1, 11, SECOND_LUT, NUM_ACTION8)
SEM_DEF_TABLE_CFG("port_mux_fwd_table", SEM_OBJ_1, 12, FIRST_LUT, NUM_ACTION8)

//===================================================================
//            LEM
//===================================================================
@intel_config("owner", "LEM_PROFILE_CFG", 1, 100)
@intel_config("owner", "LEM_OBJECT_CACHE_CFG", 0, 1)
@intel_config("owner", "LEM_HASH_SPACE_CFG", 0, 0)
@intel_config("owner", "LEM_CACHE_BANK", 0, 1)

#define LEM_OBJ_0 0

// object id, ENTRY_SIZE, START_BANK, NUM_BANKS
@intel_config("lem_objcache", LEM_OBJ_0, 64, 0, 2)

// object id, BASE
@intel_config("lem_hash_space_cfg", LEM_OBJ_0, 0)

//base 1 = base_0 + size of HASH (64B * (1024 + 256 * 5))

#define LEM_AUTO_INS_MODE_NONE 0
#define LEM_AGING_MODE_NONE 0

#define LEM_DEF_TABLE_CFG(tbl, obj, prof)                                \
    @intel_config("lem_aux_prec", 0, tbl)                           \
    @intel_config("lem_hash_size0", 10, tbl)                        \
    @intel_config("lem_hash_size1", 8, tbl)                         \
    @intel_config("lem_hash_size2", 8, tbl)                         \
    @intel_config("lem_hash_size3", 8, tbl)                         \
    @intel_config("lem_hash_size4", 8, tbl)                         \
    @intel_config("lem_hash_size5", 8, tbl)                         \
    @intel_config("lem_pinned", 0, tbl)                             \
    @intel_config("lem_objid", obj, tbl)                              \
    @intel_config("lem_profile", tbl, prof)                         \
    @intel_config("hardware_lem", tbl)                              \
    @intel_config("lem_num_actions", 12, tbl)                        \
    @intel_config("table_depth", 0, tbl)

// ACT_MISS : send the pkt to the vsi 9
// ACT_MD0  : set the user_meta.exception_packet bit



@intel_config("owner", "HASH_PROFILE", 0, 127)
@intel_config("owner", "HASH_PROFILE_LUT_CFG", 0, 15)
@intel_config("owner", "HASH_KEY_EXTRACT", 0, 15)
@intel_config("owner", "HASH_SYMMETRICIZE", 0, 15)
@intel_config("owner", "HASH_KEY_MASK", 0 , 15)

//@intel_config("hardware_hash", "ecmp_udp_hash, 1")
@intel_config("owner", "WLPG_PROFILE", 3500)

@intel_config("owner", "LPM_PROFILE_CFG", 0, 100)
@intel_config("owner", "LPM_KEY_EXTRACT", 0, 1023)

//=============================================================================
//           LPM TABLE HINTS
//=============================================================================
@intel_asm("
segment IDPF_FXP {
    block LPM {
        set %PAGE_SIZE 2MB;
    }
}
")

@intel_config("owner", "MOD_PROFILE_CFG", 0, 100)
@intel_config("owner", "MOD_FV_EXTRACT", 0, 30)

@intel_config("mod_profile", VLAN_PUSH_CTAG, "vlan_push_ctag")
@intel_config("mod_profile", VLAN_POP_CTAG, "vlan_pop_ctag")
@intel_config("mod_profile", VLAN_POP_CTAG_STAG, "vlan_pop_ctag_stag")
@intel_config("mod_profile", VLAN_PUSH_CTAG_STAG, "vlan_push_ctag_stag_mod_table")
@intel_config("mod_profile", VLAN_POP_STAG, "vlan_pop_stag")
@intel_config("mod_profile", VLAN_PUSH_STAG, "vlan_push_stag")

@intel_config("table_depth", 0, "vlan_push_ctag_mod_table")
@intel_config("table_depth", 0, "vlan_pop_ctag_mod_table")
@intel_config("table_depth", 0, "vlan_push_stag_mod_table")
@intel_config("table_depth", 0, "vlan_pop_stag_mod_table")
@intel_config("table_depth", 0, "vlan_push_ctag_stag_mod_table")
@intel_config("table_depth", 0, "vlan_pop_ctag_stag_mod_table")


#define LEM_EMPTY_TABLE_CFG(tbl)        \
    @intel_config("lem_hash_size0", 1, tbl)        \
    @intel_config("lem_hash_size1", 1, tbl)         \
    @intel_config("lem_hash_size2", 1, tbl)         \
    @intel_config("lem_hash_size3", 1, tbl)         \
    @intel_config("lem_hash_size4", 1, tbl)         \
    @intel_config("lem_hash_size5", 1, tbl)         \
    @intel_config("lem_objid", 1, tbl)            \
    @intel_config("lem_num_actions", 0, tbl)        \
    @intel_config("hardware_lem", tbl)

@intel_config("lem_objcache", 1, 64, 1, 1)

@intel_config("hardware_wcm", "wcm_bypass")

@intel_config("owner", "WCM_PROFILE_CFG0", 0, 10)
@intel_config("owner", "WCM_KEY_EXTRACT0", 0, 10)
@intel_config("owner", "WCM_ACTION_MAP0", 0, 10)
@intel_config("owner", "WCM_PROFILE_CFG1", 0, 0)
@intel_config("owner", "WCM_KEY_EXTRACT1", 0, 0)
@intel_config("owner", "WCM_ACTION_MAP1", 0, 0)

// 4 TCAM SLICES for GROUP0
@intel_config("owner", "WCM_GRP0_SLICE0", 0, 10)
@intel_config("owner", "WCM_GRP0_SLICE1", 0, 10)
@intel_config("owner", "WCM_GRP0_SLICE2", 0, 10)
@intel_config("owner", "WCM_GRP0_SLICE3", 0, 10)

//Table hints
#define WCM_GROUP_0 0
#define WCM_GROUP_1 1

#define WCM_PROF_BYPASS_GROUP0 0
#define WCM_PROF_BYPASS_GROUP1 1

#define WCM_COMMON_TABLE_CFG(tbl, prof, grp)            \
    @intel_config("wcm_action_map", tbl, 0, 1, 2, 3,    \
                        4, 5, 6, 7, 8, 9, 10, 11,       \
                        12, 13, 14, 15)                 \
    @intel_config("table_depth", 0, tbl)                \
    @intel_config("wcm_profile", tbl, grp, prof)        \
    @intel_config("hardware_wcm", tbl)

WCM_COMMON_TABLE_CFG("wcm_bypass", WCM_PROF_BYPASS_GROUP0, WCM_GROUP_0)
#define WCM_PROF_GRPn_OWN(n, x) \
       @intel_config("owner", STR(WCM_PROFILE_CFG##n), x, x)    \
       @intel_config("owner", STR(WCM_KEY_EXTRACT##n), x, x)  \
       @intel_config("owner", STR(WCM_ACTION_MAP##n), x, x)

WCM_PROF_GRPn_OWN(1, WCM_PROF_IPV4_L2)

@intel_config("owner", "WCM_GRP1_SLICE0", 0, 255)
@intel_config("owner", "WCM_GRP1_SLICE1", 0, 255)
@intel_config("owner", "WCM_GRP1_SLICE2", 0, 255)
@intel_config("owner", "WCM_GRP1_SLICE3", 0, 255)
@intel_config("owner", "WCM_GRP1_SLICE4", 0, 255)
@intel_config("owner", "WCM_GRP1_SLICE5", 0, 255)
@intel_config("owner", "WCM_GRP1_SLICE6", 0, 255)
@intel_config("owner", "WCM_GRP1_SLICE7", 0, 255)

//=============================================================================
//            TABLE HINTS
//=============================================================================
#define WCM_GROUP_1 1

#define WCM_1_COMMON_TABLE_CFG(tbl, prof, grp)        \
       @intel_config("wcm_action_map", tbl, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)  \
       @intel_config("wcm_profile", tbl, grp, prof)    \
       @intel_config("hardware_wcm", tbl)

WCM_1_COMMON_TABLE_CFG("wcm_ipv4_l2", WCM_PROF_IPV4_L2, WCM_GROUP_1)

#define MAT_IPV4_GRP1_START_SLICE 0
#define MAT_IPV4_GRP1_START_RULE 0
#define MAT_IPV4_GRP1_NUM_RULES 256

@intel_config("wcm_mat", MAT_IPV4_GRP1_START_SLICE, MAT_IPV4_GRP1_START_RULE, MAT_IPV4_GRP1_NUM_RULES, "wcm_ipv4_l2")



#define HASH_PTG_IPV4_TCP 1
#define HASH_PTG_IPV4_UDP 2
#define HASH_PTG_IPV4_PAY 3
@intel_config("hash_ptype_group", HASH_PTG_IPV4_TCP, PTYPE_MAC_IPV4_TCP, PTYPE_MAC_IPV4_TUN_MAC_IPV4_TCP)
@intel_config("hash_ptype_group", HASH_PTG_IPV4_UDP, PTYPE_MAC_IPV4_UDP, PTYPE_MAC_IPV4_TUN_MAC_IPV4_UDP)
@intel_config("hash_ptype_group", HASH_PTG_IPV4_PAY, PTYPE_MAC_IPV4_PAY, PTYPE_MAC_IPV4_TUN_MAC_IPV4_PAY,PTYPE_MAC_IPV4_TUN_PAY)
#define HASH_TYPE_QUEUE 0

#define HASH_TABLE_HINT_CFG(HASH_OBJECT_NAME, profile)  \
    @intel_config("hash_lut_cfg_out_type", HASH_TYPE_QUEUE, HASH_OBJECT_NAME)    \
    @intel_config("hash_lut_cfg_vsi_profile_ovr", 1, HASH_OBJECT_NAME)    \
    @intel_config("hash_lut_cfg_tc_ovr", 0, HASH_OBJECT_NAME)               \
    @intel_config("hardware_hash", HASH_OBJECT_NAME)                             \
    @intel_config("hash_profile", HASH_OBJECT_NAME, profile)


@intel_config("wlpg_ptype_group", PTYPE_ERROR, PTYPE_ERROR)
@intel_config("wlpg_ptype_group", PTYPE_MAC_PAY, PTYPE_MAC_PAY)
@intel_config("wlpg_ptype_group", PTYPE_MAC_ARP, PTYPE_MAC_ARP)
@intel_config("wlpg_ptype_group", PTYPE_MAC_VLAN_ARP, PTYPE_MAC_VLAN_ARP)
@intel_config("wlpg_ptype_group", PTYPE_MAC_VLAN_EXT_IN0, PTYPE_MAC_VLAN_EXT_IN0)
@intel_config("wlpg_ptype_group", PTYPE_MAC_VLAN_EXT_IN0_UDP, PTYPE_MAC_VLAN_EXT_IN0_UDP)
@intel_config("wlpg_ptype_group", PTYPE_MAC_VLAN_EXT_IN0_TCP, PTYPE_MAC_VLAN_EXT_IN0_TCP)
@intel_config("wlpg_ptype_group", PTYPE_MAC_IPV4_PAY, PTYPE_MAC_IPV4_PAY)
@intel_config("wlpg_ptype_group", PTYPE_MAC_IPV4_UDP, PTYPE_MAC_IPV4_UDP)
@intel_config("wlpg_ptype_group", PTYPE_MAC_IPV4_TCP, PTYPE_MAC_IPV4_TCP)
@intel_config("wlpg_ptype_group", PTYPE_MAC_IPV4_TUN_MAC_PAY, PTYPE_MAC_IPV4_TUN_MAC_PAY)
@intel_config("wlpg_ptype_group", PTYPE_MAC_IPV4_TUN_MAC_ARP, PTYPE_MAC_IPV4_TUN_MAC_ARP)
@intel_config("wlpg_ptype_group", PTYPE_MAC_IPV4_TUN_MAC_IPV4_PAY, PTYPE_MAC_IPV4_TUN_MAC_IPV4_PAY)
@intel_config("wlpg_ptype_group", PTYPE_MAC_IPV4_TUN_MAC_IPV4_UDP, PTYPE_MAC_IPV4_TUN_MAC_IPV4_UDP)
@intel_config("wlpg_ptype_group", PTYPE_MAC_IPV4_TUN_MAC_IPV4_TCP, PTYPE_MAC_IPV4_TUN_MAC_IPV4_TCP)

@intel_config("wlpg_ptype_group", PTYPE_MAC_VLAN_IPV4_TUN_MAC_IPV4_PAY, PTYPE_MAC_VLAN_IPV4_TUN_MAC_IPV4_PAY)
@intel_config("wlpg_ptype_group", PTYPE_MAC_VLAN_IPV4_TUN_MAC_IPV4_UDP, PTYPE_MAC_VLAN_IPV4_TUN_MAC_IPV4_UDP)
@intel_config("wlpg_ptype_group", PTYPE_MAC_VLAN_IPV4_TUN_MAC_IPV4_TCP, PTYPE_MAC_VLAN_IPV4_TUN_MAC_IPV4_TCP)

@intel_config("wlpg_ptype_group", PTYPE_MAC_IPV4_TUN_IPV4_PAY, PTYPE_MAC_IPV4_TUN_IPV4_PAY)
@intel_config("wlpg_ptype_group", PTYPE_MAC_IPV4_TUN_IPV4_UDP, PTYPE_MAC_IPV4_TUN_IPV4_UDP)
@intel_config("wlpg_ptype_group", PTYPE_MAC_IPV4_TUN_IPV4_TCP, PTYPE_MAC_IPV4_TUN_IPV4_TCP)

@intel_config("wlpg_ptype_group", PTYPE_MAC_IPV4_TUN_MAC_IPV4_TUN_PAY, PTYPE_MAC_IPV4_TUN_MAC_IPV4_TUN_PAY)

@intel_config("wlpg_ptype_group", PTYPE_MAC_IPV4_TUN_PAY, PTYPE_MAC_IPV4_TUN_PAY)

@intel_config("owner", "MOD_FIELD_MAP0_CFG", 0, 2047)
@intel_config("owner", "MOD_FIELD_MAP1_CFG", 0, 2047)
@intel_config("owner", "MOD_FIELD_MAP2_CFG", 0, 2047)

@intel_config("owner", "MOD_META_PROFILE_CFG", 0, 15)
@intel_config("mod_hash_space_cfg", 0, 0)
@intel_config("mod_hash_space_cfg", 1, 0x200000)

// 0: queue type
//@intel_config("hash_lut_cfg_out_type", 0, "ecmp_udp_hash")


@intel_asm("
segment IDPF_FXP {
    label REG 0 PMD_COMMON;
    label REG 2 PMD_HOST_INFO_TX_BASE;
    label REG 3 PMD_HOST_INFO_RX;
    label REG 4 PMD_GENERIC_32;
    label REG 5 PMD_FXP_INTERNAL;
    label REG 6 PMD_MISC_INTERNAL;
    label REG 7 PMD_HOST_INFO_TX_EXTENDED;
    label REG 8 PMD_PARSE_PTRS_SHORT;
    label REG 10 PMD_RDMARX;
    label REG 12 PMD_PARSE_PTRS;
    label REG 13 PMD_CONFIG;
    label REG 16 PMD_DROP_INFO;

    label PROTOCOL_ID 1 MAC_IN0;
    label PROTOCOL_ID 2 MAC_IN1;
    label PROTOCOL_ID 3 MAC_IN2;
    label PROTOCOL_ID 16 VLAN_EXT_IN0;
    label PROTOCOL_ID 17 VLAN_EXT_IN1;
    label PROTOCOL_ID 18 VLAN_EXT_IN2;
    label PROTOCOL_ID 19 VLAN_INT_IN0;
    label PROTOCOL_ID 20 VLAN_INT_IN1;
    label PROTOCOL_ID 21 VLAN_INT_IN2;
    label PROTOCOL_ID 32 IPV4_IN0;
    label PROTOCOL_ID 33 IPV4_IN1;
    label PROTOCOL_ID 34 IPV4_IN2;
    label PROTOCOL_ID 40 IPV6_IN0;
    label PROTOCOL_ID 41 IPV6_IN1;
    label PROTOCOL_ID 42 IPV6_IN2;
    label PROTOCOL_ID 52 UDP_IN0;
    label PROTOCOL_ID 53 UDP_IN1;
    label PROTOCOL_ID 54 UDP_IN2;
    label PROTOCOL_ID 49 TCP;

    block EVMIN {
        set %AUTO_ADD_RX_TYPE0 %PMD_FXP_INTERNAL;
        set %AUTO_ADD_RX_TYPE1 %PMD_MISC_INTERNAL;
        set %AUTO_ADD_RX_TYPE2 %PMD_PARSE_PTRS;
        set %AUTO_ADD_RX_TYPE3 %PMD_GENERIC_32;

        set %MD_SEL_RX_TYPE0 %PMD_COMMON;
        set %MD_SEL_RX_TYPE1 %PMD_FXP_INTERNAL;
        set %MD_SEL_RX_TYPE2 %PMD_HOST_INFO_RX;
        set %MD_SEL_RX_TYPE3 %PMD_MISC_INTERNAL;
        set %MD_SEL_RX_TYPE4 %PMD_GENERIC_32;

        set %AUTO_ADD_TX_TYPE0 %PMD_FXP_INTERNAL;
        set %AUTO_ADD_TX_TYPE1 %PMD_DROP_INFO;
        set %AUTO_ADD_TX_TYPE2 %PMD_PARSE_PTRS;
        set %AUTO_ADD_TX_TYPE3 %PMD_MISC_INTERNAL;
        set %AUTO_ADD_TX_TYPE4 %PMD_GENERIC_32;
	set %AUTO_ADD_TX_TYPE5 %PMD_HOST_INFO_TX_BASE;
	set %AUTO_ADD_TX_TYPE6 %PMD_HOST_INFO_TX_EXTENDED;

        set %MD_SEL_TX_TYPE0 %PMD_COMMON;
        set %MD_SEL_TX_TYPE1 %PMD_FXP_INTERNAL;
        set %MD_SEL_TX_TYPE2 %PMD_HOST_INFO_TX_BASE;
        set %MD_SEL_TX_TYPE3 %PMD_HOST_INFO_TX_EXTENDED;
        set %MD_SEL_TX_TYPE4 %PMD_MISC_INTERNAL;
        set %MD_SEL_TX_TYPE5 %PMD_GENERIC_32;

        set %AUTO_ADD_CFG_TYPE0 %PMD_FXP_INTERNAL;

        set %MD_SEL_CFG_TYPE0 %PMD_COMMON;
        set %MD_SEL_CFG_TYPE1 %PMD_CONFIG;
        set %MD_SEL_CFG_TYPE2 %PMD_FXP_INTERNAL;
    }

    block EVMOUT {
        set %AUTO_DEL_LAN_RX_TYPE0 %PMD_FXP_INTERNAL;
        set %AUTO_DEL_LAN_RX_TYPE1 %PMD_RDMARX;
        set %AUTO_DEL_LAN_RX_TYPE2 %PMD_GENERIC_32;

        set %AUTO_DEL_LANP2P_RX_TYPE0 %PMD_FXP_INTERNAL;
        set %AUTO_DEL_LANP2P_RX_TYPE1 %PMD_RDMARX;

        set %AUTO_DEL_RDMA_RX_TYPE0 %PMD_FXP_INTERNAL;
        set %AUTO_DEL_RDMA_RX_TYPE1 %PMD_MISC_INTERNAL;
        set %AUTO_DEL_RDMA_RX_TYPE2 %PMD_GENERIC_32;

        set %AUTO_DEL_RECIRC_RX_TYPE0 %PMD_PARSE_PTRS;
        set %AUTO_DEL_RECIRC_RX_TYPE1 %PMD_PARSE_PTRS_SHORT;

        set %AUTO_DEL_RECIRC_TX_TYPE0 %PMD_PARSE_PTRS;
        set %AUTO_DEL_RECIRC_TX_TYPE1 %PMD_PARSE_PTRS_SHORT;

        set %AUTO_DEL_TX_TYPE0 %PMD_FXP_INTERNAL;
        set %AUTO_DEL_TX_TYPE1 %PMD_HOST_INFO_TX_EXTENDED;

        set %AUTO_DEL_CFG_TYPE0 %PMD_FXP_INTERNAL;
    }
    block SEM {
        set %PAGE_SIZE 2MB;
    }
    block LEM {
        set %PAGE_SIZE 2MB;
    }
    block MOD {
        set %PAGE_SIZE 2MB;
	}

}
")

