#!/bin/bash

set -e

readonly PROMETHEUS_VERSION="2.26.0"
readonly NODE_EXPORTER_VERSION="1.1.2"

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

  for _ in $(seq 1 5); do
    log_info "$description"

    # The boolean operations with the exit status are there to temporarily circumvent the "set -e" at the
    # beginning of this script which exits the script immediately for error status while not losing the exit status code
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

# Create service users and directories
function create_service_users {
  log_info "Setting up service user accounts"

  sudo useradd --no-create-home --shell /bin/false prometheus
  sudo useradd --no-create-home --shell /bin/false node_exporter

  sudo mkdir "/etc/prometheus"
  sudo mkdir "/var/lib/prometheus"

  sudo chown prometheus:prometheus "/etc/prometheus"
  sudo chown prometheus:prometheus "/var/lib/prometheus"
}

function install_prometheus {
  log_info "Installing Prometheus"

  retry \
    "curl -o '/tmp/prometheus-${PROMETHEUS_VERSION}.linux.amd64.tar.gz' 'https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz' --location --silent --fail --show-error" \
    "Downloading Prometheus to /tmp/"
  
  log_info "Unpacking Prometheus archive"
  sudo tar -xf "/tmp/prometheus-${PROMETHEUS_VERSION}.linux.amd64.tar.gz" -C "/tmp/"

  log_info "Moving Prometheus binaries to /usr/local/bin"
  sudo cp "/tmp/prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus" "/usr/local/bin/"
  sudo cp "/tmp/prometheus-${PROMETHEUS_VERSION}.linux-amd64/promtool" "/usr/local/bin/"
  
  sudo chown prometheus:prometheus "/usr/local/bin/prometheus"
  sudo chown prometheus:prometheus "/usr/local/bin/promtool"

  log_info "Moving settings to /etc/prometheus"
  sudo cp -r "/tmp/prometheus-${PROMETHEUS_VERSION}.linux-amd64/consoles" "/etc/prometheus"
  sudo cp -r "/tmp/prometheus-${PROMETHEUS_VERSION}.linux-amd64/console_libraries" "/etc/prometheus"

  sudo chown -R prometheus:prometheus "/etc/prometheus/consoles"
  sudo chown -R prometheus:prometheus "/etc/prometheus/console_libraries"

  log_info "Cleaning up downloaded files"
  sudo rm -rf "/tmp/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz" "/tmp/prometheus-${PROMETHEUS_VERSION}.linux-amd64"
}

function configure_prometheus {
  log_info "Setting up Prometheus configurations"
  sudo mv "/tmp/prometheus.yml" "/etc/prometheus/prometheus.yml"
  sudo chown prometheus:prometheus "/etc/prometheus/prometheus.yml"

  # Create systemd service
  log_info "Creating systemd entry for Prometheus"
  sudo mv "/tmp/prometheus.service" "/etc/systemd/system/prometheus.service"

  # Reload systemd with new service
  sudo systemctl daemon-reload

  # Enable the service to start on boot
  sudo systemctl enable prometheus

}

function install_node_exporter {
  log_info "Installing node exporter"

  log_info "Downloading binary"
  retry \
    "curl -o '/tmp/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz' 'https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz' --location --silent --fail --show-error" \
    "Downloading node_exporter to /tmp/" 
  
  log_info "Unpacking node exporter archive"
  sudo tar -xf "/tmp/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz" -C "/tmp/"

  log_info "Moving node exporter binaries to /usr/local/bin"
  sudo cp "/tmp/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter" "/usr/local/bin/node_exporter"

  sudo chown node_exporter:node_exporter "/usr/local/bin/node_exporter"

  log_info "Cleaning up downloaded files"
  rm -rf "node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz" "node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64"

  # Setup node exporter systemd service
  sudo mv "/tmp/node_exporter.service" "/etc/systemd/system/node_exporter.service"

  # Reload systemd with new service
  sudo systemctl daemon-reload

  # Enable the service to start on boot
  sudo systemctl enable node_exporter

}

function install_grafana {
  log_info "Installing Grafana"
  
  sudo apt-get update
  retry \
    "sudo apt-get install -y apt-transport-https" \
    "Installing dependencies"

  retry \
   "sudo apt-get install -y software-properties-common wget" \
   "Installing dependencies"

  wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

  sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

  sudo apt-get update
  retry \
    "sudo apt-get install -y grafana" \
    "Installing Grafana"
  
  # Reload systemd with new service
  sudo systemctl daemon-reload

  # Enable the service to start on boot
  sudo systemctl enable grafana-server.service

}

function setup {

  create_service_users
  install_prometheus
  configure_prometheus
  install_node_exporter
  install_grafana
}

setup "$@"