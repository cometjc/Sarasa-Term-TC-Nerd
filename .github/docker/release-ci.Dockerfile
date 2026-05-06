FROM ubuntu:24.04

LABEL org.opencontainers.image.title="Sarasa Term TC Nerd Release CI" \
      org.opencontainers.image.description="Pinned CI image for building Sarasa Term TC Nerd release assets." \
      org.opencontainers.image.source="https://github.com/cometjc/Sarasa-Term-TC-Nerd"

ENV DEBIAN_FRONTEND=noninteractive \
    UV_PYTHON=/usr/bin/python3

RUN rm -f /etc/default/locale && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      aria2 \
      ca-certificates \
      curl \
      fontforge \
      git \
      jq \
      p7zip-full \
      python3 \
      python3-fontforge \
      python3-venv \
      zstd && \
    rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

WORKDIR /work
