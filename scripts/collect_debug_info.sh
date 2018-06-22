mkdir odl_dumps ovs_flows karaf_logs ovs_logs sosreport

# get ovs flows and logs and karaf logs from all nodes
. ~stack/stackrc
for i in $(nova list | awk 'NR>=4 {print $4 $12}')
do
  node=$(echo $i | awk -F 'ctlplane=' '{print $1}')
  ip=$(echo $i | awk -F 'ctlplane=' '{print $2}')
  echo "working on $node"
  mkdir ovs_logs/$node
  mkdir sosreport/$node
  ssh -oStrictHostKeyChecking=no heat-admin@$ip "sudo ovs-ofctl dump-flows br-int -OOpenFlow13 | egrep -v 'table=(0|220)' | awk '{print \$3}' | uniq | awk -F= '{print \$2}' | awk -F, '{print \$1}' | wc -l; sudo ovs-ofctl dump-flows br-int -OOpenFlow13" >> ovs_flows/$node.log
  ssh -oStrictHostKeyChecking=no heat-admin@$ip "sudo cp -r /var/log/openvswitch .; sudo chown -R heat-admin: openvswitch; mkdir sosreport; sudo sosreport -o openvswitch -o opendaylight --batch --build --all-logs --tmp-dir=sosreport; sudo chown -R heat-admin: sosreport"
  scp -oStrictHostKeyChecking=no -r heat-admin@$ip:/home/heat-admin/openvswitch/* ovs_logs/$node/.
  scp -oStrictHostKeyChecking=no -r heat-admin@$ip:/home/heat-admin/sosreport/* sosreport/$node/.
  if [[ $node = *"controller"* ]]; then
    mkdir karaf_logs/$node
    scp -oStrictHostKeyChecking=no -r heat-admin@$ip:/var/log/containers/opendaylight/* karaf_logs/$node/.
  fi
done

# get odl_dumps from VIP
source ~/stackrc
vip=$(neutron port-list | grep control_virtual_ip | grep -o '192.168[^"]*')
python -m odltools model get --ip $vip --port 8081 --user odladmin --pw redhat -p odl_dumps

