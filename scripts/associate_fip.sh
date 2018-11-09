# Associate FIP to VM
set -e

source ~/overcloudrc
source ./functions.sh

INIT=0
COUNT=$1

while [ $INIT -lt $COUNT ]; do
  INDEX=$INIT
  FIP_ID=$(neutron floatingip-create public | awk '{if(NR==10) print $4}')
  associate_fip $INIT $FIP_ID $INDEX
  INIT=$((INIT + 1))
done
