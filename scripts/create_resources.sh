#Create cirros image
openstack image create --disk-format qcow2 --public --file cirros-0.3.5-x86_64-disk.img --container-format=bare cirros && echo "cirros image created" || echo "cirros image creation failed"

# Create CentOS image
#openstack image create --disk-format qcow2 --public --file CentOS-7-x86_64-GenericCloud.qcow2 --container-format=bare centos && echo "centos image created" || echo "centos image creation failed"

# Create flavor
openstack flavor create m1.small --id 2 --ram 2048 --disk 20 --vcpus 1 && echo "m1.small flavor created" || echo "m1.small flavor creation failed"

# Create SG
openstack security group create SSH --description add_ssh_rules && echo "SSH SG created" || echo "SSH SG creation failed"

# Add ssh rule to security group
openstack security group rule create SSH --protocol tcp --dst-port 22:22 --remote-ip 0.0.0.0/0 && echo "SSH rule to SSH group added" || echo "adding SSH rule to SSH group failed"
#openstack security group rule create SSH --protocol tcp --dst-port 22:22 --remote-ip ::0/0 --ethertype IPv6 && echo "SSH rule to SSH group added" || echo "adding SSH rule to SSH group failed"

openstack security group rule create SSH --protocol icmp && echo "image created" || echo "image creation failed"
#openstack security group rule create SSH --protocol ipv6-icmp && echo "image created" || echo "image creation failed"

# Create keypair
openstack keypair create RDO_KEY > MY_KEY.pem && echo "keypair created" || echo "keypair creation failed"
chmod 600 MY_KEY.pem

