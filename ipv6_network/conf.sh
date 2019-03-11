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
sysctl -w net.ipv6.conf.all.forwarding=1

#Manually assign an IP address to the router
#c.sw00-host02.1 is the interface Host-02 --> sw00
#2001:db8:0:1::255/64
ip netns exec $ROUTER ifconfig c.sw00-host02.1 inet6 add 2001:db8:0:1::255/64
ip netns exec $ROUTER ifconfig c.sw00-host02.1 up

#After modfying /etc/dhcp/dhcpd6.conf, run a DHCPv4 server on the router on c.sw00-host02.1
chmod a+w /var/lib/dhcp/dhcpd6.leases
ip netns exec $ROUTER dhcpd -6 -cf /etc/dhcp/dhcpd6.conf c.sw00-host02.1
ip netns exec $ROUTER systemctl restart isc-dhcp-server.service

#From Host-00, run a DHCPv4 client
ip netns exec $NODE00 dhclient -6 c.sw00-host00.1
#From Host-01, run a DHCPv4 client
ip netns exec $NODE01 dhclient -6 c.sw00-host01.1
#Ping Host-01 from Host-00
#ip netns exec $NODE00 ping6 -I c.sw00-host00.1 fe80::1866:a0ff:fede:19d1