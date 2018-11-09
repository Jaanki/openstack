INIT=0
COUNT=$1
source ~/overcloudrc

if [ $COUNT = 0 ]; then
  echo "no vlan network created"
fi
while [ $INIT -lt $COUNT ]; do
  IP=$(($INIT+30))
  openstack network create vlan$INIT --provider-physical-network datacentre --provider-segment $IP --provider-network-type vlan
  openstack subnet create vlan$INIT-subnet --network vlan$INIT --subnet-range $IP.0.0.0/24
  echo "vxlan"$INIT "network created"
  INIT=$((INIT + 1))
done
