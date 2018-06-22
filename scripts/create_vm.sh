vlan1=$(neutron net-list | grep vlan1 | awk '{print $2}')
vxlan1=$(neutron net-list | grep vxlan1 | awk '{print $2}')
#vlan2=$(neutron net-list | grep vlan2 | awk '{print $2}')
#vlan3=$(neutron net-list | grep vlan3 | awk '{print $2}')

#vlan_v6_1=$(neutron net-list | grep vlan_v6_1 | awk '{print $2}')
#vlan_v6_2=$(neutron net-list | grep vlan_v6_2 | awk '{print $2}')
#vlan_v6_3=$(neutron net-list | grep vlan_v6_3 | awk '{print $2}')


echo "creating vm1 on net1 host1"
openstack server create --flavor m1.small --image cirros --nic net-id=$vlan1 --security-group SSH --key-name RDO_KEY --availability-zone nova:compute-1.localdomain vlan1_host1_vm1
vlan1_host1_vm1_ip=$(nova show vlan1_host1_vm1 | grep network | awk '{print $5}')
sleep 50
nova console-log vlan1_host1_vm1
#nova console-log vlan1_host1_vm1 | grep eth0 | grep $vlan1_host1_vm1_ip && echo "IP allocated to VM" || echo "vm didnot get ip"
FIP111=$(neutron floatingip-create public | grep floating_ip_address |awk '{print $4}')
sleep 30
openstack server add floating ip vlan1_host1_vm1 $FIP111

echo "creating vm2 on net2 host2"
openstack server create --flavor m1.small --image cirros --nic net-id=$vxlan1 --security-group SSH --key-name RDO_KEY --availability-zone nova:compute-0.localdomain vxlan1_host0_vm1
vxlan1_host0_vm1_ip=$(nova show vxlan1_host0_vm1 | grep network | awk '{print $5}')
sleep 50
nova console-log vxlan1_host0_vm1
#nova console-log vxlan1_host0_vm1 | grep eth0 | grep $vxlan1_host0_vm1_ip && echo "IP allocated to VM" || echo "vm didnot get ip"
FIP121=$(neutron floatingip-create public | grep floating_ip_address |awk '{print $4}')
sleep 30
openstack server add floating ip vxlan1_host0_vm1 $FIP121

ping -c4 $FIP121
ping -c4 $FIP111


#openstack server create --flavor m1.small --image cirros --nic net-id=$vlan1 --security-group SSH --key-name RDO_KEY --availability-zone nova:overcloud-novacompute-0.localdomain net1_host1_vm1

#openstack server create --flavor m1.small --image cirros --nic net-id=$vlan2 --security-group SSH --key-name RDO_KEY --availability-zone nova:overcloud-novacompute-0.localdomain net2_host1_vm1

#openstack server create --flavor m1.small --image cirros --nic net-id=$vlan3 --security-group SSH --key-name RDO_KEY --availability-zone nova:overcloud-novacompute-0.localdomain net3_host1_vm1

#openstack server create --flavor m1.small --image cirros --nic net-id=$vlan_v6_1 --security-group SSH --key-name RDO_KEY --availability-zone nova:overcloud-novacompute-0.localdomain net_v6_1_host1_vm1

#openstack server create --flavor m1.small --image cirros --nic net-id=$vlan_v6_2 --security-group SSH --key-name RDO_KEY --availability-zone nova:overcloud-novacompute-0.localdomain net_v6_2_host1_vm1

#openstack server create --flavor m1.small --image cirros --nic net-id=$vlan_v6_3 --security-group SSH --key-name RDO_KEY --availability-zone nova:overcloud-novacompute-0.localdomain net_v6_3_host1_vm1
