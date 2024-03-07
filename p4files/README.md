IP Packets

Phy to Pod

Program rules:
tdi.rh_mvp.main.rh_mvp_control.phy_ingress_vlan_dmac_table.add_with_vlan_pop_ctag(port_id=0,vid=200,dmac=0x001000000266,mod_ptr=8,vport=32)
tdi.rh_mvp.main.rh_mvp_control.vlan_pop_ctag_mod_table.add_with_mod_vlan_pop_ctag(mod_blob_ptr=8)

Delete rules:
tdi.rh_mvp.main.rh_mvp_control.phy_ingress_vlan_dmac_table.delete(port_id=0,vid=200,dmac=0x001000000266)

Scapy:
sendp(Ether(src="00:0e:00:00:12:39", dst="00:10:00:00:02:66")/Dot1Q(vlan=200)/IP(dst="11.11.1.20", src="172.16.0.2")/UDP(sport=50000, dport=50000)/('asdfghjklmnbvcxz'), iface="enp24s0f1",count=1)


Tcpdump:
[root@silpixa00400066 ~]# tcpdump -i enp175s0f0v3 -nnnveXX
dropped privs to tcpdump
tcpdump: listening on enp175s0f0v3, link-type EN10MB (Ethernet), snapshot length 262144 bytes
13:24:31.031468 00:0e:00:00:12:39 > 00:10:00:00:02:66, ethertype IPv4 (0x0800), length 60: (tos 0x0, ttl 64, id 1, offset 0, flags [none], proto UDP (17), length 44)
    172.16.0.2.50000 > 11.11.1.20.50000: UDP, length 16
        0x0000:  0010 0000 0266 000e 0000 1239 0800 4500  .....f.....9..E.
        0x0010:  002c 0001 0000 4011 c28f ac10 0002 0b0b  .,....@.........
        0x0020:  0114 c350 c350 0018 5f90 6173 6466 6768  ...P.P.._.asdfgh
        0x0030:  6a6b 6c6d 6e62 7663 787a 0000            jklmnbvcxz..


Pod to Phy

Program rules:
tdi.rh_mvp.main.rh_mvp_control.vport_egress_vsi_table.add_with_vlan_push_ctag(vsi=0x10,bit32_zeros=0x0000,mod_ptr=4,vport=0)
tdi.rh_mvp.main.rh_mvp_control.vlan_push_ctag_mod_table.add_with_mod_vlan_push_ctag(mod_blob_ptr=4,pcp=1,dei=1,vlan_id=100)

Delete rules:
tdi.rh_mvp.main.rh_mvp_control.vport_egress_vsi_table.delete(vsi=0x10,bit32_zeros=0x0000)
tdi.rh_mvp.main.rh_mvp_control.vlan_push_ctag_mod_table.delete(mod_blob_ptr=1)

sendp(Ether(src="00:0e:00:00:12:39", dst="00:10:00:00:02:66")/IP(dst="11.11.1.20", src="172.16.0.2")/UDP(sport=50000, dport=50000)/('asdfghjklmnbvcxz'), iface="enp175s0f0v3",count=1)
tcpdump:
[root@silpixa00400066 ~]# tcpdump -i enp24s0f1 -nnnveXX
dropped privs to tcpdump
tcpdump: listening on enp24s0f1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
13:26:58.117253 00:0e:00:00:12:39 > 00:10:00:00:02:66, ethertype 802.1Q (0x8100), length 64: vlan 100, p 1, DEI, ethertype IPv4 (0x0800), (tos 0x0, ttl 64, id 1, offset 0, flags [none], proto UDP (17), length 44)
    172.16.0.2.50000 > 11.11.1.20.50000: UDP, length 16
        0x0000:  0010 0000 0266 000e 0000 1239 8100 3064  .....f.....9..0d
        0x0010:  0800 4500 002c 0001 0000 4011 c28f ac10  ..E..,....@.....
        0x0020:  0002 0b0b 0114 c350 c350 0018 5f90 6173  .......P.P.._.as
        0x0030:  6466 6768 6a6b 6c6d 6e62 7663 787a 0000  dfghjklmnbvcxz..

Pod to Pod
Program rules:
tdi.rh_mvp.main.rh_mvp_control.vport_egress_dmac_vsi_table.add_with_fwd_to_port(vsi=0xe,dmac=0x001000000266,vport=32)
tdi.rh_mvp.main.rh_mvp_control.ingress_loopback_table.add_with_fwd_to_port(vsi=0xe,target_vsi=0x10, vport=32)


Scapy:
sendp(Ether(src="00:0e:00:00:12:39", dst="00:10:00:00:02:66")/IP(dst="11.11.1.20", src="172.16.0.2")/UDP(sport=50000, dport=50000)/('asdfghjklmnbvcxz'), iface="enp175s0f0v1",count=1)

Tcpdump: 
[root@silpixa00400066 ~]# tcpdump -i enp175s0f0v3 -nnnveXX
dropped privs to tcpdump
tcpdump: listening on enp175s0f0v3, link-type EN10MB (Ethernet), snapshot length 262144 bytes
13:29:36.314270 00:0e:00:00:12:39 > 00:10:00:00:02:66, ethertype IPv4 (0x0800), length 60: (tos 0x0, ttl 64, id 1, offset 0, flags [none], proto UDP (17), length 44)
    172.16.0.2.50000 > 11.11.1.20.50000: UDP, length 16
        0x0000:  0010 0000 0266 000e 0000 1239 0800 4500  .....f.....9..E.
        0x0010:  002c 0001 0000 4011 c28f ac10 0002 0b0b  .,....@.........
        0x0020:  0114 c350 c350 0018 5f90 6173 6466 6768  ...P.P.._.asdfgh
        0x0030:  6a6b 6c6d 6e62 7663 787a 0000            jklmnbvcxz..



tdi.rh_mvp.main.rh_mvp_control.vport_egress_vsi_table.add_with_fwd_to_port(vsi=0x12,bit32_zeros=0x0000,vport=33)
tdi.rh_mvp.main.rh_mvp_control.ingress_loopback_table.add_with_fwd_to_port(vsi=0x12,target_vsi=0x11, vport=33)


Scapy:
sendp(Ether(src="00:0e:00:00:12:39", dst="00:10:00:00:02:66")/IP(dst="11.11.1.20", src="172.16.0.2")/UDP(sport=50000, dport=50000)/('asdfghjklmnbvcxz'), iface="enp175s0f0v7",count=1)

Tcpdump:
[root@silpixa00400066 ~]# tcpdump -i enp175s0f0v4 -nnnveXX
dropped privs to tcpdump
tcpdump: listening on enp175s0f0v4, link-type EN10MB (Ethernet), snapshot length 262144 bytes
13:37:00.573069 00:0e:00:00:12:39 > 00:10:00:00:02:66, ethertype IPv4 (0x0800), length 60: (tos 0x0, ttl 64, id 1, offset 0, flags [none], proto UDP (17), length 44)
    172.16.0.2.50000 > 11.11.1.20.50000: UDP, length 16
        0x0000:  0010 0000 0266 000e 0000 1239 0800 4500  .....f.....9..E.
        0x0010:  002c 0001 0000 4011 c28f ac10 0002 0b0b  .,....@.........
        0x0020:  0114 c350 c350 0018 5f90 6173 6466 6768  ...P.P.._.asdfgh
        0x0030:  6a6b 6c6d 6e62 7663 787a 0000            jklmnbvcxz..



ARP Packets:

BC:Phy to Portmux

tdi.rh_mvp.main.rh_mvp_control.phy_ingress_arp_table.add_with_send_to_port_mux_stag(port_id=0,vid=201,mod_ptr=3,vport=31)
tdi.rh_mvp.main.rh_mvp_control.vlan_push_stag_mod_table.add_with_mod_vlan_push_stag(mod_blob_ptr=3,pcp=1,dei=1,stag_id=203)

Scapy:
sendp(Ether(src='00:0b:00:00:03:14', dst='ff:ff:ff:ff:ff:ff')/Dot1Q(vlan=201)/ARP(hwdst='00:00:00:00:00:00', ptype=2048, hwtype=1, psrc='10.10.10.100', hwlen=6, plen=4, pdst='10.10.10.101', hwsrc='00:01:00:08:03:14', op=1)/Raw(load="0"*50), iface='enp24s0f1')

Tcpdump:
[root@silpixa00400066 ~]# tcpdump -i enp175s0f0v2 -nnnveXX
dropped privs to tcpdump
tcpdump: listening on enp175s0f0v2, link-type EN10MB (Ethernet), snapshot length 262144 bytes
12:34:31.684410 00:0b:00:00:03:14 > ff:ff:ff:ff:ff:ff, ethertype 802.1Q-QinQ (0x88a8), length 100: vlan 203, p 1, DEI, ethertype 802.1Q (0x8100), vlan 201, p 0, ethertype ARP (0x0806), Ethernet (len 6), IPv4 (len 4), Request who-has 10.10.10.101 tell 10.10.10.100, length 78
        0x0000:  ffff ffff ffff 000b 0000 0314 88a8 30cb  ..............0.
        0x0010:  8100 00c9 0806 0001 0800 0604 0001 0001  ................
        0x0020:  0008 0314 0a0a 0a64 0000 0000 0000 0a0a  .......d........
        0x0030:  0a65 3030 3030 3030 3030 3030 3030 3030  .e00000000000000
        0x0040:  3030 3030 3030 3030 3030 3030 3030 3030  0000000000000000
        0x0050:  3030 3030 3030 3030 3030 3030 3030 3030  0000000000000000
        0x0060:  3030 3030                                0000


UC:Phy to Portmux
tdi.rh_mvp.main.rh_mvp_control.phy_ingress_arp_table.add_with_send_to_port_mux_stag(port_id=0,vid=202,mod_ptr=1,vport=31)
tdi.rh_mvp.main.rh_mvp_control.vlan_push_stag_mod_table.add_with_mod_vlan_push_stag(mod_blob_ptr=1,pcp=1,dei=1,stag_id=203)

sendp(Ether(src='00:0b:00:00:03:14', dst='00:0a:00:00:03:14')/Dot1Q(vlan=202)/ARP(hwdst='00:00:00:00:00:00', ptype=2048, hwtype=1, psrc='10.10.10.100', hwlen=6, plen=4, pdst='10.10.10.101', hwsrc='00:01:00:08:03:14', op=2)/Raw(load="0"*50), iface='enp24s0f1')

Tcpdump:
[root@silpixa00400066 ~]# tcpdump -i enp175s0f0v2 -nnnveXX
dropped privs to tcpdump
tcpdump: listening on enp175s0f0v2, link-type EN10MB (Ethernet), snapshot length 262144 bytes
12:35:44.425402 00:0b:00:00:03:14 > 00:0a:00:00:03:14, ethertype 802.1Q-QinQ (0x88a8), length 100: vlan 203, p 1, DEI, ethertype 802.1Q (0x8100), vlan 202, p 0, ethertype ARP (0x0806), Ethernet (len 6), IPv4 (len 4), Reply 10.10.10.100 is-at 00:01:00:08:03:14, length 78
        0x0000:  000a 0000 0314 000b 0000 0314 88a8 30cb  ..............0.
        0x0010:  8100 00ca 0806 0001 0800 0604 0002 0001  ................
        0x0020:  0008 0314 0a0a 0a64 0000 0000 0000 0a0a  .......d........
        0x0030:  0a65 3030 3030 3030 3030 3030 3030 3030  .e00000000000000
        0x0040:  3030 3030 3030 3030 3030 3030 3030 3030  0000000000000000
        0x0050:  3030 3030 3030 3030 3030 3030 3030 3030  0000000000000000
        0x0060:  3030 3030                                0000



BC: Pod to Portmux

tdi.rh_mvp.main.rh_mvp_control.vport_arp_egress_table.add_with_send_to_port_mux(vsi=0xe,bit32_zeros=0x0000,mod_ptr=2,vport=31)
tdi.rh_mvp.main.rh_mvp_control.vlan_push_ctag_stag_mod_table.add_with_mod_vlan_push_ctag_stag(mod_blob_ptr=2,ctag_id=300,dei=1,pcp=1,stag_id=301,dei_s=1,pcp_s=1)
tdi.rh_mvp.main.rh_mvp_control.portmux_ingress_loopback_table.add_with_fwd_to_port(bit32_zeros=0x0000,vport=31)

Scapy:
sendp(Ether(src='00:0b:00:00:03:14', dst='ff:ff:ff:ff:ff:ff')/ARP(hwdst='00:00:00:00:00:00', ptype=2048, hwtype=1, psrc='10.10.10.100', hwlen=6, plen=4, pdst='10.10.10.101', hwsrc='00:01:00:08:03:14', op=1)/Raw(load="0"*50), iface='enp175s0f0v1')

Tcpdump:
[root@silpixa00400066 ~]# tcpdump -i enp175s0f0v2 -nnnveXX
dropped privs to tcpdump
tcpdump: listening on enp175s0f0v2, link-type EN10MB (Ethernet), snapshot length 262144 bytes
12:38:55.929146 00:0b:00:00:03:14 > ff:ff:ff:ff:ff:ff, ethertype 802.1Q-QinQ (0x88a8), length 100: vlan 301, p 1, DEI, ethertype 802.1Q (0x8100), vlan 300, p 1, DEI, ethertype ARP (0x0806), Ethernet (len 6), IPv4 (len 4), Request who-has 10.10.10.101 tell 10.10.10.100, length 78
        0x0000:  ffff ffff ffff 000b 0000 0314 88a8 312d  ..............1-
        0x0010:  8100 312c 0806 0001 0800 0604 0001 0001  ..1,............
        0x0020:  0008 0314 0a0a 0a64 0000 0000 0000 0a0a  .......d........
        0x0030:  0a65 3030 3030 3030 3030 3030 3030 3030  .e00000000000000
        0x0040:  3030 3030 3030 3030 3030 3030 3030 3030  0000000000000000
        0x0050:  3030 3030 3030 3030 3030 3030 3030 3030  0000000000000000
        0x0060:  3030 3030                                0000


UC: Pod to Portmux

Same rule as BC pod to portmux:

Scapy:
sendp(Ether(src='00:0b:00:00:03:14', dst='ff:ff:ff:ff:ff:ff')/ARP(hwdst='00:00:00:00:00:00', ptype=2048, hwtype=1, psrc='10.10.10.100', hwlen=6, plen=4, pdst='10.10.10.101', hwsrc='00:01:00:08:03:14', op=2)/Raw(load="0"*50), iface='enp175s0f0v1')

Tcpdump:
[root@silpixa00400066 ~]# tcpdump -i enp175s0f0v2 -nnnveXX
dropped privs to tcpdump
tcpdump: listening on enp175s0f0v2, link-type EN10MB (Ethernet), snapshot length 262144 bytes
12:39:33.211204 00:0b:00:00:03:14 > ff:ff:ff:ff:ff:ff, ethertype 802.1Q-QinQ (0x88a8), length 100: vlan 301, p 1, DEI, ethertype 802.1Q (0x8100), vlan 300, p 1, DEI, ethertype ARP (0x0806), Ethernet (len 6), IPv4 (len 4), Reply 10.10.10.100 is-at 00:01:00:08:03:14, length 78
        0x0000:  ffff ffff ffff 000b 0000 0314 88a8 312d  ..............1-
        0x0010:  8100 312c 0806 0001 0800 0604 0002 0001  ..1,............
        0x0020:  0008 0314 0a0a 0a64 0000 0000 0000 0a0a  .......d........
        0x0030:  0a65 3030 3030 3030 3030 3030 3030 3030  .e00000000000000
        0x0040:  3030 3030 3030 3030 3030 3030 3030 3030  0000000000000000
        0x0050:  3030 3030 3030 3030 3030 3030 3030 3030  0000000000000000
        0x0060:  3030 3030                                0000


BC: Portmux to Port

tdi.rh_mvp.main.rh_mvp_control.portmux_egress_req_table.add_with_vlan_pop_stag(vsi=0xf,vid=500,mod_ptr=4,vport=0)
tdi.rh_mvp.main.rh_mvp_control.vlan_pop_stag_mod_table.add_with_mod_vlan_pop_stag(mod_blob_ptr=4)

Scapy:
sendp(Ether(src='00:0b:00:00:03:14', dst='ff:ff:ff:ff:ff:ff')/Dot1AD(vlan=15)/Dot1Q(vlan=500)/ARP(hwdst='00:00:00:00:00:00', ptype=2048, hwtype=1, psrc='10.10.10.100', hwlen=6, plen=4, pdst='10.10.10.101', hwsrc='00:01:00:08:03:14', op=1)/Raw(load="0"*50), iface='enp175s0f0v2')

Tcpdump:
[root@silpixa00400066 ~]# tcpdump -i enp24s0f1 -nnnveXX
dropped privs to tcpdump
tcpdump: listening on enp24s0f1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
12:25:21.888673 00:0b:00:00:03:14 > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0x8100), length 96: vlan 500, p 0, ethertype ARP (0x0806), Ethernet (len 6), IPv4 (len 4), Request who-has 10.10.10.101 tell 10.10.10.100, length 78
        0x0000:  ffff ffff ffff 000b 0000 0314 8100 01f4  ................
        0x0010:  0806 0001 0800 0604 0001 0001 0008 0314  ................
        0x0020:  0a0a 0a64 0000 0000 0000 0a0a 0a65 3030  ...d.........e00
        0x0030:  3030 3030 3030 3030 3030 3030 3030 3030  0000000000000000
        0x0040:  3030 3030 3030 3030 3030 3030 3030 3030  0000000000000000
        0x0050:  3030 3030 3030 3030 3030 3030 3030 3030  0000000000000000


BC: Portmux to Pod

tdi.rh_mvp.main.rh_mvp_control.portmux_egress_req_table.add_with_vlan_pop_ctag_stag(vsi=0xf,vid=10,mod_ptr=5,vport=27)
tdi.rh_mvp.main.rh_mvp_control.vlan_pop_ctag_stag_mod_table.add_with_mod_vlan_pop_ctag_stag(mod_blob_ptr=5)
tdi.rh_mvp.main.rh_mvp_control.ingress_loopback_table.add_with_fwd_to_port(vsi=0xf,target_vsi=0xb, vport=27)

Scapy:
sendp(Ether(src='00:0b:00:00:03:14', dst='ff:ff:ff:ff:ff:ff')/Dot1AD(vlan=15)/Dot1Q(vlan=10)/ARP(hwdst='00:00:00:00:00:00', ptype=2048, hwtype=1, psrc='10.10.10.100', hwlen=6, plen=4, pdst='10.10.10.101', hwsrc='00:01:00:08:03:14', op=1)/Raw(load="0"*50), iface='enp175s0f0v2')

[root@silpixa00400066 ~]# tcpdump -i enp175s0f0d1 -nnnveXX
dropped privs to tcpdump
tcpdump: listening on enp175s0f0d1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
12:28:45.006633 00:0b:00:00:03:14 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 92: Ethernet (len 6), IPv4 (len 4), Request who-has 10.10.10.101 tell 10.10.10.100, length 78
        0x0000:  ffff ffff ffff 000b 0000 0314 0806 0001  ................
        0x0010:  0800 0604 0001 0001 0008 0314 0a0a 0a64  ...............d
        0x0020:  0000 0000 0000 0a0a 0a65 3030 3030 3030  .........e000000
        0x0030:  3030 3030 3030 3030 3030 3030 3030 3030  0000000000000000
        0x0040:  3030 3030 3030 3030 3030 3030 3030 3030  0000000000000000
        0x0050:  3030 3030 3030 3030 3030 3030            000000000000

UC: Portmux to Port

tdi.rh_mvp.main.rh_mvp_control.portmux_egress_resp_vsi_table.add_with_vlan_pop_stag(vsi=0xf,bit32_zeros=0x0000,mod_ptr=6,vport=0)
tdi.rh_mvp.main.rh_mvp_control.vlan_pop_stag_mod_table.add_with_mod_vlan_pop_stag(mod_blob_ptr=6)

Scapy:
sendp(Ether(src='00:0b:00:00:03:14', dst='00:0a:00:00:03:14')/Dot1AD(vlan=15)/Dot1Q(vlan=200)/ARP(hwdst='00:00:00:00:00:00', ptype=2048, hwtype=1, psrc='10.10.10.100', hwlen=6, plen=4, pdst='10.10.10.101', hwsrc='00:01:00:08:03:14', op=2)/Raw(load="0"*50), iface='enp175s0f0v3')

Tcpdump:
[[root@silpixa00400066 ~]# tcpdump -i enp24s0f1 -nnnveXX
dropped privs to tcpdump
tcpdump: listening on enp24s0f1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
12:49:55.356586 00:0b:00:00:03:14 > 00:0a:00:00:03:14, ethertype 802.1Q (0x8100), length 96: vlan 200, p 0, ethertype ARP (0x0806), Ethernet (len 6), IPv4 (len 4), Reply 10.10.10.100 is-at 00:01:00:08:03:14, length 78
        0x0000:  000a 0000 0314 000b 0000 0314 8100 00c8  ................
        0x0010:  0806 0001 0800 0604 0002 0001 0008 0314  ................
        0x0020:  0a0a 0a64 0000 0000 0000 0a0a 0a65 3030  ...d.........e00
        0x0030:  3030 3030 3030 3030 3030 3030 3030 3030  0000000000000000
        0x0040:  3030 3030 3030 3030 3030 3030 3030 3030  0000000000000000
        0x0050:  3030 3030 3030 3030 3030 3030 3030 3030  0000000000000000


UC: Portmux to Pod

tdi.rh_mvp.main.rh_mvp_control.portmux_egress_resp_dmac_vsi_table.add_with_vlan_pop_ctag_stag(vsi=0xf,dmac=0x000c00000314,mod_ptr=7,vport=33)
tdi.rh_mvp.main.rh_mvp_control.vlan_pop_ctag_stag_mod_table.add_with_mod_vlan_pop_ctag_stag(mod_blob_ptr=7)
tdi.rh_mvp.main.rh_mvp_control.ingress_loopback_table.add_with_fwd_to_port(vsi=0xf,target_vsi=0x11, vport=33)
Scapy:
sendp(Ether(src='00:0b:00:00:03:14', dst='00:0c:00:00:03:14')/Dot1AD(vlan=15)/Dot1Q(vlan=200)/ARP(hwdst='00:0c:00:00:03:14', ptype=2048, hwtype=1, psrc='10.10.10.100', hwlen=6, plen=4, pdst='10.10.10.101', hwsrc='00:01:00:08:03:14', op=2)/Raw(load="0"*50), iface='enp175s0f0v3')

[root@silpixa00400066 ~]# tcpdump -i enp175s0f0v6 -nnnveXX
dropped privs to tcpdump
tcpdump: listening on enp175s0f0v6, link-type EN10MB (Ethernet), snapshot length 262144 bytes
15:33:42.787923 00:0b:00:00:03:14 > 00:0c:00:00:03:14, ethertype 802.1Q (0x8100), length 96: vlan 200, p 0, ethertype ARP (0x0806), Ethernet (len 6), IPv4 (len 4), Reply 10.10.10.100 is-at 00:01:00:08:03:14, length 78
        0x0000:  000c 0000 0314 000b 0000 0314 8100 00c8  ................
        0x0010:  0806 0001 0800 0604 0002 0001 0008 0314  ................
        0x0020:  0a0a 0a64 000c 0000 0314 0a0a 0a65 3030  ...d.........e00
        0x0030:  3030 3030 3030 3030 3030 3030 3030 3030  0000000000000000
        0x0040:  3030 3030 3030 3030 3030 3030 3030 3030  0000000000000000
        0x0050:  3030 3030 3030 3030 3030 3030 3030 3030  0000000000000000




