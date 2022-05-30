# FIXME:
# 1 Add your required parameters into the "required parameters" section. Delete 'org-type' as parameter if you don't need it.
# 2 Add your required parameters in the switch-case and export your values instead of using variables. Delete 'org-type' if you don't need it.
# 3 Add a check at the end of the file to check if the required parameter has been set. Remove the checks for 'org-type' if you don't use that parameter.
# 4 Remove this comment so that the file starts with Hash-Bang

#!/usr/bin/env bash
set -eo pipefail


# Show the usage guidance in case something went wrong and exit with a error code.
function show_usage() {
    echo "usage: ./$(basename "${0}") [REQUIRED_PARAMETERS] [OPTIONAL_PARAMETERS]"
    echo "Required Parameters:"
    echo "--stage             : Define in which AWS organisation you want to deploy. Value can be one of [sandbox, nonprod, prod]"
    echo ""
    echo "Optional Parameters:"
    echo "-auto | --auto-approve : Automatically apply all changes (no interactive confirmation)"
    echo "--plan                 : Only run terraform plan"
    echo "--upgrade              : Used this to upgrade terraform providers"
    echo ""
    echo "Any additional parameters will be added to the terraform plan/apply as-is."
    exit 1
}


# Check all given parameters and map them to their respective variables
while [[ "$#" -gt 0 ]]; do
  key="${1}" # current parameter
  value="${2}" # if the parameter expects a value then this is the value

  case $key in
    -auto | --auto-approve)
      export AUTO_APPROVE="true"
      shift # shift by one, because this parameter doesn't await a value
      ;;

    --plan)
      export PLAN="true"
      shift # shift by one, because this parameter doesn't await a value
      ;;

    --upgrade)
      export UPGRADE_PROVIDERS="true"
      echo "reconfigure terraform state"
      shift # shift by one, because this parameter doesn't await a value
      ;;

    --stage)
      export STAGE="${value}"
      shift && shift # shift by two: for the key and the value
      ;;

    *) # unknown options
      export EXTRA_TF_OPTIONS+="${key} "
      shift
      ;;
  esac
done


# Check that your required parameter is available
if [[ -z "${STAGE}" ]]; then
  echo "stage argument does not exist" && show_usage
fi

# Optionally validate the value
if [[ "|sandbox|nonprod|prod|" != *"|${STAGE}|"* ]]; then
  echo "stage value is not valid" && show_usage
fi