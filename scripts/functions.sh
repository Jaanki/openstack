function associate_fip() {
  INIT=$1
  FIP_ID=$2
  INDEX=$3
  FIP=$(neutron floatingip-list | grep $FIP_ID | awk '{print $7}')
  sleep 30
  VM_IP=$(openstack server list | grep vm$INDEX | grep -o '=[^ ]*' | tr -d '=')
  VM_PORT=$(neutron port-list | grep $VM_IP | awk '{print $2}')
  neutron floatingip-associate $FIP_ID $VM_PORT
  echo "Pinging FIP " $FIP
  ping -c4 $FIP
}

function check_failed_deployment() {
  ./check_failed_deployment.sh $1
}

function delete_overcloud() {
  echo "Deleting overcloud"
  source ~/stackrc
  openstack stack delete overcloud --yes --wait
}

function deploy_overcloud() {
  source ~/stackrc
  echo "deploying overcloud"
  ./overcloud_deploy.sh
  if [ $? == 0 ]; then
    Deployed=$((Deployed + 1))
  else
    Deploy_Failed=$((Deploy_Failed + 1))
    python send_mail_deploy.py
    exit 1
  fi
}

function dissociate_fip() {
  # Dissociate FIPs
  echo "Dissociationg FIPs"
  for fip in $(openstack floating ip list --format=value -c ID)
  do
    neutron floatingip-disassociate $fip
  done
}

function get_logs_for_container() {
ip=$1
node=$2
for service in "${@:3}"
do
  mkdir -p ~/debug_info/$service/$node
  scp -oStrictHostKeyChecking=no -r heat-admin@$ip:/var/log/containers/$service/* ~/debug_info/$service/$node/.
done
}

function get_logs_for_service() {
ip=$1
node=$2
for service in "${@:3}"
do
  mkdir -p ~/debug_info/$service/$node
  scp -oStrictHostKeyChecking=no -r heat-admin@$ip:/home/heat-admin/$service/* ~/debug_info/$service/$node/.
done
}

function validate_fip() {
  source ~/overcloudrc
  ./associate_fip.sh 4 \
  && ./reassociate_fip.sh 4 \
  ||  (Validation_Failed=$((Validation_Failed+1)) && python send_mail.py && exit 1)
}

function validate_snat() {
  source ~/overcloudrc
  ./create_resources.sh \
  && ./create_vlan_network.sh 0 \
  && ./create_vxlan_network.sh $1 \
  && ./create_public_network.sh \
  && ./create_router.sh $1 \
  && ./create_vm.sh $1 \
  && ./ping_gw_scenario.sh $1 \
  ||  (Validation_Failed=$((Validation_Failed+1)) && python send_mail.py && exit 1)
}
