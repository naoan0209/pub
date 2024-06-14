#!/bin/bash
BUCKET="s3-mount-977566148511"
MOUNT_POINT="/mnt/app"

sleep 10

# mkdir -p "${MOUNT_POINT}"
# chmod 777 "${MOUNT_POINT}"

# マウントされていたらスキップ
if mountpoint -q "${MOUNT_POINT}"; then
    echo "${MOUNT_POINT} is already mounted."
else
    echo "${MOUNT_POINT} is not mounted. Proceeding with mount."
    # デバイスをマウント
    mount-s3 "${BUCKET}" "${MOUNT_POINT}" --allow-delete --allow-other
    if [ $? -eq 0 ]; then
        echo "Mount successful."
    else
        echo "Mount failed."
    fi
fi

exit 0
#EOF
