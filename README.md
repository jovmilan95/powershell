# PowerShell Docker Image

This repository provides a versatile PowerShell Docker image built on Debian and Ubuntu, supporting both `amd64` and `arm64` architectures. It is designed to work seamlessly across multiple platforms, addressing the gap left by the official PowerShell Docker images, which currently support only the Mariner distribution for `arm64`. These Debian-based containers aim to simplify cross-platform development and deployment.

## Supported Architectures
  - `amd64` (x86_64)
  - `arm64` (aarch64)

## Usage

To use the PowerShell Docker image, you can either pull the pre-built image from Docker Hub or build the image yourself from this repository.

### Pulling the Image

To pull the image directly from Docker Hub, use the following command:

```bash
docker pull jovmilan95/powershell:debian-12
```

For additional tags and variations, visit the [Docker Hub page](https://hub.docker.com/r/jovmilan95/powershell).

## Motivation

The official PowerShell Docker images provided by Microsoft currently support the Mariner distribution for `arm64`. This repository was inspired by the need for Debian-based containers that cater to both `amd64` and `arm64` architectures. These images aim to simplify workflows and provide flexibility in development and deployment, especially for teams requiring a standardized Debian or Ubuntu base across their environments.

## Contributing

Contributions are welcome! If you encounter any issues or have suggestions for improvement, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

