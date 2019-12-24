#!/bin/bash

openstack loadbalancer show $1 -c name -c vip_address -c vip_port_id
openstack loadbalancer amphora list --loadbalancer $1 -c id -f value|xargs -I{} openstack loadbalancer amphora show {} -c name -c compute_id -c image_id -c lb_network_ip -c role
echo -n "image name: "
openstack loadbalancer amphora list --loadbalancer $1 -c id -f value|head -1 |xargs -I{} openstack loadbalancer amphora show {} -c image_id -f value |xargs glance image-show |grep name |awk '{print $4}'
