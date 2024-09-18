#!/usr/bin/env bash

# This script upgrades knative by copying all the latest github release files.
#
# To upgrade, eventing-natss simply run:
#   ./upgrade_natss.sh

set -xeuo pipefail
shopt -s dotglob

# Tags for current version of eventing-natss
NATS_TAG=1.15.0

# Base URLs
NATS_URL=https://github.com/knative-extensions/eventing-natss/releases/download/knative-v${NATS_TAG}

# Get all files, auto-apply PodDisruptionBudget patches
curl -sSL ${NATS_URL}/eventing-natss.yaml > charts/nats/templates/eventing-natss.yaml
curl -sSL ${NATS_URL}/eventing-jsm.yaml > charts/nats/templates/eventing-jsm.yaml

# Bump app version
sed "s/appVersion:.*/appVersion: \"v${NATS_TAG}\"/g" Chart.yaml > Chart.yaml.temp
sed "s/appVersion:.*/appVersion: \"v${NATS_TAG}\"/g" charts/nats/Chart.yaml > charts/nats/Chart.yaml.temp
mv Chart.yaml.temp Chart.yaml
mv charts/nats/Chart.yaml.temp charts/nats/Chart.yaml

# Commit changes
git add .
git commit -am "chore: bump eventing-natss to \"v${NATS_TAG}\""

# Finish
echo "Done upgrading eventing-natss!"
echo "Please remember to bump version numbers in Chart and sub-Charts manually"
