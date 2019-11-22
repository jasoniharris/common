#!/usr/bin/env bash
######################################
# Author: Jason Harris
# Function: File to validate json files
# Iterate over the cloudformation templates
# Pre Requisits: AWS CLI, JQ
#
#*************************************
# Ver * Who * Date * Comments
#*************************************
# 1.0 * JH * 12/11/19 * Initial Version

. ./logging.sh

process_cf_templates () {
    case ${1} in
        "json")
                key="json"
                ;;
        "yaml")
                key="yaml"
                ;;
        *)
                eerror "Unknown key supplied. Please supply json | yaml."
                check_output 2
                ;;
    esac

    cf_templates=`ls ${cf_resources_directory}/cloudformation-templates/*.${key}`

    for filename in ${cf_templates}
    do
        base_filename=$(basename ${filename})

        einfo "Working: ${base_filename}"

        cf_template_basename=`echo ${base_filename} | cut -f1 -d"."`

        validate_filename ${cf_template_basename}

        if [[ `find ${cf_resources_directory}/parameter-files -name ${cf_template_basename}-parameters.json` ]]
        then
            einfo "Working: ${filename}"
            cd ${cf_resources_directory}/cloudformation-templates
            validate_template ${filename}
            einfo "Working: ${cf_template_basename}-parameters.json"
            cd ${cf_resources_directory}/parameter-files
            validate_json ${cf_resources_directory}/parameter-files/${cf_template_basename}-parameters.json
        else
            eerror "Matching parameter file not found for: ${base_filename}"
            check_output 2
        fi
    done
    eok "Processing completed."
}

validate_filename (){
    if [[ ${1} =~ [[:upper:]] ]]
    then
        eerror "Filename contains uppercase character(s): ${1}"
        check_output 2
    fi
}

validate_template (){
    einfo "Validating: ${1}"
    aws cloudformation validate-template --template-body file://${1}
    check_output $?
}

validate_json (){
    einfo "Validating: ${1}"
    cat ${1} | jq empty
    check_output $?
}

if [[ -z $1 ]]
then
    eerror "Please supply directory of Cloudformation Templates"
    exit $?
else
    cf_resources_directory=$1
fi

process_cf_templates "json"
process_cf_templates "yaml"
