# Create 10 networks, 10 routers attached to each router and public gateway. Ping google from n/w NS

source ~/overcloudrc
./create_vxlan_network.sh 10
./create_public_network.sh
./create_router.sh 10

# log into controllers and ping google
source ~/stackrc
for i in $(nova list | awk 'NR>=4 {print $4 $12}' | grep controller)
do
  node=$(echo $i | awk -F 'ctlplane=' '{print $1}')
  ip=$(echo $i | awk -F 'ctlplane=' '{print $2}')
  echo "working on $node"
  ssh -oStrictHostKeyChecking=no heat-admin@$ip 'for net in $(sudo ip netns list | grep -o "qdhcp[^ ]*"); do echo $net; sudo ip netns exec $net ping -c4 8.8.8.8; done'
done

./check_ovs_flows.sh
