# Create public network
#openstack network create --share --external --provider-physical-network datacentre --provider-network-type vlan --provider-segment 10 public && echo "public network created" || echo "public network creation failed"
#openstack subnet create --allocation-pool start=10.0.0.1,end=10.0.0.254 --gateway=10.0.0.1 --no-dhcp --network public --subnet-range 10.0.0.0/24 public_subnet


# Flat public network
neutron net-create public --provider:physical_network datacentre --provider:network_type flat --router:external=True
neutron subnet-create public 10.0.0.0/24 --dns-nameserver 10.25.28.28 --disable-dhcp --allocation-pool start=10.0.0.210,end=10.0.0.250  && echo "public network created" || echo "public network creation failed"
