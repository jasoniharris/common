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



            - echo "Clone common bash scripts"
            - git clone git@bitbucket.org:cloudnativeservices/bash-scripts.git
            - echo "Deploying to S3"
            - mv $BITBUCKET_CLONE_DIR/cloudformation-templates/iam.yaml iam.yaml
            - mv $BITBUCKET_CLONE_DIR/parameter-files/iam-parameters.json iam-parameters.json
            - zip -r artifact.zip iam.yaml iam-parameters.json
            - aws s3 cp artifact.zip s3://adfs-iam-src-bkt-439363829178 --sse aws:kms
            - cd bash-scripts/bin
            - chmod +x track-delivery-pipeline.sh
            - ./track-delivery-pipeline.sh "adfs-iam-pipeline"