# only 4 VMs. 1 VM on each compute.

source ~/overcloudrc
INIT=0
COUNT=$1
if [ $COUNT -gt 4 ]; then
  echo "spawning only 4 VMs, 1 on each compute"
  COUNT=4
fi
if [ $COUNT -lt 2 ]; then
  echo "spawning 2 VMs minimum, 1 on each compute"
  COUNT=2
fi
tmp=0
if [ $COUNT = 0 ]; then
  echo "no VM created"
fi
zone=$(openstack availability zone list --compute --long | grep nova-compute | awk '{print $2}' | uniq)
hosts=$(openstack availability zone list --compute --long | grep nova-compute | awk '{print $7}')
az=$(openstack availability zone list --compute --long | grep nova-compute | awk '{print $7}'| wc -l)
while [ $INIT -lt $COUNT ]; do
  for host in $hosts; do
    while [ $tmp -lt $((COUNT/az)) ]; do
      echo "spawning vm"$INIT "on availability zone" $zone:$host
      openstack server create --flavor m1.small --image cirros --nic net-id=vxlan$INIT --security-group SSH --key-name RDO_KEY --availability-zone $zone:$host vm$INIT
      sleep 50
      nova console-log vm$INIT
      if [[ $2 != "fip" ]]; then
        echo "NO FIP attached to VM"
      else
        FIP_ID=$(neutron floatingip-create public | awk '{if(NR==10) print $4}')
        FIP=$(neutron floatingip-list | grep $FIP_ID | awk '{print $7}')
        sleep 30
        VM_IP=$(openstack server list | grep vm$INIT | grep -o '=[^ ]*' | tr -d '=')
        VM_PORT=$(neutron port-list | grep $VM_IP | awk '{print $2}')
        neutron floatingip-associate $FIP_ID $VM_PORT
        ping -c4 $FIP
      fi
      tmp=$((tmp + 1))
      INIT=$((INIT + 1))
    done
  tmp=0
  done
done
