openstack router create router1
echo "router1 created"
openstack router add subnet router1  vlan1-subnet
echo "added vlan1 subnet to router1"

openstack router add subnet router1  vxlan1-subnet
echo "added vxlan1 subnet to router1"

#openstack router add subnet router1  vlan3-subnet

neutron router-gateway-set router1 public
echo "public g/w to router1 set"
