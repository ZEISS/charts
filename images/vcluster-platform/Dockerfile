# Set the vcluster version
ARG VCLUSTER_PLATFORM_VERSION="latest"

# using the official vcluster OSS image as the base
FROM ghcr.io/loft-sh/vcluster-platform:${VCLUSTER_PLATFORM_VERSION} AS base
WORKDIR /loft

# we use alpine for easier debugging
FROM alpine:3.24

# install runtime dependencies
RUN apk upgrade --no-cache zlib && apk add --no-cache ca-certificates zstd tzdata

# Install CA certificates
RUN apk update && \
  apk add ca-certificates && \
  rm -rf /var/cache/apk/* && \
  mkdir /usr/local/share/ca-certificates/extra
COPY zscaler.pem /usr/local/share/ca-certificates/extra
# update the CA certificates
RUN update-ca-certificates

# Set root path as working directory
WORKDIR /loft

COPY --from=base loft .

ENTRYPOINT ["/loft", "start"]
