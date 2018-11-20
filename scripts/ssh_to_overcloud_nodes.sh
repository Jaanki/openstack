# This is quickstart and infrared proof
rm ~/nodesrc
source ~/stackrc
touch ~/nodesrc
for i in $(openstack server list | awk 'NR>=4 {print $4 $8}')
do
  node=$(echo $i | awk -F 'ctlplane=' '{print $1}')
  ip=$(echo $i | awk -F 'ctlplane=' '{print $2}')
  echo $node $ip
  echo "alias $node='ssh -q -oStrictHostKeyChecking=no heat-admin@$ip'" >> nodesrc
done
source nodesrc
