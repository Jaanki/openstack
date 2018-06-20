neutron net-create vlan1 --provider:network_type vlan --provider:physical_network datacentre --provider:segmentation_id 1 && echo "vlan1 network created" || echo "vlan1 network creation failed"
neutron subnet-create vlan1 --name vlan1-subnet 90.0.0.1/24

#neutron net-create vlan2 --provider:network_type vlan --provider:physical_network datacentre --provider:segmentation_id 2
#neutron subnet-create vlan2 --name vlan2-subnet 80.0.0.1/24

#neutron net-create vlan3 --provider:network_type vlan --provider:physical_network datacentre --provider:segmentation_id 3
#neutron subnet-create vlan3 --name vlan3-subnet 70.0.0.1/24
