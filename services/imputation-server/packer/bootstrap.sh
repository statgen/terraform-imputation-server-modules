#!/bin/bash

set -e

readonly CLOUDWATCH_CONFIG_FILE="cloudwatch-config.json"
readonly DOWNLOAD_CLOUDWATCH_PACKAGE_PATH="/tmp/amazon-cloudwatch-agent.rpm"
readonly CLOUDWATCH_CONFIGURATION_PATH="/opt/aws/amazon-cloudwatch-agent/config"

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
  sudo mv "/tmp/cloudwatch-config.json" "${CLOUDWATCH_CONFIGURATION_PATH}/${CLOUDWATCH_CONFIG_FILE}"

  log_info "Starting CloudWatch agent"
  sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:"${CLOUDWATCH_CONFIGURATION_PATH}/${CLOUDWATCH_CONFIG_FILE}" -s
}

function install_node_exporter {
  log_info "Installing node_exporter"

  retry \
    "curl -o '/tmp/node_exporter-0.18.1.linux-amd64.tar.gz' 'https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz' --location --silent --fail --show-error" \
    "Downloading node_exporter to /tmp/" 
  sudo tar -xf "/tmp/node_exporter-0.18.1.linux-amd64.tar.gz" -C "/tmp/"
  sudo mkdir -p "/opt/prometheus"
  sudo mv "/tmp/node_exporter-0.18.1.linux-amd64" "/opt/prometheus/node_exporter"

  # Amazon Linux uses upstart... 
  sudo mv "/tmp/node_exporter.conf" "/etc/init/node_exporter.conf"

  log_info "Starting node_exporter daemon..."

  sudo initctl start node_exporter
}

function install {
  local version="latest"
  local download_url=""

  log_info "Starting setup"

  install_dependencies
  fetch_cloudwatch_pkg "$version" "$download_url"
  install_cloudwatch_agent
  install_node_exporter
}

install "$@"
