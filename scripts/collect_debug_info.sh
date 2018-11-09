mkdir debug_info
mkdir ~/debug_info/odl_dumps debug_info/ovs_info

source ./functions.sh

# get ovs flows and logs and karaf logs from all nodes
. ~stack/stackrc
for i in $(openstack server list | awk 'NR>=4 {print $4 $8}')
do
  node=$(echo $i | awk -F 'ctlplane=' '{print $1}')
  ip=$(echo $i | awk -F 'ctlplane=' '{print $2}')
  echo "working on $node"
  ssh -oStrictHostKeyChecking=no heat-admin@$ip "sudo ovs-ofctl dump-flows br-int -OOpenFlow13 | egrep -v 'table=(0|220)' | awk '{print \$3}' | uniq | awk -F= '{print \$2}' | awk -F, '{print \$1}' | wc -l; sudo ovs-ofctl dump-flows br-int -OOpenFlow13; sudo ovs-vsctl show; /sbin/ifconfig; sudo ovs-vsctl show" >> ~/debug_info/ovs_info/$node.log
  ssh -oStrictHostKeyChecking=no heat-admin@$ip "rm -rf sosreport; sudo cp -r /var/log/openvswitch .; sudo chown -R heat-admin: openvswitch; mkdir sosreport; sudo sosreport -o openvswitch -o opendaylight --batch --build --all-logs --tmp-dir=sosreport; sudo chown -R heat-admin: sosreport"
  get_logs_for_service $ip $node sosreport openvswitch
  if [[ $node = *"controller"* ]]; then
    ## Run ODLTools
    scp -oStrictHostKeyChecking=no odltools.sh heat-admin@$ip:/home/heat-admin
    ssh -oStrictHostKeyChecking=no heat-admin@$ip "./odltools.sh"
    get_logs_for_container $ip $node opendaylight neutron odltools
  fi
done

source ~/stackrc
openstack server list >> ~/debug_info/undercloud.log
source ~/overcloudrc
openstack server list >> ~/debug_info/overcloud.log
openstack network list --long >> ~/debug_info/overcloud.log
openstack port list --long >> ~/debug_info/overcloud.log
openstack router list --long >> ~/debug_info/overcloud.log

