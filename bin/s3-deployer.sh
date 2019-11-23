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

deploy (){
    template=${1}.${2}
    paramFile="${1}-parameters.json"
    einfo "Deploying ${template}"
    mv cloudformation-templates/${template} ${template}
    mv parameter-files/${paramFile} ${paramFile}
    zip -r artifact.zip ${template} ${paramFile}
    aws s3 cp artifact.zip s3://wedding-infrastructure-src-bkt-728887003700 --sse aws:kms
    check_output $?
}

deploy "${1}" "${2}"