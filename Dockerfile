# ============================================================
# Define build arguments with default values
# ============================================================

ARG RUBY_VERSION=3.4.10
ARG ALPINE_VERSION=3.24
ARG CEEDLING_VERSION=1.1.1

# ============================================================
# Use the Ruby Alpine base image
# ============================================================

FROM ruby:${RUBY_VERSION}-alpine${ALPINE_VERSION}

ARG RUBY_VERSION
ARG ALPINE_VERSION
ARG CEEDLING_VERSION

ENV RUBY_VERSION=${RUBY_VERSION}
ENV ALPINE_VERSION=${ALPINE_VERSION}
ENV CEEDLING_VERSION=${CEEDLING_VERSION}

# ============================================================
# Image metadata
# ============================================================

LABEL org.opencontainers.image.title="Ceedling Docker"
LABEL org.opencontainers.image.description="Lightweight Ceedling environment for C unit testing."
LABEL org.opencontainers.image.vendor="Mohammad-Ali Safdari"
LABEL org.opencontainers.image.licenses="MIT (project); see component licenses"
LABEL org.opencontainers.image.source="https://github.com/SafdariAli/ceedling-docker"
LABEL org.opencontainers.image.version.ceedling="${CEEDLING_VERSION}"
LABEL org.opencontainers.image.version.ruby="${RUBY_VERSION}"
LABEL org.opencontainers.image.version.alpine="${ALPINE_VERSION}"

# ============================================================
# Install C build dependencies
# ============================================================
RUN apk add --no-cache \
    gcc \
    musl-dev \
    make \
    binutils

# ============================================================
# Install Ceedling
# ============================================================
RUN gem install ceedling \
    -v "${CEEDLING_VERSION}" \
    --no-document
	
# ============================================================
# Set working directory
# ============================================================
WORKDIR /workspace

# ============================================================
# Verify Ceedling installation during image build
# ============================================================

RUN ceedling --version

# ============================================================
# Run Ceedling tests by default
# ============================================================

CMD ["ceedling", "test:all"]
