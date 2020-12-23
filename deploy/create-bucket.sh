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
  printf "Environment variable WEB_BKT_NAME missing\n"
  exit 1
fi

if [[ -z $AWS_PROFILE ]]; then
  printf "Environment variable AWS_PROFILE missing\n"
  exit 1
fi

if [[ -z $AWS_REGION ]]; then
  printf "Environment variable AWS_REGION missing\n"
  exit 1
fi

if [[ -z $CORS_FILE ]]; then
  printf "Environment variable CORS_FILE mising\n"
  exit 1
fi

set -x

aws s3api create-bucket \
  --bucket $WEB_BKT_NAME \
  --region $AWS_REGION \
  --acl public-read \
  --create-bucket-configuration LocationConstraint=$AWS_REGION \
  --profile $AWS_PROFILE

aws s3 website s3://$WEB_BKT_NAME \
  --index-document index.html \
  --error-document index.html \
  --profile $AWS_PROFILE

aws s3api put-bucket-policy \
  --bucket $WEB_BKT_NAME \
  --policy "{\"Statement\": [{\"Effect\": \"Allow\", \"Principal\": \"*\", \"Action\": \"s3:GetObject\",\"Resource\": \"arn:aws:s3:::$WEB_BKT_NAME/*\"}]}" \
  --profile $AWS_PROFILE

aws s3api put-bucket-cors \
  --bucket $WEB_BKT_NAME \
  --cors-configuration file://$CORS_FILE \
  --profile $AWS_PROFILE

BKT_URL="http://$WEB_BKT_NAME.s3-website.$AWS_REGION.amazonaws.com"

BTK_URL_FILE=$(pwd)/$WEB_BKT_NAME.txt

printf "\n\nBucket website url $BKT_URL saving to $BTK_URL_FILE\n\n"

echo $BKT_URL > $BTK_URL_FILE