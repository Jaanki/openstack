source ~/stackrc

OVERCLOUD_NODES=$(($(openstack server list | awk 'NR>=4 {print $4}' | wc -l) - 1))

cat > check_odl.sh <<'EOF'

RED='\033[0;31m'
NC='\033[0m'
set -e
if [ "healthy" == $(sudo docker inspect opendaylight_api --format={{.State.Health.Status}}) ]; then 
  echo "ODL container is healthy"
else
  echo -e "ODL container is ${RED}NOT healthy${NC}. Please check logs"
fi

#TUNNEL_NUMBER=let 
EOF

chmod +x check_odl.sh

for i in $(openstack server list | awk 'NR>=4 {print $4 $8}' | grep controller)
do
  node=$(echo $i | awk -F 'ctlplane=' '{print $1}')
  ip=$(echo $i | awk -F 'ctlplane=' '{print $2}')

  echo -e "\nworking on" $node
  ssh -q -oStrictHostKeyChecking=no heat-admin@$ip "if [ -f check_odl.sh ]; then rm check_odl.sh; fi"
  scp -oStrictHostKeyChecking=no check_odl.sh heat-admin@$ip:/home/heat-admin
  ssh -q -oStrictHostKeyChecking=no heat-admin@$ip "./check_odl.sh; echo 'tunnel ports are'; sudo ovs-vsctl show | grep 'Port \"tun' | wc -l; grep -B 2 -r 'java.io.FileNotFoundException: /opt/opendaylight/etc/opendaylight/karaf/' /var/log/containers/opendaylight/karaf/logs/karaf.log || echo 'no files missing'" #; echo 'stopping ODL contaner and waiting for a minite'; sudo docker stop opendaylight_api; sudo docker ps | grep opendaylight_api; sleep 60; echo 'starting ODL container'; sudo docker start opendaylight_api; sudo docker ps | grep opendaylight_api; echo 'waiting 2 mins for ODL to come up'; sleep 120; sudo docker ps | grep opendaylight_api; ./check_odl.sh"

  echo "working on" $node
  ssh -oStrictHostKeyChecking=no heat-admin@$ip "if [ -f ping_gw.sh ]; then rm ping_gw.sh; fi"
  scp -oStrictHostKeyChecking=no check_odl.sh heat-admin@$ip:/home/heat-admin
  ssh -oStrictHostKeyChecking=no heat-admin@$ip "./check_odl.sh"
done
