#!/usr/bin/env bash
######################################
# Author: Jason Harris
# Function: File to deploy a Cloudformation template
#
#*************************************
# Ver * Who * Date * Comments
#*************************************
# 1.0 * JH * 12/11/19 * Initial Version

. ./logging.sh

aws cloudformation deploy --template-file ${1} --stack-name ${2} --capabilities CAPABILITY_NAMED_IAM
