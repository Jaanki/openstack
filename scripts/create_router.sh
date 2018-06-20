openstack router create router1 && echo "router1 created" || echo "router1 creation failed"
openstack router add subnet router1  vlan1-subnet && echo "added vlan1 subnet to router1" || echo "adding vlan1 subnet to router1 failed"

openstack router add subnet router1  vxlan1-subnet && echo "added vxlan1 subnet to router1" || echo "adding vxlan1 subnet to router1 failed"

#openstack router add subnet router1  vlan3-subnet

neutron router-gateway-set router1 public && echo "public g/w to router1 set" || echo "public g/w to router1 not set"
