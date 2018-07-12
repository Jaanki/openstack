mkdir debug_info
mkdir ~/debug_info/odl_dumps debug_info/ovs_flows ~/debug_info/karaf_logs ~/debug_info/ovs_logs ~/debug_info/sosreport

# get ovs flows and logs and karaf logs from all nodes
. ~stack/stackrc
for i in $(openstack server list | awk 'NR>=4 {print $4 $12}')
do
  node=$(echo $i | awk -F 'ctlplane=' '{print $1}')
  ip=$(echo $i | awk -F 'ctlplane=' '{print $2}')
  echo "working on $node"
  mkdir ~/debug_info/ovs_logs/$node
  mkdir ~/debug_info/sosreport/$node
  ssh -oStrictHostKeyChecking=no heat-admin@$ip "sudo ovs-ofctl dump-flows br-int -OOpenFlow13 | egrep -v 'table=(0|220)' | awk '{print \$3}' | uniq | awk -F= '{print \$2}' | awk -F, '{print \$1}' | wc -l; sudo ovs-ofctl dump-flows br-int -OOpenFlow13" >> ~/debug_info/ovs_flows/$node.log
  ssh -oStrictHostKeyChecking=no heat-admin@$ip "rm -rf sosreport; sudo cp -r /var/log/openvswitch .; sudo chown -R heat-admin: openvswitch; mkdir sosreport; sudo sosreport -o openvswitch -o opendaylight --batch --build --all-logs --tmp-dir=sosreport; sudo chown -R heat-admin: sosreport"
  scp -oStrictHostKeyChecking=no -r heat-admin@$ip:/home/heat-admin/openvswitch/* ~/debug_info/ovs_logs/$node/.
  scp -oStrictHostKeyChecking=no -r heat-admin@$ip:/home/heat-admin/sosreport/* ~/debug_info/sosreport/$node/.
  if [[ $node = *"controller"* ]]; then
    mkdir -p ~/debug_info/karaf_logs/$node
    scp -oStrictHostKeyChecking=no -r heat-admin@$ip:/var/log/containers/opendaylight/* ~/debug_info/karaf_logs/$node/.
  fi
done

# get odl_dumps from VIP
source ~/stackrc
sudo yum install wget -y
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install epel-release-latest-7.noarch.rpm -y
sudo yum install python-pip -y
sudo pip install odltools
vip=$(neutron port-list | grep control_virtual_ip | grep -o '192.168[^"]*')
python -m odltools model get --ip $vip --port 8081 --user odladmin --pw redhat -p ~/debug_info/odl_dumps

source ~/stackrc
openstack server list >> ~/debug_info/undercloud.log
source ~/overcloudrc
openstack server list >> ~/debug_info/overcloud.log
openstack network list --long >> ~/debug_info/overcloud.log
openstack port list --long >> ~/debug_info/overcloud.log
openstack router list --long >> ~/debug_info/overcloud.log

