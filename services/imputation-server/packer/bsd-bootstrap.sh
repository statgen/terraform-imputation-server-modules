#!/usr/bin/env sh

set -e

readonly SCRIPT_NAME="$(basename "$0")"

log() {
  level="$1"
  message="$2"
  timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  # shellcheck disable=SC2039
  >&2 echo "${timestamp} [${level}] [$SCRIPT_NAME] ${message}"
}

log_info() {
  message="$1"
  log "INFO" "$message"
}

log_warn() {
  message="$1"
  log "WARN" "$message"
}

log_error() {
  message="$1"
  log "ERROR" "$message"
}

enable_amazon_ssm() {
  log_info "Enabling AWS SSM Agent"
  echo 'amazon_ssm_agent_enable="YES"' >> "/mnt/etc/rc.conf"
}

create_ami() {
  log_info "Creating AMI with mkami"
  mkami "FreeBSD 12.2 w/ AWS SSM" "FreeBSD with Amazon SSM Agent enabled"
}

setup() {
  enable_amazon_ssm
  create_ami
}

setup "@"