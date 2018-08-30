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
      until openstack server show vm$INIT | grep -E 'ACTIVE' -B 5; do sleep 1 ; done
      tmp=$((tmp + 1))
      INIT=$((INIT + 1))
    done
  tmp=0
  done
done
