# uos-docker-minimal

## Project Overview

**uos-docker-minimal** is a tool to build a minimal Docker image for **UOS Desktop Professional Edition** using the official repository that requires HTTP authentication. This project provides the build tools, but **does not include access credentials**. Users must **obtain their own credentials** to access the UOS Desktop Professional repository.

## Features

- **Minimal Docker Image**: Builds a minimal Docker image with the root filesystem of UOS Desktop Professional Edition.
- **Authentication Handling**: Uses HTTP Basic Authentication to fetch the root filesystem.
- **Debootstrap**: Uses `debootstrap` to pull the root filesystem from the UOS repository.

## Flexible Use Cases

- Fetch specific packages from the UOS Desktop Professional repository.
- Build and test UOS Desktop Professional Edition environments for development and compilation.

## Usage

1. **Extract the `/etc/apt` directory** from your UOS Desktop Professional Edition and place it in the project directory.
2. Run `make` to build the Docker image.
3. Run the image with `docker run -it uos /bin/bash`.

## Disclaimers

- **No Credentials Provided**: This project **does not provide repository credentials**. Users must provide their own access credentials.
- **For Personal Use**: This project is for personal learning and research purposes only.
- **Network Proxy**: Ensure proper network and proxy settings if issues arise during the build.
