# clean up resources

source ~/overcloudrc
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
done

# delete networks
openstack network delete $(openstack network list -c Name --format=value)
if [ $? != 0 ]; then
  echo "network deletion failed"
fi
