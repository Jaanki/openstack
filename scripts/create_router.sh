INIT=0
COUNT=$1
source ~/overcloudrc
while [ $INIT -lt $COUNT ]; do
  openstack router create router$INIT
  echo "router"$INIT "created"

  openstack router add subnet router$INIT  vxlan$INIT-subnet
  echo "added vxlan"$INIT "subnet to router"$INIT

  neutron router-gateway-set router$INIT public
  echo "public g/w to router"$INIT "set"
  INIT=$((INIT + 1))
done

