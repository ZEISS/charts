# Upgrading the Eventing NATS Streaming fork

## Upgrading

To upgrade Knative, first check to see if the version tags are correct, then run:

```sh
./upgrade_nats.sh
```

The upgrade script:

- Pulls in the yaml files for the latest version of Eventing NATS Streaming
- Applies the following patches to the yaml files:
  - Relax PodDisruptionBudget
  - Several miscellaneous linter related fixes
  - Replaces sha256 tags with standard image tags for airgapped environments
- Cleans up and commits the changes
- Reminds you to go in and manually bump the version in the Chart.yaml files for the base chart and two subcharts