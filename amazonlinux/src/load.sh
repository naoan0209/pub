#!/bin/bash

set -a
source ./sample.env
set +a

echo "$TEST_ENV"
echo "$DUMMY_ENV"
echo "$NOW"

bash ./echo.sh
