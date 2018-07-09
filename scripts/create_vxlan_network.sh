INIT=0
COUNT=$1
source ~/overcloudrc

if [ $COUNT = 0 ]; then
  echo "no vlan network created"
fi

while [ $INIT -lt $COUNT ]; do
  IP=$(($INIT+20))
  openstack network create vxlan$INIT
  neutron subnet-create --name vxlan$INIT-subnet vxlan$INIT $IP.0.0.0/24
  echo "vxlan"$INIT "network created"
  INIT=$((INIT + 1))
done


