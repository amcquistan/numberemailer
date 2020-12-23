#!/bin/bash

# exit when any command fails
set -eE -o functrace

if [[ -z $WEB_BKT_NAME  ]]; then
  printf "Environment variable REACT_BKT_NAME missing\n"
  exit 1
fi

if [[ -z $AWS_PROFILE ]]; then
  printf "Environment variable AWS_PROFILE missing\n"
  exit 1
fi

set -x

aws s3 rm s3://$WEB_BKT_NAME/ --recursive --profile $AWS_PROFILE

aws s3 rb s3://$WEB_BKT_NAME --profile $AWS_PROFILE
