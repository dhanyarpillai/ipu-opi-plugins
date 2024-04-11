#ifndef EVPN_GW_P4_
#define EVPN_GW_P4_
#define STR(n) #n
#include <core.p4>
#include <pna.p4>
#include <idpf.p4>
#include "proto_ids.p4"
#include "protocols.p4"
#include "parsed_hdrs.p4"
#include "user_metadata.p4"
#include "metadata.p4"
#include "fxp_ptypes.p4"

@intel_config("domain_id", 0)
#include "fxp_parser_hints.p4"
#include "rh_mvp_hints.p4"

@intel_config("domain_id", 0, "GLOBAL")
minipkg_config() minicfg;

//extern void recirculate();

#include "parser.p4"

#define TUNNEL_ENABLE
#define INTEL_IPU_SPECIFIC_HEADER_CHANGES
#define P4_COMPILER_SUPPORTS_TABLE_APPLY_INSIDE_OF_ACTION
#define UDP 17
#define VRF_MUX 9
const PortId_t DEFAULT_MGMT_VPORT = (PortId_t) 23; // IMC

// These are the initial values only.  Runtime can change these later.
const PortId_t INITIAL_DEFAULT_P0_VPORT = (PortId_t) 0;
const PortId_t INITIAL_DEFAULT_P1_VPORT = (PortId_t) 0;
const PortId_t DEFAULT_EXCEPTION_VPORT  = (PortId_t) 0;
const PortId_t DEFAULT_DEBUG_VPORT      = (PortId_t) 0;
struct user_rx_t {

	bit<1> reserved4_0;
	bit<1> reserved4_1;
	bit<8> field2;
}
struct user_tx_t {

	bit<10> field0;
}
typedef bit<32> ipv4_addr_t;
typedef bit<48> ethernet_addr_t;


/*
 * Network-to-host RX traffic - Traffic coming in from Tunnel port
 * Network-to-network - Goes go TX after decap via resubmit. Resubmit yet to be
 * added Host-to-network TX traffic - Traffic coming in from Local Pod or
 * Gateway Host-to-host - uses TX L2 table to forward the packet from vport to
 * vport
 */
#define RxPkt(istd) (istd.direction == PNA_Direction_t.NET_TO_HOST)
#define TxPkt(istd) (istd.direction == PNA_Direction_t.HOST_TO_NET)
#define pass_1st(istd) (istd.pass == (PassNumber_t) 0)
#define pass_2nd(istd) (istd.pass == (PassNumber_t) 1)
#define RX_ISCSI(istd)     meta.common.vsig == 1
#define IS_BC_OR_MC(istd) (user_meta.pmeta.pflag_11 == 1 || user_meta.pmeta.pflag_10 == 1)

control PreControlImpl(in parsed_headers_t hdr, inout user_metadata_t meta,
		in pna_pre_input_metadata_t istd,
		inout pna_pre_output_metadata_t ostd)
{
	apply { }
}
control rh_mvp_control(inout parsed_headers_t hdrs,
		inout user_metadata_t user_meta,
		inout vendor_meta_t meta,
		out user_rx_t umeta_rx, in user_tx_t umeta_tx,
		in pna_main_input_metadata_t istd,
		inout pna_main_output_metadata_t ostd) {
action no_modify () {
		// This is simply a packet modification action that makes no
		// header modifications.
}

action l2_fwd(PortId_t port) {
	send_to_port(port);
	meta.common.mod_action = NO_MODIFY;
}
action l2_fwd_miss_action(PortId_t port) {
  send_to_port(port);
}

action fwd_to_port(PortId_t vport) {
        send_to_port(vport);
}


action drop() {
	drop_packet(); }


action mod_vlan_push_ctag(bit<3> pcp, bit<1> dei, bit<12> vlan_id) {
		hdrs.vlan_ext[meta.common.depth].hdr.type = ETYPE_VLAN_CTAG;
		hdrs.vlan_ext[meta.common.depth].hdr.pcp = pcp;
		hdrs.vlan_ext[meta.common.depth].hdr.dei = dei;
		hdrs.vlan_ext[meta.common.depth].hdr.vid = vlan_id;
		hdrs.vlan_ext[meta.common.depth].hdr.setValid();
		insert_header(hdrs.etype[meta.common.depth], hdrs.vlan_ext[meta.common.depth].hdr, 1);
}

action mod_vlan_pop_ctag_stag() {
        hdrs.vlan_int[0].hdr.setInvalid();
        hdrs.vlan_ext[0].hdr.setInvalid();
        delete_header(hdrs.vlan_ext[meta.common.depth].hdr, hdrs.vlan_int[meta.common.depth].hdr, 1);
        delete_header(hdrs.vlan_int[meta.common.depth].hdr, hdrs.etype[meta.common.depth], 1);

}

action mod_vlan_pop_stag() {
        hdrs.vlan_ext[0].hdr.setInvalid();
        delete_header(hdrs.vlan_ext[meta.common.depth].hdr, hdrs.vlan_int[meta.common.depth].hdr, 1);

  }

action mod_vlan_pop_ctag() {
		delete_header(hdrs.vlan_ext[meta.common.depth].hdr, hdrs.etype[meta.common.depth], 1);
		hdrs.vlan_ext[meta.common.depth].hdr.setInvalid();
}

action mod_vlan_push_ctag_stag(bit<3>  pcp, bit<1>  dei, bit<12> ctag_id, bit<3>  pcp_s, bit<1>  dei_s, bit<12> stag_id) {
	hdrs.vlan_int[meta.common.depth].hdr.type = ETYPE_VLAN_STAG;
	hdrs.vlan_int[meta.common.depth].hdr.pcp = pcp_s;
	hdrs.vlan_int[meta.common.depth].hdr.dei = dei_s;
	hdrs.vlan_int[meta.common.depth].hdr.vid = stag_id;
	hdrs.vlan_int[meta.common.depth].hdr.setValid();

	hdrs.vlan_ext[meta.common.depth].hdr.type = ETYPE_VLAN_CTAG;
	hdrs.vlan_ext[meta.common.depth].hdr.pcp = pcp;
	hdrs.vlan_ext[meta.common.depth].hdr.dei = dei;
	hdrs.vlan_ext[meta.common.depth].hdr.vid = ctag_id;
	hdrs.vlan_ext[meta.common.depth].hdr.setValid();
	insert_header(hdrs.etype[meta.common.depth], hdrs.vlan_ext[meta.common.depth].hdr, 1);
	insert_header(hdrs.etype[meta.common.depth], hdrs.vlan_int[meta.common.depth].hdr, 1);
}

action mod_vlan_push_stag(bit<3>  pcp, bit<1>  dei, bit<12> stag_id) {
	hdrs.vlan_int[meta.common.depth].hdr.type = ETYPE_VLAN_STAG;
	hdrs.vlan_int[meta.common.depth].hdr.pcp = pcp;
	hdrs.vlan_int[meta.common.depth].hdr.dei = dei;
	hdrs.vlan_int[meta.common.depth].hdr.vid = stag_id;
	hdrs.vlan_int[meta.common.depth].hdr.setValid();
	insert_header(hdrs.vlan_ext[meta.common.depth].hdr, hdrs.vlan_int[meta.common.depth].hdr, 1);
}

table vlan_push_ctag_stag_mod_table {
	key = {
		meta.common.mod_blob_ptr : exact;
	}
	actions = {
		mod_vlan_push_ctag_stag;
		NoAction;
	}
	const default_action = NoAction;
}

table vlan_push_stag_mod_table {
	key = {
		meta.common.mod_blob_ptr : exact;
	}
	actions = {
		mod_vlan_push_stag;
		NoAction;
	}
	const default_action = NoAction;
}

table vlan_push_ctag_mod_table {
		key = {
			meta.common.mod_blob_ptr : exact;
		}
		actions = {
			mod_vlan_push_ctag;
			NoAction;
		}
		const default_action = NoAction;
}

table vlan_pop_ctag_stag_mod_table {
                key = {
                        meta.common.mod_blob_ptr : exact;
                }
                actions = {
                        mod_vlan_pop_ctag_stag;
                        NoAction;
                }
                const default_action = NoAction;
}

table vlan_pop_stag_mod_table {
                key = {
                        meta.common.mod_blob_ptr : exact;
                }
                actions = {
                        mod_vlan_pop_stag;
                        NoAction;
                }
                const default_action = NoAction;
}

table vlan_pop_ctag_mod_table {
		key = {
			meta.common.mod_blob_ptr : exact;
		}
		actions = {
			mod_vlan_pop_ctag;
			NoAction;
		}
		const default_action = NoAction;
}


action vlan_pop_ctag_stag(bit<24> mod_ptr, PortId_t vport) {
                meta.common.mod_action = (bit<11>)VLAN_POP_CTAG_STAG;
                meta.common.mod_blob_ptr = (bit<24>)mod_ptr;
		send_to_port (vport);
}

action vlan_pop_stag(bit<24> mod_ptr, PortId_t vport) {
                meta.common.mod_action = (bit<11>)VLAN_POP_STAG;
                meta.common.mod_blob_ptr = (bit<24>)mod_ptr;
                send_to_port (vport);
}

action vlan_pop_ctag(bit<24> mod_ptr, PortId_t vport) {
                meta.common.mod_action = (bit<11>)VLAN_POP_CTAG;
                meta.common.mod_blob_ptr = (bit<24>)mod_ptr;
                send_to_port (vport);
}

action vlan_push_ctag(bit<24> mod_ptr, PortId_t vport) {
		meta.common.mod_action = (bit<11>)VLAN_PUSH_CTAG;
		meta.common.mod_blob_ptr = (bit<24>)mod_ptr;
		send_to_port(vport);
}

action set_neighbor(bit<16> neighbor, bit<1> ecmp_on) {
		recirculate();
}

action send_to_port_mux( bit<24> mod_ptr, PortId_t vport){
	meta.common.mod_action = (bit<11>)VLAN_PUSH_CTAG_STAG;
        meta.common.mod_blob_ptr = (bit<24>)mod_ptr;
        send_to_port(vport);
}

action send_to_port_mux_stag( bit<24> mod_ptr, PortId_t vport){
        meta.common.mod_action = (bit<11>)VLAN_PUSH_STAG;
        meta.common.mod_blob_ptr = (bit<24>)mod_ptr;
        send_to_port(vport);
}


table phy_ingress_vlan_dmac_table {
                key = {
                        meta.common.port_id : exact @name("port_id") @id(1);
                        hdrs.vlan_ext[meta.common.depth].hdr.vid : exact @name("vid") @id(2);
	                hdrs.mac[meta.common.depth].da : exact @name("dmac") @id(3) @format(MAC_ADDRESS);

                }
                actions = {
			vlan_pop_ctag;
                        @defaultonly l2_fwd_miss_action;
                }
                const default_action = l2_fwd_miss_action(DEFAULT_MGMT_VPORT);
                size = 16384;
}

table phy_ingress_arp_table {
		key = {
			meta.common.port_id : exact @name("port_id") @id(1);
	                hdrs.vlan_ext[meta.common.depth].hdr.vid : exact @name("vid") @id(2);
		}
		actions = {
			send_to_port_mux_stag;
			@defaultonly l2_fwd_miss_action;
		}
		const default_action = l2_fwd_miss_action(DEFAULT_MGMT_VPORT);
                size = 16384;
}

table portmux_egress_resp_vsi_table {
        key = {
                meta.common.vsi: exact @name("vsi") @id(1);
                user_meta.cmeta.bit32_zeros : exact @name("bit32_zeros") @id(2);
        }
        actions = {
                vlan_pop_ctag_stag;
		vlan_pop_stag;
		@defaultonly l2_fwd_miss_action;
                }
                const default_action = l2_fwd_miss_action(DEFAULT_MGMT_VPORT);
                size = 16384;
}

table portmux_egress_resp_dmac_vsi_table {
        key = {
		hdrs.mac[meta.common.depth].da : exact @name("dmac") @id(1) @format(MAC_ADDRESS);
                meta.common.vsi: exact @name("vsi") @id(2);
        }
        actions = {
                vlan_pop_ctag_stag;
                @defaultonly NoAction;

        }
        size = 1024;
        const default_action = NoAction;
}

table portmux_egress_req_table {
	key = {
		meta.common.vsi: exact @name("vsi") @id(1);
                hdrs.vlan_int[meta.common.depth].hdr.vid : exact @name("vid") @id(2);
	}
	actions = {
		vlan_pop_ctag_stag;
		vlan_pop_stag;
                @defaultonly l2_fwd_miss_action;

	}
	size = 16384;
        const default_action = l2_fwd_miss_action(DEFAULT_MGMT_VPORT);
}

table portmux_ingress_loopback_table {
        key = {
                user_meta.cmeta.bit32_zeros : exact @name("bit32_zeros") @id(2);
        }
        actions = {
                fwd_to_port;
                @defaultonly l2_fwd_miss_action;
                }
                const default_action = l2_fwd_miss_action(DEFAULT_MGMT_VPORT);
                size = 16384;
}

table vport_arp_egress_table {
        key = {
                meta.common.vsi: exact @name("vsi") @id(1);
                user_meta.cmeta.bit32_zeros : exact @name("bit32_zeros") @id(2);
        }
        actions = {
                send_to_port_mux;
                @defaultonly l2_fwd_miss_action;
        }
        const default_action = l2_fwd_miss_action(DEFAULT_MGMT_VPORT);
        size = 16384;
}

table ingress_loopback_table {
	key = {
		meta.common.vsi : exact @ name("vsi") @id(1);
		meta.misc_internal.vm_to_vm_or_port_to_port[27:17] : exact @name("target_vsi");
        }
	actions = {
		fwd_to_port;
		@defaultonly l2_fwd_miss_action;
                }
                const default_action = l2_fwd_miss_action(DEFAULT_MGMT_VPORT);
                size = 16384;
}

table ingress_loopback_dmac_table {
	key = {
		hdrs.mac[meta.common.depth].da : exact @name("dmac") @id(1) @format(MAC_ADDRESS);
        }
	actions = {
		fwd_to_port;
		@defaultonly l2_fwd_miss_action;
                }
                const default_action = l2_fwd_miss_action(DEFAULT_MGMT_VPORT);
                size = 16384;
}

table vport_egress_vsi_table {
                key = {
                        meta.common.vsi : exact @name("vsi") @id(1);
			user_meta.cmeta.bit32_zeros : exact @name("bit32_zeros") @id(2);
                }
                actions = {
                        fwd_to_port;
			vlan_push_ctag;
                        @defaultonly l2_fwd_miss_action;
                }
                const default_action = l2_fwd_miss_action(DEFAULT_MGMT_VPORT);

		size = 16384;
}

		
table vport_egress_dmac_vsi_table {
		key = {
			hdrs.mac[meta.common.depth].da : exact @name("dmac") @id(1) @format(MAC_ADDRESS);
			meta.common.vsi : exact @name("vsi") @id(2);
		}
		actions = {
			fwd_to_port;
			@defaultonly NoAction;
		}
		size = 1024;
		const default_action = NoAction;
}

table vport_egress_dmac_table {
		key = {
			hdrs.mac[meta.common.depth].da : exact @name("dmac") @id(1) @format(MAC_ADDRESS);
		}
		actions = {
			fwd_to_port;
			@defaultonly NoAction;
		}
		size = 1024;
		const default_action = NoAction;
}

table comms_channel_table {
	    key = {
		    meta.common.vsi : exact;
		    user_meta.cmeta.bit32_zeros[15:0] : exact;
	    }

	    actions = {
		    l2_fwd;
	    }
}


apply {

    /* Tx packets from any vsi */

	if (RX_ISCSI(istd)) {
            comms_channel_table.apply();
        } 
    	if (TxPkt(istd) && pass_1st(istd) && user_meta.pmeta.evlan_8100 == 0 &&  user_meta.pmeta.stag == 0 && hdrs.mac[meta.common.depth].isValid() && hdrs.ipv4[meta.common.depth].isValid() && !hdrs.arp.isValid()) {
	    	vport_egress_dmac_vsi_table.apply();
		vport_egress_vsi_table.apply();
		vport_egress_dmac_table.apply();
	}
	else if (TxPkt(istd) && pass_1st(istd) && hdrs.arp.isValid() && user_meta.pmeta.evlan_8100 == 0 && user_meta.pmeta.stag == 1 && istd.loopedback == false && IS_BC_OR_MC(istd)) {
		portmux_egress_req_table.apply();
	}
	else if (TxPkt(istd) && pass_1st(istd) && hdrs.arp.isValid() && user_meta.pmeta.evlan_8100 == 0 && user_meta.pmeta.stag == 1 && istd.loopedback == false && !IS_BC_OR_MC(istd)) {
                portmux_egress_resp_dmac_vsi_table.apply();
                portmux_egress_resp_vsi_table.apply();
        }
	else if(TxPkt(istd) && pass_1st(istd) && istd.loopedback == false && hdrs.mac[meta.common.depth].isValid()  && hdrs.arp.isValid() && user_meta.pmeta.evlan_8100 == 0 && user_meta.pmeta.stag == 0  ){
        vport_arp_egress_table.apply();
	}


    /* loopbacked packets  */

 if (RxPkt(istd) && pass_1st(istd) && istd.loopedback == true && user_meta.pmeta.stag == 0 ) {
     ingress_loopback_table.apply();
     ingress_loopback_dmac_table.apply();
  } 
 else if (RxPkt(istd) && pass_1st(istd) && istd.loopedback == true && user_meta.pmeta.stag == 1 ) {
      portmux_ingress_loopback_table.apply();
  }


    /* Rx ARP packets from phy */

	if ((RxPkt(istd) && pass_1st(istd) && istd.loopedback == false &&
			hdrs.mac[meta.common.depth].isValid() && hdrs.arp.isValid() && user_meta.pmeta.evlan_8100 == 1)) {
		phy_ingress_arp_table.apply();
        }
	
	if ((RxPkt(istd) && pass_1st(istd) && istd.loopedback == false &&
                        hdrs.mac[meta.common.depth].isValid() &&  hdrs.ipv4[meta.common.depth].isValid()  && user_meta.pmeta.evlan_8100 == 1 && !hdrs.arp.isValid())) {
                phy_ingress_vlan_dmac_table.apply();
        }
	
    /* Mod meta action */

	switch (meta.common.mod_action) {
		VLAN_PUSH_CTAG : { vlan_push_ctag_mod_table.apply(); }
		VLAN_POP_CTAG : { vlan_pop_ctag_mod_table.apply(); }
		VLAN_PUSH_CTAG_STAG: { vlan_push_ctag_stag_mod_table.apply();}
		VLAN_POP_CTAG_STAG : { vlan_pop_ctag_stag_mod_table.apply(); }
		VLAN_POP_STAG : { vlan_pop_stag_mod_table.apply(); }
		VLAN_PUSH_STAG : { vlan_push_stag_mod_table.apply();}
		NO_MODIFY : { no_modify(); }
	}
} // control main
}

control MainDeparserImpl(packet_out pkt, in parsed_headers_t main_hdr,
		in user_metadata_t main_user_meta,
		in pna_main_output_metadata_t ostd) {
	apply {}
}
PNA_NIC(main_parser = IDPFParser(), main_control = rh_mvp_control(), main_deparser = MainDeparserImpl()) main;
#endif // EVPN_GW_P4_
