#!/bin/bash

# logging for any errors during bootstrapping
exec > >(tee -i /var/log/bootstrap-script.log)
exec 2>&1

# Force the cluster to terminate early with "Bootstrap failure"
# if any command or pipeline returns non-zero exit status.
set -eo pipefail

readonly IMPUTATION_SERVER_VERSION="1.2.7"
readonly CLOUDGENE_VERSION="2.1.3"
readonly IMPUTATION_SERVER_BUCKET="nih-nhlbi-imputation-server"

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

## Checks if node is EMR master node
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

## Install and setup Cloudgene
function install_cloudgene {
  log_info "Installing CloudGene"

  cd /home/hadoop
  curl -s install.cloudgene.io | bash -s ${CLOUDGENE_VERSION}
}

## Install and setup Docker
function install_docker {
  log_info "Installing Docker"

  sudo yum update -y
  sudo yum install -y docker
  sudo service docker start
  sudo usermod -a -G docker hadoop
}

## Customize Cloudgene installation
function configure_cloudgene {
  log_info "Configuring CloudGene"

  cd /home/hadoop
  aws s3 sync s3://${IMPUTATION_SERVER_BUCKET}/configuration .
  chmod +x cloudgene-aws
}

## Install imputationserver and reference panels
function install_reference_panels {
  log_info "Installing reference panels"

  cd /home/hadoop
  ./cloudgene clone s3://${IMPUTATION_SERVER_BUCKET}/apps.yaml
}

## Set tmp-directory to ebs volume.
function configure_directories {
  log_info "Configuring application directories"
  cat <<- 'EOF' > "/mnt/apps/imputationserver/${IMPUTATION_SERVER_VERSION}/job.config"
  minimac.command=--refHaps ${ref} --haps ${vcf} --start ${start} --end ${end} --window ${window} --prefix ${prefix} --chr ${chr} --cpus 4 --noPhoneHome --format GT,DS,GP --allTypedSites --meta --minRatio 0.00001  ${unphased ? '--unphasedOutput' : ''} ${mapMinimac != null ? '--referenceEstimates --map ' + mapMinimac : ''}
  minimac.tmp=/mnt/mapred
  chunksize=10000000
  phasing.window=5000000
  minimac.window=500000
  samples.max=25000
  minimac.sendmail=yes
  minimac.sendmail.error=imputationserver@umich.edu
  contact.name=Imputation Team
  contact.email=imputationserver@umich.edu
  eagle.command=--vcfRef ${ref} --vcfTarget ${vcf} --geneticMapFile ${map} --outPrefix ${prefix} --bpStart ${start} --bpEnd ${end} --allowRefAltSwap --vcfOutFormat z --keepMissingPloidyX --numThreads 4
  server.url=https://imputation.biodatacatalyst.nhlbi.nih.gov
EOF
}

## Start webservice on port 8082 by default. Needs sudo to avoid permission issues with docker.
function start_cloudgene {
  log_info "Starting CloudGene"

  cd /home/hadoop
  sudo ./cloudgene-aws &
}

function install {
  log_info "Starting setup"

  if ! $(is_master); then
    log_error "Instance is not EMR master, exiting"
    exit 0
  fi

  install_cloudgene
  install_docker
  configure_cloudgene
  install_reference_panels
  configure_directories
  start_cloudgene
}

install "$@"