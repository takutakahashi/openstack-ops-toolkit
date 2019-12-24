#!/bin/bash

glance image-create --file amphora-x64-haproxy.qcow2 \
--disk-format qcow2 --visibility private --progress \
--container-format bare --name $1
