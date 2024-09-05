# Helm Charts

[![publish](https://github.com/ZEISS/charts/actions/workflows/publish.yml/badge.svg)](https://github.com/ZEISS/charts/actions/workflows/publish.yml)
[![Taylor Swift](https://img.shields.io/badge/secured%20by-taylor%20swift-brightgreen.svg)](https://twitter.com/SwiftOnSecurity)
[![Volkswagen](https://auchenberg.github.io/volkswagen/volkswargen_ci.svg?v=1)](https://github.com/auchenberg/volkswagen)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

These are charts used to bridge the gap in available tools and a common way to deploy these tools via [Helm](http://https://helm.sh/).

There are charts in staging an stable.

## Install

### Staging

These are the staged charts in try-out.

```bash
helm repo add zeiss-staging https://zeiss.github.io/charts/staging
helm repo update
```

### Stable

These are the stable charts available.

```bash
helm repo add zeiss-stable https://zeiss.github.io/charts/stable
helm repo update
```

## License

[MIT](/LICENSE)
