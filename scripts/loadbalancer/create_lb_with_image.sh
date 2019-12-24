#!/bin/bash -e
PREV_IMAGE_ID=`glance image-list --tag amphora |grep amphora |awk '{print $2}'`
NOW_IMAGE_ID=$2
LB_NAME=$1
echo change amphora
./champhora.sh $NOW_IMAGE_ID
echo create loadbalancer
openstack loadbalancer create --name $LB_NAME --vip-network-id $TARGET_VIP_NETWORK_ID
while [ "`openstack loadbalancer show $LB_NAME -c provisioning_status -f value`" != "ACTIVE" ]
do
  echo -n .
  sleep 1
done
./champhora.sh $PREV_IMAGE_ID
