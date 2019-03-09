NODE00="Host-00"
NODE01="Host-01"
ROUTER="Host-02"
#switches=(sw00 sw01)

#OVS non-SDN behavior (switch with standard behavior)
#for s in ${switches[@]};
#do
#    ovs-vsctl set-fail-mode $s standalone
#done
ovs-vsctl set-fail-mode sw00 standalone

#IP forwarding
#In this way, Host-02 can simulate the behavior of a router
ip netns exec $ROUTER sysctl -w net.ipv4.ip_forward=1

#Manually assign an IP address to the router
#c.sw00-host02.1 is the interface Host-02 --> sw00
ip netns exec $ROUTER ifconfig c.sw00-host02.1 192.168.42.254/24

#After modfying /etc/dhcp/dhcpd.conf, run a DHCPv4 server on the router on c.sw00-host02.1
chmod a+w /var/lib/dhcp/dhcpd.leases
ip netns exec $ROUTER dhcpd -4 c.sw00-host02.1
ip netns exec $ROUTER systemctl restart isc-dhcp-server.service

#From Host-00, run a DHCPv4 client
ip netns exec $NODE00 dhclient -4 c.sw00-host00.1