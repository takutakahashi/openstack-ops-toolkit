#!/bin/bash -ex
LB_NAME=$1
PORT=$2
AMPHORA_IMAGE_ID=$3
ADDRESS=$4

glance image-show $AMPHORA_IMAGE_ID || exit 1

echo create loadbalancer
./create_lb_with_image.sh $LB_NAME $AMPHORA_IMAGE_ID

LB_ID=`openstack loadbalancer list --name $LB_NAME -c id -f value`

echo create listener
openstack loadbalancer listener create --name $LB_NAME-listener --protocol TCP --protocol-port $PORT $LB_ID
./wait.sh $LB_ID
echo create pool
openstack loadbalancer pool create --name $LB_NAME-pool --protocol TCP --listener $LB_NAME-listener --lb-algorithm ROUND_ROBIN
./wait.sh $LB_ID
if [ "$ADDRESS" = "" ]; then
  echo create instance for member
  ./create_instance.sh $LB_NAME-member
  echo wait
  sleep 10
  ADDRESS=`openstack server list --name $LB_NAME-member -c Networks -f value |awk -F'=' '{print $2}'`
fi
echo create member
openstack loadbalancer member create --name $LB_NAME-member --address $ADDRESS --protocol-port $PORT $LB_NAME-pool
./wait.sh $LB_ID
echo create healthmonitor
openstack loadbalancer healthmonitor create --name $LB_NAME-hm --delay 60 --timeout 30 --max-retries 3 --type TCP $LB_NAME-pool
./wait.sh $LB_ID
echo add floating ip
VIP_PORT_ID=`openstack loadbalancer show $LB_ID -c vip_port_id -f value`
FLOATING_IP_ID=`openstack floating ip list --project $TARGET_PROJECT|grep None |awk '{print $2}' |head -1`
openstack floating ip set --port $VIP_PORT_ID $FLOATING_IP_ID
echo attached floating ip. details below:
openstack floating ip show $FLOATING_IP_ID
