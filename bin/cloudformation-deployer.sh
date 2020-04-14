#!/usr/bin/env bash
######################################
# Author: Jason Harris
# Function: Program to deploy a Cloudformation template
#
#*************************************
# Ver * Who * Date * Comments
#*************************************
# 1.0 * JH * 12/11/19 * Initial Version

. ./logging.sh

cd ${GITHUB_WORKSPACE}/cloudformation-templates

deploy (){
    einfo "Deploying: ${1}"
    aws cloudformation deploy --template-file ${1} --stack-name ${2} --capabilities CAPABILITY_NAMED_IAM --no-fail-on-empty-changeset
    check_output $?
}

deploy "$1" "$2"
