#!/usr/bin/env bash

# This script upgrades knative by copying all the latest github release files.
#
# To upgrade, simply run:
#   ./upgrade_knative.sh

set -xeuo pipefail
shopt -s dotglob

# Tags for current version of knative
OPERATOR_TAG=1.16.0

# Base URLs
OPERATOR_URL=https://github.com/knative/operator/releases/download/knative-v${OPERATOR_TAG}

# Get all files, auto-apply PodDisruptionBudget patches
curl -sSL ${OPERATOR_URL}/operator.yaml > charts/operator/templates/operator.yaml

# Bump app version
sed "s/appVersion:.*/appVersion: \"v${OPERATOR_TAG}\"/g" Chart.yaml > Chart.yaml.temp
sed "s/appVersion:.*/appVersion: \"v${OPERATOR_TAG}\"/g" charts/operator/Chart.yaml > charts/operator/Chart.yaml.temp
mv Chart.yaml.temp Chart.yaml
mv charts/operator/Chart.yaml.temp charts/operator/Chart.yaml

# Commit changes
git add .
git commit -am "chore: bump Knative Operator to \"v${OPERATOR_TAG}\""

# Finish
echo "Done upgrading knative!"
echo "Please remember to bump version numbers in Chart and sub-Charts manually"
