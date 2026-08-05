# Ceedling Docker for C Unit Testing on Alpine Linux

[![Docker Pulls](https://img.shields.io/docker/pulls/safdariali/ceedling)](https://hub.docker.com/r/safdariali/ceedling)
[![Docker Image Size](https://img.shields.io/docker/image-size/safdariali/ceedling/latest)](https://hub.docker.com/r/safdariali/ceedling)
[![License](https://img.shields.io/badge/license-MIT-blue)](https://github.com/SafdariAli/ceedling-docker/blob/main/LICENSE)

Lightweight Docker image providing **Ceedling** for C unit testing and Test-Driven Development (TDD) on Alpine Linux.

The image provides a reproducible environment containing Ceedling, Ruby, and the native C build tools required by Ceedling.

## 📋 Table of Contents

* [Features](#-features)
* [Quick Start](#-quick-start)
* [Usage Examples](#-usage-examples)
* [Version Tags](#-version-tags)
* [GitHub Actions Integration](#-github-actions-integration)
* [Building from Source](#-building-from-source)
* [Local Build Scripts](#-local-build-scripts)
* [Version Management](#-version-management)
* [License](#-license)
* [Support](#-support)

## ✨ Features

* **C Unit Testing**: Ready-to-use environment for C unit testing with Ceedling
* **TDD Ready**: Designed for Test-Driven Development workflows
* **Embedded Development**: Suitable for unit testing embedded C projects
* **Lightweight Base**: Based on Alpine Linux
* **CI/CD Ready**: Designed for GitHub Actions and other CI/CD systems
* **Self-Contained**: Ceedling and required build dependencies are pre-installed
* **Testing Frameworks**:

  * Ceedling
  * Unity
  * CMock
  * CException
* **Native C Toolchain**:

  * GCC
  * musl-dev
  * GNU Make
  * binutils
* **Reproducible Builds**: Ceedling, Ruby, and Alpine versions are explicitly defined
* **Versioned Images**: Full image tags identify the Ceedling, Ruby, and Alpine versions
* **Automated Version Management**: Project infrastructure can detect and track upstream releases

Ceedling itself provides build automation for C projects, including unit-test execution, mocking, test reporting, and integration with C toolchains.

## 🚀 Quick Start

### Pull the image

```bash
docker pull safdariali/ceedling:latest
```

### Check Ceedling version

```bash
docker run --rm safdariali/ceedling:latest ceedling --version
```

### Run a Ceedling project

From the root directory of a Ceedling project:

```bash
docker run --rm \
  -v "$(pwd):/workspace" \
  -w /workspace \
  safdariali/ceedling:latest \
  ceedling test:all
```

## 📖 Usage Examples

### 1. Run all unit tests

Mount the project directory to `/workspace`:

```bash
docker run --rm \
  -v "$(pwd):/workspace" \
  -w /workspace \
  safdariali/ceedling:latest \
  ceedling test:all
```

This runs the complete Ceedling test suite.

### 2. Run a specific test

```bash
docker run --rm \
  -v "$(pwd):/workspace" \
  -w /workspace \
  safdariali/ceedling:latest \
  ceedling test:test_blink
```

Replace `test_blink` with the name of the desired test target.

### 3. Run tests with verbose output

```bash
docker run --rm \
  -v "$(pwd):/workspace" \
  -w /workspace \
  safdariali/ceedling:latest \
  ceedling test:all VERBOSE=1
```

### 4. Generate a new Ceedling project

```bash
docker run --rm \
  -v "$(pwd):/workspace" \
  -w /workspace \
  safdariali/ceedling:latest \
  ceedling new my_project
```

This creates a new Ceedling project in the mounted workspace.

### 5. Interactive shell

For debugging or inspecting the container environment:

```bash
docker run --rm -it \
  -v "$(pwd):/workspace" \
  -w /workspace \
  safdariali/ceedling:latest \
  /bin/sh
```

### 6. Check installed components

```bash
docker run --rm safdariali/ceedling:latest ceedling --version
```

The output includes the installed Ceedling version and its bundled testing frameworks.

## 🏷️ Version Tags

Each image is published with both a `latest` tag and a complete version tag.

| Tag                           | Description                  | Example                                             |
| :---------------------------- | :--------------------------- | :-------------------------------------------------- |
| `latest`                      | Latest published image       | `safdariali/ceedling:latest`                        |
| `X.Y.Z-ruby-X.Y.Z-alpine-X.Y` | Complete version information | `safdariali/ceedling:1.1.1-ruby-3.4.10-alpine-3.24` |

### Example

```text
safdariali/ceedling:1.1.1-ruby-3.4.10-alpine-3.24
```

represents:

```text
Ceedling = 1.1.1
Ruby     = 3.4.10
Alpine   = 3.24
```

Using the complete version tag is recommended when reproducibility is important.

The `latest` tag is intended for users who want the current published image without explicitly selecting component versions.

## 🔧 GitHub Actions Integration

The image can be used directly as a container in GitHub Actions.

### Basic unit-test workflow

```yaml
name: C Unit Tests

on:
  push:
  pull_request:
  workflow_dispatch:

jobs:
  test:
    runs-on: ubuntu-latest

    container:
      image: safdariali/ceedling:latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Show Ceedling version
        run: ceedling --version

      - name: Run unit tests
        run: ceedling test:all
```

### Using a fixed version

For reproducible CI builds, use a complete image tag:

```yaml
container:
  image: safdariali/ceedling:1.1.1-ruby-3.4.10-alpine-3.24
```

This prevents a future `latest` update from changing the test environment unexpectedly.

## 🏗️ Building from Source

### Prerequisites

* Docker
* Git (optional)

### Clone the repository

```bash
git clone https://github.com/SafdariAli/ceedling-docker.git
cd ceedling-docker
```

### Build using Docker directly

```bash
docker build \
  --build-arg CEEDLING_VERSION=1.1.1 \
  --build-arg RUBY_VERSION=3.4.10 \
  --build-arg ALPINE_VERSION=3.24 \
  -t safdariali/ceedling:custom \
  .
```

### Verify the image

```bash
docker run --rm \
  safdariali/ceedling:custom \
  ceedling --version
```

## 🖥️ Local Build Scripts

The repository provides scripts for building the image locally.

### Windows PowerShell

```powershell
.\build-ceedling-local.ps1
```

Custom versions can be specified:

```powershell
.\build-ceedling-local.ps1 `
  -CeedlingVersion "1.1.1" `
  -RubyVersion "3.4.10" `
  -AlpineVersion "3.24"
```

### Linux / macOS

```bash
chmod +x build-ceedling-local.sh
./build-ceedling-local.sh
```

Custom versions:

```bash
./build-ceedling-local.sh \
  --CeedlingVersion "1.1.1" \
  --RubyVersion "3.4.10" \
  --AlpineVersion "3.24"
```

The local build scripts:

1. Check that Docker is available.
2. Validate the Dockerfile.
3. Build the image.
4. Apply the versioned image tag.
5. Apply the `latest` tag.
6. Run a basic Ceedling version test.

## 🔄 Version Management

The project is designed to keep upstream component versions configurable rather than hard-coded into the Dockerfile.

The main components are:

```text
Ceedling
Ruby
Alpine Linux
```

Ceedling is distributed as a RubyGem and currently requires Ruby 3.0 or newer.

The Docker image uses the official Ruby Docker image as its base, allowing Ruby and Alpine combinations to be selected through the image tag. The official Ruby image publishes Alpine-based tags such as `3.4.10-alpine3.24`.

The project includes automation infrastructure for detecting newer upstream versions and updating the build configuration.

The goal is to make updating the image reproducible while keeping the repository itself minimal.

## 🧪 Testing

The image performs a basic installation test during the Docker build:

```dockerfile
RUN ceedling --version
```

A successful image build therefore verifies that Ceedling can be installed and executed inside the container.

After building the image locally, an additional test can be performed:

```bash
docker run --rm safdariali/ceedling:latest ceedling --version
```

For actual projects, the recommended validation is to mount the project and execute:

```bash
docker run --rm \
  -v "$(pwd):/workspace" \
  -w /workspace \
  safdariali/ceedling:latest \
  ceedling test:all
```

## 📦 Docker Image

The published image is available from Docker Hub:

```text
safdariali/ceedling
```

Pull the latest version:

```bash
docker pull safdariali/ceedling:latest
```

Pull a specific version:

```bash
docker pull safdariali/ceedling:1.1.1-ruby-3.4.10-alpine-3.24
```

## 📄 License

This repository contains Docker packaging and automation for Ceedling.

### Packaging

The Dockerfile, build scripts, documentation, and other original files in this repository are licensed under the **MIT License**.

### Included software

The Docker image contains third-party software distributed under their respective licenses, including:

* Ceedling — MIT License
* Ruby — Ruby License / BSD-style terms
* Alpine Linux — various licenses depending on included packages
* GCC — GNU General Public License and related licenses
* binutils — GNU General Public License and related licenses
* musl — MIT License and related licenses
* Unity, CMock, and CException — their respective upstream licenses

The MIT license in this repository applies to the original packaging and automation provided by this project. It does not replace or modify the licenses of the software included in the Docker image.

See the `LICENSE` file and the respective upstream projects for complete license terms.

## 🤝 Support

* **Maintainer:** Mohammad Ali Safdari
* **Email:** m.ali.safdari [at] gmail [dot] com
* **GitHub:** SafdariAli
* **Docker Hub:** safdariali
* **Issues:** Feature requests, bug reports, and suggestions are welcome through GitHub Issues.

## 🌟 Show Your Support

If you find this image useful:

* ⭐ Star the GitHub repository
* 🐳 Pull the Docker image
* 📢 Share it with your team

Happy Testing with Ceedling! 🌱
