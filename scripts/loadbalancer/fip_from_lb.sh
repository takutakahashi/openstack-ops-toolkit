#!/bin/bash
FIXED_IP=`openstack loadbalancer show $1 -c vip_address -f value`
openstack floating ip show `openstack floating ip list -c ID -f value --fixed-ip-address $FIXED_IP` -c floating_ip_address -f value
