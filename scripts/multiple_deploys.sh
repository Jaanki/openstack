rm -rf ~/multiple
rm -rf debug_info
source ~/overcloudrc
./cleanup.sh
source ./functions.sh

Deployed=0
Deploy_Failed=0
Validation_Failed=0
DEPLOY_FOR=$1
INIT=0

if [[ ! -e cirros-0.3.5-x86_64-disk.img ]]; then
  ./get_images.sh # Download cirros image
fi

while [ $INIT -lt $DEPLOY_FOR ]; do
  mkdir -p ~/multiple/$INIT/snat ~/multiple/$INIT/fip
  echo "Starting overcloud delete" $(date) >> ~/multiple/$INIT/delete_overcloud.log
  delete_overcloud >> ~/multiple/$INIT/delete_overcloud.log
  echo "Completed overcloud delete" $(date) >> ~/multiple/$INIT/delete_overcloud.log
  sleep 60
  echo "Starting overcloud deploy" $(date) >> ~/multiple/$INIT/deploy_overcloud.log
  deploy_overcloud >> ~/multiple/$INIT/deploy_overcloud.log
  if [ $? != 0 ]; then
    echo "deployment failed. check logs for reasons"
    check_failed_deployment ~/multiple/$INIT
    exit
  else
    echo "Completed overcloud deploy" $(date) >> ~/multiple/$INIT/deploy_overcloud.log
    ./ssh_to_overcloud_nodes.sh >> ~/multiple/$INIT/nodesrc
    sleep 60
    echo "Starting overcloud validate" $(date) >> ~/multiple/$INIT/validate_overcloud.log
    validate_snat 4 >> ~/multiple/$INIT/snat/validate_overcloud.log
    mv ~/ping_gw.sh ~/multiple/$INIT/snat
    validate_fip >> ~/multiple/$INIT/fip/validate_overcloud.log
    echo "Completed overcloud validate" $(date) >> ~/multiple/$INIT/validate_overcloud.log
    ./check_ovs_flows.sh >> ~/multiple/$INIT/ovs_flows.log
    ./collect_debug_info.sh
  fi
  INIT=$((INIT + 1))
  sleep 60
done

echo "Completed"
echo "Total deployments" $DEPLOY_FOR >> ~/multiple/validations.txt
echo "Successful deployments" $Deployed >> ~/multiple/validations.txt
echo "    of which" $Validation_Failed "failed validations" >> ~/multiple/validations.txt
echo "Failed deployments" $Deploy_Failed >> ~/multiple/validations.txt
