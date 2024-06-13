#!/bin/bash

BUCKET="s3-mount-977566148511"
MOUNT="/mnt"

mkdir -p "${MOUNT}"
mount-s3 "${BUCKET}" "${MOUNT}" --allow-delete

#EOF
