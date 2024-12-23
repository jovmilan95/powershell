# PowerShell Docker Image

This repository provides a versatile PowerShell Docker image built on both Debian and Ubuntu, supporting `amd64` and `arm64` architectures. The image is designed to work seamlessly across multiple platforms.


## Features

- **Supported Operating Systems**:
  - Debian 12 (`debian-12`)
  - Debian 12 Slim (`debian-12-slim`)
  - Ubuntu 22.04 (`ubuntu-22.04`)
  - Ubuntu 24 (`ubuntu-24`)

- **Supported Architectures**:
  - `amd64` (x86_64)
  - `arm64` (aarch64)

## Usage

To use the PowerShell Docker image, you can either pull the pre-built image from Docker Hub or build the image yourself.

### Pulling the Image

To pull the image directly from Docker Hub, use the following command:

```bash
docker pull jovmilan95/powershell:debian-12
```

For more available tags, visit the [Docker Hub](https://hub.docker.com/r/jovmilan95/powershell) page to see all the versions and variations of the image.