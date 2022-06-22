#!/usr/bin/env bash
set -eo pipefail

# source check_arguments in order to be able to access the variables and environment variables set there
source ../scripts/check_arguments.sh

# Initialize terraform
echo "Initializing..."
../scripts/init.sh

export ACCOUNT_ID=$(aws sts get-caller-identity --output=json | jq -r .Account)
echo "Deploying for AWS account ${ACCOUNT_ID}"

# PLAN: Only run terraform plan. We need this for example in the build pipeline for feature branches
if [[ "${PLAN}" == "true" && -z "${AUTO_APPROVE}" ]]; then
    echo "Performing PLAN only"
    terraform plan -input=false \
      -var "stage=${STAGE}" \
      -var "account_id=${ACCOUNT_ID}" \
      -var-file "../common.tfvars.json" \
      -var-file "./service.tfvars.json" \
      $([[ -n "${STAGE}" ]] && printf %s "-var "stage=${STAGE}"" ) 
    exit 0
fi


# AUTO-APPROVE: Automatically apply changes. We need this for example in the build pipeline to apply changes in non-production
if [[ "${AUTO_APPROVE}" == "true" && -z "${PLAN}" ]]; then
    echo "Automatically applying changes"
    terraform apply -auto-approve \
      -var "stage=${STAGE}" \
      -var "account_id=${ACCOUNT_ID}" \
      -var-file "../common.tfvars.json" \
      -var-file "./service.tfvars.json" \
      $([[ -n "${STAGE}" ]] && printf %s "-var "stage=${STAGE}"" ) 
    exit 0
fi

# INTERACTIVE APPLY: If none of the above has been executed then this is the fallback.
# Interactively apply changes. We use this whenever we execute the script locally on a dev machine
echo "Interactively apply changes"
terraform apply \
      -var "stage=${STAGE}" \
      -var "account_id=${ACCOUNT_ID}" \
      -var-file "../common.tfvars.json" \
      -var-file "./service.tfvars.json" \
  $([[ -n "${STAGE}" ]] && printf %s "-var "stage=${STAGE}"" ) 
exit 0