source ~/overcloudrc
openstack network create vxlan1 && echo "vxlan1 network created" || echo "vxlan1 network creation failed"
neutron subnet-create --name vxlan1-subnet vxlan1 192.168.99.0/24
