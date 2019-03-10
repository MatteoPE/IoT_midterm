Install Open vSwitch

``sudo apt install openvswitch-switch``


This code uses Linux Network Namespace.

List created Network Namespaces:

``sudo ip netn``

Give commands to a particular Network Namespace:

``sudo ip netns exec <netns_name> <command>``

(if you want to open a terminal into a node: command = `bash`)


After installing dhcpd,

add to /etc/dhcp/dhcpd.conf:

subnet 192.168.42.0 netmask 255.255.255.0 {

  range 192.168.42.1 192.168.42.127;

  option broadcast-address 192.168.42.255;

}


First, run `topology.sh` with superuser permissions.

Then, run `conf.sh` (I recommend running one line of code at a time), always with superuser permissions.

