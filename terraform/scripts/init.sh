#!/usr/bin/env bash
set -eo pipefail

# Ensure that aws cli doesn't open tools like 'less' for showing results
export AWS_PAGER=""

# Input variables
export ACCOUNT_ID=$(aws sts get-caller-identity --output=json | jq -r .Account)
REGION=$(jq -r .region ../common.tfvars.json)
USE_CASE=$(jq -r .use_case ../common.tfvars.json) # Optional
REPOSITORY=$(jq -r .repository ../common.tfvars.json) # Used in state key if USE_CASE is not set
SERVICE=$(jq -r .service ./service.tfvars.json)

# Print the information about the AWS account in which we currently operate to stdout
aws sts get-caller-identity

USE_CASE_OR_REPOSITORY=$([[ -n "${USE_CASE}" && "${USE_CASE}" != "null" ]] && echo "${USE_CASE}" || echo "${REPOSITORY}")
STATE_BUCKET=terraform-state-${ACCOUNT_ID}-${REGION}
STATE_BUCKET_KEY=${USE_CASE_OR_REPOSITORY}/${STAGE}/${SERVICE}.tfstate
echo "Using state bucket '${STATE_BUCKET}' with key '${STATE_BUCKET_KEY}'"

# enforce a new terraform init
#if [ -d "./.terraform" ]; then
#  rm -rf .terraform
#fi

if [[ -f .terraform/terraform.tfstate ]] ; then
  OLDBUCKET=$(jq -r .backend.config.bucket .terraform/terraform.tfstate)
  echo "found existing tfstate file referring to bucket ${OLDBUCKET}"
  OLDKEY=$(jq -r .backend.config.key .terraform/terraform.tfstate)
  echo "found existing tfstate file referring to key ${OLDKEY}"
else
  OLDBUCKET=""
  OLDKEY=""
fi
 
if [[ "${STATE_BUCKET}" != "${OLDBUCKET}" || "${STATE_BUCKET_KEY}" != "${OLDKEY}" ]]; then
    # this statefile uses a different state bucket and/or lock and needs to be removed
    echo "removing existing .terraform folder"
    rm -rf .terraform # fresh init, because we want to switch to state of other account
else
    echo "existing .terraform folder refers same statefile and key, re-using it"
fi

terraform init \
  $([[ "${UPGRADE_PROVIDERS}" == "true" ]] && echo "-upgrade") \
  -backend-config="bucket=${STATE_BUCKET}" \
  -backend-config="key=${STATE_BUCKET_KEY}" \
  -backend-config="dynamodb_table=terraform-state-lock" \
  -backend-config="region=${REGION}" \
  -reconfigure