# run ping_gw 20 times. Create 10 ntwrks attached to each router. ping google from NS. Delete routers, networks. create again



#source ~/stackrc
#openstack stack delete overcloud --yes --wait
#./overcloud_deploy.sh

rm -rf

INIT=0
COUNT=20
mkdir gw

while [ $INIT -lt $COUNT ]; do
  mkdir gw/$INIT
  ./ping_gw_scenario.sh >> gw/$INIT/ping.log || (python send_mail_deploy.py && exit 1)
  ./cleanup.sh >> gw/$INIT/cleanup.log || (python send_mail_deploy.py && exit 1)
  INIT=$((INIT + 1))
  sleep 60
done



