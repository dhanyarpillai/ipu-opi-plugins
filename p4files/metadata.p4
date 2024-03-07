#ifndef EVPN_GW_METADATA_P4_
#define EVPN_GW_METADATA_P4_

#include "pna.p4"

// TODO Andy: The following definitions probably belong in MEV's
// extended version of the pna.p4 include file.  It seems unlikely to
// me that they would be desired by other public PNA vendors.

// ActionRef_t
// ModDataPtr_t
// vendor_metadata_t -- and probably with an 'intel_' or 'intc_' name
//     prefix before the type name.

//type bit<11> ActionRef_t;
//type bit<20> ModDataPtr_t;
#define ActionRef_t bit<11>
#define ModDataPtr_t bit<20>
#if 0
struct vendor_metadata_t {
    // The modify action to be done at the end of a pass
    ActionRef_t mod_action_ref;
    // A pointer to any data needed by the action mod_action_ref
    ModDataPtr_t mod_data_ptr;
}
#endif
// TODO: Is 0 a valid mod profile id in MEV hardware?  Is it
// hard-coded to be a no packet header modification action, or can it
// be configured to do programmable header modifications like other
// mod profile ids can?
const ActionRef_t VLAN_POP_CTAG_STAG = (ActionRef_t) 1;
const ActionRef_t VLAN_POP_CTAG = (ActionRef_t) 2;
const ActionRef_t VLAN_POP_STAG = (ActionRef_t) 3;
const ActionRef_t VLAN_PUSH_CTAG_STAG = (ActionRef_t) 4;
const ActionRef_t VLAN_PUSH_CTAG = (ActionRef_t) 5;
const ActionRef_t VLAN_PUSH_STAG = (ActionRef_t) 6;
const ActionRef_t NO_MODIFY =  (ActionRef_t) 0;
#define MIN_TABLE_SIZE 64

/* These bit widths are simply initial guesses by Andy.  Feel free to
 * replace the bit widths somewhat arbitrarily chosen here with bit
 * widths you expect to be used in a production deployment. */

struct port_metadata_t {
  bool admin_state;  /* SAI_PORT_ATTR_ADMIN_STATE              */
  bool ingress_filtering;  /* SAI_PORT_ATTR_INGRESS_FILTERING        */
  bool drop_untagged;  /* SAI_PORT_ATTR_DROP_UNTAGGED            */
  bool drop_tagged;  /* SAI_PORT_ATTR_DROP_UNTAGGED            */
  bit<12> port_vlan_id; /* SAI_PORT_ATTR_VLAN_ID                  */
  bit<16> mtu; /* SAI_PORT_ATTR_MTU                      */
  bit<3> default_vlan_priority;  /* SAI_PORT_ATTR_DEFAULT_VLAN_PRIORITY    */
}



struct tunnel_metadata_t {
  bit<24> id;
  bit<24> vni;
  bit<4> tun_type;
  bit<16> hash;
}


#if 0
// Local metadata for each packet being processed.
struct local_metadata_t {
  bit<1> exception_packet;
  bit<1> control_packet;
  bool admit_to_l3;
  vrf_id_t vrf_id;
  bit<16> ecmp_group_id;
  bit<16> ecmp_hash;
  bit<16> nexthop_id;
  router_interface_id_t rif_mod_map_id;
  ipv4_addr_t outer_ipv4_dst;
  // Tunnel metadata
  tunnel_metadata_t tunnel;
}
#endif
#endif

