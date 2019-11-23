#!/usr/bin/env bash
######################################
# Author: Jason Harris
# Function: This shell script tracks the progress of a codepipeline run
#
#*************************************
# Ver * Who * Date * Comments
#*************************************
# 1.0 * JH * 17/05/19 * Initial Version
#

. ./logging.sh

export pipeline=${1}

success="Succeeded"
superseded="Superseded"
fail="Failed"
inProgress="InProgress"
pipelineIDFile="response.json"
pipelineStatusFile="responseStatus.json"
sleepTime=60
counter=0
checkAttempts=3

if [ -z "${AWS_REGION}" ]
then
      export AWS_REGION=${DEFAULT_AWS_REGION}
else
      export AWS_REGION="eu-west-1"
fi

function parseResponse() {
    export counter=$((counter+1))
    if [[ ${counter} -ge ${checkAttempts} ]]
    then
        eerror "Maximum number of retries attempted."
        check_output 2
    fi

    aws codepipeline list-pipeline-executions --pipeline-name ${pipeline} > ${pipelineIDFile}
    export pipelineExecId=`jq --raw-output '.pipelineExecutionSummaries[0].pipelineExecutionId' ${pipelineIDFile}`
    einfo "pipelineExecId is: ${pipelineExecId}"
}

function trackProgress() {
    aws codepipeline get-pipeline-execution --pipeline-name ${pipeline} --pipeline-execution-id ${pipelineExecId}> ${pipelineStatusFile}
    export executionStatus=`jq --raw-output '.pipelineExecution.status' ${pipelineStatusFile}`
}

function processResponse() {
    while [[ ${executionStatus} = ${inProgress} ]]
    do
        einfo "Pipeline in progress, checking again..."
        sleep ${sleepTime}
        trackProgress
    done

    case ${executionStatus} in
        ${success})
            einfo "Pipeline completed successfully!"
            check_output 0
            ;;
        ${superseded})
            eerror "Pipeline completed successfully, however with the status Superseded as another pipeline has run successfully since this one was executed."
            check_output 2
            ;;
        ${fail})
            einfo "Status is fail, however going to wait for ${sleepTime}s to ensure the CodePipeline service has updated to the latest execution ID."
            sleep ${sleepTime}
            parseResponse
            trackProgress
            processResponse
            eerror "Pipeline failed!"
            check_output 2
            ;;
    esac
}


# Run order
sleep ${sleepTime}
parseResponse
trackProgress
processResponse
