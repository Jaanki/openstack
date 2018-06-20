vxlan1=$(openstack network create net1 | awk '/ id / { print  $4}') && echo "vxlan1 network created" || echo "vxlan1 network creation failed"
neutron subnet-create --name vxlan1-subnet vxlan1 192.168.99.0/24
