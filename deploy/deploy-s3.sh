#!/bin/bash

# exit when any command fails
set -eE -o functrace

if [[ -f ./create-bucket.sh ]]; then
  cd ..
fi

if [[ ! -f ./index.html ]]; then 
  printf "Expecting an index.html file at minimum. Exiting!\n"
  exit 1
fi

if [[ ! -f deploy/.env ]]; then
  printf "No deploy/.env environment variable file found.\n"
  printf "See deploy/.env.example for details.\n"
  exit 1
fi

source deploy/.env

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

aws s3 cp . s3://$WEB_BKT_NAME/ --recursive --profile $AWS_PROFILE

BKT_URL="http://$WEB_BKT_NAME.s3-website.$AWS_REGION.amazonaws.com"

printf "\n\nDeployed to: $BKT_URL\n\n"