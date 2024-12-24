# syntax=docker/dockerfile:1

ARG BASE_IMAGE_TAG
ARG BASE_OS

FROM --platform=$BUILDPLATFORM alpine:3.20 AS pwsh_downloader
ARG PWSH_VERSION
WORKDIR /app 
COPY get-pwsh.sh .
RUN chmod +x get-pwsh.sh
RUN ./get-pwsh.sh $PWSH_VERSION

FROM ${BASE_OS}:${BASE_IMAGE_TAG}
ARG TARGETARCH
ARG PWSH_VERSION 
ENV PWSH_VERSION=$PWSH_VERSION
WORKDIR /app
RUN apt-get update && apt-get install libicu-dev ca-certificates -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
COPY --from=pwsh_downloader /powershell/7/$TARGETARCH /opt/microsoft/powershell/7/
RUN ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh && \
    chmod +x /usr/bin/pwsh

CMD ["pwsh"]