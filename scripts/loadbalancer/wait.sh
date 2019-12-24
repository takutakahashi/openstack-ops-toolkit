#!/bin/bash

while openstack loadbalancer status show $1|grep PENDING;
do 
  sleep 1
done
