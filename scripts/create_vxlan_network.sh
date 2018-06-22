source ~/overcloudrc
openstack network create vxlan1
neutron subnet-create --name vxlan1-subnet vxlan1 100.0.0.0/24
echo "vxlan1 network created"


openstack network create vxlan2
neutron subnet-create --name vxlan2-subnet vxlan2 200.0.0.0/24


INIT=0
COUNT=$1
source ~/overcloudrc
while [ $INIT -lt $COUNT ]; do
  IP=$(($INIT*10))
  openstack network create vxlan$INIT
  neutron subnet-create --name vxlan$INIT-subnet vxlan$INIT $IP.0.0.0/24
  echo "vxlan"$INIT "network created"
  INIT=$((INIT + 1))
done

