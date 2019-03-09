#!/bin/bash

#OVS non-SDN behavior
#ovs-vsctl set-fail-mode <switch-name> standalone
NODE00="Host-00"
NODE01="Host-01"
ROUTER="Host-02"

#OVS non-SDN behavior
switches=(sw00 sw01)
for s in ${switches[@]};
do
    ovs-vsctl set-fail-mode $s standalone
done

#make the host02 a router 
#IP forwarding
ip netns exec $ROUTER sysctl -w net.ipv4.ip_forward=1
#create a DHCP server
ip netns exec $ROUTER dhcpd -4 -p 50001 &
#create DHCP client on nodes
ip netns exec $NODE00 dhclient -4 -p 50001 &
ip netns exec $NODE01 dhclient -4 -p 50001 &