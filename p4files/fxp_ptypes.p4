/**********************************************************
* Copyright(c) 2018 - 2021 Intel Corporation
*
* For licensing information, see the file ‘LICENSE’ in the root folder
***********************************************************/

typedef bit<10> ptype_t;  // 10b package specific ptype

const ptype_t PTYPE_ERROR        = 255; //something went wrong during parsing

const ptype_t PTYPE_MAC_PAY      = 1;
const ptype_t PTYPE_MAC_ARP      = 11;
const ptype_t PTYPE_MAC_VLAN_EXT_IN0     = 12;
const ptype_t PTYPE_MAC_VLAN_EXT_IN0_UDP     = 13;
const ptype_t PTYPE_MAC_VLAN_EXT_IN0_TCP    = 14;
const ptype_t PTYPE_MAC_VLAN_ARP = 15;


/********************************************************************************
 NON-TUNNELED IP
********************************************************************************/
const ptype_t PTYPE_MAC_IPV4_PAY     = 23;
const ptype_t PTYPE_MAC_IPV4_ARP     = 25;
const ptype_t PTYPE_MAC_IPV4_UDP     = 24;
const ptype_t PTYPE_MAC_IPV4_TCP     = 26;

/********************************************************************************
 IP --> tunnel --> MAC --> Pay
 IP --> tunnel --> MAC --> ARP
********************************************************************************/
const ptype_t PTYPE_MAC_IPV4_TUN_MAC_PAY  = 58;
const ptype_t PTYPE_MAC_IPV4_TUN_MAC_ARP  = 287;

/********************************************************************************
 IP --> tunnel --> MAC --> IPV4
********************************************************************************/
const ptype_t PTYPE_MAC_VLAN_IPV4_TUN_MAC_IPV4_PAY     = 56;
const ptype_t PTYPE_MAC_VLAN_IPV4_TUN_MAC_IPV4_UDP     = 57;
const ptype_t PTYPE_MAC_VLAN_IPV4_TUN_MAC_IPV4_TCP     = 59;

const ptype_t PTYPE_MAC_IPV4_TUN_MAC_IPV4_PAY     = 60;
const ptype_t PTYPE_MAC_IPV4_TUN_MAC_IPV4_UDP     = 61;
const ptype_t PTYPE_MAC_IPV4_TUN_MAC_IPV4_TCP     = 63;

/********************************************************************************
 IP --> tunnel --> IPV4
********************************************************************************/
const ptype_t PTYPE_MAC_IPV4_TUN_IPV4_PAY     = 50;
const ptype_t PTYPE_MAC_IPV4_TUN_IPV4_UDP     = 52;
const ptype_t PTYPE_MAC_IPV4_TUN_IPV4_TCP     = 53;

/********************************************************************************
 IP --> tunnel --> MAC -- > IP --> tunnel -> Pay
 IP --> tunnel --> MAC -- > IP --> tunnel -> MAC --> Pay
 IP --> tunnel --> MAC -- > IP --> tunnel -> MAC --> ARP
********************************************************************************/
const ptype_t PTYPE_MAC_IPV4_TUN_MAC_IPV4_TUN_PAY      = 366;

/********************************************************************************
 IP --> tunnel --> Pay
 IP --> tunnel --> MAC --> Pay
 IP --> tunnel --> MAC --> ARP
********************************************************************************/
const ptype_t PTYPE_MAC_IPV4_TUN_PAY      = 43;