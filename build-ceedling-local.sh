#!/bin/bash

# ============================================================

# Script: build-ceedling-local.sh

# Description: Build Ceedling Docker image locally on Linux

# Usage: ./build-ceedling-local.sh

# ./build-ceedling-local.sh --CeedlingVersion "1.1.1" --RubyVersion "3.4.10" --AlpineVersion "3.24"

# ============================================================

# Default values

CEEDLING_VERSION="1.1.1"
RUBY_VERSION="3.4.10"
ALPINE_VERSION="3.24"

# Parse command line arguments

while [[ $# -gt 0 ]]; do
case $1 in
--CeedlingVersion)
CEEDLING_VERSION="$2"
shift 2
;;
--RubyVersion)
RUBY_VERSION="$2"
shift 2
;;
--AlpineVersion)
ALPINE_VERSION="$2"
shift 2
;;
-h|--help)
echo "Usage: $0 [OPTIONS]"
echo "  --CeedlingVersion VERSION  Ceedling version (default: 1.1.1)"
echo "  --RubyVersion VERSION      Ruby version (default: 3.4.10)"
echo "  --AlpineVersion VERSION    Alpine version (default: 3.24)"
echo "  -h, --help                 Show this help"
exit 0
;;
*)
echo "Unknown option: $1"
echo "Use -h or --help for usage"
exit 1
;;
esac
done

# Configuration

IMAGE_NAME="safdariali/ceedling"
FULL_TAG="${CEEDLING_VERSION}-ruby-${RUBY_VERSION}-alpine-${ALPINE_VERSION}"

# Colors for terminal output

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color

echo "========================================"
echo -e "${CYAN}Ceedling Docker Image Builder${NC}"
echo "========================================"
echo ""

# Check Docker

echo -e "${YELLOW}Checking Docker installation...${NC}"
if command -v docker &> /dev/null; then
dockerVersion=$(docker --version)
echo -e "${GREEN}Docker found: $dockerVersion${NC}"
else
echo -e "${RED}Docker is not installed or not in PATH!${NC}"
echo "Please install Docker from: https://docs.docker.com/engine/install/"
exit 1
fi

# Build info

echo ""
echo -e "${YELLOW}Build Configuration:${NC}"
echo "  Ceedling Version: $CEEDLING_VERSION"
echo "  Ruby Version: $RUBY_VERSION"
echo "  Alpine Version: $ALPINE_VERSION"
echo "  Full Tag: $FULL_TAG"
echo ""

# Check Dockerfile

echo -e "${YELLOW}Checking Dockerfile...${NC}"
if [ ! -f "Dockerfile" ]; then
echo -e "${RED}Dockerfile not found!${NC}"
exit 1
fi
echo -e "${GREEN}Dockerfile found${NC}"

# Build

echo ""
echo -e "${YELLOW}Building Docker image...${NC}"
echo -e "${YELLOW}This may take a few minutes...${NC}"
echo ""

docker build 
--build-arg CEEDLING_VERSION="$CEEDLING_VERSION" 
--build-arg RUBY_VERSION="$RUBY_VERSION" 
--build-arg ALPINE_VERSION="$ALPINE_VERSION" 
-t ${IMAGE_NAME}:"$FULL_TAG" 
-t ${IMAGE_NAME}:latest 
.

if [ $? -eq 0 ]; then
echo ""
echo -e "${GREEN}Build completed successfully!${NC}"

```
# Test
echo ""
echo -e "${YELLOW}Testing the image...${NC}"

echo -e "${YELLOW}  Testing Ceedling...${NC}"
docker run --rm ${IMAGE_NAME}:"$FULL_TAG" ceedling --version

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  Ceedling test passed${NC}"
else
    echo -e "${RED}  Ceedling test failed${NC}"
fi

# Final info
echo ""
echo "========================================"
echo -e "${GREEN}Image built successfully!${NC}"
echo ""
echo -e "${YELLOW}Tags:${NC}"
echo "  ${IMAGE_NAME}:${FULL_TAG}"
echo "  ${IMAGE_NAME}:latest"
echo ""
echo -e "${YELLOW}To run:${NC}"
echo "  docker run --rm ${IMAGE_NAME}:latest ceedling --version"
echo "========================================"
```

else
echo ""
echo -e "${RED}Build failed!${NC}"
exit 1
fi
