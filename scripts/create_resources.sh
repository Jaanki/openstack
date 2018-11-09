source ~/overcloudrc

if [ ! -f cirros-0.3.5-x86_64-disk.img ]; then
  ./get_images.sh
fi
#Create cirros image
openstack image create --disk-format qcow2 --public --file cirros-0.3.5-x86_64-disk.img --container-format=bare cirros
echo "cirros image created"

# Create CentOS image
#openstack image create --disk-format qcow2 --public --file CentOS-7-x86_64-GenericCloud.qcow2 --container-format=bare centos
#echo "centos image created"

# Create flavor
openstack flavor create m1.small --id 2 --ram 2048 --disk 20 --vcpus 1
echo "m1.small flavor created"

# Create SG
openstack security group create SSH --description add_ssh_rules
echo "SSH SG created"

# Add ssh rule to security group
openstack security group rule create SSH --protocol tcp --dst-port 22:22 --remote-ip 0.0.0.0/0
echo "SSH rule to SSH group added"
#openstack security group rule create SSH --protocol tcp --dst-port 22:22 --remote-ip ::0/0 --ethertype IPv6
echo "SSH6 rule to SSH group added"

openstack security group rule create SSH --protocol icmp
echo "ICMP SSH rule created"
#openstack security group rule create SSH --protocol ipv6-icmp
#echo "ICMP6 SSH rule created"

# Create keypair
openstack keypair create RDO_KEY > MY_KEY.pem
chmod 600 MY_KEY.pem
echo "keypair created"
