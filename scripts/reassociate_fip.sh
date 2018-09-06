source ~/overcloudrc
source ./functions.sh

INIT=0
COUNT=$1

declare -A FIPS

# Get all FIPs
while [ $INIT -lt $COUNT ]; do
  FIPS[$INIT]=$(openstack server list | grep vm$INIT | grep -o "10.0.[^ ]*")
  INIT=$((INIT + 1))
done

openstack server list
echo ${FIPS[@]}  # [FIP0, FIP1, FIP2, FIP3]

dissociate_fip

INIT=0
# Re-associate same FIPs
while [ $INIT -lt $COUNT ]; do
  INDEX=$INIT
  echo " Associating same FIP"
  FIP_ID=$(openstack floating ip list | grep ${FIPS[$INIT]} | awk '{print $2}')
  associate_fip $INIT $FIP_ID $INDEX
  INIT=$((INIT + 1))
done

openstack server list
echo ${FIPS[@]} # [FIP0, FIP1, FIP2, FIP3]

dissociate_fip

INIT=0
# Re-associate different FIPs
while [ $INIT -lt $COUNT ]; do
  INDEX=$((INIT + 1))
  if [[ $INDEX == 4 ]]; then
    INDEX=0
  fi
  echo "Associating different FIP"
  FIP_ID=$(openstack floating ip list | grep ${FIPS[$INIT]} | awk '{print $2}')
  associate_fip $INIT $FIP_ID $INDEX
  INIT=$((INIT + 1))
done

openstack server list
echo ${FIPS[@]} # [FIP3, FIP0, FIP1, FIP2]
