#!/bin/bash

# Workaround for EMR bug that kills amazon-ssm-agent and never restarts it.
# This script will make sure the AWS script located in /etc/init.d/setup-devices has
# completed running commands for which amazon-ssm-agent must be disabled by monitoring
# the file "/var/setup-devices/completed". When this file is found, it is assumed that the
# AWS setup-devices script has completed and the SSM agent can be started. This cannot take
# place in the userdata bootstrap script as the bootstrap script runs before Amazon's setup
# script. Therefor this is meant to be setup as a crontab entry.

set -eo pipefail

# Location of file used by AWS to determine if setup-devices script is finished.
readonly ONE_TIME_OPERATION_COMPLETED="/var/setup-devices/completed"
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

function check_if_service_is_running {
  log_info "Checking if $1 is running"
  systemctl is-active --quiet "$1"
}

if [[ -e $ONE_TIME_OPERATION_COMPLETED ]] ; then
  if check_if_service_is_running amazon-ssm-agent ; then
    exit 0
  else
    sudo systemctl start amazon-ssm-agent
  fi
else
  exit 0
fi