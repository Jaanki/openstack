. ~stack/stackrc
echo "Checking for ovs tables on each overcloud node"
for i in $(openstack server list -f value -c Networks | awk -F= '{print $2}'); do echo "working on $i"; ssh -oStrictHostKeyChecking=no heat-admin@$i "sudo ovs-ofctl dump-flows br-int -OOpenFlow13 | egrep -v 'table=(0|220)' | awk '{print \$3}' | uniq | awk -F= '{print \$2}' | awk -F, '{print \$1}' | wc -l"; done
echo "ovs tables checked"


#flow_tables="17 18 19 20 22 23 24 43 45 48 50 51 60 80 81 90 210 211 212 213 214 215 216 217 239 240 241 242 243 244 245 246 247"
#for table in $flow_tables; do ovs-ofctl -O openflow13 dump-flows br-int | grep $table; done
