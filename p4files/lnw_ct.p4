

    // Masks of the bit positions of some bit flags within the TCP flags field.
    const bit<8> TCP_URG_MASK = 0x20;
    const bit<8> TCP_ACK_MASK = 0x10;
    const bit<8> TCP_PSH_MASK = 0x08;
    const bit<8> TCP_RST_MASK = 0x04;
    const bit<8> TCP_SYN_MASK = 0x02;
    const bit<8> TCP_FIN_MASK = 0x01;
    
    // Define names for different expire time profile id values.
    
    const ExpireTimeProfileId_t EXPIRE_TIME_PROFILE_TCP_NOW    = (ExpireTimeProfileId_t) 0;
    const ExpireTimeProfileId_t EXPIRE_TIME_PROFILE_TCP_NEW    = (ExpireTimeProfileId_t) 1;
    const ExpireTimeProfileId_t EXPIRE_TIME_PROFILE_TCP_ESTABLISHED = (ExpireTimeProfileId_t) 2;
    const ExpireTimeProfileId_t EXPIRE_TIME_PROFILE_TCP_NEVER  = (ExpireTimeProfileId_t) 3;
    
    action tcp_syn_packet () {
        user_meta.do_add_on_miss = 1;
        user_meta.update_aging_info = 1;
        update_expire_time = true;
        new_expire_time = EXPIRE_TIME_PROFILE_TCP_NEW;
    }
    action tcp_fin_or_rst_packet () {
        user_meta.do_add_on_miss = 0;
        user_meta.update_aging_info = 1;
        update_expire_time = true;
        new_expire_time = EXPIRE_TIME_PROFILE_TCP_NOW;
    }
    action tcp_other_packets () {
        user_meta.do_add_on_miss = 0;
        user_meta.update_aging_info = 1;
        update_expire_time = true;
        new_expire_time = EXPIRE_TIME_PROFILE_TCP_ESTABLISHED;
    }

    table ct_tcp_state_table {
        key = {
            hdrs.tcp.syn: ternary;
            hdrs.tcp.fin: ternary;
            hdrs.tcp.rst: ternary;
        }
        actions = {
            tcp_syn_packet;
            tcp_fin_or_rst_packet;
            tcp_other_packets;
        }
        const entries = {
            (1, _, _): tcp_syn_packet;
            (_, 1, _): tcp_fin_or_rst_packet;
            (_, _, 1): tcp_fin_or_rst_packet;
        }
        const default_action = tcp_other_packets;
    }
    
    action ct_tcp_table_hit () {
        if (user_meta.update_aging_info == 1) {
            // AR Andy: Define an action with parameters
            // update_expire_time an new_expire_time as a convenience
            // for P4 developers.
            if (update_expire_time) {
                set_entry_expire_time(new_expire_time);
                restart_expire_timer();
            } else {
                restart_expire_timer();
            }
            // (A) a target might also support additional statements here
        } else {
            // Do nothing here.  In particular, DO NOT
            // restart_expire_time().  Whatever state the target
            // device uses per-entry to represent the last time this
            // entry was matched is left UNCHANGED.  This can be
            // useful in some connection tracking scenarios,
            // e.g. where one wishes to "star the timer" when a FIN
            // packet arrives, but it should KEEP RUNNING as later
            // packets arrive, without being restarted.

            // (B) a target might also support additional statements here
        }
    }

    action ct_tcp_table_miss() {
        if (user_meta.do_add_on_miss == 1) {
            // This example does not need to use allocate_flow_id(),
            // because no later part of the P4 program uses its return
            // value for anything.
            add_succeeded =
                add_entry(action_name = "ct_tcp_table_hit",  // name of action
                          action_params = (ct_tcp_table_hit_params_t)
                                          {});
            // (C) a target might also support additional statements here
        } else {
            drop_packet();
            // (D) a target might also support additional statements here
        }
        // a target might also support additional statements here, e.g.
        // mirror the packet
        // update a counter
        // set receive queue
    }

    table ct_tcp_table {
        /* add_on_miss table is restricted to have all exact match fields */
        key = {
            // other key fields also possible, e.g. VRF
            SelectByDirection(PNA_Direction_t.NET_TO_HOST, hdrs.ipv4[meta.depth].src_ip, 
                                              hdrs.ipv4[meta.depth].dst_ip):
                exact @name("ipv4_addr_0");
            SelectByDirection(PNA_Direction_t.HOST_TO_NET, hdrs.ipv4[meta.depth].dst_ip, 
                                              hdrs.ipv4[meta.depth].src_ip):
                exact @name("ipv4_addr_1");
            hdrs.ipv4[meta.depth].protocol : exact;
            SelectByDirection(PNA_Direction_t.NET_TO_HOST, hdrs.tcp.sport,
                                              hdrs.tcp.dport):
                exact @name("tcp_port_0");
            SelectByDirection(PNA_Direction_t.HOST_TO_NET, hdrs.tcp.dport,
                                              hdrs.tcp.sport):
                exact @name("tcp_port_1");
        }
        actions = {
            @tableonly   ct_tcp_table_hit;
            @defaultonly ct_tcp_table_miss;
        }

        // New PNA table property 'add_on_miss = true' indicates that
        // this table can use extern function add_entry() in its
        // default (i.e. miss) action to add a new entry to the table
        // from the data plane.
        add_on_miss = true;

        // New PNA table property 'idle_timeout_with_auto_delete' is
        // similar to 'idle_timeout' in other architectures, except
        // that entries that have not been matched for their expire
        // time interval will be deleted, without the control plane
        // having to delete the entry.
        idle_timeout_with_auto_delete = true;
        const default_action = ct_tcp_table_miss;
    }


