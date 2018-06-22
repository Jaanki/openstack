source ~/overcloudrc
openstack network create vxlan1
neutron subnet-create --name vxlan1-subnet vxlan1 192.168.99.0/24
echo "vxlan1 network created"
