#!/bin/bash -e
PREV_IMAGE_ID=`glance image-list --tag amphora |grep amphora |awk '{print $2}'`
NOW_IMAGE_ID=$1
test "$PREV_IMAGE_ID" = "$NOW_IMAGE_ID" && exit 0
echo ==== from $PREV_IMAGE_ID to $NOW_IMAGE_ID ====
glance image-show $NOW_IMAGE_ID || exit 1
glance image-tag-delete $PREV_IMAGE_ID amphora
glance image-tag-update $NOW_IMAGE_ID amphora
