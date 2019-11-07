#!/bin/bash

set -e

readonly CLOUDWATCH_CONFIG_FILE="cloudwatch-config.json"
readonly DOWNLOAD_CLOUDWATCH_PACKAGE_PATH="/tmp/amazon-cloudwatch-agent.rpm"
readonly CLOUDWATCH_CONFIGURATION_PATH="/opt/aws/amazon-cloudwatch-agent/config"
readonly SETUP_BUCKET_NAME="csg-imputation-setup"

readonly SCRIPT_NAME="$(basename "$0")"

function log {
  local -r level="$1"
  local -r message="$2"
  local -r timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  >&2 echo -e "${timestamp} [${level}] [$SCRIPT_NAME] ${message}"
}

function log_info {
  local -r message="$1"
  log "INFO" "$message"
}

function log_warn {
  local -r message="$1"
  log "WARN" "$message"
}

function log_error {
  local -r message="$1"
  log "ERROR" "$message"
}

# A retry function that attempts to run a command a number of times and returns the output
function retry {
  local -r cmd="$1"
  local -r description="$2"

  for i in $(seq 1 5); do
    log_info "$description"

    # The boolean operations with the exit status are there to temporarily circumvent the "set -e" at the
    # beginning of this script which exits the script immediatelly for error status while not losing the exit status code
    output=$(eval "$cmd") && exit_status=0 || exit_status=$?
    log_info "$output"
    if [[ $exit_status -eq 0 ]]; then
      echo "$output"
      return
    fi
    log_warn "$description failed. Will sleep for 10 seconds and try again."
    sleep 10
  done;

  log_error "$description failed after 5 attempts."
  exit $exit_status
}

function is_master {
  local is_master="true"

  if [[ -f "/mnt/var/lib/info/instance.json" ]]; then
    is_master=$(jq .isMaster "/mnt/var/lib/info/instance.json")
    if [[ "$is_master" = "true" ]]; then
      return 0
    else
      return 1
    fi
  else
    log_error "Could not find instance.json config. file"
    exit 1
  fi
}

function install_dependencies {
  log_info "Installing dependencies"

  sudo yum update -y
  retry \
    "sudo yum install -y curl" \
    "Installing dependencies"
}

function fetch_cloudwatch_pkg {
  local -r version="$1"
  local download_url="$2"

  if [[ -z "$download_url" && -n "$version" ]]; then
    download_url="https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/${version}/amazon-cloudwatch-agent.rpm"
  fi

  retry \
    "curl -o '$DOWNLOAD_CLOUDWATCH_PACKAGE_PATH' '$download_url' --location --silent --fail --show-error" \
    "Downloading CloudWatch agent to $DOWNLOAD_CLOUDWATCH_PACKAGE_PATH"
}

function install_cloudwatch_agent {
  log_info "Installing CloudWatch agent"

  sudo rpm -U "$DOWNLOAD_CLOUDWATCH_PACKAGE_PATH"

  sudo mkdir -p "$CLOUDWATCH_CONFIGURATION_PATH"
  sudo aws s3 cp "s3://${SETUP_BUCKET_NAME}/rhel/cloudwatch-config.json" "${CLOUDWATCH_CONFIGURATION_PATH}/${CLOUDWATCH_CONFIG_FILE}"

  log_info "Starting CloudWatch agent"
  sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:"${CLOUDWATCH_CONFIGURATION_PATH}/${CLOUDWATCH_CONFIG_FILE}" -s
}

function configure_system_use_notification {
  log_info "Configuring system use notification"

  sudo bash -c 'echo "************************************************************************" > /etc/issue.net'
  sudo bash -c 'echo "* By your use of these resources, you agree to abide by Proper Use of  *" >> /etc/issue.net'
  sudo bash -c 'echo "* Information Resources, Information Technology, and Networks at the   *" >> /etc/issue.net'
  sudo bash -c 'echo "* University of Michigan (SPG 601.07), in addition to all relevant     *" >> /etc/issue.net'
  sudo bash -c 'echo "* state and federal laws.                                              *" >> /etc/issue.net'
  sudo bash -c 'echo "* https://spg.umich.edu/policy/601.07                                  *" >> /etc/issue.net'
  sudo bash -c 'echo "************************************************************************" >> /etc/issue.net'

  sudo sed -i "s=#Banner none=Banner /etc/issue.net=g" "/etc/ssh/sshd_config"
}

function install {
  local version="latest"
  local download_url=""

  log_info "Starting setup"

  if ! $(is_master); then
    log_info "Instance is not EMR master, exiting"
    exit 0
  fi

  install_dependencies
  fetch_cloudwatch_pkg "$version" "$download_url"
  install_cloudwatch_agent
  configure_system_use_notification
}

install "$@"
