source ~/stackrc

OVERCLOUD_NODES=$(($(openstack server list | awk 'NR>=4 {print $4}' | wc -l) - 1))

cat > check_odl.sh <<'EOF'
if [ "healthy" == $(sudo docker inspect opendaylight_api --format={{.State.Health.Status}}) ]; then 
  echo "ODL container is healthy"
else
  echo "ODL container is NOT healthy. Please check logs"
fi

#TUNNEL_NUMBER=let 
EOF

chmod +x check_odl.sh

for i in $(openstack server list | awk 'NR>=4 {print $4 $8}' | grep controller)
do
  node=$(echo $i | awk -F 'ctlplane=' '{print $1}')
  ip=$(echo $i | awk -F 'ctlplane=' '{print $2}')
  echo "working on" $node
  ssh -oStrictHostKeyChecking=no heat-admin@$ip "if [ -f ping_gw.sh ]; then rm ping_gw.sh; fi"
  scp -oStrictHostKeyChecking=no check_odl.sh heat-admin@$ip:/home/heat-admin
  ssh -oStrictHostKeyChecking=no heat-admin@$ip "./check_odl.sh"
done
