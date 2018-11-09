if [ -f ping_gw.sh ]; then
  rm ping_gw.sh
fi

source ~/overcloudrc
INIT=0
COUNT=$1
while [ $INIT -lt $COUNT ]; do
  echo -e "set -e\nsudo ip netns exec qdhcp-$(openstack network list | grep vxlan$INIT | awk '{print $2}') sshpass -p 'cubswin:)' ssh -oStrictHostKeyChecking=no cirros@$(openstack server list | grep vm$INIT | grep -o '=[^ ]*' | tr -d '=') 'ip a; ping -c4 10.0.0.1;  ping -c4 8.8.8.8'" >> ping_gw.sh
  INIT=$((INIT + 1))
done

chmod +x ping_gw.sh

source ~/stackrc
for i in $(openstack server list | awk 'NR>=4 {print $4 $8}' | grep controller)
do
  node=$(echo $i | awk -F 'ctlplane=' '{print $1}')
  ip=$(echo $i | awk -F 'ctlplane=' '{print $2}')
  echo "working on" $node
  ssh -oStrictHostKeyChecking=no heat-admin@$ip "if [ -f ping_gw.sh ]; then rm ping_gw.sh; fi"
  scp -oStrictHostKeyChecking=no ping_gw.sh heat-admin@$ip:/home/heat-admin
  ssh -oStrictHostKeyChecking=no heat-admin@$ip "./ping_gw.sh && echo 'ping successfull' || exit 1"
done
