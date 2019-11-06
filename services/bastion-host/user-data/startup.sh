#!/bin/bash

set -e

readonly CLOUDWATCH_CONFIG_FILE_PATH="/opt/aws/amazon-cloudwatch-agent/config/cloudwatch-config.json"

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

function start_cloudwatch_agent {
    log_info "Starting CloudWatch Agent"
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:${CLOUDWATCH_CONFIG_FILE_PATH} -s
}

function setup {
    start_cloudwatch_agent
}

setup "$@"
