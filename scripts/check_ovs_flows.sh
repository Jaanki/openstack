. ~stack/stackrc
for i in $(nova list | awk 'NR>=4 {print $4 $12}')
do
  node=$(echo $i | awk -F 'ctlplane=' '{print $1}')
  ip=$(echo $i | awk -F 'ctlplane=' '{print $2}')
  echo "working on $node"
  ssh -oStrictHostKeyChecking=no heat-admin@$ip "sudo ovs-ofctl dump-flows br-int -OOpenFlow13 | egrep -v 'table=(0|220)' | awk '{print \$3}' | uniq | awk -F= '{print \$2}' | awk -F, '{print \$1}' | wc -l; sudo ovs-ofctl dump-flows br-int -OOpenFlow13; sudo ovs-vsctl show"
done
echo "ovs tables checked"
