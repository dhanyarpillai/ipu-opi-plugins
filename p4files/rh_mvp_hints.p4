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
@intel_config("sem_objcache", SEM_OBJ_2, 0x20A0000, 32, 4, 1)

// object id, BASE, ENTRY_SIZE, START_BANK, NUM_BANKS
//@intel_config("sem_objcache", SEM_OBJ_0, 0, 32, 0, 1)
//@intel_config("sem_objcache", SEM_OBJ_1, 0x5000, 32, 1, 1)
//@intel_config("sem_objcache", SEM_OBJ_2, 0x2D000, 32, 2, 1)
//@intel_config("sem_objcache", SEM_OBJ_3, 0x55000, 32, 3, 1)
//@intel_config("sem_objcache", SEM_OBJ_4, 0x7D000, 32, 4, 1)


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

SEM_DEF_TABLE_CFG("comms_channel_table", SEM_OBJ_0, 1, FIRST_LUT, NUM_ACTION4)
SEM_DEF_TABLE_CFG("phy_ingress_arp_table", SEM_OBJ_2, 2, FIRST_LUT, NUM_ACTION4)
SEM_DEF_TABLE_CFG("vport_egress_dmac_vsi_table", SEM_OBJ_2, 4 , FIRST_LUT, NUM_ACTION4)
SEM_DEF_TABLE_CFG("vport_egress_vsi_table", SEM_OBJ_2, 4 , SECOND_LUT, NUM_ACTION4)
SEM_DEF_TABLE_CFG("vport_egress_dmac_table", SEM_OBJ_2, 4 , THIRD_LUT, NUM_ACTION4)
SEM_DEF_TABLE_CFG("ingress_loopback_table", SEM_OBJ_1, 5, FIRST_LUT, NUM_ACTION4)
SEM_DEF_TABLE_CFG("ingress_loopback_dmac_table", SEM_OBJ_1, 5, SECOND_LUT, NUM_ACTION4)
SEM_DEF_TABLE_CFG("phy_ingress_vlan_dmac_table", SEM_OBJ_1, 6 , FIRST_LUT, NUM_ACTION4)
SEM_DEF_TABLE_CFG("vport_arp_egress_table", SEM_OBJ_2, 7 , FIRST_LUT, NUM_ACTION4)
SEM_DEF_TABLE_CFG("portmux_ingress_loopback_table", SEM_OBJ_1, 9, FIRST_LUT, NUM_ACTION4)
SEM_DEF_TABLE_CFG("portmux_egress_req_table", SEM_OBJ_1, 10, FIRST_LUT, NUM_ACTION4)
SEM_DEF_TABLE_CFG("portmux_egress_resp_dmac_vsi_table", SEM_OBJ_1, 11, FIRST_LUT, NUM_ACTION4)
SEM_DEF_TABLE_CFG("portmux_egress_resp_vsi_table", SEM_OBJ_1, 11, SECOND_LUT, NUM_ACTION4)
SEM_DEF_TABLE_CFG("port_mux_fwd_table", SEM_OBJ_1, 12, FIRST_LUT, NUM_ACTION4)

@intel_config("owner", "MOD_PROFILE_CFG", 0, 100)
@intel_config("owner", "MOD_FV_EXTRACT", 0, 30)

@intel_config("mod_profile", VLAN_PUSH_CTAG, "mod_vlan_push_ctag")
@intel_config("mod_profile", VLAN_POP_CTAG, "mod_vlan_pop_ctag")
@intel_config("mod_profile", VLAN_POP_CTAG_STAG, "mod_vlan_pop_ctag_stag")
@intel_config("mod_profile", VLAN_PUSH_CTAG_STAG, "mod_vlan_push_ctag_stag_mod")
@intel_config("mod_profile", VLAN_POP_STAG, "mod_vlan_pop_stag")
@intel_config("mod_profile", VLAN_PUSH_STAG, "mod_vlan_push_stag")

@intel_config("table_depth", 0, "vlan_push_ctag_mod_table")
@intel_config("table_depth", 0, "vlan_pop_ctag_mod_table")
@intel_config("table_depth", 0, "vlan_push_stag_mod_table")
@intel_config("table_depth", 0, "vlan_pop_stag_mod_table")
@intel_config("table_depth", 0, "vlan_push_ctag_stag_mod_table")
@intel_config("table_depth", 0, "vlan_pop_ctag_stag_mod_table")

@intel_config("lpm_hash_space_cfg", 0, 0)


@intel_config("owner", "MOD_FIELD_MAP0_CFG", 0, 2047)
@intel_config("owner", "MOD_FIELD_MAP1_CFG", 0, 2047)
@intel_config("owner", "MOD_FIELD_MAP2_CFG", 0, 2047)

@intel_config("owner", "MOD_META_PROFILE_CFG", 0, 15)
@intel_config("mod_hash_space_cfg", 0, 0)
@intel_config("mod_hash_space_cfg", 1, 0x200000)



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
    block MOD {
        set %PAGE_SIZE 2MB;
	}

}
")

