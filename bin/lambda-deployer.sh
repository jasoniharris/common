#!/usr/bin/env bash

DB_TABLE=`aws cloudformation describe-stacks --stack-name wedding-infrastructure --query "Stacks[0].Outputs[?OutputKey=='RSVPDynamodbTable'].OutputValue" --output text --profile jh-pipeline`
ROLE=`aws cloudformation describe-stacks --stack-name wedding-infrastructure --query "Stacks[0].Outputs[?OutputKey=='IAMLambdaServiceRole'].OutputValue" --output text --profile jh-pipeline`

echo "DBTABLE is ${DB_TABLE}"
echo "ROLE is ${ROLE}"
sam package \
  --template-file template.yml \
  --output-template-file package.yml \
  --s3-bucket harris-wedding-lambda-retrieve \
  --profile jh-pipeline

sam deploy \
  --template-file package.yml \
  --stack-name harris-wedding-lambda-retrieve \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides DBTABLE=$DB_TABLE ROLE=$ROLE \
  --profile jh-pipeline