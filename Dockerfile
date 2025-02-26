# syntax=docker/dockerfile:1

# Define build arguments
ARG BASE_IMAGE_TAG=debian
ARG BASE_OS=12-slim

# Stage: PowerShell Downloader
FROM --platform=$BUILDPLATFORM alpine:3.20 AS pwsh_downloader
ARG PWSH_VERSION
WORKDIR /app
COPY get-pwsh.sh .
RUN chmod +x get-pwsh.sh
RUN ./get-pwsh.sh $PWSH_VERSION

# Stage: Final Image
FROM ${BASE_OS}:${BASE_IMAGE_TAG}
ARG TARGETARCH
ARG PWSH_VERSION
ENV PWSH_VERSION=$PWSH_VERSION
ENV DEBIAN_FRONTEND=noninteractive

# Add maintainer information and labels
LABEL maintainer="jovmilan995@gmail.com" \
      org.opencontainers.image.title="PowerShell Docker Image" \
      org.opencontainers.image.description="Cross-platform PowerShell Docker images built on Debian and Ubuntu, supporting amd64 and arm64." \
      org.opencontainers.image.authors="jovmilan995@gmail.com" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://github.com/jovmilan95/powershell"

# Install necessary dependencies and copy PowerShell binaries
RUN apt-get update && apt-get install libicu-dev ca-certificates -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/ /var/cache/apt/archives /var/log/apt/ /tmp/*

COPY --from=pwsh_downloader /powershell/7/$TARGETARCH /opt/microsoft/powershell/7/
RUN ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh && \
    chmod +x /usr/bin/pwsh

CMD ["pwsh"]
