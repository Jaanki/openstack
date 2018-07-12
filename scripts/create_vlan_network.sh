INIT=0
COUNT=$1
source ~/overcloudrc

if [ $COUNT = 0 ]; then
  echo "no vlan network created"
fi
while [ $INIT -lt $COUNT ]; do
  IP=$(($INIT+30))
  openstack network create vlan$INIT
  neutron subnet-create --name vlan$INIT-subnet vlan$INIT $IP.0.0.0/24 --provider:physical_network datacentre --provider:segmentation_id $IP
  echo "vxlan"$INIT "network created"
  INIT=$((INIT + 1))
done
