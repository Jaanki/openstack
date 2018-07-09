rm ping_gw.sh
source ~/overcloudrc
INIT=0
COUNT=$1
while [ $INIT -lt $COUNT ]; do
  echo "sudo ip netns exec qdhcp-$(openstack network list | grep vxlan$INIT | awk '{print $2}') sshpass -p 'cubswin:)' ssh -oStrictHostKeyChecking=no cirros@$(openstack server list | grep vm$INIT | grep -o '=[^ ]*' | tr -d '=') 'ip a; ping -c4 $(openstack router list --long | grep router$INIT | grep -o '10.0[^"]*')'" >> ping_gw.sh
  INIT=$((INIT + 1))
done

chmod +x ping_gw.sh

source ~/stackrc
for i in $(openstack server list | awk 'NR>=4 {print $4 $12}' | grep controller)
do
  node=$(echo $i | awk -F 'ctlplane=' '{print $1}')
  ip=$(echo $i | awk -F 'ctlplane=' '{print $2}')
  echo "working on $node"
  scp -oStrictHostKeyChecking=no ping_gw.sh heat-admin@$ip:/home/heat-admin
  ssh -oStrictHostKeyChecking=no heat-admin@$ip "./ping_gw.sh && echo 'ping successfull' || exit 1"
done
