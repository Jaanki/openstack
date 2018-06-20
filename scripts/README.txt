# Deploy overcloud via quickstart
# It is assumed that you have an undercloud deployed and are logged into undercloud with "stack" user

# Prepare container images for the deployment. Change the argument to "downstream" to fetch downstream container images with latest tags.
# This script will create "docker_registry.yaml" file and upload all the images to local registry
./prepare_container.sh upstream

# Deploy overcloud with "docker_registry.yaml" file and ODL enabled in HA. 3 controllers, 1 compute
./deploy_overcloud.sh

# To create overcloud resources and ping a VM, run the scripts in below sequence
./create_resources.sh  # creates cirros image, SSH and ICMP SG, m1.small flavor and keypair

# Create 1 vlan network "vlan1" with vlan tag 1
./create_network.sh

# Create vlan public network on vlan 10
./create_public_network.sh

# Create "router 1", attach to vlan1 net and public gateway
./create_router.sh

# Create VM net1_host1_vm1 on net1 with cirros image, m1.small flavor and SSH,ICMP SG, attach FIP and ping it
./create_vm.sh

# There is also multiple_deploy.sh script which deletes the stack, deploys it and validates the deployment.
# Validation includes creating resources, network, VM and pinging its FIP.
./multiple_deploy.sh
