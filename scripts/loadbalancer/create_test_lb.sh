#!/bin/bash
IMAGE_ID=`glance image-list --tag amphora |grep amphora |awk '{print $2}'`
TIMESTAMP=`date "+%Y%m%d-%H%M%S"`
LB_NAME=function-test-lb-${TIMESTAMP}
./create_lb.sh $LB_NAME 80 $IMAGE_ID $TARGET_IP
LB_ID=`openstack loadbalancer list --name $LB_NAME -c id -f value`
FIP=`./fip_from_lb.sh $LB_ID`
ssh base httping -c 100 $FIP
