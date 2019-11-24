#!/usr/bin/env bash
######################################
# Author: Jason Harris
# Function: File to deploy SAM Lambda functions
#
#*************************************
# Ver * Who * Date * Comments
#*************************************
# 1.0 * JH * 12/11/19 * Initial Version

. ./logging.sh

package(){
sam package \
  --template-file template.yml \
  --output-template-file package.yml \
  --s3-bucket ${1}
check_output $?
}

deploy(){
sam deploy \
  --template-file package.yml \
  --stack-name ${1} \
  --capabilities CAPABILITY_IAM
check_output $?
}

package "$1"
deploy "$1"


