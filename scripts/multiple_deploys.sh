rm -rf ~/multiple
Deployed=0
Deploy_Failed=0
Validation_Failed=0
DEPLOY_FOR=$1
INIT=0

function delete() {
  echo "Deleting overcloud"
  source ~/stackrc
  openstack stack delete overcloud --yes --wait
}


function check_failed_deployment() {
  ./check_failed_deployment.sh $1
}

function deploy() {
  source stackrc
  echo "deploying overcloud"
  ./deploy_overcloud.sh
  if [ $? == 0 ]; then
    Deployed=$((Deployed + 1))
  else
    Deploy_Failed=$((Deploy_Failed + 1))
    python send_mail.py
    exit 1
  fi
}

function validate() {
  source ~/overcloudrc
  ./create_resources.sh \
  && ./create_vlan_network.sh \
  && ./create_vxlan_network.sh \
  && ./create_public_network.sh \
  && ./create_router.sh \
  && ./create_vm.sh \
  && ./check_ovs_flows.sh \
  ||  Validation_Failed=$((Validation_Failed+1)) && exit 1
}

if [[ ! -e cirros-0.3.5-x86_64-disk.img ]]; then
  ./get_images.sh # Download cirros image
fi

while [ $INIT -lt $DEPLOY_FOR ]; do
  mkdir -p ~/multiple/$INIT
  echo "Starting overcloud delete" $(date) >> ~/multiple/$INIT/delete_overcloud.log
  delete >> ~/multiple/$INIT/delete_overcloud.log
  echo "Completed overcloud delete" $(date) >> ~/multiple/$INIT/delete_overcloud.log
  echo "Starting overcloud deploy" $(date) >> ~/multiple/$INIT/deploy_overcloud.log
  deploy >> ~/multiple/$INIT/deploy_overcloud.log
  if [ $? != 0 ]; then
    echo "deployment failed. check logs for reasons"
    check_failed_deployment ~/multiple/$INIT
    exit 1
  else
    echo $? >> ~/multiple/$INIT/deploy_overcloud.log
    echo "Completed overcloud deploy" $(date) >> ~/multiple/$INIT/deploy_overcloud.log
    echo "Starting overcloud validate" $(date) >> ~/multiple/$INIT/validate_overcloud.log
    ./ssh_to_overcloud_nodes.sh
    validate >> ~/multiple/$INIT/validate_overcloud.log
    if [ $? == 0 ]; then
      echo "Completed overcloud validate" $(date) >> ~/multiple/$INIT/validate_overcloud.log
    else
      echo "validation failed. see logs at ~/multiple/"$INIT"/validate_overcloud.log"
      python send_mail.py
      exit
    fi
  fi
  INIT=$((INIT + 1))
done

echo "Completed"
echo "Total deployments" $DEPLOY_FOR >> ~/multiple/validations.txt
echo "Successful deployments" $Deployed >> ~/multiple/validations.txt
echo "    of which" $Validation_Failed "failed validations" >> ~/multiple/validations.txt
echo "Failed deployments" $Deploy_Failed >> ~/multiple/validations.txt