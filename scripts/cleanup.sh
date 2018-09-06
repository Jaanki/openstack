source ~/overcloudrc
source ./functions.sh

# Delete FIPs
dissociate_fip
openstack floating ip delete $(openstack floating ip list -c ID --format=value)

# Delete VMs
openstack server delete $(openstack server list -c ID --format=value)

# clean up resources
openstack image delete $(openstack image list -c ID -c Name --format value | grep cirros | awk '{print $1}')
openstack flavor delete $(openstack flavor list -c Name --format value | grep m1.small)
openstack security group delete $(openstack security group list -c ID --format value -c Name | grep SSH | awk '{print $1}')
openstack keypair delete RDO_KEY

# Delete routers
for ROUTER in $(openstack router list -c Name --format=value)
do
  openstack router unset --external-gateway $ROUTER
  for PORT in $(openstack port list --router $ROUTER --format=value -c ID)
  do
    openstack router remove port $ROUTER $PORT
  done
  openstack router delete $ROUTER
  if [ $? != 0 ]; then
    echo $ROUTER "deletion failed"
    exit 1
  fi
done

# delete networks
openstack network delete $(openstack network list -c ID --format=value)
if [ $? != 0 ]; then
  echo "network deletion failed"
fi

